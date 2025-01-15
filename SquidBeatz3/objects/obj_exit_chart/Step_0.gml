/// @description Insert description here
// You can write your code in this editor

if (global.new_song_id == undefined || global.new_song_name == "") {
	switch (global.current_difficulty) {
		case "easy":
			if ((keyboard_check_pressed(ord("L")) || (!already_check_load && array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]) == 0)) &&
				(array_length(global.charts.normal.charts[global.current_chart_index]) > 0 ||
				array_length(global.charts.hard.charts[global.current_chart_index]) > 0)) {
				load_shown = !load_shown;
				obj_chart_game.message_shown = 1;
				obj_chart_game2.message_shown = 1;
				obj_editor_button.blocked = 1;
				already_check_load = 1;
			} else {
				if ((keyboard_check_pressed(ord("L")))) {
					show_message(global.current_language == "ENGLISH" ? "It is only possible to load a previous chart if there's a previous difficulty with a chart" : "Sólo es posible cargar un charteo anterior si alguno tiene elementos.");
				}
			}
			break;
		case "normal":
			if ((keyboard_check_pressed(ord("L")) || (!already_check_load && array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]) == 0)) &&
				(array_length(global.charts.easy.charts[global.current_chart_index]) > 0 ||
				array_length(global.charts.hard.charts[global.current_chart_index]) > 0)) {
				load_shown = !load_shown;
				already_check_load = 1;
				obj_chart_game.message_shown = 1;
				obj_chart_game2.message_shown = 1;
				obj_editor_button.blocked = 1;
			} else {
				if ((keyboard_check_pressed(ord("L")))) {
					show_message(global.current_language == "ENGLISH" ? "It is only possible to load a previous chart if there's a previous difficulty with a chart" : "Sólo es posible cargar un charteo anterior si alguno tiene elementos.");
				}
			}
			break;
		case "hard":
			if ((keyboard_check_pressed(ord("L")) ||  (!already_check_load && array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]) == 0)) &&
				(array_length(global.charts.easy.charts[global.current_chart_index]) > 0 ||
				array_length(global.charts.normal.charts[global.current_chart_index]) > 0)) {
				load_shown = !load_shown
				obj_chart_game.message_shown = 1;
				obj_chart_game2.message_shown = 1;
				obj_editor_button.blocked = 1;
				already_check_load = 1;
			} else {
				if ((keyboard_check_pressed(ord("L")))) {
					show_message(global.current_language == "ENGLISH" ? "It is only possible to load a previous chart if there's a previous difficulty with a chart" : "Sólo es posible cargar un charteo anterior si alguno tiene elementos.");
				}
			}
			break;
	}
} else {
	if ((keyboard_check_pressed(ord("L")))) {
		show_message(global.current_language == "ENGLISH" ? "It is only possible to load a previous chart after saving the new song." : "Sólo es posible cargar un charteo anterior tras guardar la nueva canción.");
	}
}


// Si el mensaje está activo, manejar clicks
if (message_shown) {
	if (keyboard_check_pressed(vk_escape)) {
		with (obj_editor_button) {
			blocked = 0;
		}
		selected_row = 0;
		obj_chart_game.message_shown = 0;
		obj_chart_game2.message_shown = 0;
		obj_editor_button.blocked = 0;
		message_shown = 0
	}
	if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up)) {
		selected_row = (selected_row - 1 + 3) % 3;
	}
	if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down)) {
		selected_row = (selected_row + 1) % 3;
	}
	
	if (global.current_song != undefined) {
		audio_stop_sound(global.current_song);
		global.current_song = obj_chart_game.current_song;
	}
	if (obj_chart_game.playing_audio) obj_chart_game.playing_audio = 0;
    var mx = mouse_x;
    var my = mouse_y;
    
    // Botón "CANCELAR"
    if ((mouse_check_button_pressed(mb_left) && mx > msg_x - btn_width - 20 && mx < msg_x + btn_width + 20 && my > btn_cancel_y + 20 && my < btn_cancel_y + 80) || (selected_row == 0 && keyboard_check_pressed(vk_enter)) || keyboard_check_pressed(vk_escape)) {
        message_shown = false; // Ocultar mensaje
		selected_row = 0;
		obj_chart_game.message_shown = 0;
		obj_chart_game2.message_shown = 0;
		obj_editor_button.blocked = 0;
    }
    
    // Botón "SALIR SIN GUARDAR"
    if ((mouse_check_button_pressed(mb_left) && mx > msg_x - btn_width - 20 && mx < msg_x + btn_width + 20 && my > btn_no_save_y + 25 && my < btn_no_save_y + 75) || (selected_row == 1 && keyboard_check_pressed(vk_enter))) {
        if (global.new_song_id != undefined || global.new_song_name != "") {
			audio_destroy_stream(global.new_song_id);
			global.new_song_id = undefined;
			global.new_song_name = "";
			global.current_chart_index = 0;
			global.current_song_index = 0;
			global.current_song = undefined;
			global.new_song_path = "";
			global.new_song_async_id = undefined;
			global.new_song_visualizer = [];
		}
		obj_chart_game.message_shown = 0;
		obj_chart_game2.message_shown = 0;
		obj_editor_button.blocked = 0;
		room_goto(Game); // Cambiar a la room
    }
    
    // Botón "SALIR Y GUARDAR"
    if ((mouse_check_button_pressed(mb_left) && mx > msg_x - btn_width - 20 && mx < msg_x + btn_width + 20 && my > btn_save_y + 25 && my < btn_save_y + 80) || (selected_row == 2 && keyboard_check_pressed(vk_enter))) {
		if (global.new_song_id != undefined || global.new_song_name != "") {
			if (save_song_at_gamefiles()) {
				audio_destroy_stream(global.new_song_id);	// Se libera memoria
				global.new_song_id = undefined;
				global.new_song_name = "";
				global.new_song_path = "";
				global.new_song_async_id = undefined;
				global.current_song_index = global.current_chart_index;
				
				var diff = ["easy", "normal", "hard"];
				for (var k = 0; k < 3; k++) {
					var d = diff[k];
					
					array_push(global.charts[$ d].charts, []);
					array_push(global.charts[$ d].tempo, global.tempo);
					array_push(global.charts[$ d].start_point, global.start_point);
				
					array_push(global.game_points[$ d].count_silver, 0);
					array_push(global.game_points[$ d].count_gold, 0);
					array_push(global.game_points[$ d].total_hits, 0);
					
					array_push(global.wins_lifebar[$ d], 0);
				}
			} else {
				if (global.current_language == "ENGLISH") show_message("Error trying to save chart.")
				else show_message("Error al guardar Chart.");
				restore_actions_new();
				bug_found = 1;
			}
		}
		if (bug_found == 0) {
			save_chart_at_gamefiles();
			load_single_song();
			
			obj_chart_game.message_shown = 0;
			obj_chart_game2.message_shown = 0;
			obj_editor_button.blocked = 0;
			room_goto(Game);
		}
	}
}

// Mostrar el mensaje si se presiona esc
if ((keyboard_check_pressed(vk_escape) || (keyboard_check_pressed(vk_shift) && obj_chart_game2.editing_element == -1)) && !load_shown) {
    if (message_shown) {
		with (obj_editor_button) {
			blocked = 0;
		}
		selected_row = 0;
		obj_chart_game.message_shown = 0;
		obj_chart_game2.message_shown = 0;
		obj_editor_button.blocked = 0;
	} else {
		obj_chart_game.message_shown = 1;
		obj_chart_game2.message_shown = 1;
		obj_editor_button.blocked = 1;
	}
	message_shown = !message_shown;
}

if (load_shown) {
	obj_chart_game.message_shown = 1;
	obj_chart_game2.message_shown = 1;
	obj_editor_button.blocked = 1;
	if (keyboard_check_pressed(vk_escape)) {
		with (obj_editor_button) {
			blocked = 0;
		}
		selected_row = 0;
		obj_chart_game.message_shown = 0;
		obj_chart_game2.message_shown = 0;
		obj_editor_button.blocked = 0;
		load_shown = 0
	}
	if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up)) {
		selected_row = (selected_row - 1 + 4) % 4; 
	}
	if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down)) {
		selected_row = (selected_row + 1) % 4;
	}
	
    if (global.current_song != undefined) {
        audio_stop_sound(global.current_song);
        global.current_song = obj_chart_game.current_song;
    }
    if (obj_chart_game.playing_audio) obj_chart_game.playing_audio = 0;
    
    var mx = mouse_x;
    var my = mouse_y;
    
    var msg_width = 500;
    var msg_height = 350;
    var btn_spacing = 20;
    var offset_y = 100;
    
    // Ajustar posiciones con el offset
    var adjusted_msg_x = msg_x;
    var adjusted_msg_y = msg_y + offset_y;
    
    var cancel_x = adjusted_msg_x;
    var cancel_y = adjusted_msg_y + 100;
    var easy_x = adjusted_msg_x - btn_width - btn_spacing;
    var normal_x = adjusted_msg_x;
    var hard_x = adjusted_msg_x + btn_width + btn_spacing;
    var btn_y = adjusted_msg_y - 5;
    
    // Botón "CANCELAR"
    if ((mouse_check_button_pressed(mb_left) && mx > cancel_x - btn_width && mx < cancel_x + btn_width && my > cancel_y - btn_height / 2 && my < cancel_y + btn_height / 2) || (selected_row == 0 && keyboard_check_pressed(vk_enter)) || keyboard_check_pressed(vk_escape)) {
        load_shown = 0; // Ocultar mensaje
		selected_row = 0;
		obj_chart_game.message_shown = 0;
		obj_chart_game2.message_shown = 0;
		obj_editor_button.blocked = 0;
    }
    
    // Botón "Easy"
    if (array_length(global.charts.easy.charts[global.current_chart_index]) > 0) {
        if ((mouse_check_button_pressed(mb_left) && mx > easy_x - btn_width / 20 && mx < easy_x + btn_width / 2 && my > btn_y - btn_height / 2 && my < btn_y + btn_height / 2 + 20) || (selected_row == 1 && keyboard_check_pressed(vk_enter))) {
            global.current_chart = [];
			for (var i = 0; i < array_length(global.charts.easy.charts[global.current_chart_index]); i++) {
				var element = global.charts.easy.charts[global.current_chart_index][i];
				array_push(global.current_chart, element);
			}
            global.tempo = global.charts.easy.tempo[global.current_chart_index];
            global.start_point = global.charts.easy.start_point[global.current_chart_index];
            load_shown = 0; // Ocultar mensaje
			global.base_x = global.start_point;
			obj_chart_game.index_bar = 0;
			obj_chart_game.conteo_desplazamiento = 0;
			obj_chart_game.game_bar[0].x = global.start_point;
			for (var i = 1; i < 4; i++) {
			    obj_chart_game.game_bar[i].x = obj_chart_game.game_bar[i-1].x + obj_chart_game.sprite_width;
			}
           
			if (global.current_language == "ENGLISH") show_message("Chart from easy difficulty loaded successfully.");
			else show_message("Chart de la dificultad fácil cargado con éxito.");
			obj_chart_game.message_shown = 0;
			obj_chart_game2.message_shown = 0;
			obj_editor_button.blocked = 0;
        }
    }

    // Botón "Normal"
    if (global.charts.normal.charts[global.current_chart_index] != []) {
        if ((mouse_check_button_pressed(mb_left) && mx > normal_x - btn_width / 2 && mx < normal_x + btn_width / 2 && my > btn_y - btn_height / 2 && my < btn_y + btn_height / 2 + 20) || (selected_row == 3 && keyboard_check_pressed(vk_enter))) {
            global.current_chart = [];
			for (var i = 0; i < array_length(global.charts.normal.charts[global.current_chart_index]); i++) {
				var element = global.charts.normal.charts[global.current_chart_index][i];
				array_push(global.current_chart, element);
			}
            global.tempo = global.charts.normal.tempo[global.current_chart_index];
            global.start_point = global.charts.normal.start_point[global.current_chart_index];
            load_shown = 0;
			global.base_x = global.start_point;
			obj_chart_game.index_bar = 0;
			obj_chart_game.conteo_desplazamiento = 0;
			obj_chart_game.game_bar[0].x = global.start_point;
			for (var i = 1; i < 4; i++) {
			    obj_chart_game.game_bar[i].x = obj_chart_game.game_bar[i-1].x + obj_chart_game.sprite_width;
			}
			
            if (global.current_language == "ENGLISH") show_message("Chart from normal difficulty loaded successfully.");
			else show_message("Chart de la dificultad normal cargado con éxito.");
			obj_chart_game.message_shown = 0;
			obj_chart_game2.message_shown = 0;
			obj_editor_button.blocked = 0;
        }
    }

    // Botón "Hard"
    if (global.charts.hard.charts[global.current_chart_index] != []) {
        if ((mouse_check_button_pressed(mb_left) && mx > hard_x - btn_width / 2 && mx < hard_x + btn_width / 2 && my > btn_y - btn_height / 2 && my < btn_y + btn_height / 2 + 20) || (selected_row == 4 && keyboard_check_pressed(vk_enter))) {
            global.current_chart = [];
			for (var i = 0; i < array_length(global.charts.hard.charts[global.current_chart_index]); i++) {
				var element = global.charts.hard.charts[global.current_chart_index][i];
				array_push(global.current_chart, element);
			}
            global.tempo = global.charts.hard.tempo[global.current_chart_index];
            global.start_point = global.charts.hard.start_point[global.current_chart_index];
            load_shown = 0;
			global.base_x = global.start_point;
			obj_chart_game.index_bar = 0;
			obj_chart_game.conteo_desplazamiento = 0;
			obj_chart_game.game_bar[0].x = global.start_point;
			for (var i = 1; i < 4; i++) {
			    obj_chart_game.game_bar[i].x = obj_chart_game.game_bar[i-1].x + obj_chart_game.sprite_width;
			}
			
            if (global.current_language == "ENGLISH") show_message("Chart from hard difficulty loaded successfully.");
			else show_message("Chart de la dificultad difícil cargado con éxito.");
			obj_chart_game.message_shown = 0;
			obj_chart_game2.message_shown = 0;
			obj_editor_button.blocked = 0;
        }
    }
}
