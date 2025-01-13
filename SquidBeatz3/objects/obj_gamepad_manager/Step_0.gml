var pass = 1;
if (room == Game) pass = !obj_play.play_music;

if (pass) {
	if (keyboard_check_pressed(ord("Z"))) {
	    if (global.is_gamepad) {
			if (global.current_language == "ENGLISH") add_message("Using keyboard.", 120);
	        else add_message("Usando teclado.", 120);
	        gamepad_connected_now = 0;
	        gamepad_connected = 0;
	        global.is_gamepad = false;
	        global.current_gamepad = -1;
	        already_shown = 1;
	    } else {
			if (global.current_language == "ENGLISH") add_message("Searching game controls", 120);
			else add_message("Buscando controles", 120);
			if (alarm_get(0) <= 0) {
	            alarm_set(0, 90); // 3 segundos
	        }
	    }
		global.gamepad_already_set = 1;
	}

	if (!global.gamepad_already_set) {
		for (var i = 0; i < 5; i++) {
		    if (gamepad_is_connected(i)) {
		        gamepad_connected_now = 1;
		        if (global.current_gamepad != i && !already_shown) {
					if (global.current_language == "ENGLISH") add_message("Controller " + string(i) + " found.", 120);
					else add_message("Control " + string(i) + " encontrado.", 120);
		            global.is_gamepad = true;
		            global.current_gamepad = i;
		            already_shown = 1;
		        }
		        break;
		    }
		}
	}
}