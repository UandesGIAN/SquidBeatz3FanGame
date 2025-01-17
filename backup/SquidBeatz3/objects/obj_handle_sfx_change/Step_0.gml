
if (mouse_check_button_pressed(mb_left) && !global.is_gamepad) {
	if (message_shown == 1 && point_in_rectangle(mouse_x, mouse_y, dialog_x + 50, dialog_y + dialog_height - 50, dialog_x + dialog_width - 40, dialog_y + dialog_height + 10)) {
	    message_shown = 0;
		with(obj_editor_button) {
			blocked = 0;
		}
		obj_sync_color_sample.blocked = 0;
		obj_sync_color_sample.exit_delay = current_time;
		selected_row = 1;
		selected_col = 0;
		audio_stop_all();
	}
}

if (message_shown == 1 && selected_row == 4 && ((keyboard_check_pressed(vk_enter) && !global.is_gamepad) || (!gamepad_message && global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2)) )) {
	message_shown = 0;
	with(obj_editor_button) {
		blocked = 0;
	}
	obj_sync_color_sample.blocked = 0;
	obj_sync_color_sample.exit_delay = current_time;
	selected_row = 1;
	selected_col = 0;
	audio_stop_all();
}

if (((keyboard_check_pressed(vk_escape) && !global.is_gamepad) || (!gamepad_message && global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face1))) && message_shown == 1) {
    selected_row = 4;
}


if (gamepad_message && message_shown) {
	if (gamepad_button_check_pressed(global.current_gamepad, gp_face1)) {
		gamepad_message = 0;
	}
	
	if (mouse_check_button_pressed(mb_left)) {
	    var mx = mouse_x, my = mouse_y;
       
		if (point_in_rectangle(mx, my, room_width / 2 - 50, room_height / 2 + 100 - 50, room_width / 2 + 100, room_height / 2 + 100 + 10)) {
	        gamepad_message = 0;
		}
	}
}
