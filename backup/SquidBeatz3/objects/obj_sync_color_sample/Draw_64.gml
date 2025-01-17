/// @description Insert description here
// You can write your code in this editor

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(splat_font_title);
if (message_shown) {
	// Dibujar fondo del diálogo
    draw_set_color(c_dkgray);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, false);

    // Dibujar borde del diálogo
    draw_set_color(c_white);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, true);
	if (global.current_language == "ENGLISH") draw_text(slider_start_x + 110, dialog_y + 30, "SYNC: "); 
	else draw_text(slider_start_x + 110, dialog_y + 30, "SINC: "); 
    // Dibujar los sliders para el primer color
    // Rojo
    draw_set_color(c_red); 
    draw_rectangle(slider_start_x, slider_start_y, slider_start_x + slider_width, slider_start_y + slider_height, false);
    draw_set_color(c_white); 
	if (selected_item == 0) {
		if (editing || editing_manual) draw_set_color(global.primary_color_yellow); 
		else draw_set_color(global.secondary_color_purple); 
	}
	
    draw_circle(handle_red_x, slider_start_y + slider_height / 2, 5, false); 
	draw_set_color(c_black); 
    draw_circle(handle_red_x, slider_start_y + slider_height / 2, 5, true); 

    // Verde
    draw_set_color(c_green); 
    draw_rectangle(slider_start_x, slider_start_y + slider_spacing, slider_start_x + slider_width, slider_start_y + slider_spacing + slider_height, false);
    draw_set_color(c_white); 
	if (selected_item == 1) {
		if (editing || editing_manual) draw_set_color(global.primary_color_yellow); 
		else draw_set_color(global.secondary_color_purple); 
	}
    draw_circle(handle_green_x, slider_start_y + slider_spacing + slider_height / 2, 5, false); 
	draw_set_color(c_black);
    draw_circle(handle_green_x, slider_start_y + slider_spacing + slider_height / 2, 5, true); 

    // Azul
    draw_set_color(c_blue); 
    draw_rectangle(slider_start_x, slider_start_y + 2 * slider_spacing, slider_start_x + slider_width, slider_start_y + 2 * slider_spacing + slider_height, false);
    draw_set_color(c_white);
	if (selected_item == 2) {
		if (editing || editing_manual) draw_set_color(global.primary_color_yellow);  
		else draw_set_color(global.secondary_color_purple); 
	}
    draw_circle(handle_blue_x, slider_start_y + 2 * slider_spacing + slider_height / 2, 5, false); 
	draw_set_color(c_black);
    draw_circle(handle_blue_x, slider_start_y + 2 * slider_spacing + slider_height / 2, 5, true); 

    // Dibujar cuadro de color principal
    draw_set_color(color_actual);
    draw_rectangle(dialog_x + 120, dialog_y + 150, dialog_x + 170, dialog_y + 200, false);

    // Mostrar valores RGB del primer grupo
    draw_set_color(c_white);
	draw_set_font(splat_font_small);
    draw_text(slider_start_x + 100, slider_start_y + 2 * slider_spacing + slider_height + 20, "COLOR: " + string(red) + ", " + string(green) + ", " + string(blue)); 

	draw_set_font(splat_font_title);
	if (global.current_language == "ENGLISH") draw_text(slider_start_x + slider_width + 2 + 130, dialog_y + 30, "BAR: "); 
	else draw_text(slider_start_x + slider_width + 2 + 130, dialog_y + 30, "BARRA: "); 
    // Dibujar los sliders para el segundo color
    // Rojo
    draw_set_color(c_red); 
	draw_rectangle(slider_start_x + slider_width + 30, slider_start_y, slider_start_x + slider_width * 2 + 20, slider_start_y + slider_height, false);
	draw_set_color(c_white); 
	if (selected_item == 3) {
		if (editing || editing_manual) draw_set_color(global.primary_color_yellow); 
		else draw_set_color(global.secondary_color_purple); 
	}
	draw_circle(handle_red_x_secondary, slider_start_y + slider_height / 2, 5, false); 
	draw_set_color(c_black);
	draw_circle(handle_red_x_secondary, slider_start_y + slider_height / 2, 5, true); 

	draw_set_color(c_green); 
	draw_rectangle(slider_start_x + slider_width + 30, slider_start_y + slider_spacing, slider_start_x + slider_width * 2 + 20, slider_start_y + slider_spacing + slider_height, false);
	draw_set_color(c_white); 
	if (selected_item == 4) {
		if (editing || editing_manual) draw_set_color(global.primary_color_yellow); 
		else draw_set_color(global.secondary_color_purple);
	}
	draw_circle(handle_green_x_secondary, slider_start_y + slider_spacing + slider_height / 2, 5, false);
	draw_set_color(c_black);
	draw_circle(handle_green_x_secondary, slider_start_y + slider_spacing + slider_height / 2, 5, true); 

	draw_set_color(c_blue); 
	draw_rectangle(slider_start_x + slider_width + 30, slider_start_y + 2 * slider_spacing, slider_start_x + slider_width * 2 + 20, slider_start_y + 2 * slider_spacing + slider_height, false);
	draw_set_color(c_white); 
	if (selected_item == 5) {
		if (editing || editing_manual) draw_set_color(global.primary_color_yellow); 
		else draw_set_color(global.secondary_color_purple);
	}
	draw_circle(handle_blue_x_secondary, slider_start_y + 2 * slider_spacing + slider_height / 2, 5, false); 
	draw_set_color(c_black);
	draw_circle(handle_blue_x_secondary, slider_start_y + 2 * slider_spacing + slider_height / 2, 5, true); 

    // Dibujar cuadro de color secundario
    draw_set_color(color_actual_secondary);
	draw_rectangle(slider_start_x + slider_width + 30 + 80, dialog_y + 150, slider_start_x + slider_width + 30 + 130, dialog_y + 200, false);
    // Mostrar valores RGB del segundo grupo
    draw_set_color(c_white);
	draw_set_font(splat_font_small);
    draw_text(slider_start_x + slider_width + 30 + 100, slider_start_y + 2 * slider_spacing + slider_height + 20, "COLOR: " + string(red_secondary) + ", " + string(green_secondary) + ", " + string(blue_secondary)); 
	draw_set_font(splat_font_title);
	
	draw_set_color(c_white);
	draw_set_font(splat_font_title);
	draw_set_halign(fa_center);
	if (global.current_language == "ENGLISH") draw_text(dialog_x + (dialog_width / 2), slider_start_y + 3 * slider_spacing + slider_height + 100, "SHIFT MAIN TONE: "); 
	else draw_text(dialog_x + (dialog_width / 2), slider_start_y + 3 * slider_spacing + slider_height + 100, "CAMBIAR TONO PRINCIPAL: "); 

	if (selected_item == 6) {
		if (editing || editing_manual) draw_set_color(global.primary_color_yellow); 
		else draw_set_color(global.secondary_color_purple);
	}
	draw_sprite_ext(spr_hue_bar, 0, dialog_x + (dialog_width / 2) - 150, slider_start_y + 3 * slider_spacing + slider_height + 140, 0.83, 1, 0, c_white, 1);
	draw_circle(handle_hue_shift, slider_start_y + 3 * slider_spacing + slider_height + 145, 6, false); 
	draw_set_color(c_black);
	draw_circle(handle_hue_shift,slider_start_y + 3 * slider_spacing + slider_height + 145, 6, true); 
	
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
	
	var shifted_color_primary = make_color_hsv(adjusted_hue_yellow, color_get_saturation(c_yellow),color_get_value(c_yellow));
	var shifted_color_secondary = make_color_hsv(adjusted_hue_purple, color_get_saturation(make_color_rgb(125, 10, 255)),color_get_value(make_color_rgb(125, 10, 255)));
	
	draw_set_color(shifted_color_primary);
	draw_rectangle(dialog_x + (dialog_width / 2) - 50, slider_start_y + 3 * slider_spacing + slider_height + 170, dialog_x + (dialog_width / 2) - 10, slider_start_y + 3 * slider_spacing + slider_height + 210, false);
	draw_set_color(shifted_color_secondary);
	draw_rectangle(dialog_x + (dialog_width / 2) + 10, slider_start_y + 3 * slider_spacing + slider_height + 170, dialog_x + (dialog_width / 2) + 50, slider_start_y + 3 * slider_spacing + slider_height + 210, false);

	draw_set_color(c_white);
	draw_set_font(splat_font_small);
    if(global.current_language == "ENGLISH") draw_text(dialog_x + (dialog_width / 2), slider_start_y + 3 * slider_spacing + slider_height + 230, "VALUE: " + string(hue_shift)); 
	else draw_text(dialog_x + (dialog_width / 2), slider_start_y + 3 * slider_spacing + slider_height + 230, "VALOR: " + string(hue_shift)); 
	
	draw_set_font(splat_font_title)
	if (message_shown == 1) {
	    var mx = mouse_x, my = mouse_y;
	    if (selected_item == 7 || (point_in_rectangle(mx, my, dialog_x + 50, dialog_y + dialog_height - 50, dialog_x + dialog_width - 40, dialog_y + dialog_height + 10) && !global.is_gamepad)) {
	        salir_text_color = global.secondary_color_purple;
			selected_item = 7
	    } else {
	        salir_text_color = c_white; // Revertir el color si el mouse no está sobre el botón
	    }
	}
	draw_set_color(salir_text_color);
	if (global.current_language == "ENGLISH") draw_text(dialog_x + dialog_width / 2, dialog_y + dialog_height - 25, "EXIT");
	else draw_text(dialog_x + dialog_width / 2, dialog_y + dialog_height - 25, "SALIR");
}