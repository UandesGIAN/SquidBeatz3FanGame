/// @description Draw message with hover effect
if (message_shown) {
    // Fondo del mensaje
	draw_set_valign(fa_top);
    draw_set_color(c_dkgray);
    draw_rectangle(msg_x - 250, msg_y - 100, msg_x + 250, msg_y + 250, false);

    // Texto del mensaje
    draw_set_font(splat_font_title);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
	if (global.current_language == "ENGLISH") draw_text(msg_x, msg_y - 60, "Sure to quit?");
    else draw_text(msg_x, msg_y - 60, "Seguro que quieres salir?");
    
    // Obtener posición del mouse
    var mx = mouse_x;
    var my = mouse_y;

    // Botón "CANCELAR"
    draw_set_color(make_color_rgb(25, 25, 25));
    draw_rectangle(msg_x - btn_width + 50, btn_cancel_y + 25, msg_x + btn_width - 50, btn_cancel_y + 75, false);

    if ((mx > msg_x - btn_width - 20 && mx < msg_x + btn_width + 20 && my > btn_cancel_y + 20 && my < btn_cancel_y + 80) || selected_row = 0) {
        draw_set_color(global.primary_color_yellow);
		selected_row = 0;
    } else {
        draw_set_color(c_white);
    }
    if (global.current_language == "ENGLISH") draw_text(msg_x, btn_cancel_y + btn_height / 2, "[CANCEL]");
	else draw_text(msg_x, btn_cancel_y + btn_height / 2, "[CANCELAR]");

    // Botón "SALIR SIN GUARDAR"
    draw_set_color(make_color_rgb(25, 25, 25));
	if (global.current_language == "ENGLISH")  draw_rectangle(msg_x - btn_width + 10, btn_no_save_y + 25, msg_x + btn_width - 10, btn_no_save_y + 75, false);
    else draw_rectangle(msg_x - btn_width + 20, btn_no_save_y + 25, msg_x + btn_width - 20, btn_no_save_y + 75, false);
   

    if ((mx > msg_x - btn_width - 20 && mx < msg_x + btn_width + 20 && my > btn_no_save_y + 30 && my < btn_no_save_y + 80) || selected_row = 1) {
        draw_set_color(global.primary_color_yellow);
		selected_row = 1;
    } else {
        draw_set_color(c_white); 
    }
	if (global.current_language == "ENGLISH") draw_text(msg_x, btn_no_save_y + btn_height / 2, "[EXIT WITHOUT SAVING]");
    else draw_text(msg_x, btn_no_save_y + btn_height / 2, "[SALIR SIN GUARDAR]");

    // Botón "SALIR Y GUARDAR"
    draw_set_color(make_color_rgb(25, 25, 25));
    draw_rectangle(msg_x - btn_width + 25, btn_save_y + 25, msg_x + btn_width - 25, btn_save_y + 75, false);

    if ((mx > msg_x - btn_width - 20 && mx < msg_x + btn_width + 20 && my > btn_save_y + 30 && my < btn_save_y + 80) || selected_row = 2) {
        draw_set_color(global.primary_color_yellow);
		selected_row = 2;
    } else {
        draw_set_color(c_white);
    }
	if (global.current_language == "ENGLISH") draw_text(msg_x, btn_save_y + btn_height / 2, "[SAVE AND EXIT]");
    else draw_text(msg_x, btn_save_y + btn_height / 2, "[SALIR Y GUARDAR]");
}


if (load_shown) {
    var offset_y = 100;

    var msg_width = 500;
    var msg_height = 350;
    var btn_spacing = 20;

    // Ajustar posiciones con el offset
    var adjusted_msg_x = msg_x;
    var adjusted_msg_y = msg_y + offset_y;

    // Fondo del mensaje
    draw_set_color(c_dkgray);
    draw_rectangle(adjusted_msg_x - msg_width / 2, adjusted_msg_y - msg_height / 2, adjusted_msg_x + msg_width / 2, adjusted_msg_y + msg_height / 2, false);

    // Texto del mensaje
    draw_set_font(splat_font_title);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
	if (global.current_language == "ENGLISH") {
		draw_text(adjusted_msg_x, adjusted_msg_y - 160, "Chart data found");
		draw_text(adjusted_msg_x, adjusted_msg_y - 130, "for other difficulties.");
		draw_text(adjusted_msg_x, adjusted_msg_y - 80, "Do you want to load them here?");
	} else {
		draw_text(adjusted_msg_x, adjusted_msg_y - 160, "Se encontraron datos de charts");
	    draw_text(adjusted_msg_x, adjusted_msg_y - 130, "para otras dificultades.");
	    draw_text(adjusted_msg_x, adjusted_msg_y - 80, "Deseas cargarlas aqui?");
	}
    
    
    // Obtener posición del mouse
    var mx = mouse_x;
    var my = mouse_y;

    // Botón "CANCELAR"
    var cancel_x = adjusted_msg_x;
    var cancel_y = adjusted_msg_y + 100;
    draw_set_color(make_color_rgb(25, 25, 25));
    draw_rectangle(cancel_x - btn_width, cancel_y - btn_height / 2, cancel_x + btn_width, cancel_y + btn_height / 2, false);

    if ((mx > cancel_x - btn_width && mx < cancel_x + btn_width && my > cancel_y - btn_height / 2 && my < cancel_y + btn_height / 2) || selected_row = 0) {
        draw_set_color(global.primary_color_yellow);
		selected_row = 0;
    } else {
        draw_set_color(c_white);
    }
    if (global.current_language == "ENGLISH") draw_text(cancel_x, cancel_y - 25, "[CANCEL]");
	else draw_text(cancel_x, cancel_y - 25, "[CANCELAR]");

    // Botones de dificultad
    var easy_x = adjusted_msg_x - btn_width - btn_spacing;
    var normal_x = adjusted_msg_x;
    var hard_x = adjusted_msg_x + btn_width + btn_spacing;
    var btn_y = adjusted_msg_y + 20;

    // Determinar el color del texto según las condiciones
    var easy_color = (global.charts.easy.charts[global.current_chart_index] == []) ? make_color_rgb(169, 169, 169) : make_color_rgb(25, 25, 25);
    var normal_color = (global.charts.normal.charts[global.current_chart_index] == []) ? make_color_rgb(169, 169, 169) : make_color_rgb(25, 25, 25);
    var hard_color = (global.charts.hard.charts[global.current_chart_index] == []) ? make_color_rgb(169, 169, 169) : make_color_rgb(25, 25, 25);

    // Botón "Easy"
    draw_set_color(make_color_rgb(25, 25, 25));
    draw_rectangle(easy_x - btn_width / 2, btn_y - btn_height / 2, easy_x + btn_width / 2, btn_y + btn_height / 2, false);
    
    if (array_length(global.charts.easy.charts[global.current_chart_index]) > 0) {
        if ((mx > easy_x - btn_width / 2 && mx < easy_x + btn_width / 2 && my > btn_y - btn_height / 2 && my < btn_y + btn_height / 2) || selected_row = 1) {
            draw_set_color(global.primary_color_yellow);
			selected_row = 1;
        } else {
            draw_set_color(c_white);
        }
    } else {
        draw_set_color(make_color_rgb(169, 169, 169));
    }
    if (global.current_language == "ENGLISH") draw_text(easy_x, btn_y - 25, "[EASY]");
	else draw_text(easy_x, btn_y - 25, "[FACIL]");
    
    // Botón "Normal"
    draw_set_color(make_color_rgb(25, 25, 25));
    draw_rectangle(normal_x - btn_width / 2, btn_y - btn_height / 2, normal_x + btn_width / 2, btn_y + btn_height / 2, false);
    
    if (array_length(global.charts.normal.charts[global.current_chart_index]) > 0) {
        if ((mx > normal_x - btn_width / 2 && mx < normal_x + btn_width / 2 && my > btn_y - btn_height / 2 && my < btn_y + btn_height / 2) || selected_row = 2) {
            draw_set_color(global.primary_color_yellow);
			selected_row = 2;
        } else {
            draw_set_color(c_white);
        }
    } else {
        draw_set_color(make_color_rgb(169, 169, 169));
    }
    draw_text(normal_x, btn_y - 25, "[NORMAL]");

    // Botón "Hard"
    draw_set_color(make_color_rgb(25, 25, 25));
    draw_rectangle(hard_x - btn_width / 2, btn_y - btn_height / 2, hard_x + btn_width / 2, btn_y + btn_height / 2, false);
    
    if (array_length(global.charts.hard.charts[global.current_chart_index]) > 0) {
        if ((mx > hard_x - btn_width / 2 && mx < hard_x + btn_width / 2 && my > btn_y - btn_height / 2 && my < btn_y + btn_height / 2) || selected_row = 3) {
            draw_set_color(global.primary_color_yellow);
			selected_row = 3;
        } else {
            draw_set_color(c_white);
        }
    } else {
        draw_set_color(make_color_rgb(169, 169, 169));
    }
    if (global.current_language == "ENGLISH") draw_text(hard_x, btn_y - 25, "[HARD]");
	else draw_text(hard_x, btn_y - 25, "[DIFICIL]");
}
