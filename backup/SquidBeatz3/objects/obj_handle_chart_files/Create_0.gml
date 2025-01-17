/// @description Insert description here
// You can write your code in this editor

new_song_title = "";
new_song_path = "";

// Formato del nombre de la cancion
function valid_name(name) {
    // Verificar longitud
    if (string_length(name) > 50) return false; // Verifica que el nombre no tenga más de 50 caracteres

    // Verificar caracteres permitidos manualmente
    var allowed_chars = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?$()&-_";
    var len = string_length(name);
    
    for (var i = 0; i < len; i++) {
        var ch = string_char_at(name, i); // Obtener el carácter actual
        if (string_pos(ch, allowed_chars) == 0) {
            return false; // Si el carácter es inválido o no permitido, retorna false
        }
    }
    return true;
}


function export_chart_to_file(tempo, chart, start_point) {
    // Estructura del archivo JSON
    var chart_data = {
        easy: {
            chart: global.charts.easy.charts[global.current_chart_index],
            tempo: global.charts.easy.tempo[global.current_chart_index],
            start_point: global.charts.easy.start_point[global.current_chart_index]
        },
        normal: {
            chart: global.charts.normal.charts[global.current_chart_index],
            tempo: global.charts.normal.tempo[global.current_chart_index],
            start_point: global.charts.normal.start_point[global.current_chart_index]
        },
        hard: {
            chart: global.charts.hard.charts[global.current_chart_index],
            tempo: global.charts.hard.tempo[global.current_chart_index],
            start_point: global.charts.hard.start_point[global.current_chart_index]
        }
    };

    // Actualizar los datos específicos según la dificultad actual
    switch (global.current_difficulty) {
        case "easy":
            chart_data.easy.chart = global.current_chart;
            chart_data.easy.tempo = global.tempo;
            chart_data.easy.start_point = global.start_point;
            break;
        case "normal":
            chart_data.normal.chart = global.current_chart;
            chart_data.normal.tempo = global.tempo;
            chart_data.normal.start_point = start_point;
            break;
        case "hard":
            chart_data.hard.chart = global.current_chart;
            chart_data.hard.tempo = global.tempo;
            chart_data.hard.start_point = global.start_point;
            break;
    }

    // Convertir el objeto a JSON
    var json_data = json_stringify(chart_data);

    // Abrir explorador de archivos para guardar
    var filter = "*.json|*.*";
    var file_name = get_save_filename(filter, string(global.current_chart_index) + "_song" + string(global.current_chart_index) + ".json");

    // Si se selecciono una ruta valida se guarda el archivo
    if (string_length(file_name) != 0) {
        var file = file_text_open_write(file_name);
        file_text_write_string(file, json_data);
        file_text_close(file);

        show_message(global.current_language == "ENGLISH" ? "Chart saved successfully as " + file_name : "Gráfico guardado exitosamente como " + file_name);
		} else {
		    show_message(global.current_language == "ENGLISH" ? "No location selected to save." : "No se seleccionó ninguna ubicación para guardar.");
		}
};


function load_chart_from_file() {
    // Solicita al usuario abrir un archivo, solo permite JSON
    var filter = "*.json|*.*";
    var file_name = get_open_filename_ext(filter, string(global.current_chart_index) + "_song" + string(global.current_chart_index) + ".json", false, "Abre un json compatible.");

    if (string_length(file_name) == 0) {
        show_message(global.current_language == "ENGLISH" ? "No file was selected." : "No se seleccionó ningún archivo.");
        return undefined;
    }
    if (!file_exists(file_name)) {
        show_message(global.current_language == "ENGLISH" ? "The selected file does not exist." : "El archivo seleccionado no existe.");
        return undefined;
    }
	if (!string_pos(".json",file_name)) {
		show_message(global.current_language == "ENGLISH" ? "The selected file is not a JSON." : "El archivo seleccionado no es un JSON.");
        return undefined;
	}
    var file = file_text_open_read(file_name);
    var json_data = "";
    while (!file_text_eof(file)) {
        json_data += file_text_readln(file);
    }
    file_text_close(file);

    // Convierte el JSON a un objeto
    var chart_data = json_parse(json_data);

    var expected_difficulties = ["easy", "normal", "hard"];
    var expected_attributes = ["chart", "tempo", "start_point"];

    // Verifica la estructura y los atributos del JSON
    var is_valid_chart = true;

    // Validar dificultades y sus atributos
    for (var i = 0; i < array_length(expected_difficulties); i++) {
        var difficulty = expected_difficulties[i];

        if (!variable_struct_exists(chart_data, difficulty)) {
            is_valid_chart = false;
            break;
        }

        var difficulty_data = chart_data[$ difficulty];

        if (!is_struct(difficulty_data)) {
            is_valid_chart = false;
            break;
        }

        for (var j = 0; j < array_length(expected_attributes); j++) {
            var attr = expected_attributes[j];

            if (!variable_struct_exists(difficulty_data, attr)) {
                is_valid_chart = false;
                break;
            }

            // Validar los tipos de datos
            switch (attr) {
                case "chart":
                    if (!is_array(difficulty_data[$ attr])) {
                        is_valid_chart = false;
                    }
                    break;
                case "tempo":
                    if (!is_real(difficulty_data[$ attr])) {
                        is_valid_chart = false;
                    }
                    break;
                case "start_point":
                    if (!is_real(difficulty_data[$ attr])) {
                        is_valid_chart = false;
                    }
                    break;
            }
        }

        if (!is_valid_chart) break;
    }

    if (!is_valid_chart) {
        show_message(global.current_language == "ENGLISH" ? "The JSON file is not compatible. Ensure it contains only the attributes: tempo, chart, and start_point." : "El archivo JSON no es compatible. Asegúrate de que tiene únicamente los atributos: tempo, chart, y start_point.");
    } else {
        show_message(global.current_language == "ENGLISH" ? "Chart loaded successfully from " + file_name : "Chart cargado exitosamente desde " + file_name);
    }
    return is_valid_chart ? chart_data : undefined;
}


// Funcion para reemplazar nombre de cancion actual
function replace_song_name() {
    // Se le pide al usuario seleccionar un archivo de audio, solo .ogg
    show_message(global.current_language == "ENGLISH" ? "WARNING:\n\nChanging the song name is a permanent change and applies to the song being edited, even if you exit without saving." : "ADVERTENCIA:\n\nCambiar el nombre de la canción es un cambio permanente y se aplica sobre la canción que se está editando, incluso si se sale sin guardar.");
    
    // Pedir al usuario un nombre personalizado para la canción
    var default_text = "";
    if (global.new_song_id == undefined || global.new_song_name == "") {
        default_text = string_copy(global.song_text_list[global.current_song_index], 4, string_length(global.song_text_list[global.current_song_index]) - 2);
    } else {
        default_text = global.new_song_name;
    }
    global.async_id = get_string_async(global.current_language == "ENGLISH" ? "Enter the song name in the format 'Name - Author':\nThe name must be less than 50 characters and contain letters, numbers, and the characters -_ .!?$()&." : "Ingrese el nombre para la canción con formato 'Nombre - Autor':\nEl nombre debe tener menos de 50 caracteres y poseer letras del inglés, números y los caracteres -_ .!?$()&", default_text);
    
    return 0;
}


// Funcion para agregar una nueva cancion
function replace_song() {
    show_message(global.current_language == "ENGLISH" ? "WARNING:\n\nChanging the song file is a permanent change and applies to the song being edited, even if you exit without saving. IT IS ALSO REQUIRED TO CHANGE THE VISUALIZER FILE; IF NOT PROVIDED, THE SONG WILL NOT HAVE A VISUALIZER." : "ADVERTENCIA:\n\nCambiar el archivo de la canción es un cambio permanente y se aplica sobre la canción que se está editando, incluso si se sale sin guardar. TAMBIEN SE PIDE CAMBIAR EL ARCHIVO DE VISUALIZADOR, SI NO SE ENTREGA, LA CANCION NO TENDRA VISUALIZADOR.");

    // Se le pide al usuario seleccionar un archivo de audio, solo .ogg
    var filter = "(*.ogg)|*.ogg|*.*";
    var file_path = get_open_filename_ext(filter, ".ogg", false, global.current_language == "ENGLISH" ? "Open an audio file .ogg" : "Abre un archivo de audio .ogg");
    var sound_id = undefined;

    // Si se seleccionó un archivo válido
    if (file_path != "") {
        // Validar que el archivo sea de extensión .ogg
        if (string_pos(".ogg", file_path)) {
            // Guardar la ruta del archivo en una variable temporal
            new_song_path = file_path
			
			var filter2 = "(*.json)|*.json|*.*";
		    var file_path2 = get_open_filename_ext(filter2, ".json", false, global.current_language == "ENGLISH" ? "Open an visualizer file .json" : "Abre un archivo de visualizador .json");
			var visualizer_data = [];
	
			if (string_length(file_path2) != 0) {
			    if (string_pos(".json", file_path)) {
			        show_message(global.current_language == "ENGLISH" ? "Error: The file " + file_path2 + " is not a .json." : "Error: El archivo " + file_path2 + " no es un .json.");
			        visualizer_data = [];
			    } else {
			        var json_file = file_text_open_read(file_path2);
			        var json_content = "";
			        while (!file_text_eof(json_file)) {
			            json_content += file_text_read_string(json_file);
			            file_text_readln(json_file);
			        }
			        file_text_close(json_file);

			        visualizer_data = json_parse(json_content);
            
			        if (!is_struct(visualizer_data)) {
			            show_message(global.current_language == "ENGLISH" ? "Error: The file " + file_path2 + " does not have a valid format." : "Error: El archivo " + file_path2 + " no tiene un formato válido.");
			            visualizer_data = [];
			        } else {
			            if (!variable_struct_exists(visualizer_data, "visualizer")) {
			                show_message(global.current_language == "ENGLISH" ? "Error: " + file_path2 + " does not have the valid format." : "Error: " + file_path2 + " no tiene el formato válido.");
			                visualizer_data = [];
			            } else {
			                visualizer_data = visualizer_data.visualizer;
			            }
			        }
			    }
			} else {
			    visualizer_data = [];
			}
            
            if (global.new_song_id == undefined || global.new_song_name == "") {
                audio_destroy_stream(global.song_list[global.current_song_index]);
                sound_id = audio_create_stream(new_song_path); // Crear stream de audio para acceder al archivo
                // Guarda la cancion nueva en los archivos del juego
                var file_name = string(global.current_chart_index) + "_song" + string(global.current_chart_index) + ".ogg";
                var gamefile_path = working_directory + "sounds\\";

                // Si se seleccionó una ruta válida se reemplaza el archivo
                if (directory_exists(gamefile_path + "songs\\")) {
                    file_copy(new_song_path, gamefile_path + "songs\\" + file_name);
                }
            
                // Y Finalmente se actualiza en la lista de canciones
                global.song_list[global.current_song_index] = sound_id;
                obj_chart_game.current_song = sound_id;
				global.song_visualizer[global.current_song_index] = visualizer_data;
            } else {
                // Si es una canción nueva solo actualiza su valor
                audio_destroy_stream(global.new_song_id);
                sound_id = audio_create_stream(new_song_path); // Crear stream de audio para acceder al archivo
                global.new_song_id = sound_id;
                obj_chart_game.current_song = global.new_song_id;
                global.new_song_path = new_song_path;
				global.new_song_visualizer = visualizer_data;
            }
            
            show_message(global.current_language == "ENGLISH" ? "Song updated successfully from " + file_path : "Cancion actualizada exitosamente a partir de " + file_path);
        } else {
            show_message(global.current_language == "ENGLISH" ? "The selected file is invalid. Please select a file with the .ogg extension." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo con la extensión .ogg.");
        }
    } else {
        show_message(global.current_language == "ENGLISH" ? "No file was selected." : "No se seleccionó ningún archivo.");
    }
}
