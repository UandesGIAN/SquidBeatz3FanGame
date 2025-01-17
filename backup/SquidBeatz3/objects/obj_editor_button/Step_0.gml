/// @description Insert description here
// You can write your code in this editor

if (room == Settings) {
	if (obj_handle_savedata.message_shown || obj_handle_savedata.message_shown2 || obj_sync_color_sample.message_shown || obj_background_show.message_shown || obj_handle_sfx_change.message_shown) blocked = 1;
} else {
	if (obj_chart_game.message_shown || obj_chart_game2.message_shown) blocked = 1;
	else blocked = 0;
}

if (!blocked) {
	if (seleccionado && ((keyboard_check_pressed(vk_enter) && !global.is_gamepad) || (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2)))) {
		temporizador_presionado = current_time;
		if (is_callable(action)) {
	        action();
	    }
	}
	if (!global.is_gamepad) {
		mouse_encima = point_in_rectangle(mouse_x, mouse_y, x, y, x + ancho, y + alto);

		// Si el mouse está encima y se presiona
		if (mouse_encima && (mouse_check_button_pressed(mb_left) && !global.is_gamepad)) {
		    presionado = true;
		    temporizador_presionado = current_time;
		}

		// Temporizador para el efecto de presionado
		if (presionado == true && (current_time - temporizador_presionado) > 200) {
			// Llamar la acción si está definida
		    if (is_callable(action)) {
		        action();
		    }
			presionado = false;
		}
	}
}

if (game_controller_message) {
	if (gamepad_button_check_pressed(global.current_gamepad, gp_face1)) {
		game_controller_message = 0;
		with (obj_editor_button) {
			blocked = 0;
		}
		obj_sync_color_sample.blocked = 0;
		obj_sync_color_sample.exit_delay = current_time;
	}
	
	if (mouse_check_button_pressed(mb_left)) {
	    var mx = mouse_x, my = mouse_y;
       
		if (point_in_rectangle(mx, my, room_width / 2 - 50, room_height / 2 + 100 - 50, room_width / 2 + 100, room_height / 2 + 100 + 10)) {
	        game_controller_message = 0;
			with (obj_editor_button) {
				blocked = 0;
			}
			obj_sync_color_sample.blocked = 0;
			obj_sync_color_sample.exit_delay = current_time;
		}
	}
}