/// @description Insert description here
// You can write your code in this editor

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_font(splat_font_title);
if (global.current_language  == "ENGLISH") draw_text(1024, 268, "Selected: ");
else draw_text(1024, 268, "Seleccion: ");
var sprite_position_y = (selected_type < 4) ? 270 : 250;
draw_set_color(global.primary_color_yellow);
if (global.current_language  == "ENGLISH") draw_text(1024 + string_width("Selected:")/2-5, 305, string(selected_type));
else draw_text(1024 + string_width("Seleccion:")/2-5, 305, string(selected_type));

draw_set_color(c_white);
shader_set(shader_hue_shift);
shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);

if (global.current_language  == "ENGLISH") draw_sprite(type_spr[selected_type], 0, 1150, sprite_position_y);
else draw_sprite(type_spr[selected_type], 0, 1155, sprite_position_y);

shader_reset();

draw_set_color(global.secondary_color_purple);
if (global.current_language  == "ENGLISH") {
	draw_text(1024, 150, "Current BPM: " + string(global.tempo));
	draw_text(1024, 200, "Notes number: " + string(array_length(global.current_chart)));
} else {
	draw_text(1024, 150, "BPM actual: " + string(global.tempo));
	draw_text(1024, 200, "Numero de Notas: " + string(array_length(global.current_chart)));
}
draw_set_color(global.primary_color_yellow);
switch (global.current_difficulty) {
		case ("easy"):
			if (global.current_language  == "ENGLISH") draw_text(1024, 105, "Difficulty: Easy");
			else draw_text(1024, 105, "Dificultad: Facil");
			break;
		case ("normal"):
			if (global.current_language  == "ENGLISH") draw_text(1024, 105, "Difficulty: Normal");
			else draw_text(1024, 105, "Dificultad: Normal");
			break;
		case ("hard"):
			if (global.current_language  == "ENGLISH") draw_text(1024, 105, "Difficulty: Hard");
			else draw_text(1024, 105, "Dificultad: Dificil");
			break;
	}

// Agrega el texto de x_base en la parte inferior de la pantalla
draw_set_color(c_white);
if (global.current_language  == "ENGLISH") draw_text(10, 655, "Start coordinate: " + string(-global.base_x div 1));
else draw_text(10, 655, "Coordenada de inicio: " + string(-global.base_x div 1));
if (global.current_language  == "ENGLISH") draw_text(10, 690, "Current second: " + string(obj_chart_game.tiempo_inicio));
else draw_text(10, 690, "Segundo actual: " + string(obj_chart_game.tiempo_inicio));


draw_set_halign(fa_right);
if (global.current_language  == "ENGLISH") draw_text(room_width-20, 400, "Current coordinate: " + string((global.base_x + mouse_x) div 1));
else draw_text(room_width-20, 400, "Coordenada actual: " + string((global.base_x + mouse_x) div 1));
draw_set_halign(fa_left);

if ((!keyboard_check(ord("V")) && !keyboard_check(vk_control) && (keyboard_check_pressed(vk_subtract) || keyboard_check_pressed(vk_add)))) volume_message_timer = current_time + 1000;
else if ((keyboard_check(ord("V")) && keyboard_check(vk_control) && (keyboard_check_pressed(vk_subtract) || keyboard_check_pressed(vk_add)))) volume_message_timer = current_time + 1000;

// Si ha pasado menos de 1 segundo, muestra el volumen actual
if (volume_message_timer > current_time) {
	if (keyboard_check(ord("V")) && keyboard_check(vk_control)) {
		var padding = 10; // Espaciado interno del rectángulo
		var volume_text = "DELAY: " + string(global.sound_delay);
	    var text_width = string_width(volume_text);

		// Dibujar volumen
	    draw_set_color(c_black);
	    draw_rectangle(800 - padding, 380 - padding, 800 + text_width + padding, 380 + 30 + padding, false);
	    draw_set_color(c_white);
	    draw_text(800, 365, volume_text);
	} else {
		var padding = 10; // Espaciado interno del rectángulo
		var volume_text = "VOLUMEN: " + string(audio_sound_get_gain(obj_chart_game.current_song));
		if (global.current_language  == "ENGLISH") volume_text = "VOLUME: " + string(audio_sound_get_gain(obj_chart_game.current_song));
	    var text_width = string_width(volume_text);

		// Dibujar volumen
	    draw_set_color(c_black);
	    draw_rectangle(800 - padding, 380 - padding, 800 + text_width + padding, 380 + 30 + padding, false);
	    draw_set_color(c_white);
	    draw_text(800, 365, volume_text);
	}
}

draw_set_font(splat_font_small);
draw_set_color(global.interface_color);
draw_text(global.start_point - 1, 440, "R");
if (global.current_language  == "ENGLISH") {
	if (global.start_point == global.base_x) draw_text(global.start_point - 18, 460, "START");
	else draw_text(global.start_point - global.base_x - global.start_point - 18, 460, "START");
} else {
	if (global.start_point == global.base_x) draw_text(global.start_point - 18, 460, "INICIO");
	else draw_text(global.start_point - global.base_x - global.start_point - 18, 460, "INICIO");
}
draw_set_color(c_white);

draw_set_color(c_aqua);
if (!obj_chart_game.toggle_checkpoint && obj_chart_game.checkpoint_start != -1) draw_text(obj_chart_game.checkpoint_text_x - 1, 440, "C");
else if (obj_chart_game.toggle_checkpoint && obj_chart_game.checkpoint_start != -1) draw_text(obj_chart_game.checkpoint_text_x - 1, 440, "X");
draw_set_color(c_white);

var elements = global.current_chart;
if (array_length(elements) > 0) {
	for (var i = 0; i < array_length(elements); i++) {
	    var element = elements[i];
        var fixed_x = element.pos_x - global.base_x;
        // Verifica si el elemento está dentro de los límites del cuarto
        if (fixed_x >= 0 && fixed_x <= room_width) {
            // Si el elemento está en edición, dibuja un rectángulo celeste debajo
            if (i == editing_element) {
                draw_set_color(c_aqua);
                draw_rectangle(fixed_x - 5, pos_y[element.index_type] - 10, fixed_x + 15, pos_y[element.index_type], false);
                draw_set_color(c_white);
				draw_set_font(splat_font_title);
				draw_set_halign(fa_right);
				draw_set_color(global.primary_color_yellow);
				if (global.current_language  == "ENGLISH") draw_text(room_width-20, 360, "Selected element: " + string(element.pos_x div 1));
				else draw_text(room_width-20, 360, "Elemento seleccionado: " + string(element.pos_x div 1));
            }
			
			for (var j = 0; j < array_length(editing_elements); j++) {
				var local_editing_element = editing_elements[j];
				if (i == local_editing_element) {
	                draw_set_color(c_aqua);
	                draw_rectangle(fixed_x - 5, pos_y[element.index_type] - 10, fixed_x + 15, pos_y[element.index_type], false);
	                draw_set_color(c_white);
				}
			}
            draw_set_color(c_white);
            // Dibuja el sprite del elemento
			draw_set_font(splat_font_small);
			draw_set_halign(fa_left);
			
			shader_set(shader_hue_shift);
			shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);
            draw_sprite(type_spr[element.index_type], 0, fixed_x - (((element.index_type) mod 2)*10+20), pos_y[element.index_type]);
			shader_reset();
			if (element.index_type == 0 || element.index_type == 1) {
				draw_text(fixed_x - 8 - element.index_type*5, 485, string(element.pos_x div 1));
			} else if (element.index_type == 2 || element.index_type == 3) {
				draw_text(fixed_x + (element.index_type-1)*2, 644, string(element.pos_x div 1));
			} else {
				draw_text(fixed_x - 8 - element.index_type*5, 485, string(element.pos_x div 1));
				draw_text(fixed_x + (element.index_type-1)*2, 644, string(element.pos_x div 1));
			}
        }
	}
}