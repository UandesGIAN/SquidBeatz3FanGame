/// @description Insert description here
// You can write your code in this editor

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

// Funcion para agregar una nueva cancion
function add_song() {
    // Ask the user to select an audio file, only .ogg allowed
    var filter = "(*.ogg)|*.ogg|*.*";
    var file_path = get_open_filename_ext(filter, "song.ogg", false, global.current_language == "ENGLISH" ? "Upload an .ogg audio file" : "Sube un archivo de audio .ogg");
    var sound_id = undefined;
    
    // If a valid file is selected
    if (file_path != "") {
        // Validate that the file has a .ogg extension
        if (string_pos(".ogg", file_path)) {
			
			var filter2 = "(*.json)|*.json|*.*";
		    var file_path2 = get_open_filename_ext(filter2, "visualizer.json", false, global.current_language == "ENGLISH" ? "Open an visualizer file .json" : "Abre un archivo de visualizador .json");
			var visualizer_data = [];
			
			var loaded_chart_data = {"easy" : {
										"chart" : [],
										"tempo" : 120,
										"start_point" : 272
									}};
			
			if (string_length(file_path2) != 0) {
				if (string_pos(".json", file_path2)) {
					var json_file = file_text_open_read(file_path2);
				    var json_content = "";
				    while (!file_text_eof(json_file)) {
				        json_content += file_text_read_string(json_file);
				        file_text_readln(json_file);
				    }
				    file_text_close(json_file);
		
					visualizer_data = json_parse(json_content);
						
					if (!is_struct(visualizer_data)) {
						show_message(global.current_language == "ENGLISH" ? "Error: the file at " + file_path2 + " is not compatible." : "Error: " + file_path2 + " no es compatible.");
						visualizer_data = [];
					} else {
						if (!variable_struct_exists(visualizer_data, "visualizer")) {
							show_message(global.current_language == "ENGLISH" ? "Error: the file at " + file_path2 + " is not compatible." : "Error: " + file_path2 + " no es compatible.");
							visualizer_data = [];
					    } else {
							visualizer_data = visualizer_data.visualizer;
							
						    var file_name3 = get_open_filename_ext(filter2, "chart.json", false, global.current_language == "ENGLISH" ? "Open a chart json." : "Abre un json de charteo.");

						    if (string_length(file_name3) == 0) {
						        show_message(global.current_language == "ENGLISH" ? "No file was selected." : "No se seleccionó ningún archivo.");
						    } else {
							    if (!file_exists(file_name3)) {
							        show_message(global.current_language == "ENGLISH" ? "The selected file does not exist." : "El archivo seleccionado no existe.");
							    } else {
									if (!string_pos(".json",file_name3)) {
										show_message(global.current_language == "ENGLISH" ? "The selected file is not a JSON." : "El archivo seleccionado no es un JSON.");
									} else {
										var file = file_text_open_read(file_name3);
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
											loaded_chart_data = {"easy" : {
												"chart" : [],
												"tempo" : 120,
												"start_point" : 272
											}};
										} else {
											loaded_chart_data = chart_data;
									        show_debug_message(global.current_language == "ENGLISH" ? "Chart loaded successfully from " + file_name3 : "Chart cargado exitosamente desde " + file_name3);
									    }
									}
								}
							}
						}
					}
				} else {
					show_message(global.current_language == "ENGLISH" ? "Error: " + file_path2 + " its not a .json.": "Error: El archivo " + file_path2 + " no es un .json.");
					visualizer_data = [];
				}
			} else {
				visualizer_data = [];
			}
			
            // Save the file path to a temporary variable
            global.new_song_path = file_path;
            sound_id = audio_create_stream(global.new_song_path); // Create an audio stream to access the file
            
            // Ask the user for a custom name for the song
            global.async_id = get_string_async(global.current_language == "ENGLISH" ? "Enter the song name in the format 'Name - Author':\nThe name must be less than 50 characters and contain letters, numbers, and characters -_ .!?$()&\n" : "Ingrese el nombre para la canción con formato 'Nombre - Autor':\nEl nombre debe tener menos de 50 caracteres y poseer letras del\níngles, números y los caracteres -_ .!?$()&\n", "");
            // Global variables to handle new songs without saving them in the final game location
            global.new_song_id = sound_id;
			global.new_song_visualizer = visualizer_data;
			global.current_chart = loaded_chart_data.easy.chart;
			global.tempo = loaded_chart_data.easy.tempo;
			global.start_point = loaded_chart_data.easy.start_point;
            return 1;
        } else {
            show_message(global.current_language == "ENGLISH" ? "The selected file is not valid. Please select a file with the .ogg extension." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo con la extensión .ogg.");
            global.new_song_id = undefined;
            global.new_song_name = "";
			global.new_song_visualizer = [];
        }
    } else {
        show_message(global.current_language == "ENGLISH" ? "No file selected." : "No se seleccionó ningún archivo.");
        global.new_song_id = undefined;
        global.new_song_name = "";
		global.new_song_visualizer = [];
    }
    return 0;
}