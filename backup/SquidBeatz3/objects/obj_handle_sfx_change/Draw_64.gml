/// @description Adjust table layout with specified format
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(splat_font_title);

if (message_shown && current_time - inputs_delay > 100) {
	// row 1,2,3,(4) and col 0,1,2,3,4
	if (!gamepad_message) {
	    // Keyboard navigation
	    if ((keyboard_check_pressed(vk_up) && !global.is_gamepad) || (global.is_gamepad && (gamepad_button_check_pressed(global.current_gamepad, gp_padu) || !stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislv) < -0.5))) {
	        selected_row = max(1, (selected_row - 1 + 5) % 5);
			if (global.is_gamepad) stick_moved = 1;
	    }
		if ((keyboard_check_pressed(vk_right) && !global.is_gamepad) || (global.is_gamepad && (gamepad_button_check_pressed(global.current_gamepad, gp_padr) || !stick_moved &&gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5))) {
			selected_col = (selected_col + 1) % 5;	
			if (global.is_gamepad) stick_moved = 1;
		}
		if ((keyboard_check_pressed(vk_down) && !global.is_gamepad)|| (global.is_gamepad && (gamepad_button_check_pressed(global.current_gamepad, gp_padd) || !stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislv) > 0.5))) {
	        selected_row = max(1, (selected_row + 1) % 5);
			if (global.is_gamepad) stick_moved = 1;
	    }
		if ((keyboard_check_pressed(vk_left) && !global.is_gamepad) || (global.is_gamepad && (gamepad_button_check_pressed(global.current_gamepad, gp_padl) || !stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5))) {
			selected_col = (selected_col - 1 + 5) % 5;
			if (global.is_gamepad) stick_moved = 1;
		}
	
		if (global.is_gamepad && abs(gamepad_axis_value(global.current_gamepad, gp_axislh)) < 0.2 && abs(gamepad_axis_value(global.current_gamepad, gp_axislv)) < 0.2) {
	        stick_moved = 0;
	    }
	}
	
    // Dibujar el diálogo
    draw_set_color(c_dkgray);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, false);

    draw_set_color(c_white);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, true);

    var table_x = room_width / 2;
    var table_y = (room_height / 2) - 120; // Subir 120 píxeles
    var cell_width = 150;
    var cell_height = 50;
    var row_spacing = 20;
    var col_spacing = 10;

    // Títulos y sprites
    var row_headers = ["SFX", "DEFAULT", "USER1", "USER2"];
    var row_actions = ["EDIT", "", "REPLACE", "REPLACE"];
	if (global.current_language == "CASTELLANO") row_actions = ["EDITAR", "", "REEMPLAZAR", "REEMPLAZAR"];
    var sprites = [spr_lr, spr_lr2, spr_abxy];
    var button_text = "Play";
	if (global.current_language == "CASTELLANO") button_text = "Escuchar";
    // Colores
    var color_title = c_white;
    var color_action = make_color_rgb(200, 150, 0);
    var color_button = c_green;
    var color_cell_bg = c_ltgray;

    // Dibujar filas
    for (var row = 0; row < 4; row++) {
        var y_local = table_y + row * (cell_height + row_spacing);

        // Dibujar encabezados de fila como botones con borde
        var x_local_header = table_x - 2 * (cell_width + col_spacing);
        var header_width = string_width(row_headers[row]) + 20; // Añadir margen al ancho
        var header_height = string_height(row_headers[row]) + 10; // Añadir margen al alto

        if (row > 0) { // Solo para "DEFAULT", "USER1", "USER2"
            // Dibujar fondo y borde
            draw_set_color(color_cell_bg);
            draw_rectangle(x_local_header - cell_width / 2, y_local - cell_height / 2, x_local_header + cell_width / 2, y_local + cell_height / 2, false);

			if (point_in_rectangle(mouse_x, mouse_y, x_local_header - header_width / 2, y_local - header_height / 2, x_local_header + header_width / 2, y_local + header_height / 2) && !global.is_gamepad) {
				selected_row = row;
				selected_col = 0;
			}

            // Detectar clics en encabezados
            if (mouse_check_button_pressed(mb_left) && !global.is_gamepad) {
                var mx = mouse_x, my = mouse_y;
                if (point_in_rectangle(mx, my, x_local_header - header_width / 2, y_local - header_height / 2, x_local_header + header_width / 2, y_local + header_height / 2)) {
					global.current_sfx_index = row - 1;
					audio_stop_all();
                }
            }
			
			if (((keyboard_check_pressed(vk_enter) && !global.is_gamepad) || (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2)) && !gamepad_message) && selected_row == row && selected_col == 0) {
				global.current_sfx_index = row - 1;
				audio_stop_all();
			}
        }

        // Dibujar el texto del encabezado
        if (row == 0) draw_set_color(c_white);
		else draw_set_color(c_dkgrey)
		if (global.current_sfx_index == row - 1) {
			draw_set_color(global.primary_color_yellow);
		}
		if (selected_col == 0 && selected_row == row) draw_set_color(global.secondary_color_purple);
		draw_text(x_local_header, y_local, row_headers[row]);
		
        // Dibujar "EDIT" como texto en la primera columna de acciones
        var x_local_action = table_x - 1 * (cell_width + col_spacing);
        draw_set_color(color_action);
        if (row == 0) {
            draw_set_color(c_white);
            draw_text(x_local_action, y_local, row_actions[row]);
        } else {
            // Dibujar los botones de acciones
            if (row != 1) {
                draw_set_color(color_cell_bg);
                draw_rectangle(x_local_action - cell_width / 2, y_local - cell_height / 2, x_local_action + cell_width / 2, y_local + cell_height / 2, false);
            }
			
			if (point_in_rectangle(mouse_x, mouse_y, x_local_action - cell_width / 2, y_local - cell_height / 2, x_local_action + cell_width / 2, y_local + cell_height / 2) && !global.is_gamepad) {
				selected_row = row;
				selected_col = 1;
			}
			
            if (row == selected_row && selected_col == 1) {
	            draw_set_color(global.secondary_color_purple);
	        } else {
	            draw_set_color(make_color_rgb(200, 150, 0));
	        }
            draw_text(x_local_action, y_local, row_actions[row]);

            // Detectar clics en acciones
            if (mouse_check_button_pressed(mb_left) && !global.is_gamepad) {
                var mx = mouse_x, my = mouse_y;
                if (point_in_rectangle(mx, my, x_local_action - cell_width / 2, y_local - cell_height / 2, x_local_action + cell_width / 2, y_local + cell_height / 2)) {
                    if (row == 3) change_or_add_sfx(2);
					else change_or_add_sfx(1);
					
					global.current_sfx_index = row - 1;
                }
            }
			if (((keyboard_check_pressed(vk_enter) && !global.is_gamepad) || (!gamepad_message && global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2))) && selected_row == row && selected_col == 1) {
				if(global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2)) {
					gamepad_message = 1;
				} else {
					if (row == 3) change_or_add_sfx(2);
					else change_or_add_sfx(1);
					
					global.current_sfx_index = row - 1;
				}
			}
        }

        // Dibujar sprites o botones
        for (var col = 0; col < 3; col++) {
            var x_local = table_x + col * (cell_width + col_spacing);

            if (row == 0) {
                // Primera fila: dibujar sprites
				shader_set(shader_hue_shift);
				shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);

                draw_sprite(sprites[col], 0, x_local - 15, y_local - 25);
				shader_reset();
            } else {
                // Otras filas: dibujar botones
                draw_set_color(color_cell_bg);
                draw_rectangle(x_local - cell_width / 2, y_local - cell_height / 2, x_local + cell_width / 2, y_local + cell_height / 2, false);
				
				if (point_in_rectangle(mouse_x, mouse_y, x_local - cell_width / 2, y_local - cell_height / 2, x_local + cell_width / 2, y_local + cell_height / 2) && !global.is_gamepad) {
					selected_row = row;
					selected_col = col+2;
				}
				
				if (row == selected_row && col+2 == selected_col) {
	                draw_set_color(global.secondary_color_purple);
	            } else {
	                draw_set_color(color_button);
	            }
                draw_text(x_local, y_local, button_text);

                // Detectar clics en botones
                if (mouse_check_button_pressed(mb_left) && !global.is_gamepad) {
                    var mx = mouse_x, my = mouse_y;
                    if (point_in_rectangle(mx, my, x_local - cell_width / 2 + 20, y_local - cell_height / 2, x_local + cell_width / 2 + 10, y_local + cell_height / 2)) {
                        var index = row;
						var column = (col + 1) % 3;
						audio_play_sound(global.sound_effects[index-1][column], 0, 0);
                    }
                }
				if (((keyboard_check_pressed(vk_enter) && !global.is_gamepad) || (!gamepad_message && global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2))) && selected_row == row && col+2 == selected_col) {
					var index = row;
					var column = (col + 1) % 3;
					audio_play_sound(global.sound_effects[index-1][column], 0, 0);
				}
            }
        }
    }

    // Botón de "SALIR"
    if (message_shown == 1) {
        var mx = mouse_x, my = mouse_y;
        if (selected_row == 4 || (point_in_rectangle(mx, my, dialog_x + 50, dialog_y + dialog_height - 50, dialog_x + dialog_width - 40, dialog_y + dialog_height + 10) && !global.is_gamepad)) {
            salir_text_color = global.secondary_color_purple;
        } else {
            salir_text_color = c_white; // Revertir el color si el mouse no está sobre el botón
        }
    }
    draw_set_color(salir_text_color);
    if (global.current_language == "ENGLISH") draw_text(dialog_x + dialog_width / 2, dialog_y + dialog_height - 25, "EXIT");
	else draw_text(dialog_x + dialog_width / 2, dialog_y + dialog_height - 25, "SALIR");
}


if (gamepad_message) {
	draw_set_color(c_dkgrey);
	draw_rectangle(room_width / 2 - 250,room_height / 2 - 100, room_width / 2 + 250, room_height / 2 + 100, 0);
	draw_set_color(c_white);
	draw_rectangle(room_width / 2 - 250,room_height / 2 - 100, room_width / 2 + 250, room_height / 2 + 100, 1);
	draw_set_halign(fa_center);
	
	draw_set_font(splat_font_title);
	if (global.current_language == "ENGLISH") {
		draw_text(room_width / 2, room_height / 2-15, "You can not use this function with a")
		draw_text(room_width / 2, room_height / 2+15, "game controller, switch to keyboard.")
	} else {
		draw_text(room_width / 2, room_height / 2-15, "No puedes acceder a esta funcion usando")
		draw_text(room_width / 2, room_height / 2+15, "un control, cambia a teclado.")
	}
	
	// Botón de "SALIR"
    draw_set_color(make_color_rgb(125, 10, 255));
    if (global.current_language == "ENGLISH") draw_text(room_width / 2, room_height / 2 + 100 - 25, "EXIT");
	else draw_text(room_width / 2, room_height / 2 + 100 - 25, "SALIR");
	draw_set_color(c_white);
	draw_sprite(spr_b_button, 0, room_width / 2 + 50, room_height / 2 + 64);
}