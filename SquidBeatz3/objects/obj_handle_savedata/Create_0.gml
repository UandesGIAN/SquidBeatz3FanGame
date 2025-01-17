/// @description Insert description here
// You can write your code in this editor

message_shown = 0; // load
message_shown2 = 0; // delete
message_shown3 = 0; // delete confirmation
load_path = "";

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


function load_ini_data(dir_path=working_directory + "save_data.ini", type_of_load) {
	
	if (file_exists(dir_path)) {
        ini_open(dir_path);
		
		var array_string = ini_read_string("Main", "SongNames", "[]");
		array_string = string_replace_all(array_string, "[", "[\"");
	    array_string = string_replace_all(array_string, "]", "\"]");
	    array_string = string_replace_all(array_string, ", ", "\", \"");
		var loaded_songs = json_parse(array_string);
		for (var i = 0; i < array_length(loaded_songs); i++) {
		    loaded_songs[i] = string_copy(loaded_songs[i], 4, string_length(loaded_songs[i]) - 2);
		}
		var real_songs = [];
		for (var i = 0; i < array_length(global.song_text_list); i++) {
		    var real_song_name = string_copy(real_songs[i], 4, string_length(real_songs[i]) - 2);
			array_push(real_songs, real_song_name);
		}
		
		show_debug_message(json_stringify(real_songs) + " . . . . . " + json_stringify(loaded_songs));
        // Cargar según el tipo especificado
        if (type_of_load == "all" || type_of_load == "charts") {
            // Cargar datos de "Charts"
            var json_string = ini_read_string("Main", "Charts", global.charts);
			json_string = string_replace_all(json_string, "normal", "\"normal\"");
			json_string = string_replace_all(json_string, "hard", "\"hard\"");
			json_string = string_replace_all(json_string, "easy", "\"easy\"");
			json_string = string_replace_all(json_string, "start_point", "\"start_point\"");
			json_string = string_replace_all(json_string, "tempo", "\"tempo\"");
			json_string = string_replace_all(json_string, "charts", "\"charts\"");
			json_string = string_replace_all(json_string, "index_type", "\"index_type\"");
			json_string = string_replace_all(json_string, "pos_x", "\"pos_x\"");
			
			var loaded_charts = json_parse(json_string);
			var progress_restarted = [];
			
			var dif = ["easy", "normal", "hard"];
			for (var i = 1; i < array_length(loaded_songs); i++) {
				var current_loaded_song = loaded_songs[i];
				for (var j = 1; j < array_length(real_songs); j++) {
					var real_song = real_songs[j];
					if (current_loaded_song == real_song) {
						var save_data_restart = 0;
						for (var d = 0; d < 3; d++) {
							var difficulty = dif[d];
							if (type_of_load == "charts" && array_length(global.charts[$ difficulty].charts[j]) != array_length(loaded_charts[$ difficulty].charts[i])) {
								save_data_restart = j;
								global.game_points[$ difficulty].count_silver[j] = 0;
								global.game_points[$ difficulty].count_gold[j] = 0;
								global.game_points[$ difficulty].total_hits[j] = 0;
								global.wins_lifebar[$ difficulty][j] = 0;
							}
							global.charts[$ difficulty].charts[j] = loaded_charts[$ difficulty].charts[i];
							global.charts[$ difficulty].tempo[j] = loaded_charts[$ difficulty].tempo[i];
							global.charts[$ difficulty].start_point[j] = loaded_charts[$ difficulty].start_point[i];
						}
							
						array_push(progress_restarted, j);
						
						var chart_data = {
						    easy: {
						        chart: global.charts.easy.charts[j],
						        tempo: global.charts.easy.tempo[j],
						        start_point: global.charts.easy.start_point[j]
						    },
						    normal: {
						        chart: global.charts.normal.charts[j],
						        tempo: global.charts.normal.tempo[j],
						        start_point: global.charts.normal.start_point[j]
						    },
						    hard: {
						        chart: global.charts.hard.charts[j],
						        tempo: global.charts.hard.tempo[j],
						        start_point: global.charts.hard.start_point[j]
						    }
						};
							
						var json_data = json_stringify(chart_data);

						// Nombre del archivo a guardar y ruta
						var file_name = string(j) + "_song" + string(j) + ".json";
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
				}
			}

            if (type_of_load == "charts") {
                ini_close();
				if (global.first_load) {
					var progress_restart_songs = json_stringify(progress_restarted);
					progress_restart_songs = string_replace_all(progress_restart_songs, "[", "");
					progress_restart_songs = string_replace_all(progress_restart_songs, ".0", "");
					progress_restart_songs = string_replace_all(progress_restart_songs, "]", "");
				    show_message(global.current_language == "ENGLISH"
				        ? "Game data loaded successfully from " + string(dir_path) + ".\nGame progresss for songs: " + progress_restart_songs + ". Was restarted because the chart data was different. To load the progress use the PROGRESS or ALL option."
				        : "Datos de guardado cargados exitosamente desde " + string(dir_path) + ".\nProgreso del juego para las canciones: " + progress_restart_songs + ". Fue restablecido porque los datos de charteo eran diferentes. Para cargar el progreso usa la opción PROGRESO o TODO al cargar.");
				}
                return; // Salir después de cargar solo charts
            }
        }

        if (type_of_load == "all" || type_of_load == "game_points") {
            // Cargar datos de "GamePoints"
            var json_string = ini_read_string("Main", "GamePoints", global.game_points);
			json_string = string_replace_all(json_string, "normal", "\"normal\"");
			json_string = string_replace_all(json_string, "hard", "\"hard\"");
			json_string = string_replace_all(json_string, "easy", "\"easy\"");
			json_string = string_replace_all(json_string, "count_silver", "\"count_silver\"");
			json_string = string_replace_all(json_string, "count_gold", "\"count_gold\"");
			json_string = string_replace_all(json_string, "total_hits", "\"total_hits\"");
			
			var loaded_game_points = json_parse(json_string);
			
			json_string = ini_read_string("Main", "WinsLifebar", global.wins_lifebar);
			json_string = string_replace_all(json_string, "normal", "\"normal\"");
			json_string = string_replace_all(json_string, "hard", "\"hard\"");
			json_string = string_replace_all(json_string, "easy", "\"easy\"");
			
			var loaded_wins = json_parse(json_string);
			
			var dif = ["easy", "normal", "hard"];
			
			for (var i = 1; i < array_length(loaded_songs); i++) {
				var current_loaded_song = loaded_songs[i];
				for (var j = 1; j < array_length(real_songs); j++) {
					var real_song = real_songs[j];
					if (current_loaded_song == real_song) {
						for (var d = 0; d < 3; d++) {
							var difficulty = dif[d];
							global.game_points[$ difficulty].count_silver[j] = loaded_game_points[$ difficulty].count_silver[i];
							global.game_points[$ difficulty].count_gold[j] = loaded_game_points[$ difficulty].count_gold[i];
							global.game_points[$ difficulty].total_hits[j] = loaded_game_points[$ difficulty].total_hits[i];
							global.wins_lifebar[$ difficulty][j] = loaded_wins[$ difficulty][i];
						}
						break;
					}
				}
			}
			
            if (type_of_load == "game_points") {
                ini_close();
				if (global.first_load) {
			    show_message(global.current_language == "ENGLISH"
			        ? "Game data loaded successfully from " + string(dir_path) + "."
			        : "Datos de guardado cargados exitosamente desde " + string(dir_path) + ".");
				}
                return; // Salir después de cargar solo game_points
            }
        }

        if (type_of_load == "all" || type_of_load == "settings") {
            // Cargar datos de "Settings"
            show_debug_message(
			    "Antes de la asignación: " + 
			    "current_sfx_index: " + string(global.current_sfx_index) + ", " +
			    "current_bg_index: " + string(global.current_bg_index) + ", " +
			    "PrimaryColor: " + string(global.primary_color_yellow) + ", " +
			    "SecondaryColor: " + string(global.secondary_color_purple) + ", " +
			    "HueShift: " + string(global.hue_shift) + ", " +
			    "InterfaceColor: " + string(global.interface_color) + ", " +
			    "InterfaceColorSecondary: " + string(global.interface_color_secondary)
			);

			global.current_sfx_index = ini_read_real("Settings", "CurrentSFXIndex", global.current_sfx_index);
			global.current_bg_index = ini_read_real("Settings", "CurrentBGIndex", global.current_bg_index);
			global.custom_sprites = json_parse(ini_read_string("Settings", "CustomSprites", json_stringify(global.custom_sprites)));
			global.primary_color_yellow = ini_read_real("Settings", "PrimaryColor", global.primary_color_yellow);
			global.secondary_color_purple = ini_read_real("Settings", "SecondaryColor", global.secondary_color_purple);
			global.hue_shift = ini_read_real("Settings", "HueShift", global.hue_shift);
			global.interface_color = ini_read_real("Settings", "InterfaceColor", global.interface_color);
			global.interface_color_secondary = ini_read_real("Settings", "InterfaceColorSecondary", global.interface_color_secondary);
			global.octo_icons = ini_read_real("Settings", "OctoIcons", global.octo_icons);
			global.lifebar = ini_read_real("Settings", "LifeBar", global.lifebar);
			
			show_debug_message(
			    "Después de la asignación: " + 
			    "current_sfx_index: " + string(global.current_sfx_index) + ", " +
			    "current_bg_index: " + string(global.current_bg_index) + ", " +
			    "PrimaryColor: " + string(global.primary_color_yellow) + ", " +
			    "SecondaryColor: " + string(global.secondary_color_purple) + ", " +
			    "HueShift: " + string(global.hue_shift) + ", " +
			    "InterfaceColor: " + string(global.interface_color) + ", " +
			    "InterfaceColorSecondary: " + string(global.interface_color_secondary)
			);
            if (type_of_load == "settings") {
                ini_close();
				if (global.first_load) {
			    show_message(global.current_language == "ENGLISH"
			        ? "Game data loaded successfully from " + string(dir_path) + "."
			        : "Datos de guardado cargados exitosamente desde " + string(dir_path) + ".");
				}
                return; // Salir después de cargar solo settings
            }
        }

        if (type_of_load == "all") {
            // Cargar la configuración del idioma (esto se hace al final para asegurarnos de que no interfiera)
            global.current_language = ini_read_string("Settings", "Language", "ENGLISH");
			global.song_text_list[0] = (global.current_language == "ENGLISH" ? "0. Add a new song (Shift)" : "0. Agregar nueva cancion (Shift)");
        }

        ini_close();
		
		if (global.first_load) {
	        show_message(global.current_language == "ENGLISH"
	            ? "Game data loaded successfully from " + string(dir_path) + "."
	            : "Datos de guardado cargados exitosamente desde " + string(dir_path) + ".");
		}
	} else {
		if (global.first_load) {
	        show_message(global.current_language == "ENGLISH"
	            ? "Save file not found."
	            : "Archivo de guardado no encontrado.");
		} else {
			show_debug_message("SAVE DATA NOT FOUND.")
		}
    }
}

function save_ini_data(dir_path=working_directory + "save_data.ini") {
	if (file_exists(dir_path)) file_delete(dir_path);
	
	ini_open(dir_path);

	// Sección de configuración general
	ini_write_string("Main", "Charts", global.charts);
	ini_write_string("Main", "GamePoints", global.game_points);
	ini_write_string("Main", "WinsLifebar", global.wins_lifebar);
	
	var array_string = "[";
    for (var i = 0; i < array_length(global.song_text_list); i++) {
        array_string += string(global.song_text_list[i]); // Sin comillas
        if (i < array_length(global.song_text_list) - 1) array_string += ", ";
    }
    array_string += "]";
	ini_write_string("Main", "SongNames", array_string);
		
	// Sección de colores de la interfaz
	ini_write_real("Settings", "CurrentSFXIndex", global.current_sfx_index);
	ini_write_real("Settings", "CurrentBGIndex", global.current_bg_index);
	ini_write_string("Settings", "CustomSprites", json_stringify(global.custom_sprites));
	ini_write_real("Settings", "PrimaryColor", global.primary_color_yellow);
	ini_write_real("Settings", "SecondaryColor", global.secondary_color_purple);
	ini_write_real("Settings", "HueShift", global.hue_shift);
	ini_write_real("Settings", "InterfaceColor", global.interface_color);
	ini_write_real("Settings", "InterfaceColorSecondary", global.interface_color_secondary);
	ini_write_string("Settings", "OctoIcons", global.octo_icons);
	ini_write_string("Settings", "LifeBar", global.lifebar);
	ini_write_string("Settings", "Language", global.current_language);
		
	// Cerrar el archivo INI
	ini_close();
	
	if (dir_path== working_directory + "save_data.ini" && array_length(global.song_list) > 1) {
		for (var i = 1; i <= array_length(global.song_list); i++) {
			// Copy the chart file to the ZIP
	        var chart_src_path = working_directory + "\\sounds\\songs\\charts\\" + string(i) + "_song" + string(i) + ".json";
	        if (file_exists(chart_src_path)) {
	            var updated_chart_file = {
			        easy: {
			            chart: global.charts.easy.charts[i],
			            tempo: global.charts.easy.tempo[i],
			            start_point: global.charts.easy.start_point[i]
			        },
			        normal: {
			            chart: global.charts.normal.charts[i],
			            tempo: global.charts.normal.tempo[i],
			            start_point: global.charts.normal.start_point[i]
			        },
			        hard: {
			            chart: global.charts.hard.charts[i],
			            tempo: global.charts.hard.tempo[i],
			            start_point: global.charts.hard.start_point[i]
			        }
			    };
				
				var chart_file_json = json_stringify(updated_chart_file);
				var file = file_text_open_write(chart_src_path);
		        file_text_write_string(file, chart_file_json);
		        file_text_close(file);
	        }
		}
	}
}

msg_width = 460;
msg_height = 340;

// Centro de la pantalla
msg_x = (room_width - msg_width) / 2;
msg_y = (room_height - msg_height) / 2;

msg_width2 = 500;
msg_height2 = 250;

// Centro de la pantalla
msg_x2 = (room_width - msg_width) / 2;
msg_y2 = (room_height - msg_height) / 2;

selected_row = 0;