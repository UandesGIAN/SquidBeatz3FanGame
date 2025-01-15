/// @description Insert description here
// You can write your code in this editor

if (!variable_global_exists("first_load")) {
	global.first_load = false;
}
if (!global.first_load) {
	room_goto(Start);
}

// FUNCION UTIL PARA OBTENER CONTENIDO DENTRO DE UN DIRECTORIO DEL TIPO pattern
function get_directory_contents(dname, pattern) {
    var result = [];
	var file = file_find_first(dname+pattern, fa_archive); // Buscar primer archivo
	
 	while (file != "") {
		var full_file_path = dname + "\\" + file;
		
		array_push(result, full_file_path);
		file = file_find_next();
	}
    return result;
}

// CARGA DE CANCIONES, TITULOS Y CHARTS AL INICIAR EL JUEGO POR PRIMERA VEZ
function load_songs_from_directory(dir_path) {
    // Variables locales para validar
    var json_path = dir_path + "\\song_titles.json";
    var song_names_array;
    var files, charts_files;
    var validation_success = true;
    var songs_ignored_count = 0;

    // Validar el archivo JSON de nombres de canciones
    if (file_exists(json_path)) {
        var json_file = file_text_open_read(json_path);
        var json_content = "";
        while (!file_text_eof(json_file)) {
            json_content += file_text_read_string(json_file);
            file_text_readln(json_file);
        }
        file_text_close(json_file);

        var song_names_json = json_parse(json_content);
        if (is_struct(song_names_json) && variable_struct_exists(song_names_json, "song_names")) {
            song_names_array = song_names_json.song_names;
        } else {
            show_message(global.current_language == "ENGLISH" 
                ? "Error: The 'song_names' field was not found in the JSON file."
                : "Error: No se encontró el campo 'song_names' en el archivo JSON.");
            return;
        }
    } else {
        show_message(global.current_language == "ENGLISH" 
            ? "Error: The JSON file was not found at path: " + json_path 
            : "Error: No se encontró el archivo JSON en la ruta: " + json_path);
        return;
    }

    // Validar directorio de canciones y cantidad
    files = get_directory_contents(dir_path + "\\songs\\", "*.ogg");
    if (array_length(files) != array_length(song_names_array)) {
        show_message(global.current_language == "ENGLISH" 
            ? "The number of song files does not match the number of titles in the JSON." 
            : "La cantidad de archivos de canciones no coincide con la cantidad de títulos en el JSON.");
        return;
    }

    // Validar directorio de charteos y cantidad
    charts_files = get_directory_contents(dir_path + "\\songs\\charts\\", "*.json");
    if (array_length(charts_files) != array_length(song_names_array)) {
        show_message(global.current_language == "ENGLISH" 
            ? "The number of chart files does not match the number of songs." 
            : "La cantidad de archivos de charteos no coincide con la cantidad de canciones.");
        return;
    }

    // Validar charteos
    for (var i = 0; i < array_length(charts_files); i++) {
        var file_name = charts_files[i];
        var json_file = file_text_open_read(file_name);
        var json_content = "";
        while (!file_text_eof(json_file)) {
            json_content += file_text_read_string(json_file);
            file_text_readln(json_file);
        }
        file_text_close(json_file);

        var chart_data = json_parse(json_content);
        if (!is_struct(chart_data)) {
            show_message(global.current_language == "ENGLISH" 
                ? "Error: The file " + file_name + " does not have a valid format." 
                : "Error: El archivo " + file_name + " no tiene un formato válido.");
            validation_success = false;
            break;
        }

        var expected_difficulties = ["easy", "normal", "hard"];
        var expected_attributes = ["chart", "tempo", "start_point"];
        for (var j = 0; j < array_length(expected_difficulties); j++) {
            var difficulty = expected_difficulties[j];
            if (!variable_struct_exists(chart_data, difficulty)) {
                show_message(global.current_language == "ENGLISH" 
                    ? "Error: The difficulty '" + difficulty + "' is missing in " + file_name 
                    : "Error: Falta la dificultad '" + difficulty + "' en " + file_name);
                validation_success = false;
                break;
            }

            var difficulty_data = chart_data[$ difficulty];
            for (var k = 0; k < array_length(expected_attributes); k++) {
                var attr = expected_attributes[k];
                if (!variable_struct_exists(difficulty_data, attr)) {
                    show_message(global.current_language == "ENGLISH" 
                        ? "Error: The attribute '" + attr + "' is missing in " + difficulty + " of " + file_name 
                        : "Error: Falta el atributo '" + attr + "' en " + difficulty + " de " + file_name);
                    validation_success = false;
                    break;
                }
            }
        }
        if (!validation_success) break;
    }

    // Validar visualizadores
    var visualizer_files = get_directory_contents(dir_path + "\\songs\\", "*.json");
    if (array_length(visualizer_files) != array_length(song_names_array)) {
        show_message(global.current_language == "ENGLISH" 
            ? "The number of chart files does not match the number of songs." 
            : "La cantidad de archivos de charteos no coincide con la cantidad de canciones.");
        return;
    }

    for (var i = 0; i < array_length(visualizer_files); i++) {
        var file_name = visualizer_files[i];
        var json_file = file_text_open_read(file_name);
        var json_content = "";
        while (!file_text_eof(json_file)) {
            json_content += file_text_read_string(json_file);
            file_text_readln(json_file);
        }
        file_text_close(json_file);

        var visualizer_data = json_parse(json_content);
        if (!is_struct(visualizer_data)) {
            show_message(global.current_language == "ENGLISH" 
                ? "Error: The file " + file_name + " does not have a valid format." 
                : "Error: El archivo " + file_name + " no tiene un formato válido.");
            validation_success = false;
            break;
        }

        if (!variable_struct_exists(visualizer_data, "visualizer")) {
            show_message(global.current_language == "ENGLISH" 
                ? "Error: " + file_name + " does not have the valid format." 
                : "Error: " + file_name + " no tiene el formato válido.");
            validation_success = false;
            break;
        }

        if (!validation_success) break;
    }

    // Si la validación falla, detener el proceso
    if (!validation_success) return;

    // Procesar y guardar datos en las variables globales
    for (var i = 0; i < array_length(files); i++) {
        var file_name = files[i];
        var song_name = song_names_array[i];
        var ogg_filename = string_copy(file_name, 4, string_length(file_name) - 4); // Obtener solo el nombre del archivo sin extensión
		var song_already_loaded = 0;
        if (array_length(global.song_text_list) > 0) {
            for (var j = 0; j < array_length(global.song_text_list); j++) {
                if (string_copy(global.song_text_list[j], 4, string_length(global.song_text_list[j]) - 2) == song_name) {
                    show_debug_message(global.current_language == "ENGLISH" 
                        ? "Song already loaded: " + song_name 
                        : "Canción ya cargada: " + song_name);
                    song_already_loaded = 1;
                    break;
                }
            }
        }

        if (song_already_loaded) {
            songs_ignored_count++;
            continue;
        }
		
		var current_json_file = file_text_open_read(working_directory + "\\sounds\\song_titles.json");
        var current_json_content = "";
        while (!file_text_eof(current_json_file)) {
            current_json_content += file_text_read_string(current_json_file);
            file_text_readln(current_json_file);
        }
        file_text_close(current_json_file);

        var song_names_json = json_parse(current_json_content);
		
		array_push(song_names_json.song_names, song_name);
		var updated_json_content = json_stringify(song_names_json);

		// Write the updated JSON back to the file
		var write_file = file_text_open_write(working_directory + "\\sounds\\song_titles.json");
		file_text_write_string(write_file, updated_json_content);
		file_text_close(write_file);
		
        var new_file_name = string(array_length(global.song_text_list)) + "_song" + string(array_length(global.song_text_list)) + ".ogg";
        file_copy(file_name, working_directory + "sounds\\songs\\" + new_file_name);

        var sound_id = audio_create_stream(working_directory + "sounds\\songs\\" + new_file_name);
        array_push(global.song_list, sound_id);
        array_push(global.song_text_list, string(array_length(global.song_text_list)) + ". " + song_name);
		
        var chart_file = charts_files[i];
        var json_file = file_text_open_read(chart_file);
        var json_content = "";
        while (!file_text_eof(json_file)) {
            json_content += file_text_read_string(json_file);
            file_text_readln(json_file);
        }
        file_text_close(json_file);
		
		new_file_name = string(array_length(global.song_text_list)-1) + "_song" + string(array_length(global.song_text_list)-1) + ".json";
		file_copy(chart_file, working_directory + "sounds\\songs\\charts\\" + new_file_name);
        var chart_data = json_parse(json_content);
        var expected_difficulties = ["easy", "normal", "hard"];
		
        for (var j = 0; j < array_length(expected_difficulties); j++) {
            var difficulty = expected_difficulties[j];
            var data = chart_data[$ difficulty];
            array_push(global.charts[$ difficulty].charts, data.chart);
            array_push(global.charts[$ difficulty].tempo, data.tempo);
            array_push(global.charts[$ difficulty].start_point, data.start_point);

            array_push(global.game_points[$ difficulty].count_silver, 0);
            array_push(global.game_points[$ difficulty].count_gold, 0);
            array_push(global.game_points[$ difficulty].total_hits, 0);
			
			array_push(global.wins_lifebar[$ difficulty], 0);
        }

        var visualizer_file = visualizer_files[i];
        json_file = file_text_open_read(visualizer_file);
        json_content = "";
        while (!file_text_eof(json_file)) {
            json_content += file_text_read_string(json_file);
            file_text_readln(json_file);
        }
        file_text_close(json_file);
		
        var visualizer_data = json_parse(json_content);
		
		if(file_exists(visualizer_file)) {
			new_file_name = string(array_length(global.song_text_list)-1) + "_song" + string(array_length(global.song_text_list)-1) + ".json";
			file_copy(visualizer_file, working_directory + "sounds\\songs\\" + new_file_name);
		}
		
        array_push(global.song_visualizer, visualizer_data.visualizer);
    }
	if (array_length(song_names_array) - songs_ignored_count == 0) {
		show_message(global.current_language == "ENGLISH" 
        ? "All songs were already loaded, none was added."
        : "Todas las canciones ya estaban presentes, no se cargó ninguna..");
	} else {
		show_message(global.current_language == "ENGLISH" 
        ? "Songs successfully loaded: " + string(array_length(song_names_array)-songs_ignored_count) + "!\nSkipped songs: " + string(songs_ignored_count) + "."
        : "¡Canciones cargadas exitosamente: " + string(array_length(song_names_array)-songs_ignored_count) + "!\nCanciones ignoradas: " + string(songs_ignored_count) + ".");
	}
   
}

// Indica que la musica esta sonando
play_music = 0;
sound_playing = -1;
volume_message_timer = -1;
stick_moved = 0;
volume_count = 1;
if (!variable_global_exists("sound_delay")) {
	global.sound_delay = 0;
}


// Feedback
animation_start_time = 0;
animation_timer = 0; // Timer para controlar el bucle
current_sprite = -1;   // Sprite seleccionado
animation_duration = 5000;
prev_frame_timer = current_time;
randomcolor = c_white;

// Para modo practica
global.practice_mode = false; // Modo práctica deshabilitado por defecto

// EXPORTAR X CANCIONES// EXPORTAR X CANCIONES
export_step = 0;
start_song_i = -1;
end_song_i = -1;
export_dir = "";
global.export_async_id = undefined;
alarm_zip_path = "";
alarm_dir_path = "";

delete_step = 0;
global.delete_async_id = undefined;

function export_song_files_to_directory(dir_path, song_start, song_end) {
    // Create necessary directories
    directory_create(dir_path);
    directory_create(dir_path + "\\sounds");
    directory_create(dir_path + "\\sounds\\songs");
    directory_create(dir_path + "\\sounds\\songs\\charts");

    // Read song names from song_titles.json in the working directory
    var titles_path = working_directory + "\\sounds\\song_titles.json";
    if (!file_exists(titles_path)) {
        show_message(global.current_language == "ENGLISH" ? "Error: The song_titles.json file was not found in the game files." : "Error: No se encontró el archivo song_titles.json en los archivos del juego.");
        return;
    }

    var file = file_text_open_read(titles_path);
    var json_content = "";
    while (!file_text_eof(file)) {
        json_content += file_text_readln(file);
    }
    file_text_close(file);

    var song_titles = json_parse(json_content);
    if (!variable_struct_exists(song_titles, "song_names")) {
        show_message(global.current_language == "ENGLISH" ? "Error: The song_titles.json file does not contain the 'song_names' field." : "Error: El archivo song_titles.json no contiene el campo 'song_names'.");
        return;
    }

    var song_names = song_titles.song_names;

    // Create a new JSON to store the exported song names
    var export_titles = { song_names: [] };

    // Create a ZIP to store the files
    var zip = zip_create();

    // Process each song within the range
    for (var i = song_start; i <= song_end; i++) {
        // Copy the song file to the ZIP
        var song_src_path = working_directory + "\\sounds\\songs\\" + string(i) + "_song" + string(i) + ".ogg";
        if (file_exists(song_src_path)) {
            zip_add_file(zip, "sounds\\songs\\" + string(i) + "_song" + string(i) + ".ogg", song_src_path);
            show_debug_message(global.current_language == "ENGLISH" ? "Song added to ZIP: " + song_src_path : "Canción añadida al ZIP: " + song_src_path);
        } else {
            show_message(global.current_language == "ENGLISH" ? "Error: Song not found at " + song_src_path : "Error: No se encontró la canción " + song_src_path);
            continue;
        }
		
		var song_src_path2 = working_directory + "\\sounds\\songs\\" + string(i) + "_song" + string(i) + ".json";
        if (file_exists(song_src_path2)) {
            zip_add_file(zip, "sounds\\songs\\" + string(i) + "_song" + string(i) + ".json", song_src_path2);
            show_debug_message(global.current_language == "ENGLISH" ? "Visualizer added to ZIP: " + song_src_path2 : "Visualizador añadido al ZIP: " + song_src_path2);
        } else {
            show_message(global.current_language == "ENGLISH" ? "Error: Visualizer not found at " + song_src_path2 : "Error: No se encontró el visualizador " + song_src_path2);
            continue;
        }

        // Copy the chart file to the ZIP
        var chart_src_path = working_directory + "\\sounds\\songs\\charts\\" + string(i) + "_song" + string(i) + ".json";
        if (file_exists(chart_src_path)) {
            zip_add_file(zip, "sounds\\songs\\charts\\" + string(i) + "_song" + string(i) + ".json", chart_src_path);
            show_debug_message(global.current_language == "ENGLISH" ? "Chart added to ZIP: " + chart_src_path : "Chart añadido al ZIP: " + chart_src_path);
        } else {
            show_message(global.current_language == "ENGLISH" ? "Error: Chart not found for song " + i : "Error: No se encontró el chart para la canción " + i);
            continue;
        }

        // Add the song name to the new JSON
        array_push(export_titles.song_names, song_names[i-1]);
    }

    // Save the JSON with exported song names in the ZIP
    var export_titles_path = dir_path + "\\sounds\\song_titles.json";
    file = file_text_open_write(export_titles_path);
    if (file != -1) {
        file_text_write_string(file, json_stringify(export_titles));
        file_text_close(file);
        show_debug_message(global.current_language == "ENGLISH" ? "Titles successfully saved as " + json_stringify(export_titles) : "titulos guardados exitosamente como " + json_stringify(export_titles));
    } else {
        show_debug_message(global.current_language == "ENGLISH" ? "Error opening file for writing." : "Error al abrir el archivo para escritura.");
    }

    zip_add_file(zip, "sounds\\song_titles.json", export_titles_path);

    // Save the ZIP and delete temporary files
    var zip_path = dir_path + "\\SquidBeatz3_exported_songs.zip";
	var i = 1;
	while (file_exists(zip_path)) {
		zip_path = dir_path + "\\SquidBeatz3_exported_songs" + "_" + string(i) + ".zip";
		if (!file_exists(zip_path)) break;
		i++;
	}
	
    zip_save(zip, zip_path);
	
	alarm_zip_path = zip_path;
	alarm_dir_path = dir_path;
	alarm_set(0, 300);

    show_message(global.current_language == "ENGLISH" ? "Songs from " + string(song_start) + " to " + string(song_end) + " have been exported to directory: " + string(dir_path) + " as a ZIP." : "Se exportaron las canciones de la " + string(song_start) + " a la " + string(song_end) + " en el directorio: " + string(dir_path) + " en formato ZIP.");
}


// Function to handle deletion of files
function handle_delete_files(start_song_i, end_song_i) {
	var gamefiles_path = working_directory + "sounds\\";
	var og_files = array_length(global.song_text_list)-1;
	
	var i_charts = 0;
	for (var i = start_song_i; i <= end_song_i; i++) {
		// DELETE CHARTS
		var file_path = gamefiles_path + "songs\\charts\\" + string(i) + "_song" + string(i) + ".json";
		if (file_exists(file_path)) {
			if (file_delete(file_path)) {
				var difficulties = ["easy", "normal", "hard"];
				for (var j = 0; j < array_length(difficulties); j++) {
				    var difficulty = difficulties[j];
				    // Loop to remove elements from each difficulty
				    array_delete(global.charts[$ difficulty].charts, i-i_charts, 1);
				    array_delete(global.charts[$ difficulty].tempo, i-i_charts, 1);
				    array_delete(global.charts[$ difficulty].start_point, i-i_charts, 1);
					
					array_delete(global.game_points[$ difficulty].count_silver, i-i_charts, 1);
				    array_delete(global.game_points[$ difficulty].count_gold, i-i_charts, 1);
				    array_delete(global.game_points[$ difficulty].total_hits, i-i_charts, 1);
					
					array_delete(global.wins_lifebar[$ difficulty], i-i_charts, 1);
					show_debug_message(json_stringify(global.charts[$ difficulty].tempo));
				}
				
				global.tempo = 120;
				global.start_point = 272;
				global.current_chart_index = 0;
				i_charts++;
				
				show_debug_message(global.current_language == "ENGLISH" ? "Deleted chart file at: " + file_path : "Eliminado archivo de charteo en: " + file_path);
			} else {
				show_message(global.current_language == "ENGLISH" ? "An error occurred while trying to delete the chart file for song " + string(i) + "." : "Hubo un error al intentar eliminar el archivo de charteo de la canción " + string(i) + ".");
				return;
			}
		} else {
			var difficulties = ["easy", "normal", "hard"];
			for (var j = 0; j < array_length(difficulties); j++) {
				var difficulty = difficulties[j];

				// Loop to remove elements from each difficulty
				array_delete(global.charts[$ difficulty].charts, i-i_charts, 1);
				array_delete(global.charts[$ difficulty].tempo, i-i_charts, 1);
				array_delete(global.charts[$ difficulty].start_point, i-i_charts, 1);
					
				array_delete(global.game_points[$ difficulty].count_silver, i-i_charts, 1);
				array_delete(global.game_points[$ difficulty].count_gold, i-i_charts, 1);
				array_delete(global.game_points[$ difficulty].total_hits, i-i_charts, 1);
				
				array_delete(global.wins_lifebar[$ difficulty], i-i_charts, 1);
			}
				
			global.tempo = 120;
			global.start_point = 272;
			global.current_chart_index = 0;
			i_charts++;
		}
		
		// DELETE SONG
		file_path = gamefiles_path + "songs\\" + string(i) + "_song" + string(i) + ".ogg";
		if (file_exists(file_path)) {
			if (file_delete(file_path)) {
				global.current_song = undefined;
				global.current_song_index = 0;
				array_delete(global.song_list, i, 1);
				
				show_debug_message(global.current_language == "ENGLISH" ? "Deleted audio file at: " + file_path : "Eliminado archivo de musica en: " + file_path);
			} else {
				show_message(global.current_language == "ENGLISH" ? "An error occurred while trying to delete the audio file for song " + string(i) + "." : "Hubo un error al intentar eliminar el archivo de audio de la canción " + string(i) + ".");
				return;
			}
		} else {
			global.current_song = undefined;
			global.current_song_index = 0;
			array_delete(global.song_list, i, 1);
		}
		
		// DELETE SONG VISUALIZER
		file_path = gamefiles_path + "songs\\" + string(i) + "_song" + string(i) + ".json";
		if (file_exists(file_path)) {
			if (file_delete(file_path)) {
				array_delete(global.song_visualizer, i, 1);
				
				show_debug_message(global.current_language == "ENGLISH" ? "Deleted visualizer file at: " + file_path : "Eliminado archivo de visualizador en: " + file_path);
			} else {
				show_message(global.current_language == "ENGLISH" ? "An error occurred while trying to delete the visualizer file for song " + string(i) + "." : "Hubo un error al intentar eliminar el archivo de visualizador de la canción " + string(i) + ".");
				return;
			}
		} else {
			array_delete(global.song_visualizer, i, 1);
		}
		
		// DELETE SONG NAME
		file_path = gamefiles_path + "song_titles.json";
		if (file_exists(file_path)) {
            var json_file = file_text_open_read(file_path);
            var json_content = "";
            while (!file_text_eof(json_file)) {
                json_content += file_text_read_string(json_file);
                file_text_readln(json_file);
            }
            file_text_close(json_file);

            // Parse JSON content to struct
            var song_names_json = json_parse(json_content);
			if (is_struct(song_names_json) && variable_struct_exists(song_names_json, "song_names")) {
				var song_names_array = song_names_json.song_names;
				// Remove the element from the array
				array_delete(song_names_array, start_song_i-1, 1);

				array_delete(global.song_text_list, start_song_i, 1);
				
				// Update JSON with the required structure
				var updated_json_content = json_stringify({ song_names: song_names_array });

				// Write the updated content to the file
				var write_file = file_text_open_write(file_path);
				file_text_write_string(write_file, updated_json_content);
				file_text_close(write_file);
					
				for (var j = 1; j < array_length(global.song_text_list); j++) {
					var name_song = string_copy(global.song_text_list[j], 4, string_length(global.song_text_list[j]) - 2);
					global.song_text_list[j] = string(j) + ". " + name_song;
				}
			} else {
                show_debug_message(global.current_language == "ENGLISH" ? "Error: 'song_names' field not found in the JSON file." : "Error: No se encontró el campo 'song_names' en el archivo JSON.");
				return;
			}
        } else {
            show_message(global.current_language == "ENGLISH" ? "Song titles file not found." : "No se encontró el archivo con los nombres de las canciones.");
			return;
		}
	}
	
	
	if (end_song_i + 1 - start_song_i < og_files) {
		for (var i = end_song_i + 1; i <= og_files; i++) {
			var new_i = i-(end_song_i - start_song_i)-1;
	        var old_chart_path = gamefiles_path + "songs\\charts\\" + string(i) + "_song" + string(i) + ".json";
	        var new_chart_path = gamefiles_path + "songs\\charts\\" + string(new_i) + "_song" + string(new_i) + ".json";
	        if (file_exists(old_chart_path)) file_rename(old_chart_path, new_chart_path);
        
	        var old_song_path = gamefiles_path + "songs\\" + string(i) + "_song" + string(i) + ".ogg";
	        var new_song_path = gamefiles_path + "songs\\" + string(new_i) + "_song" + string(new_i) + ".ogg";
	        if (file_exists(old_song_path)) file_rename(old_song_path, new_song_path);
		
			var old_visualizer_path = gamefiles_path + "songs\\" + string(i) + "_song" + string(i) + ".json";
	        var new_visualizer_path = gamefiles_path + "songs\\" + string(new_i) + "_song" + string(new_i) + ".json";
	        if (file_exists(old_visualizer_path)) file_rename(old_visualizer_path, new_visualizer_path);
		
			show_debug_message(new_song_path + "..." + string(new_i) + "..")
			audio_destroy_stream(global.song_list[new_i])
			var sound_id = audio_create_stream(new_song_path);
			global.song_list[new_i] = sound_id;
	    }
	}
	
	global.charts.easy.charts[0] = [];
	global.charts.easy.tempo[0] = 120;
	global.charts.easy.start_point[0] = 272;
	global.charts.normal.charts[0] = [];
	global.charts.normal.tempo[0] = 120;
	global.charts.normal.start_point[0] = 272;
	global.charts.hard.charts[0] = [];
	global.charts.hard.tempo[0] = 120;
	global.charts.hard.start_point[0] = 272;
	
	global.song_list[0] = undefined;
	global.song_visualizer[0] = [];
	
	if (start_song_i == end_song_i) show_message(global.current_language == "ENGLISH" ? "Song " + string(start_song_i) + " successfully deleted." : "Se ha eliminado la canción " + string(start_song_i) + " con éxito.");
	else show_message(global.current_language == "ENGLISH" ? "Songs from " + string(start_song_i) + " to " + string(end_song_i) + " successfully deleted." : "Se han eliminado las canciones de la " + string(start_song_i) + " a la " + string(end_song_i) + " con éxito.");
}
