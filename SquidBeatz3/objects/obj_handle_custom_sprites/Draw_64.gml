// Dibujar interfaz de cambio de fondo
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (message_shown && current_time - inputs_delay > 100) {
	// row 1,2,3,4,(5) and col 0,1
	if (!gamepad_message) {
	    // Keyboard navigation
	    if (selected_col == 0 && (keyboard_check_pressed(vk_up) && !global.is_gamepad) || (global.is_gamepad && (gamepad_button_check_pressed(global.current_gamepad, gp_padu) || !stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislv) < -0.5))) {
	        selected_row = max(1, (selected_row - 1 + 6) % 6);
			if (global.is_gamepad) stick_moved = 1;
	    }
		if (((keyboard_check_pressed(vk_right) && !global.is_gamepad) || (global.is_gamepad && (gamepad_button_check_pressed(global.current_gamepad, gp_padr) || !stick_moved &&gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5)))) {
			if (selected_row == 3 && selected_col == 0) {
				selected_col = 1;
				selected_row = 4;
			} else if (selected_row > 2) {
				selected_col = (selected_col + 1) % 9;
			}
			if (global.is_gamepad) stick_moved = 1;
		}
		if ((keyboard_check_pressed(vk_down) && !global.is_gamepad) || (global.is_gamepad && (gamepad_button_check_pressed(global.current_gamepad, gp_padd) || !stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislv) > 0.5))) {
	        if (selected_col == 0) {
				selected_row = max(1, (selected_row + 1) % 6);
				if (global.is_gamepad) stick_moved = 1;
			} else {
				selected_row = 5;
				selected_col = 0;
			}
	    }
		if ((keyboard_check_pressed(vk_left) && !global.is_gamepad) || (global.is_gamepad && (gamepad_button_check_pressed(global.current_gamepad, gp_padl) || !stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5))) {
			selected_col = (selected_col - 1 + 9) % 9;
			if (global.is_gamepad) stick_moved = 1;
		}
	
		if (global.is_gamepad && abs(gamepad_axis_value(global.current_gamepad, gp_axislh)) < 0.2 && abs(gamepad_axis_value(global.current_gamepad, gp_axislv)) < 0.2) {
	        stick_moved = 0;
	    }
	}
	
    draw_set_color(c_dkgray);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, false);

    draw_set_color(c_white);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, true);

    // Configuración inicial
    var table_x = room_width / 2 - 220;
    var table_y = room_height / 2 - 100;
    var cell_width = 150;
    var cell_height = 50;
    var row_spacing = 20; // Reducido
    var col_spacing = 20; // Reducido

    // Datos de las filas
    var row_headers = ["SELECTED", "DEFAULT", "NONE", "CUSTOM", "SILHOUETTE"];
    if (global.current_language == "CASTELLANO") {
		cell_width = 200;
		table_x = room_width / 2 - 170;
        row_headers = ["SELECCION", "DEFAULT", "NADA", "PERSONALIZADO", "SILUETA"];
    }

    var sprites = global.dance_sprites; // Lista de sprites

    // Colores
    var color_text = c_white;
    var color_button_border = c_ltgray;
    var color_selected = global.primary_color_yellow;
    var color_action = make_color_rgb(200, 150, 0);

    // Dibujar encabezados (sin fondo)
    draw_set_color(color_text);
    var header_y = table_y - cell_height - 10;
    draw_text(table_x - (cell_width + col_spacing), header_y, row_headers[0]);

    // Dibujar tabla
    for (var row = 1; row < array_length(row_headers); row++) {
        var y_local = table_y + (row - 1) * (cell_height + row_spacing);
		
        // Dibujar encabezados con fondo
        var x_header = table_x - (cell_width + col_spacing);
        
		if (row < 4) {
			draw_set_color(color_button_border);
	        draw_rectangle(x_header - cell_width / 2, y_local - cell_height / 2, x_header + cell_width / 2, y_local + cell_height / 2, false);
	        draw_set_color(row == global.custom_sprites[0] + 1 ? color_selected : c_dkgrey);
			if (point_in_rectangle(mouse_x, mouse_y, x_header - cell_width / 2, y_local - cell_height / 2, x_header + cell_width / 2, y_local + cell_height / 2) && !global.is_gamepad) {
				selected_row = row;
				selected_col = 0;
			}
		
			if (selected_col == 0 && selected_row == row) draw_set_color(global.secondary_color_purple);
	        draw_text(x_header, y_local, row_headers[row]);
			
			// Detectar clic en encabezados
	        if (mouse_check_button_pressed(mb_left) && !global.is_gamepad) {
	            if (point_in_rectangle(mouse_x, mouse_y, x_header - cell_width / 2, y_local - cell_height / 2, x_header + cell_width / 2, y_local + cell_height / 2)) {
	                if (row > 0) global.custom_sprites[0] = row - 1;
	            }
	        }
		
			if (((keyboard_check_pressed(vk_enter) && !global.is_gamepad) || (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2)) && !gamepad_message) && selected_row == row && selected_col == 0) {
				if (row > 0) global.custom_sprites[0] = row - 1;
			}
		} else {
			draw_set_color(c_white);
			draw_rectangle(x_header - cell_width / 2+2, y_local - 15, x_header - cell_width / 2 + 32, y_local + 15, true);
			if (global.custom_sprites[1]) {
				draw_set_color(global.secondary_color_purple);
				draw_rectangle(x_header - cell_width / 2+7, y_local - 10 , x_header - cell_width / 2 + 27, y_local + 10, false);
			}
			if (point_in_rectangle(mouse_x, mouse_y, x_header - cell_width / 2, y_local - cell_height / 2, x_header + cell_width / 2, y_local + cell_height / 2) && !global.is_gamepad) {
				selected_row = row;
				selected_col = 0;
			}
			draw_set_color(c_white);
			if (selected_col == 0 && selected_row == row) draw_set_color(global.secondary_color_purple);
	        draw_text(x_header + 25 - (global.current_language == "CASTELLANO" ? 25: 0), y_local, row_headers[row]);
			
			// Detectar clic en encabezados
	        if (mouse_check_button_pressed(mb_left) && !global.is_gamepad) {
	            if (point_in_rectangle(mouse_x, mouse_y, x_header - cell_width / 2, y_local - cell_height / 2 + (global.current_language == "CASTELLANO" ? 30: 0), x_header + cell_width / 2, y_local + cell_height / 2 + (global.current_language == "CASTELLANO" ? 30: 0))) {
	                if (row == 4) global.custom_sprites[1] = !global.custom_sprites[1];
	            }
	        }
		
			if (((keyboard_check_pressed(vk_enter) && !global.is_gamepad) || (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2)) && !gamepad_message) && selected_row == row && selected_col == 0) {
				if (row == 4) global.custom_sprites[1] = !global.custom_sprites[1];
			}
		}
		if (row == 1) {
	        // Dibujar sprites
			for (var j = 0; j < 8; j++) {
				var sprite_to_draw = sprites[0][j];
			    var x_sprite = table_x + (cell_width + (col_spacing*4.8)*j) - 175- (global.current_language == "CASTELLANO" ? 85 : 0);
			    var x_scale =  77 / sprite_get_width(sprite_to_draw);
			    var y_scale = 116 / sprite_get_height(sprite_to_draw);
				draw_set_color(c_white);
				draw_rectangle(x_sprite - 77 + 40, y_local - 90, x_sprite + 77 - 40, y_local - 90 + 116, 1);
				draw_set_color(c_black);
				draw_rectangle(x_sprite - 77 + 40, y_local - 90, x_sprite + 77 - 40, y_local - 90 + 116, 0);
			    draw_sprite_ext(sprite_to_draw, 0, x_sprite - 35, y_local - 90, x_scale, y_scale, 0, c_white, 1);
				
			}
		} else if (row == 4) {
	        // Dibujar sprites
			for (var j = 0; j < 8; j++) {
				var sprite_to_draw = sprites[1][j];
			    var x_sprite = table_x + (cell_width + (col_spacing*4.8)*j) - 175 - (global.current_language == "CASTELLANO" ? 85 : 0);
			    var x_scale =  77 / sprite_get_width(sprite_to_draw);
			    var y_scale = 116 / sprite_get_height(sprite_to_draw);
				if (point_in_rectangle(mouse_x, mouse_y,x_sprite - 77 + 40, y_local - 130 - 20, x_sprite + 77 - 40, y_local - 130 + 116 - 20) && !global.is_gamepad) {
					selected_row = 4;
					selected_col = j+1;
				}
				draw_set_color(c_white);
				if (selected_col == j+1 && selected_row == row) draw_set_color(global.secondary_color_purple);
				draw_rectangle(x_sprite - 77 + 40, y_local - 130 - 20, x_sprite + 77 - 40, y_local - 130 + 116 - 20, 1);
				draw_set_color(c_dkgray);
				draw_rectangle(x_sprite - 77 + 40, y_local - 130 - 20, x_sprite + 77 - 40, y_local - 130 + 116 - 20, 0);
			    
				if (global.custom_sprites[1] && sprite_to_draw != sprites[0][j]) {
					shader_set(shader_silhouette);

					// Dibujamos el sprite en su escala y posición original
					draw_sprite_ext(sprite_to_draw, 0, x_sprite - 35, y_local - 130 - 20, x_scale, y_scale, 0, c_white, 1);
					shader_reset();  

					shader_set(shader_outline);
					// Obtener la uniform de tamaño de textura y pasar el valor
					var tex_size_uniform = shader_get_uniform(shader_outline, "u_texture_size");
					shader_set_uniform_f(tex_size_uniform, sprite_get_width(sprite_to_draw)*x_scale, sprite_get_height(sprite_to_draw)*y_scale); // Tamaño de la textura

					// Pasar el color del borde al shader
					var edge_color_uniform = shader_get_uniform(shader_outline, "u_edge_color");
					shader_set_uniform_f(edge_color_uniform, 1,1,1, 1);  // Establecer el color del borde

					// Dibujar el sprite negro con borde blanco, y reemplazar el borde blanco
					draw_sprite_ext(sprite_to_draw, 0, x_sprite - 35, y_local - 130 - 20, x_scale, y_scale, 0, c_white, 1);
					shader_reset();
				} else {
					draw_sprite_ext(sprite_to_draw, 0, x_sprite - 35, y_local - 130 - 20, x_scale, y_scale, 0, c_white, 1);
				}
				
				
				// Detectar clic en encabezados
		        if (mouse_check_button_pressed(mb_left) && !global.is_gamepad) {
		            if (point_in_rectangle(mouse_x-50, mouse_y, x_sprite - 77 + 40, y_local - 130 - 20, x_sprite + 77 - 40, y_local - 130 + 116 - 20) && check_permissions()) {
		                loadGIF(j);
		            }
		        }
		
				if (((keyboard_check_pressed(vk_enter) && !global.is_gamepad) && selected_row == row && selected_col == j+1)) {
					if (check_permissions()) loadGIF(j);
				} else if ((global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2)) && !gamepad_message && selected_row == row && selected_col == j+1) {
					gamepad_message = 1;
				}
			}
			
			draw_set_color(global.primary_color_yellow);
			draw_text(x_header + 280 + (global.current_language == "CASTELLANO" ? 17 + string_width("ESCALA DE GRISES"): string_width("SILHOUETTE") + 90), room_height - 255 - 20, global.current_language == "ENGLISH" ? "Click on one of the custom sprites to change it!" : "Has click sobre uno de los sprites personalizados para cambiarlo!")
		}
    }

    // Botón de "SALIR"
    if (message_shown == 1) {
        var mx = mouse_x, my = mouse_y;
        if (selected_row == 5 || (point_in_rectangle(mx, my, dialog_x + 50, dialog_y + dialog_height - 50, dialog_x + dialog_width - 40, dialog_y + dialog_height + 10) && !global.is_gamepad)) {
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