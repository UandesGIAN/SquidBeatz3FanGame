/// @description Insert description here
// You can write your code in this editor

if (file_exists(working_directory+"save_data.ini")) {
	ini_open(working_directory+"save_data.ini");
	global.current_language = ini_read_string("Settings", "Language", "ENGLISH");
	ini_close();
}


current_load = 0;
time_delay = current_time;

if (!variable_global_exists("current_language")) {
	global.current_language = "ENGLISH";
}

global.song_text_list = [
	(global.current_language == "ENGLISH" ? "0. Add a new song (Shift)" : "0. Agregar nueva cancion (Shift)"),
];

// Lista de canciones
if (!variable_global_exists("song_list")) {
    global.song_list = [
		undefined,
    ];
}
if (!variable_global_exists("song_visualizer")) {
    global.song_visualizer = [
		[],
    ];
}

// Lista de charteos por cancion
if (!variable_global_exists("charts")) {
    global.charts = {"easy": {"charts": [[]], "tempo": [120], "start_point": [272]},
					"normal": {"charts": [[]], "tempo": [120], "start_point": [272]},
					"hard": {"charts": [[]], "tempo": [120], "start_point": [272]}};	// Default
}
if (!variable_global_exists("game_points")) {
	global.game_points = {"easy": {"count_silver": [0], "count_gold": [0], "total_hits": [0]},
						 "normal": {"count_silver": [0], "count_gold": [0], "total_hits": [0]},
						 "hard": {"count_silver": [0], "count_gold": [0], "total_hits": [0]}};
}
if (!variable_global_exists("wins_lifebar")) {
	global.wins_lifebar = {"easy": [0],
						 "normal": [0],
						 "hard": [0]};
}

if (!variable_global_exists("sound_effects")) {
    global.sound_effects = [
		[tambourine, clap_drum, snare_drum], [tambourine, clap_drum, snare_drum], [tambourine, clap_drum, snare_drum]
    ];
}
if (!variable_global_exists("current_sfx_index")) {
    global.current_sfx_index = 0;
}

if (!variable_global_exists("bg_options")) {
    global.bg_options = [
		spr_background4, spr_background3, spr_background3, spr_background3
    ];
}
if (!variable_global_exists("current_bg_index")) {
    global.current_bg_index = 0;
}

if (!variable_global_exists("dance_sprites")) {
    global.dance_sprites = [
		[spr_dance1, spr_dance2, spr_dance3, spr_dance4, spr_dance5, spr_dance6, spr_dance7, spr_dance8],
		[spr_dance1, spr_dance2, spr_dance3, spr_dance4, spr_dance5, spr_dance6, spr_dance7, spr_dance8]
    ];
}
if (!variable_global_exists("custom_sprites")) {
    global.custom_sprites = [0,0]; // [default/none/using_custom, grayscale]
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
function load_songs_from_directory(dir_path=working_directory+"sounds\\") {
    // Variables locales para validar
    var json_path = dir_path + "\\song_titles.json";
    var song_names_array;
    var files, charts_files;
    var validation_success = true;

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
            show_message(global.current_language == "ENGLISH" ? "Error: The 'song_names' field was not found in the JSON file." : "Error: No se encontró el campo 'song_names' en el archivo JSON.");
            return;
        }
    } else {
        show_message(global.current_language == "ENGLISH" ? "Error: The JSON file was not found at path: " + json_path  : "Error: No se encontró el archivo JSON en la ruta: " + json_path);
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
    if (array_length(charts_files) != array_length(song_names_array)) {
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

        if (array_length(global.song_text_list) > 0) {
            for (var j = 0; j < array_length(global.song_text_list); j++) {
                if (string_copy(global.song_text_list[j], 4, string_length(global.song_text_list[j]) - 2) == song_name) {
                    show_debug_message("Canción ya cargada: " + song_name);
                    continue;
                }
            }
        }

        var new_file_name = string(array_length(global.song_text_list)) + "_song" + string(array_length(global.song_text_list)) + ".ogg";
        file_copy(file_name, working_directory + "sounds\\songs\\" + new_file_name);

        var sound_id = audio_create_stream(working_directory + "sounds\\songs\\" + new_file_name);
        array_push(global.song_list, sound_id);
        array_push(global.song_text_list, string(array_length(global.song_text_list)) + ". " + song_name);
    }

    for (var i = 0; i < array_length(charts_files); i++) {
        var chart_file = charts_files[i];
        var json_file = file_text_open_read(chart_file);
        var json_content = "";
        while (!file_text_eof(json_file)) {
            json_content += file_text_read_string(json_file);
            file_text_readln(json_file);
        }
        file_text_close(json_file);
		
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
		
		array_push(global.song_visualizer, visualizer_data.visualizer);
    }

    show_debug_message("¡Canciones y charteos cargados exitosamente!");
}


function load_sfx(dir_path=working_directory+"sounds\\sfx\\") {
	var sfx_files = [dir_path+"user1\\tambourine.ogg",
					dir_path+"user1\\clap_drum.ogg",
					dir_path+"user1\\snare_drum.ogg",
					dir_path+"user2\\tambourine.ogg",
					dir_path+"user2\\clap_drum.ogg",
					dir_path+"user2\\snare_drum.ogg"]
    
    for (var i = 0; i < 6; i++) {
		var file_path = sfx_files[i];
		var sound_id = undefined;
		
	    if (file_exists(file_path)) {
	        sound_id = audio_create_stream(file_path); // Create an audio stream to access the file
			if (i == 0 || i == 3) global.sound_effects[i < 3 ? 1 : 2][0] = sound_id;
		    else if (i == 1 || i == 4) global.sound_effects[i < 3 ? 1 : 2][1] = sound_id;
		    else if (i == 2 || i == 5) global.sound_effects[i < 3 ? 1 : 2][2] = sound_id;
	    } else {
	        show_debug_message((global.current_language == "ENGLISH" ? "No file found " : "No existe el archivo ") + string(file_path));
	    }
	}
}

function load_bg(dir_path=working_directory+"sprites\\") {
	var bg_files = [dir_path+"user1\\background.png",
					dir_path+"user1\\background.jpg",
					dir_path+"user2\\background.png",
					dir_path+"user2\\background.jpg"]
	for (var i = 0; i < 4; i++) {
		var file_path = bg_files[i];
		var sprite_id = undefined;
		
	    // If a valid file is selected
	    if (file_exists(file_path)) {
				sprite_id = sprite_add(file_path, 0, 0, 0, 0, 0);
				if (i == 0 || i == 1) global.bg_options[2] = sprite_id;
				if (i == 2 || i == 3) global.bg_options[3] = sprite_id;
	    } else {
	        show_debug_message((global.current_language == "ENGLISH" ? "No file found " : "No existe el archivo ") + string(file_path));
	    }
	}
}


function load_dances(dir_path=working_directory+"sprites\\") {
	var dance_files = [dir_path+"custom_dances\\dance1.gif",
					dir_path+"custom_dances\\dance2.gif",
					dir_path+"custom_dances\\dance3.gif",
					dir_path+"custom_dances\\dance4.gif",
					dir_path+"custom_dances\\dance5.gif",
					dir_path+"custom_dances\\dance6.gif",
					dir_path+"custom_dances\\dance7.gif",
					dir_path+"custom_dances\\dance8.gif",]
	
	for (var i = 0; i < 8; i++) {
		var file_path = dance_files[i];
		var gif_frame_sprites = undefined;
		var gif_delays = [0]; // delays per frame, in centiseconds
		
	    // If a valid file is selected
	    if (file_exists(file_path)) {
			var gif_sprite = sprite_add_gif(file_path, 0, 0, gif_delays, gif_frame_sprites);


		    // Guardar el GIF en el arreglo global
		    global.dance_sprites[1][i] = gif_sprite;
			show_debug_message(gif_sprite);
			
			show_debug_message(global.current_language == "ENGLISH" ? "Sprite dance " + string(i+1) + " successfully updated." : "Baile para el sprite " + string(i+1) + " actualizado con éxito.");
	    } else {
	        show_debug_message((global.current_language == "ENGLISH" ? "No file found " : "No existe el archivo ") + string(file_path));
	    }
	}
}


global.new_song_name = "";
global.new_song_id = undefined;
global.async_id = undefined;
global.new_song_path = "";
global.new_song_visualizer = [];

global.sound_delay = 0;
if (array_length(global.song_text_list) - 1 > 0) global.current_song_index = 1;
else global.current_song_index = 0;
global.current_song = global.song_list[global.current_song_index];
global.current_chart_index = global.current_song_index;
global.current_difficulty = "easy";

global.is_gamepad = 0;
global.current_gamepad = -1;
global.gamepad_already_set = 0;

// COLORES PERSONALIZACION
if (!variable_global_exists("primary_color_yellow")) {
    global.primary_color_yellow = c_yellow;
}
if (!variable_global_exists("secondary_color_purple")) {
    global.secondary_color_purple = make_color_rgb(125, 10, 255);
}
if (!variable_global_exists("hue_shift")) {
    global.hue_shift = 0;
}
if (!variable_global_exists("interface_color")) {
	global.interface_color = make_color_rgb(0,255,0);
}
if (!variable_global_exists("interface_color_secondary")) {
	global.interface_color_secondary = make_color_rgb(255,255,255);
}
if (!variable_global_exists("octo_icons")) {
	global.octo_icons = 0;
}
if (!variable_global_exists("lifebar")) {
	global.lifebar = 1;
}