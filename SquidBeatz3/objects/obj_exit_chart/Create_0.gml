 /// @description Insert description here
// You can write your code in this editor
load_shown = 0;
already_check_load = 0;

selected_row = 0;

message_shown = 0; // Si se muestra el mensaje
btn_width = 150;
btn_height = 50;

// Posiciones del mensaje y botones
msg_x = room_width / 2;
msg_y = room_height / 2 - 100;
btn_cancel_y = msg_y;
btn_no_save_y = btn_cancel_y + btn_height + 10;
btn_save_y = btn_no_save_y + btn_height + 10;


bug_found = 0;
function save_chart_at_gamefiles() {
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
            chart_data.normal.start_point = global.start_point;
            break;
        case "hard":
            chart_data.hard.chart = global.current_chart;
            chart_data.hard.tempo = global.tempo;
            chart_data.hard.start_point = global.start_point;
            break;
    }

    // Convertir el objeto a JSON
    var json_data = json_stringify(chart_data);

    // Nombre del archivo a guardar y ruta
    var file_name = string(global.current_chart_index) + "_song" + string(global.current_chart_index) + ".json";
    var gamefile_path = working_directory + "\\sounds\\songs\\charts\\";
    
    // Si se selecciona una ruta válida, guarda el archivo
    if (directory_exists(gamefile_path)) {
        var file = file_text_open_write(gamefile_path + file_name);
        if (file != -1) {
            file_text_write_string(file, json_data);
            file_text_close(file);
            show_debug_message("Chart guardado exitosamente como " + file_name);
        } else {
            show_debug_message("Error al abrir el archivo para escritura.");
        }
    } else {
        show_debug_message("Directorio no existe o no tiene permisos de escritura.");
    }
}

// Guarda la cancion nueva en los archivos del juego
function save_song_at_gamefiles() {
    // Nombre del archivo a guardar y ruta
    var file_name = string(global.current_chart_index) + "_song" + string(global.current_chart_index) + ".ogg";
	var gamefile_path = working_directory + "sounds\\";
	var file_name2 = string(global.current_chart_index) + "_song" + string(global.current_chart_index) + ".json";
	
	// Luego se guarda su nombre al final del json con los titulos
	if (directory_exists(gamefile_path)) {
	    // Se lee el contenido actual del JSON
	    var file = file_text_open_read(gamefile_path + "song_titles.json");
	    var json_content = "";
	    while (!file_text_eof(file)) {
	        json_content += file_text_read_string(file);
	        file_text_readln(file);
	    }
	    file_text_close(file);
    
	    // Se parsea el JSON para obtenerlo como objeto
	    var json_data = json_parse(json_content);

	    // Verificar si tiene el campo "song_names" (es compatible)
	    if (variable_struct_exists(json_data, "song_names")) {
	        // Agregar el nuevo elemento al array "song_names"
	        array_push(json_data.song_names, global.new_song_name);
			
	        // Convertir de nuevo a JSON
	        var updated_json_content = json_stringify(json_data);

	        // Escribir el JSON actualizado de vuelta al archivo
	        var write_file = file_text_open_write(gamefile_path + "song_titles.json");
	        file_text_write_string(write_file, updated_json_content);
	        file_text_close(write_file);
			
	    } else return 0;
	} else return 0;
	
    // Si se selecciono una ruta valida se guarda el archivo
    if (directory_exists(gamefile_path+"songs\\")) {
		if (global.new_song_path != "") {
			file_copy(global.new_song_path, gamefile_path+"songs\\"+file_name);
			
			var json_data = {"visualizer": global.new_song_visualizer};
			var updated_json_content = json_stringify(json_data);
			var write_file = file_text_open_write(gamefile_path + "songs\\" + file_name2);
	        file_text_write_string(write_file, updated_json_content);
	        file_text_close(write_file);
			
			show_debug_message("Cancion guardada exitosamente como " + file_name);
			return 1;
		} else return 0;
	} else return 0;
};


// Funcion para cargar la informacion de la cancion modificada
function load_single_song() {
    // CARGAR NOMBRES DE CANCIONES
	var dir_path = working_directory + "\\sounds\\"
	var song_index = global.current_chart_index;
	
	// Solo carga elementos de canciones si es nueva
	if (song_index >= array_length(global.song_list)) {
	    var json_path = dir_path + "song_titles.json";
	    var song_name = "";

	    if (file_exists(json_path)) {
	        // Leer el archivo JSON de nombres de canciones
	        var json_file = file_text_open_read(json_path);
	        var json_content = "";
	        while (!file_text_eof(json_file)) {
	            json_content += file_text_read_string(json_file);
	            file_text_readln(json_file);
	        }
	        file_text_close(json_file);

	        // Convertir el JSON a un struct
	        var song_names_json = json_parse(json_content);
	        if (is_struct(song_names_json) && variable_struct_exists(song_names_json, "song_names")) {
	            var song_names_array = song_names_json.song_names;

	            // Obtener el nombre de la canción en el índice especificado
	            if (song_index <= array_length(song_names_array) + 1) {
	                song_name = song_names_array[song_index-1];
	            } else {
	                show_debug_message("Error: Índice fuera de rango en el archivo de títulos.");
	            }
	        } else {
	            show_debug_message("Error: No se encontró el campo 'song_names' en el archivo JSON.");
	        }
	    } else {
	        show_debug_message("Error: No se encontró el archivo JSON en la ruta: " + json_path);
	    }

	    // CARGAR CANCIONES
	    var song_file_path = dir_path + "songs\\" + string(song_index) + "_song" + string(song_index) + ".ogg";
	    if (file_exists(song_file_path)) {
	        var sound_id = audio_create_stream(song_file_path);
	        if (sound_id != -1) {
	            // Guardar información en las listas globales
	            array_push(global.song_list, sound_id);
	            array_push(global.song_text_list, string(song_index) + ". " + song_name);
				global.current_song_index = song_index;
				global.current_song = sound_id;
				array_push(global.song_visualizer, global.new_song_visualizer);
				
				show_debug_message("Error al cargar el archivo de sonido: " + string(global.current_song_index));
	        } else {
	            show_debug_message("Error al cargar el archivo de sonido: " + song_file_path);
	        }
	    } else {
	        show_debug_message("Error: No se encontró el archivo de sonido para el índice: " + string(song_index));
	    }
	}

    // CARGAR CHARTEOS
    var chart_file_path = dir_path + "songs\\charts\\" + string(song_index) + "_song" + string(song_index) + ".json";
    if (file_exists(chart_file_path)) {
        // Leer el archivo de charteo
        var opened_file = file_text_open_read(chart_file_path);
        var json_data = "";
        while (!file_text_eof(opened_file)) {
            json_data += file_text_readln(opened_file);
        }
        file_text_close(opened_file);

        // Convertir el JSON a un struct
        var chart_data = json_parse(json_data);
		
		if (array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]) != array_length(global.current_chart)) {
			global.game_points[$ global.current_difficulty].count_silver[global.current_chart_index] = 0;
			global.game_points[$ global.current_difficulty].count_gold[global.current_chart_index] = 0;
			global.game_points[$ global.current_difficulty].total_hits[global.current_chart_index] = 0;
			global.wins_lifebar[$ global.current_difficulty][global.current_chart_index] = 0;
		}
		
        global.charts[$ global.current_difficulty].tempo[global.current_chart_index] = chart_data[$ global.current_difficulty].tempo;
	    global.charts[$ global.current_difficulty].charts[global.current_chart_index] = chart_data[$ global.current_difficulty].chart;
	    global.charts[$ global.current_difficulty].start_point[global.current_chart_index] = chart_data[$ global.current_difficulty].start_point;
		show_debug_message("Canción y datos cargados exitosamente para el índice: " + string(song_index));
    } else {
        show_debug_message("Error: No se encontró el archivo de charteo para el índice: " + string(song_index));
    }
}