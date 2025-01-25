if (array_length(botones) > 0) {
	if (obj_handle_custom_sprites.message_shown || obj_handle_savedata.message_shown2 || obj_sync_color_sample.message_shown || obj_background_show.message_shown || obj_handle_sfx_change.message_shown) blocked = 1;

	if (!blocked) {
		if (current_time - exit_delay > 50 && (keyboard_check_pressed(vk_escape) && !global.is_gamepad)|| (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face1))) {
				botones[indice_actual].seleccionado = false; // Deselecciona el actual
		        botones[0].seleccionado = true; // Selecciona el primero
		}
	    // Navegar entre botones con las flechas
	    if (((keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_left)) && !global.is_gamepad) || (global.is_gamepad &&
			(gamepad_button_check_pressed(global.current_gamepad, gp_padu) || gamepad_button_check_pressed(global.current_gamepad, gp_padl)) ||
			(!stick_moved && (gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5 || gamepad_axis_value(global.current_gamepad, gp_axislv) < -0.5)))) {
			if ((indice_actual == 6 || indice_actual == 7) && (keyboard_check_pressed(vk_left) || (
				gamepad_button_check_pressed(global.current_gamepad, gp_padl) || (!stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5) ))) {
				botones[indice_actual].seleccionado = false; // Deselecciona el actual
		        indice_actual = (indice_actual - 2 + array_length(botones)) mod array_length(botones); // Mover al anterior
		        botones[indice_actual].seleccionado = true; // Selecciona el nuevo
			} else if ((indice_actual == 8) && (keyboard_check_pressed(vk_left) || (
				gamepad_button_check_pressed(global.current_gamepad, gp_padl) || (!stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5) ))) {
				botones[indice_actual].seleccionado = false; // Deselecciona el actual
		        indice_actual = (indice_actual - 5 + array_length(botones)) mod array_length(botones); // Mover al anterior
		        botones[indice_actual].seleccionado = true; // Selecciona el nuevo
			} else if ((indice_actual == 9 || indice_actual == 10) && (keyboard_check_pressed(vk_left) || (
				gamepad_button_check_pressed(global.current_gamepad, gp_padl) || (!stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5) ))) {
				botones[indice_actual].seleccionado = false; // Deselecciona el actual
		        indice_actual = (indice_actual - 3 + array_length(botones)) mod array_length(botones); // Mover al anterior
		        botones[indice_actual].seleccionado = true; // Selecciona el nuevo
			} else {
				botones[indice_actual].seleccionado = false; // Deselecciona el actual
		        indice_actual = (indice_actual - 1 + array_length(botones)) mod array_length(botones); // Mover al anterior
		        botones[indice_actual].seleccionado = true; // Selecciona el nuevo
			}
			if (global.is_gamepad) stick_moved = 1;
	    }
	    if (((keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_right)) && !global.is_gamepad) || (global.is_gamepad &&
			(gamepad_button_check_pressed(global.current_gamepad, gp_padd) || gamepad_button_check_pressed(global.current_gamepad, gp_padr)) ||
			(!stick_moved && (gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5 || gamepad_axis_value(global.current_gamepad, gp_axislv) > 0.5)))) {
	        if ((indice_actual == 3) && (keyboard_check_pressed(vk_right) || (
				gamepad_button_check_pressed(global.current_gamepad, gp_padr) || (!stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5) ))) {
				botones[indice_actual].seleccionado = false; // Deselecciona el actual
		        indice_actual = (indice_actual + 6) mod array_length(botones); // Mover al siguiente
		        botones[indice_actual].seleccionado = true; // Selecciona el nuevo
			} else if ((indice_actual == 0 || indice_actual == 4 || indice_actual == 5) && (keyboard_check_pressed(vk_right) || (
				gamepad_button_check_pressed(global.current_gamepad, gp_padr) || (!stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5) ))) {
				botones[indice_actual].seleccionado = false; // Deselecciona el actual
		        indice_actual = (indice_actual + 2) mod array_length(botones); // Mover al anterior
		        botones[indice_actual].seleccionado = true; // Selecciona el nuevo
			} else if ((indice_actual == 6 || indice_actual == 7) && (keyboard_check_pressed(vk_right) || (
				gamepad_button_check_pressed(global.current_gamepad, gp_padr) || (!stick_moved && gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5) ))) {
				botones[indice_actual].seleccionado = false; // Deselecciona el actual
		        indice_actual = (indice_actual + 3) mod array_length(botones); // Mover al anterior
		        botones[indice_actual].seleccionado = true; // Selecciona el nuevo
			} else {
				botones[indice_actual].seleccionado = false; // Deselecciona el actual
		        indice_actual = (indice_actual + 1) mod array_length(botones); // Mover al siguiente
		        botones[indice_actual].seleccionado = true; // Selecciona el nuevo
			}
			
			if (global.is_gamepad) stick_moved = 1;
	    }
	}

	if (global.is_gamepad && abs(gamepad_axis_value(global.current_gamepad, gp_axislh)) < 0.5 && abs(gamepad_axis_value(global.current_gamepad, gp_axislv)) < 0.5) stick_moved = false;
}

if (mouse_check_button_pressed(mb_left) && !global.is_gamepad) {
    var mx = mouse_x, my = mouse_y;
       
	if (message_shown == 1 && point_in_rectangle(mx, my, dialog_x + 50, dialog_y + dialog_height - 50, dialog_x + dialog_width - 40, dialog_y + dialog_height + 10)) {
        message_shown = 0;
		blocked = 0;
		with(obj_editor_button) {
			blocked = 0;
		}
		selected_item = 0;
		editing = 0;
		editing_manual = 0;
		global.hue_shift = hue_shift;
	    global.interface_color = make_color_rgb(red, green, blue); // Guardar el color principal
		global.interface_color_secondary = make_color_rgb(red_secondary, green_secondary, blue_secondary); // Guardar el color secundario
		
		var adjusted_hue_yellow;
		if (hue_shift < 30) {
		    // Hue shift aplica para tonos amarillos.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift) mod 300;
		} else if (hue_shift < 90) {
		    // Hue shift aplica para tonos verdes.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 20) mod 300;
		} else if (hue_shift < 120) {
		    // Hue shift aplica para tonos verdes.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 30) mod 300;
		} else if (hue_shift < 160) {
		    // Hue shift aplica para tonos azules/morados.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 40) mod 300;
		} else if (hue_shift < 200) {
		    // Hue shift aplica para tonos azules/morados.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 50) mod 300;
		} else if (hue_shift < 242) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 60) mod 300;
		} else {
		    // Hue shift aplica para tonos rojos.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift) mod 300;
		}
	
		var adjusted_hue_purple;
		if (hue_shift < 75) {
		    // Hue shift aplica para tonos amarillos.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift) mod 300;
		} else if (hue_shift < 120) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 10) mod 300;
		} else if (hue_shift < 160) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 25) mod 300;
		}  else if (hue_shift < 220) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 40) mod 300;
		} else if (hue_shift < 258) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 60) mod 300;
		} else {
		    // Hue shift aplica para tonos rojos.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 300) mod 300;
		}
	
		global.primary_color_yellow = make_color_hsv(adjusted_hue_yellow, color_get_saturation(c_yellow),color_get_value(c_yellow));
		global.secondary_color_purple = make_color_hsv(adjusted_hue_purple, color_get_saturation(make_color_rgb(125, 10, 255)),color_get_value(make_color_rgb(125, 10, 255)));
    }
	
    // Sliders para el primer color
    if (point_in_rectangle(mx, my, slider_start_x, slider_start_y + 10, slider_start_x + slider_width + 20, slider_start_y + slider_height + 20)) {
        dragging = 0; // Slider rojo del primer grupo
		selected_item = 0;
		editing_manual = 1;
    } else if (point_in_rectangle(mx, my, slider_start_x, slider_start_y + slider_spacing + 10, slider_start_x + slider_width + 20, slider_start_y + slider_spacing + slider_height + 20)) {
        dragging = 1; // Slider verde del primer grupo
		selected_item = 1;
		editing_manual = 1;
    } else if (point_in_rectangle(mx, my, slider_start_x, slider_start_y + 2 * slider_spacing + 10, slider_start_x + slider_width + 20, slider_start_y + 2 * slider_spacing + slider_height + 20)) {
        dragging = 2; // Slider azul del primer grupo
		selected_item = 2;
		editing_manual = 1;
    }
    
    // Sliders para el segundo color
    else if (point_in_rectangle(mx, my, slider_start_x + slider_width + 50, slider_start_y + 10, slider_start_x + slider_width + 50 + slider_width, slider_start_y + slider_height + 20)) {
        dragging = 3; // Slider rojo del segundo grupo
		selected_item = 3;
		editing_manual = 1;
    } else if (point_in_rectangle(mx, my, slider_start_x + slider_width + 50, slider_start_y + slider_spacing + 10, slider_start_x + slider_width + 50 + slider_width, slider_start_y + slider_spacing + slider_height + 20)) {
        dragging = 4; // Slider verde del segundo grupo
		selected_item = 4;
		editing_manual = 1;
    } else if (point_in_rectangle(mx, my, slider_start_x + slider_width + 50, slider_start_y + 2 * slider_spacing + 10, slider_start_x + slider_width + 50 + slider_width, slider_start_y + 2 * slider_spacing + slider_height + 20)) {
        dragging = 5; // Slider azul del segundo grupo
		selected_item = 5;
		editing_manual = 1;
    }
	
	
	else if (point_in_rectangle(mx, my, dialog_x + 50, slider_start_y + 3 * slider_spacing + slider_height + 140, dialog_x + dialog_width - 50, slider_start_y + 3 * slider_spacing + slider_height + 180)) {
		dragging = 6;
		selected_item = 6; // hue shift
		editing_manual = 1;
	}
}

if ((!editing_manual || !editing) && !global.is_gamepad) {
	// Sliders para el primer color
	if (point_in_rectangle(mouse_x, mouse_y, slider_start_x, slider_start_y + 10, slider_start_x + slider_width + 20, slider_start_y + slider_height + 20)) {
		selected_item = 0;
	} else if (point_in_rectangle(mouse_x, mouse_y, slider_start_x, slider_start_y + slider_spacing + 10, slider_start_x + slider_width + 20, slider_start_y + slider_spacing + slider_height + 20)) {
		selected_item = 1;
	} else if (point_in_rectangle(mouse_x, mouse_y, slider_start_x, slider_start_y + 2 * slider_spacing + 10, slider_start_x + slider_width + 20, slider_start_y + 2 * slider_spacing + slider_height + 20)) {
		selected_item = 2;
	}
    
	// Sliders para el segundo color
	else if (point_in_rectangle(mouse_x, mouse_y, slider_start_x + slider_width + 50, slider_start_y + 10, slider_start_x + slider_width + 50 + slider_width, slider_start_y + slider_height + 20)) {
		selected_item = 3;
	} else if (point_in_rectangle(mouse_x, mouse_y, slider_start_x + slider_width + 50, slider_start_y + slider_spacing + 10, slider_start_x + slider_width + 50 + slider_width, slider_start_y + slider_spacing + slider_height + 20)) {
		selected_item = 4;
	} else if (point_in_rectangle(mouse_x, mouse_y, slider_start_x + slider_width + 50, slider_start_y + 2 * slider_spacing + 10, slider_start_x + slider_width + 50 + slider_width, slider_start_y + 2 * slider_spacing + slider_height + 20)) {
		selected_item = 5;
	}
	
	// hue shift
	else if (point_in_rectangle(mouse_x, mouse_y, dialog_x + 50, slider_start_y + 3 * slider_spacing + slider_height + 140, dialog_x + dialog_width - 50, slider_start_y + 3 * slider_spacing + slider_height + 180)) {
		selected_item = 6;
	}
}

// Actualizar la posición del slider arrastrado
if (mouse_check_button(mb_left) && !global.is_gamepad && dragging != -1) {
    var mx = clamp(mouse_x, slider_start_x + (dragging < 3 ? 0 : slider_width + 20), slider_start_x + (dragging < 3 ? slider_width : slider_width + 20 + slider_width));
    var mx2 = clamp(mouse_x, (dialog_x + 100), (dialog_x + dialog_width - 100));
	
	var normalized_value = (mx - (dragging < 3 ? slider_start_x : slider_start_x + slider_width + 20)) / slider_width * 255;
	var normalized_value2 = (mx2 - (dialog_x + 100)) / 300 * 300;
	
    switch (dragging) {
        case 0:
            red = round(normalized_value); 
            handle_red_x = mx;
            break;
        case 1:
            green = round(normalized_value); 
            handle_green_x = mx;
            break;
        case 2:
            blue = round(normalized_value); 
            handle_blue_x = mx;
            break;
        case 3:
            red_secondary = round(normalized_value); 
            handle_red_x_secondary = mx;
            break;
        case 4:
            green_secondary = round(normalized_value); 
            handle_green_x_secondary = mx;
            break;
        case 5:
            blue_secondary = round(normalized_value); 
            handle_blue_x_secondary = mx;
            break;
		case 6:
			handle_hue_shift = mx2;
			hue_shift = round(normalized_value2)
    }
}

// Soltar el slider
if (mouse_check_button_released(mb_left) && !global.is_gamepad) {
    dragging = -1;
	editing_manual = 0;
	editing = 0;
}

color_actual = make_color_rgb(red, green, blue);
color_actual_secondary = make_color_rgb(red_secondary, green_secondary, blue_secondary);
slider_color[0] = red;slider_color[1] = green;slider_color[2] = blue;
slider_color[3] = red_secondary;slider_color[4] = green_secondary;slider_color[5] = blue_secondary;
slider_color[6] = hue_shift;

// Color principal
if (((keyboard_check_pressed(vk_escape) && !global.is_gamepad) || (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face1))) && message_shown == 1 && (!editing && !editing_manual)) {
    selected_item = 7;
	exit_delay = current_time;
}

var sliders = [
    {x1: slider_start_x, y1: slider_start_y + 10, width: slider_width, height: slider_height}, // Slider rojo (grupo 1)
    {x1: slider_start_x, y1: slider_start_y + slider_spacing + 10, width: slider_width, height: slider_height}, // Slider verde (grupo 1)
    {x1: slider_start_x, y1: slider_start_y + 2 * slider_spacing + 10, width: slider_width, height: slider_height}, // Slider azul (grupo 1)
    {x1: slider_start_x + slider_width + 30, y1: slider_start_y + 10, width: slider_width, height: slider_height}, // Slider rojo (grupo 2)
    {x1: slider_start_x + slider_width + 30, y1: slider_start_y + slider_spacing + 10, width: slider_width, height: slider_height}, // Slider verde (grupo 2)
    {x1: slider_start_x + slider_width + 30, y1: slider_start_y + 2 * slider_spacing + 10, width: slider_width, height: slider_height}, // Slider azul (grupo 2)
	{x1: dialog_x + (dialog_width / 2) - 150, y1: slider_start_y + 3 * slider_spacing + slider_height + 140, width: 300, height: slider_height} // Slider hue shift
];

var close_button = {x1: dialog_x + 50, y1: dialog_y + dialog_height - 50, width: dialog_width - 90, height: 60}; // Botón de cerrar


// Interacción con Enter
if ((keyboard_check_pressed(vk_enter) && !global.is_gamepad) || (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face2)) && message_shown && (current_time - start_delay) > 50) {
    if (editing) {
        editing = false; // Salir del modo edición
		editing_manual = 0;
    } else if (selected_item < array_length(sliders)) {
        editing = true; // Entrar en modo edición para el slider seleccionado
    } else {
        // Botón de cerrar
        message_shown = 0;
        blocked = 0;
        with (obj_editor_button) {
            blocked = 0;
        }
		selected_item = 0;
		editing = 0;
		editing_manual = 0;
		global.hue_shift = hue_shift;
        global.interface_color = make_color_rgb(red, green, blue);
        global.interface_color_secondary = make_color_rgb(red_secondary, green_secondary, blue_secondary);
    
		var adjusted_hue_yellow;
		if (hue_shift < 30) {
		    // Hue shift aplica para tonos amarillos.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift) mod 300;
		} else if (hue_shift < 90) {
		    // Hue shift aplica para tonos verdes.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 20) mod 300;
		} else if (hue_shift < 120) {
		    // Hue shift aplica para tonos verdes.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 30) mod 300;
		} else if (hue_shift < 160) {
		    // Hue shift aplica para tonos azules/morados.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 40) mod 300;
		} else if (hue_shift < 200) {
		    // Hue shift aplica para tonos azules/morados.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 50) mod 300;
		} else if (hue_shift < 242) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift - 60) mod 300;
		} else {
		    // Hue shift aplica para tonos rojos.
		    adjusted_hue_yellow = (color_get_hue(c_yellow) + hue_shift) mod 300;
		}
	
		var adjusted_hue_purple;
		if (hue_shift < 75) {
		    // Hue shift aplica para tonos amarillos.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift) mod 300;
		} else if (hue_shift < 120) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 10) mod 300;
		} else if (hue_shift < 160) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 25) mod 300;
		}  else if (hue_shift < 220) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 40) mod 300;
		} else if (hue_shift < 258) {
		    // Hue shift aplica para tonos morados.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 60) mod 300;
		} else {
		    // Hue shift aplica para tonos rojos.
		    adjusted_hue_purple = (color_get_hue(make_color_rgb(125, 10, 255)) - hue_shift + 300) mod 300;
		}
	
		global.primary_color_yellow = make_color_hsv(adjusted_hue_yellow, color_get_saturation(c_yellow),color_get_value(c_yellow));
		global.secondary_color_purple = make_color_hsv(adjusted_hue_purple, color_get_saturation(make_color_rgb(125, 10, 255)),color_get_value(make_color_rgb(125, 10, 255)));
	}
}

if (selected_item != 7 && (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_face1) || (keyboard_check_pressed(vk_escape)) && !global.is_gamepad) && message_shown && (current_time - start_delay) > 50) {
	if (editing) {
        editing = false; // Salir del modo edición
		editing_manual = 0;
	}
}

// Navegación con las teclas de flecha
if (!editing) {
    if (((keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_left)) && !global.is_gamepad) || (global.is_gamepad &&
		(gamepad_button_check_pressed(global.current_gamepad, gp_padu) || gamepad_button_check_pressed(global.current_gamepad, gp_padl)) ||
		(!stick_moved && (gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5 || gamepad_axis_value(global.current_gamepad, gp_axislv) < -0.5)))) {
		if ((selected_item >= 3 && selected_item < 6) && (keyboard_check_pressed(vk_left) ||
			gamepad_button_check_pressed(global.current_gamepad, gp_padl)) || (!stick_moved && (gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5))) selected_item = (selected_item - 3); 
        else selected_item = (selected_item - 1 + array_length(sliders) + 1) % (array_length(sliders) + 1);
		stick_moved = 1;
    }
    if (((keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_right)) && !global.is_gamepad) || (global.is_gamepad &&
		(gamepad_button_check_pressed(global.current_gamepad, gp_padd) || gamepad_button_check_pressed(global.current_gamepad, gp_padr)) ||
		(!stick_moved && (gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5 || gamepad_axis_value(global.current_gamepad, gp_axislv) > 0.5)))) {
        if ((selected_item < 3) && (keyboard_check_pressed(vk_right) ||
			gamepad_button_check_pressed(global.current_gamepad, gp_padr)) || (!stick_moved && (gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5))) selected_item = (selected_item + 3); 
		else selected_item = (selected_item + 1) % (array_length(sliders) + 1);
		stick_moved = 1;
    }
	
	if (global.is_gamepad && abs(gamepad_axis_value(global.current_gamepad, gp_axislh)) < 0.2 && abs(gamepad_axis_value(global.current_gamepad, gp_axislv)) < 0.2) {
        stick_moved = false;
    }
}

// Ajuste del slider en modo edición
if (editing && selected_item < array_length(sliders)) {
    var current_slider = sliders[selected_item];
	
    if ((keyboard_check(vk_left) && !global.is_gamepad) || (global.is_gamepad && (gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5 || gamepad_button_check(global.current_gamepad, gp_padl)))) {
        slider_color[selected_item] -= 1;
    }
    if ((keyboard_check(vk_right) && !global.is_gamepad) || (global.is_gamepad && (gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5 || gamepad_button_check(global.current_gamepad, gp_padr)))) {
        slider_color[selected_item] += 1;
    }

    // Limitar el valor entre 0 y 255
    var normalized_value_selected = clamp(slider_color[selected_item], 0, 255);
	var normalized_value_selected2 = clamp(slider_color[selected_item], 0, 300);

    switch (selected_item) {
        case 0: red = normalized_value_selected; handle_red_x = current_slider.x1 + (normalized_value_selected / 255) * current_slider.width; break;
        case 1: green = normalized_value_selected; handle_green_x = current_slider.x1 + (normalized_value_selected / 255) * current_slider.width; break;
        case 2: blue = normalized_value_selected; handle_blue_x = current_slider.x1 + (normalized_value_selected / 255) * current_slider.width; break;
        case 3: red_secondary = normalized_value_selected; handle_red_x_secondary = current_slider.x1 + (normalized_value_selected / 255) * current_slider.width; break;
        case 4: green_secondary = normalized_value_selected; handle_green_x_secondary = current_slider.x1 + (normalized_value_selected / 255) * current_slider.width; break;
        case 5: blue_secondary = normalized_value_selected; handle_blue_x_secondary = current_slider.x1 + (normalized_value_selected / 255) * current_slider.width; break;
		case 6: hue_shift = normalized_value_selected2; handle_hue_shift = current_slider.x1 + (normalized_value_selected2 / 300) * current_slider.width; break;
    }
}