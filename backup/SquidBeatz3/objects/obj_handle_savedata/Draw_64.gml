/// @description Insert description here
// You can write your code in this editor

if (message_shown) {
    // Fondo del mensaje
	draw_set_valign(fa_top);
    draw_set_color(c_dkgrey);
    draw_rectangle(msg_x, msg_y, msg_x + msg_width, msg_y + msg_height, false);

    // Texto del mensaje
    draw_set_font(splat_font_title);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
	
	if (global.current_language == "ENGLISH") draw_text(msg_x + msg_width / 2, msg_y + 5, "What type of data do you want to load?");
    else draw_text(msg_x + msg_width / 2, msg_y + 5, "Que tipo de datos quieres cargar?");
    
    // Obtener posición del mouse
    var mx = mouse_x;
    var my = mouse_y;
	var padding = 20;
	var text_y = msg_y + 80;

   // Botón "[CHARTS]"
	draw_set_color(c_ltgray);
	draw_rectangle(msg_x + msg_width / 2 - string_width("[CHARTS]"), text_y + 15 - padding, msg_x + msg_width / 2 + string_width("[CHARTS]"), text_y + 20 + padding, false);

	if ((mx > msg_x + msg_width / 2 - string_width("[CHARTS]") && mx < msg_x + msg_width / 2 + string_width("[CHARTS]") && my > msg_y + 90 - padding && my < msg_y + 90 + padding) || selected_row == 0) {
	    draw_set_color(global.primary_color_yellow);
	    selected_row = 0;
	} else {
	    draw_set_color(c_dkgrey);
	}
	draw_text(msg_x + msg_width / 2, text_y - 5, "[CHARTS]");

	// Botón "[PROGRESS]"
	draw_set_color(c_ltgray);
	draw_rectangle(msg_x + msg_width / 2 - string_width("[PROGRESS]"), text_y + 60 + 15 - padding, msg_x + msg_width / 2 + string_width("[PROGRESS]"), text_y + 60 + 20 + padding, false);

	if ((mx > msg_x + msg_width / 2 - string_width("[PROGRESS]") && mx < msg_x + msg_width / 2 + string_width("[PROGRESS]") && my > msg_y + 120 - padding +20 && my < msg_y + 120 + padding +20) || selected_row == 1) {
	    draw_set_color(global.primary_color_yellow);
	    selected_row = 1;
	} else {
	    draw_set_color(c_dkgrey);
	}
	if (global.current_language == "ENGLISH") draw_text(msg_x + msg_width / 2, text_y + 60- 5, "[PROGRESS]");
	else draw_text(msg_x + msg_width / 2, text_y + 60- 5, "[PROGRESO]");

	// Botón "[SETTINGS]"
	draw_set_color(c_ltgray);
	draw_rectangle(msg_x + msg_width / 2 - string_width("[SETTINGS]"), text_y + 120 + 15 - padding, msg_x + msg_width / 2 + string_width("[SETTINGS]"), text_y + 120 + 20 + padding, false);

	if ((mx > msg_x + msg_width / 2 - string_width("[SETTINGS]") && mx < msg_x + msg_width / 2 + string_width("[SETTINGS]") && my > text_y + 120 + 15 - padding +20 && my < text_y + 120 + 20 + padding) || selected_row == 2) {
	    draw_set_color(global.primary_color_yellow);
	    selected_row = 2;
	} else {
	    draw_set_color(c_dkgrey);
	}
	if (global.current_language == "ENGLISH") draw_text(msg_x + msg_width / 2, text_y + 120- 5, "[SETTINGS]");
	else draw_text(msg_x + msg_width / 2, text_y + 120- 5, "[AJUSTES]");

	// Botón "[ALL]"
	draw_set_color(c_ltgray);
	draw_rectangle(msg_x + msg_width / 2 - string_width("[ALL]"), text_y + 180 + 15 - padding, msg_x + msg_width / 2 + string_width("[ALL]"), text_y + 180 + 20 + padding, false);

	if ((mx > msg_x + msg_width / 2 - string_width("[ALL]") && mx < msg_x + msg_width / 2 + string_width("[ALL]") && my > text_y + 180 + 15 - padding+20 && my < text_y + 180 + 20 + padding) || selected_row == 3) {
	    draw_set_color(global.primary_color_yellow);
	    selected_row = 3;
	} else {
	    draw_set_color(c_dkgrey);
	}
	if (global.current_language == "ENGLISH") draw_text(msg_x + msg_width / 2, text_y + 180- 5, "[ALL]");
	else draw_text(msg_x + msg_width / 2, text_y + 180- 5, "[TODO]");
}


if (message_shown2) {
    // Fondo del mensaje
	draw_set_valign(fa_top);
    draw_set_color(c_dkgrey);
    draw_rectangle(msg_x2, msg_y2, msg_x2 + msg_width2, msg_y2 + msg_height2, false);

    // Texto del mensaje
    draw_set_font(splat_font_title);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
	
	if (global.current_language == "ENGLISH") draw_text(msg_x2 + msg_width2 / 2, msg_y2, "Are you sure?");
    else draw_text(msg_x2 + msg_width2 / 2, msg_y2, "Seguro que deseas continuar?");
    if (global.current_language == "ENGLISH") draw_text(msg_x2 + msg_width2 / 2, msg_y2 + 35, "Erase data will delete all your progress.");
    else draw_text(msg_x2 + msg_width2 / 2, msg_y2 + 35, "Borrar datos eliminara todo tu progreso.");
    // Obtener posición del mouse
    var mx = mouse_x;
    var my = mouse_y;
	var padding = 20;
	var text_y = msg_y2 + 80;

   // Botón "[CANCELAR]"
	draw_set_color(c_ltgray);
	if (global.current_language == "ENGLISH") {
		draw_rectangle(msg_x2 + msg_width2 / 2 - string_width("[CANCEL]"), text_y + 15 + 20 - padding, msg_x2 + msg_width2 / 2 + string_width("[CANCEL]"), text_y + 20+ 20  + padding, false);
		if ((mx > msg_x2 + msg_width2 / 2 - string_width("[CANCEL]") && mx < msg_x2 + msg_width2 / 2 + string_width("[CANCEL]") && my > msg_y2 + 20 + 90 - padding && my < msg_y2 + 90+ 20  + padding) || selected_row == 0) {
		    draw_set_color(global.primary_color_yellow);
		    selected_row = 0;
		} else {
		    draw_set_color(c_dkgrey);
		}
		draw_text(msg_x2 + msg_width2 / 2, text_y - 5 +20, "[CANCEL]");
	} else { 
		draw_rectangle(msg_x2 + msg_width2 / 2 - string_width("[CANCELAR]"), text_y + 15 + 20 - padding, msg_x2 + msg_width2 / 2 + string_width("[CANCELAR]"), text_y + 20 + 20 + padding, false);
		if ((mx > msg_x2 + msg_width2 / 2 - string_width("[CANCELAR]") && mx < msg_x2 + msg_width2 / 2 + string_width("[CANCELAR]") && my > msg_y2 + 90+ 20  - padding && my < msg_y2 + 90+ 20  + padding) || selected_row == 0) {
		    draw_set_color(global.primary_color_yellow);
		    selected_row = 0;
		} else {
		    draw_set_color(c_dkgrey);
		}
		draw_text(msg_x2 + msg_width2 / 2, text_y - 5  + 20 , "[CANCELAR]");
	}

	// Botón "[BORRAR DATOS]"
	draw_set_color(c_ltgray);
	if (global.current_language == "ENGLISH") {
		draw_rectangle(msg_x2 + msg_width2 / 2 - string_width("[ERASE DATA]"), text_y + 60 + 40 + 15 - padding, msg_x2 + msg_width2 / 2 + string_width("[ERASE DATA]"), text_y + 60 + 20 + 40 + padding, false);

		if ((mx > msg_x2 + msg_width2 / 2 - string_width("[ERASE DATA]") && mx < msg_x2 + msg_width2 / 2 + string_width("[ERASE DATA]") && my > msg_y2 + 120 + 60 - padding && my < msg_y2 + 120 + 60 + padding) || selected_row == 1) {
		    draw_set_color(global.primary_color_yellow);
		    selected_row = 1;
		} else {
		    draw_set_color(c_dkgrey);
		} 
		draw_text(msg_x2 + msg_width2 / 2, text_y + 60 - 5 + 40, "[ERASE DATA]");
	} else {
		draw_rectangle(msg_x2 + msg_width2 / 2 - string_width("[BORRAR DATOS]"), text_y + 60 + 15 + 40 - padding, msg_x2 + msg_width2 / 2 + string_width("[BORRAR DATOS]"), text_y + 60 + 20 + 40 + padding, false);
		if ((mx > msg_x2 + msg_width2 / 2 - string_width("[BORRAR DATOS]") && mx < msg_x2 + msg_width2 / 2 + string_width("[BORRAR DATOS]") && my > msg_y2 + 60 + 120 - padding && my < 60 + msg_y2 + 120 + padding) || selected_row == 1) {
		    draw_set_color(global.primary_color_yellow);
		    selected_row = 1;
		} else {
		    draw_set_color(c_dkgrey);
		} 
		draw_text(msg_x2 + msg_width2 / 2, text_y + 60- 5 + 40, "[BORRAR DATOS]");
	}
}


if (message_shown3) {
	draw_set_color(c_dkgrey);
	draw_rectangle(room_width / 2 - 230,room_height / 2 - 100, room_width / 2 + 230, room_height / 2 + 100, 0);
	draw_set_color(c_white);
	draw_rectangle(room_width / 2 - 230,room_height / 2 - 100, room_width / 2 + 230, room_height / 2 + 100, 1);
	draw_set_halign(fa_center);
	
	draw_set_font(splat_font_title);
	if (global.current_language == "ENGLISH") {
		draw_text(room_width / 2, room_height / 2-15, "Game data erased successfully.")
	} else {
		draw_text(room_width / 2, room_height / 2-15, "Datos de progreso borrados con exito.")
	}
	
	// Botón de "SALIR"
    draw_set_color(global.secondary_color_purple);
    if (global.current_language == "ENGLISH") draw_text(room_width / 2, room_height / 2 + 70 - 25, "EXIT");
	else draw_text(room_width / 2, room_height / 2 + 70 - 25, "SALIR");
	draw_set_color(c_white);
}