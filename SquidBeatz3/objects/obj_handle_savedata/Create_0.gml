/// @description Insert description here
// You can write your code in this editor

message_shown = 0; // load
message_shown2 = 0; // delete
message_shown3 = 0; // delete confirmation
load_path = "";

function load_ini_data(dir_path=working_directory + "save_data.ini", type_of_load) {
	
	if (file_exists(dir_path)) {
        ini_open(dir_path);

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
			
			var dif = ["easy", "normal", "hard"];
			for (var d = 0; d < 3; d++) {
				var difficulty = dif[d];
				for (var i = 0; i < array_length(global.charts[$ difficulty].charts); i++) {
					if (i < array_length(global.song_text_list) && i < array_length(loaded_charts[$ difficulty].charts)) {
						global.charts[$ difficulty].charts[i] = loaded_charts[$ difficulty].charts[i];
						global.charts[$ difficulty].tempo[i] = loaded_charts[$ difficulty].tempo[i];
						global.charts[$ difficulty].start_point[i] = loaded_charts[$ difficulty].start_point[i];
					}
				}
			}

            if (type_of_load == "charts") {
                ini_close();
				if (global.first_load) {
			    show_message(global.current_language == "ENGLISH"
			        ? "Game data loaded successfully from " + string(dir_path) + "."
			        : "Datos de guardado cargados exitosamente desde " + string(dir_path) + ".");
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
			
			json_string = ini_read_string("Main", "Charts", global.charts);
			json_string = string_replace_all(json_string, "normal", "\"normal\"");
			json_string = string_replace_all(json_string, "hard", "\"hard\"");
			json_string = string_replace_all(json_string, "easy", "\"easy\"");
			json_string = string_replace_all(json_string, "start_point", "\"start_point\"");
			json_string = string_replace_all(json_string, "tempo", "\"tempo\"");
			json_string = string_replace_all(json_string, "charts", "\"charts\"");
			json_string = string_replace_all(json_string, "index_type", "\"index_type\"");
			json_string = string_replace_all(json_string, "pos_x", "\"pos_x\"");
			
			var saved_game_charts = json_parse(json_string);
			
			json_string = ini_read_string("Main", "WinsLifebar", global.wins_lifebar);
			json_string = string_replace_all(json_string, "normal", "\"normal\"");
			json_string = string_replace_all(json_string, "hard", "\"hard\"");
			json_string = string_replace_all(json_string, "easy", "\"easy\"");
			
			var loaded_wins = json_parse(json_string);
			
			var dif = ["easy", "normal", "hard"];
			for (var d = 0; d < 3; d++) {
				var difficulty = dif[d];
				for (var i = 0; i < array_length(global.song_text_list); i++) {
					if (i < array_length(saved_game_charts[$ difficulty].charts)) { 
						if (array_length(saved_game_charts[$ difficulty].charts[i]) == array_length(global.charts[$ difficulty].charts[i])) {
							global.game_points[$ difficulty].count_silver[i] = loaded_game_points[$ difficulty].count_silver[i];
							global.game_points[$ difficulty].count_gold[i] = loaded_game_points[$ difficulty].count_gold[i];
							global.game_points[$ difficulty].total_hits[i] = loaded_game_points[$ difficulty].total_hits[i];
							global.wins_lifebar[$ difficulty][i] = loaded_wins[$ difficulty][i];
						}
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
		
	// Sección de colores de la interfaz
	ini_write_real("Settings", "CurrentSFXIndex", global.current_sfx_index);
	ini_write_real("Settings", "CurrentBGIndex", global.current_bg_index);
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