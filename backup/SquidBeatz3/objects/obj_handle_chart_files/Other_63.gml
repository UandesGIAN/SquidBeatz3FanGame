/// @description Insert description here
// You can write your code in this editor

// Manejo del Dialog para el nombre de la cancion
if (async_load[? "id"] == global.async_id) {
    var custom_name = async_load[? "result"];
    
    // Verificar que el usuario ingresó un nombre
    if (custom_name != "") {
        if (valid_name(custom_name)) {
            // Cargar nombres desde el JSON
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

                // Convertir el contenido JSON a un struct
                var song_names_json = json_parse(json_content);
                if (is_struct(song_names_json) && variable_struct_exists(song_names_json, "song_names")) {
                    var song_names_array = song_names_json.song_names;

                    // Verificar si el nombre ya existe
                    var is_duplicate = false;
                    for (var i = 0; i < array_length(song_names_array); i++) {
                        if (song_names_array[i] == custom_name) {
                            is_duplicate = true;
                            break;
                        }
                    }

                    if (is_duplicate) {
                        show_message(global.current_language == "ENGLISH" ? "Error: The entered name already exists in the song list. Please choose another." : "Error: El nombre ingresado ya existe en la lista de canciones. Elige otro.");
                    } else {
                        // Valid and non-duplicate name, add the song
                        var new_song_title = custom_name;
						
						if (global.new_song_id != undefined || global.new_song_name != "") {
							// Just change the value
							global.new_song_name = string(global.current_song_index) + ". " + new_song_title;
						} else {
							// Replace in the file
		                    for (var i = 0; i < array_length(song_names_array); i++) {
		                        if (song_names_array[i] == string_copy(global.song_text_list[global.current_song_index], 4, string_length(global.song_text_list[global.current_song_index]) - 2)) {
		                            song_names_array[i] = new_song_title;
		                            break;
		                        }
		                    }
							var updated_json_content = json_stringify(song_names_array);

						    // Write the updated JSON back to the file
						    var write_file = file_text_open_write(dir_path + "song_titles.json");
						    file_text_write_string(write_file, updated_json_content);
						    file_text_close(write_file);
							
							global.song_text_list[global.current_song_index] = string(global.current_song_index) + ". " + new_song_title;
							show_message(global.current_language == "ENGLISH" ? "Name successfully updated as " + new_song_title : "Nombre actualizado exitosamente como " + new_song_title);
						}
                    }
                } else {
                    show_debug_message(global.current_language == "ENGLISH" ? "Error: 'song_names' field not found in the JSON file." : "Error: No se encontró el campo 'song_names' en el archivo JSON.");
                }
            } else {
                show_debug_message(global.current_language == "ENGLISH" ? "Error: JSON file not found at path: " + json_path : "Error: No se encontró el archivo JSON en la ruta: " + json_path);
            }
        } else {
            show_message(global.current_language == "ENGLISH" ? "The name cannot exceed 50 characters or contain unsupported special characters." : "El nombre no puede tener más de 50 caracteres o tener símbolos especiales no compatibles.");
        }
    } else {
        show_message(global.current_language == "ENGLISH" ? "No name entered." : "No se ingresó ningún nombre.");
    }
}