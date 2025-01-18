/// @description Insert description here
// You can write your code in this editor

// Handling the dialog for the song name
if (async_load[? "id"] == global.async_id) {
	var custom_name = async_load[? "result"];
    
	// Check if the user entered a name
	if (custom_name != "") {
	    if (valid_name(custom_name)) {
	        // Load names from the JSON
	        var dir_path = working_directory + "\\sounds\\";
	        var json_path = dir_path + "song_titles.json";

	        if (file_exists(json_path)) {
	            var json_file = file_text_open_read(json_path);
	            var json_content = "";
	            while (!file_text_eof(json_file)) {
	                json_content += file_text_read_string(json_file);
	                file_text_readln(json_file);
	            }
	            file_text_close(json_file);

	            // Convert the JSON content to a struct
	            var song_names_json = json_parse(json_content);
	            if (is_struct(song_names_json) && variable_struct_exists(song_names_json, "song_names")) {
	                var song_names_array = song_names_json.song_names;
		            // Check if the name already exists
		            var is_duplicate = false;
		            for (var i = 0; i < array_length(song_names_array); i++) {
		                if (song_names_array[i] == custom_name) {
		                    is_duplicate = true;
		                    break;
		                }
		            }

	                if (is_duplicate) {
	                    show_message(global.current_language == "ENGLISH" ? "Error: The entered name already exists in the song list. Please choose another." : "Error: El nombre ingresado ya existe en la lista de canciones. Elige otro.");
						global.new_song_name = "";
						global.new_song_id = undefined;
						global.new_song_visualizer = [];
						global.current_chart_index = 0;
						global.current_song_index = 0;
						global.new_song_visualizer = [];
					} else {
	                    // Valid and non-duplicate name, add the song
	                    global.new_song_name = custom_name;
	                    show_message(global.current_language == "ENGLISH" ? "Song successfully added: " + custom_name : "Canción agregada con éxito: " + custom_name);
	                    room_goto(Chart);
	                }
	            } else {
	                show_debug_message(global.current_language == "ENGLISH" ? "Error: 'song_names' field not found in the JSON file." : "Error: No se encontró el campo 'song_names' en el archivo JSON.");
	            }
	        } else {
	            show_debug_message(global.current_language == "ENGLISH" ? "Error: JSON file not found at path: " + json_path : "Error: No se encontró el archivo JSON en la ruta: " + json_path);
	        }
	    } else {
	        show_message(global.current_language == "ENGLISH" ? "The name cannot exceed 50 characters or contain unsupported special characters." : "El nombre no puede tener más de 50 caracteres o tener símbolos especiales no compatibles.");
			global.new_song_name = "";
			global.new_song_id = undefined;
			global.new_song_visualizer = [];
			global.current_chart_index = 0;
			global.current_song_index = 0;
			global.new_song_visualizer = [];
		}
	} else {
	    show_message(global.current_language == "ENGLISH" ? "No name entered." : "No se ingresó ningún nombre.");
		global.new_song_name = "";
		global.new_song_id = undefined;
		global.new_song_visualizer = [];
		global.current_chart_index = 0;
		global.current_song_index = 0;
		global.new_song_visualizer = [];
	}
}
