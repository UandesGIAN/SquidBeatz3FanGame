/// @description Insert description here
// You can write your code in this editor

// Si el mensaje está activo, manejar clicks
if (message_shown) {
	if (keyboard_check_pressed(vk_escape)) {
		with (obj_editor_button) {
			blocked = 0;
		}
		selected_row = 0;
		message_shown = 0
		obj_sync_color_sample.blocked = 0;
		obj_sync_color_sample.exit_delay = current_time;
	}
	if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up)) {
		selected_row = (selected_row - 1 + 4) % 4;
	}
	if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down)) {
		selected_row = (selected_row + 1) % 4;
	}
	
    var mx = mouse_x;
    var my = mouse_y;
    var padding = 15;
	var text_y = msg_y + 80;

	// Botón "[CHARTS]"
	if ((mouse_check_button_pressed(mb_left) && mx > msg_x + msg_width / 2 - string_width("[CHARTS]") - 10 && mx < msg_x + msg_width / 2 + string_width("[CHARTS]") + 10 && my > msg_y + 90 - padding && my < msg_y + 90 + padding + 20) || (selected_row == 0 && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)))) {
	    load_ini_data(load_path, "charts");
	    message_shown = 0;
	    with (obj_editor_button) {
	        blocked = 0;
	    }
		obj_sync_color_sample.blocked = 0;
		obj_sync_color_sample.exit_delay = current_time;
	}

	// Botón "[PROGRESS]"
	if ((mouse_check_button_pressed(mb_left) && mx > msg_x + msg_width / 2 - string_width("[PROGRESS]") - 10 && mx < msg_x + msg_width / 2 + string_width("[PROGRESS]") + 10 && my > msg_y + 120 - padding && my < msg_y + 120 + padding + 20) || (selected_row == 1 && keyboard_check_pressed(vk_enter))) {
	    load_ini_data(load_path, "game_points");
	    message_shown = 0;
	    with (obj_editor_button) {
	        blocked = 0;
	    }
		obj_sync_color_sample.blocked = 0;
		obj_sync_color_sample.exit_delay = current_time;
	}

	// Botón "[SETTINGS]"
	if ((mouse_check_button_pressed(mb_left) && mx > msg_x + msg_width / 2 - string_width("[SETTINGS]") - 10 && mx < msg_x + msg_width / 2 + string_width("[SETTINGS]") + 10 && my > text_y + 120 + 15 - padding && my < text_y + 120 + 20 + padding) || (selected_row == 2 && keyboard_check_pressed(vk_enter))) {
	    load_ini_data(load_path, "settings");
	    message_shown = 0;
	    with (obj_editor_button) {
	        blocked = 0;
	    }
		obj_sync_color_sample.blocked = 0;
		obj_sync_color_sample.exit_delay = current_time;
	}

	// Botón "[ALL]"
	if ((mouse_check_button_pressed(mb_left) && mx > msg_x + msg_width / 2 - 50 - 10 && mx < msg_x + msg_width / 2 + 50 + 10 && my > text_y + 180 + 15 - padding +20 && my < text_y + 180 + 20 +20 + padding) || (selected_row == 3 && keyboard_check_pressed(vk_enter))) {
	    load_ini_data(load_path, "all");
	    message_shown = 0;
	    with (obj_editor_button) {
	        blocked = 0;
	    }
		obj_sync_color_sample.blocked = 0;
		obj_sync_color_sample.exit_delay = current_time;
	}
}


if (message_shown2) {
	if (keyboard_check_pressed(vk_escape)) {
		with (obj_editor_button) {
			blocked = 0;
		}
		selected_row = 0;
		message_shown2 = 0
		obj_sync_color_sample.blocked = 0;
		obj_sync_color_sample.exit_delay = current_time;
	}
	if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up)) {
		selected_row = (selected_row - 1 + 2) % 2;
	}
	if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down)) {
		selected_row = (selected_row + 1) % 2;
	}
	
	var mx = mouse_x;
	var my = mouse_y;
	var padding = 20;
	
	if ((mouse_check_button_pressed(mb_left) && mx > msg_x2 + msg_width2 / 2 - string_width("[CANCELAR]") - 10 && mx < msg_x2 + msg_width2 / 2 + string_width("[CANCELAR]") + 10 && my > msg_y2 + 90 + 40 - padding && 
	    my < msg_y2 + 90 + 40 + padding) || (selected_row == 0 && keyboard_check_pressed(vk_enter))) 
	{
	    // Acción para el botón CANCELAR
	    message_shown2 = 0; // Ejemplo de acción, ajusta según lo necesario
	    with (obj_editor_button) {
	        blocked = 0;
	    }
	    obj_sync_color_sample.blocked = 0;
	    obj_sync_color_sample.exit_delay = current_time;
	}

	// Botón "[BORRAR DATOS]"
	if ((mouse_check_button_pressed(mb_left) && 
	    mx > msg_x2 + msg_width2 / 2 - string_width("[BORRAR DATOS]") - 10 && mx < msg_x2 + msg_width2 / 2 + string_width("[BORRAR DATOS]") + 10 && my > msg_y2 + 120 + 20 + 60 - padding && 
	    my < msg_y2 + 120  + 20 + 60 + padding) || (selected_row == 1 && keyboard_check_pressed(vk_enter))) 
	{
	    // Acción para el botón BORRAR DATOS
	    for (var i = 0; i < array_length(global.song_text_list); i++) {
			var diff = ["easy", "normal", "hard"];
			for (var d = 0; d < 3; d++) {
				var difficulty = diff[d];
				global.game_points[$ difficulty].count_silver[i] = 0;
				global.game_points[$ difficulty].count_gold[i] = 0;
				global.game_points[$ difficulty].total_hits[i] = 0;
			}
		}
		save_ini_data();
		
		message_shown3 = 1;
	    message_shown2 = 0;
	}
}


if (message_shown3) {
	if ((keyboard_check_pressed(vk_anykey) && !global.is_gamepad) || (global.is_gamepad &&
	(gamepad_button_check_pressed(global.current_gamepad, gp_face1) || gamepad_button_check_pressed(global.current_gamepad,gp_face2) || gamepad_button_check_pressed(global.current_gamepad,gp_face3) || gamepad_button_check_pressed(global.current_gamepad,gp_face4)))) {
		with (obj_editor_button) {
			blocked = 0;
		}
		selected_row = 0;
		message_shown3 = 0
		obj_sync_color_sample.blocked = 0;
		obj_sync_color_sample.exit_delay = current_time;
	}
	
	if ((mouse_check_button_pressed(mb_left) && mouse_x > room_width / 2 - 80 && mouse_x < room_width / 2 + 80 && mouse_y > room_height / 2 + 100 - 25 - 20 && 
	    mouse_y < room_height / 2 + 100 - 25 + 40)) {
	    // Acción para el botón CANCELAR
	    message_shown3 = 0; // Ejemplo de acción, ajusta según lo necesario
	    with (obj_editor_button) {
	        blocked = 0;
	    }
		selected_row = 0;
	    obj_sync_color_sample.blocked = 0;
	    obj_sync_color_sample.exit_delay = current_time;
	}
}