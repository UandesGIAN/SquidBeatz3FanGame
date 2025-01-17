/// @description Insert description here
// You can write your code in this editor

// Desde el editor, si se presiona ctrl+O se permite cargar un chart desde un archivo JSON compatible
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("O")) && check_permissions()) {
	show_message(global.current_language == "ENGLISH" ? "WARNING: Opening a chart .JSON file will load the CURRENT DIFFICULTY's chart, be sure to be at the right difficulty to load. You can use the Load previous to load a chart from another difficulty." : "ADVERTENCIA: Abrir un archivo .JSON de un chart cargará el charteo de la DIFICULTAD ACTUAL. Asegúrate de estar en la dificultad correcta antes de cargar. Puedes usar la opción Cargar previo para cargar un charteo de otra dificultad.");
	var char_data = load_chart_from_file();
	if (char_data != undefined) {
		global.tempo = char_data[$ global.current_difficulty].tempo;
		global.current_chart = [];
		for (var i = 0; i < array_length(char_data[$ global.current_difficulty].chart); i++) {
			var element = char_data[$ global.current_difficulty].chart[i];
			array_push(global.current_chart, element);
		}
		global.start_point = char_data[$ global.current_difficulty].start_point;
		global.base_x = global.start_point;
		obj_chart_game.index_bar = 0;
		obj_chart_game.conteo_desplazamiento = 0;
		obj_chart_game.game_bar[0].x = global.start_point;
		for (var i = 1; i < 4; i++) {
		    obj_chart_game.game_bar[i].x = obj_chart_game.game_bar[i-1].x + obj_chart_game.sprite_width;
		}
	}
}

// Al hacer ctrl+S se permite exportar el archivo de charteo como JSON
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("S")) && check_permissions()) {
	if (array_length(global.current_chart) > 0 && (global.new_song_id == undefined || global.new_song_name == "")) {
		export_chart_to_file(global.tempo, global.current_chart, global.start_point);
    } else {
		show_message(global.current_language == "ENGLISH" ? "You can only save the current chart as a file if there is an element present or if it's not a new song that hasn't been saved." : "Sólo es posible guardar el charteo actual en un archivo si hay algún elemento presente o si no es una nueva canción que no ha sido guardada.");
	}
}

// Al hacer ctrl+T se permite reemplazar el nombre de la canción
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("R"))  && check_permissions()) {
	replace_song_name();
}

// Al hacer ctrl+Y se permite reemplazar el audio de la canción
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("T"))  && check_permissions()) {
	replace_song();
}

// Al hacer ctrl+T se permite exportar el archivo de charteo como JSON
if (keyboard_check(vk_control) && keyboard_check_pressed(vk_delete)) {
	if (show_question(global.current_language == "ENGLISH" ? "Are you sure?\nThis action will delete all elements from the current chart." : "¿Estás seguro?\nEsta acción borrará todos los elementos del chart actual.")) {
	    global.current_chart = [];
	}
}