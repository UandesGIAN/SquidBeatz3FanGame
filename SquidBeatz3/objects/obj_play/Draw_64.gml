/// @description Insert description here
// You can write your code in this editor

/// @description Insert description here
// You can write your code in this editor

draw_set_halign(fa_left);
draw_set_valign(fa_top);
// HUD
layer_set_visible("HUD_CONTROLLER", false);
layer_set_visible("HUD_CONTROLLER_PRACTICE", false);
layer_set_visible("HUD_CONTROLLER_PLAYING", false);
layer_set_visible("HUD_CONTROLLER_PRACTICE_PLAYING", false);
layer_set_visible("HUD_CONTROLLER_NEWSONG", false);
layer_set_visible("HUD_PC", false);
layer_set_visible("HUD_PC_PRACTICE", false);
layer_set_visible("HUD_PC_PLAYING", false);
layer_set_visible("HUD_PC_PRACTICE_PLAYING", false);
layer_set_visible("HUD_PC_NEWSONG", false);

layer_set_visible("HUD_CONTROLLER_ENGLISH", false);
layer_set_visible("HUD_CONTROLLER_PRACTICE_ENGLISH", false);
layer_set_visible("HUD_CONTROLLER_PLAYING_ENGLISH", false);
layer_set_visible("HUD_CONTROLLER_PRACTICE_PLAYING_ENGLISH", false);
layer_set_visible("HUD_CONTROLLER_NEWSONG_ENGLISH", false);
layer_set_visible("HUD_PC_ENGLISH", false);
layer_set_visible("HUD_PC_PRACTICE_ENGLISH", false);
layer_set_visible("HUD_PC_PLAYING_ENGLISH", false);
layer_set_visible("HUD_PC_PRACTICE_PLAYING_ENGLISH", false);
layer_set_visible("HUD_PC_NEWSONG_ENGLISH", false);

draw_set_color(global.primary_color_yellow);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(splat_font_title);

// Condiciones para mostrarcapas específicas
if (global.is_gamepad) {
    if (global.practice_mode && global.is_playing && play_music) {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_PRACTICE_PLAYING_ENGLISH" : "HUD_CONTROLLER_PRACTICE_PLAYING", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_PRACTICE_PLAYING_ENGLISH" : "HUD_CONTROLLER_PRACTICE_PLAYING"), shader_hue_shift);
		
		draw_set_color(c_aqua);
		if (global.current_language == "ENGLISH") draw_text_ext_transformed(121, 624, "C", 0, 100, 0.8258677, 0.5660378, 0);
		else draw_text_ext_transformed(169, 624, "C", 0, 100, 0.8258677, 0.5660378, 0);
		draw_set_color(global.primary_color_yellow);
	} else if (global.practice_mode) {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_PRACTICE_ENGLISH" : "HUD_CONTROLLER_PRACTICE", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_PRACTICE_ENGLISH" : "HUD_CONTROLLER_PRACTICE"), shader_hue_shift);
		
		draw_set_color(c_aqua);
		if (global.current_language == "ENGLISH") draw_text_ext_transformed(121, 612, "C", 0, 100, 0.8258677, 0.5660378, 0);
		else draw_text_ext_transformed(169, 612, "C", 0, 100, 0.8258677, 0.5660378, 0);
		draw_set_color(global.primary_color_yellow);
	} else if (global.is_playing && play_music) {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_PLAYING_ENGLISH" : "HUD_CONTROLLER_PLAYING", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_PLAYING_ENGLISH" : "HUD_CONTROLLER_PLAYING"), shader_hue_shift);
	} else if (global.current_chart_index == 0) {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_NEWSONG_ENGLISH" : "HUD_CONTROLLER_NEWSONG", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_NEWSONG_ENGLISH" : "HUD_CONTROLLER_NEWSONG"), shader_hue_shift);
	} else {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_ENGLISH" : "HUD_CONTROLLER", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_CONTROLLER_ENGLISH" : "HUD_CONTROLLER"), shader_hue_shift);
	}
} else {
	if (global.practice_mode && global.is_playing && play_music) {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_PC_PRACTICE_PLAYING_ENGLISH" : "HUD_PC_PRACTICE_PLAYING", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_PC_PRACTICE_PLAYING_ENGLISH" : "HUD_PC_PRACTICE_PLAYING"), shader_hue_shift);
		
		draw_text_ext_transformed(1101, 137, "Editor", 0, 100, 0.8571177, 0.735849, 0);
		draw_set_color(c_aqua);
		if (global.current_language == "ENGLISH") draw_text_ext_transformed(96, 612, "C", 0, 100, 0.5025722, 0.4339623, 0);
		else draw_text_ext_transformed(129, 612, "C", 0, 100, 0.5025722, 0.4339623, 0);
		draw_set_color(global.primary_color_yellow);
	} else if (global.practice_mode) {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_PC_PRACTICE_ENGLISH" : "HUD_PC_PRACTICE", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_PC_PRACTICE_ENGLISH" : "HUD_PC_PRACTICE"), shader_hue_shift);

		draw_text_ext_transformed(1101,198, "Editor", 0, 100, 0.8571177, 0.735849, 0);
		draw_set_color(c_aqua);
		if (global.current_language == "ENGLISH") draw_text_ext_transformed(107, 676, "C", 0, 100, 0.5025722, 0.4339623, 0);
		else draw_text_ext_transformed(140, 676, "C", 0, 100, 0.5025722, 0.4339623, 0);
		draw_set_color(global.primary_color_yellow);
	} else if (global.is_playing && play_music) {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_PC_PLAYING_ENGLISH" : "HUD_PC_PLAYING", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_PC_PLAYING_ENGLISH" : "HUD_PC_PLAYING"), shader_hue_shift);
		
		draw_text_ext_transformed(1101, 137, "Editor", 0, 100, 0.8571177, 0.735849, 0);
	} else if (global.current_chart_index == 0) {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_PC_NEWSONG_ENGLISH" : "HUD_PC_NEWSONG", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_PC_NEWSONG_ENGLISH" : "HUD_PC_NEWSONG"), shader_hue_shift);
		
		draw_text_ext_transformed(1177, 69, (global.current_language == "ENGLISH" ? "Create" : "Crear"), 0, 100, 0.8571177, 0.735849, 0);
	} else {
	    layer_set_visible(global.current_language == "ENGLISH" ? "HUD_PC_ENGLISH" : "HUD_PC", true);
		layer_shader(layer_get_id(global.current_language == "ENGLISH" ? "HUD_PC_ENGLISH" : "HUD_PC"), shader_hue_shift);
		
		draw_text_ext_transformed(1101, 198, "Editor", 0, 100, 0.8571177, 0.735849, 0);
	}
}


shader_set(shader_hue_shift);
shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);

// Dibujar el sprite con el shader
draw_self();

shader_reset();

// Nombre cancion
draw_set_color(global.secondary_color_purple);
draw_set_font(splat_font_title);
draw_set_halign(fa_left);
draw_text(x+150, y-5, global.song_text_list[global.current_song_index]);

// Sprite medalla
var fade_duration = 800; // Duración del fade-in (frames)
var zoom_duration = 1000; // Duración del zoom (frames)
var start_scale = 16; // Escala inicial
var end_scale = 1; // Escala final

// Calcular el progreso del fade-in y zoom
var progress = clamp((current_time - animation_start_time) / fade_duration, 0, 1); 
var alpha = progress; // Opacidad entre 0 y 1
var scale = lerp(start_scale, end_scale, progress); // Escala progresiva

var total_elements = array_length(global.charts[$ global.current_difficulty].charts[global.current_song_index]);
var total_hits = global.game_points[$ global.current_difficulty].total_hits[global.current_song_index];

if (obj_sync.game_win_for_first_time && total_elements > 0) {
	if (total_elements == global.game_points[$ global.current_difficulty].count_gold[global.current_song_index]) {
        draw_set_alpha(alpha);
		if (global.octo_icons) draw_sprite_ext(spr_gold_octo, 0, x+80, y, scale, scale, 0, c_white, alpha);
        else draw_sprite_ext(spr_gold, 0, x+80, y, scale, scale, 0, c_white, alpha);
        draw_set_alpha(1);
    } else if (total_elements == global.game_points[$ global.current_difficulty].count_silver[global.current_song_index] + global.game_points[$ global.current_difficulty].count_gold[global.current_song_index]) {
        draw_set_alpha(alpha);
        if (global.octo_icons) draw_sprite_ext(spr_silver_octo, 0, x+80, y, scale, scale, 0, c_white, alpha);
		else draw_sprite_ext(spr_silver, 0, x+80, y, scale, scale, 0, c_white, alpha);
        draw_set_alpha(1);
    } else if (total_elements == global.game_points[$ global.current_difficulty].count_silver[global.current_song_index]) {
        draw_set_alpha(alpha);
        if (global.octo_icons) draw_sprite_ext(spr_bronze_octo, 0, x+80, y, scale, scale, 0, c_white, alpha);
		else draw_sprite_ext(spr_bronze, 0, x+80, y, scale, scale, 0, c_white, alpha);
        draw_set_alpha(1);
    }
} else {
	if (obj_sync.game_win && total_elements > 0) {
		if (total_elements == global.game_points[$ global.current_difficulty].count_gold[global.current_song_index]) {
			if (global.octo_icons) draw_sprite(spr_gold_octo, 0, x+80, y);
			else draw_sprite(spr_gold, 0, x+80, y)
		} else if (total_elements == global.game_points[$ global.current_difficulty].count_silver[global.current_song_index] + global.game_points[$ global.current_difficulty].count_gold[global.current_song_index]) {
			if (global.octo_icons) draw_sprite(spr_silver_octo, 0, x+80, y);
			else draw_sprite(spr_silver, 0, x+80, y);
		} else if (total_elements == global.game_points[$ global.current_difficulty].count_silver[global.current_chart_index]) {
			if (global.octo_icons) draw_sprite(spr_bronze_octo, 0, x+80, y);
			else draw_sprite(spr_bronze, 0, x+80, y);
		}
	}
}

if (play_music) {
    if (current_time - prev_frame_timer > (current_sprite == spr_dance6 || current_sprite == spr_dance8 ? 34 : 31) && obj_sync.current_life > 0) {
		animation_timer++;
		prev_frame_timer = current_time;
	}
	
    // Si el temporizador ha llegado al final del ciclo o el sprite aún no se seleccionó
    if (current_sprite == -1) {
        // Selecciona un sprite aleatorio
        current_sprite = choose(spr_dance2, spr_dance1, spr_dance3, spr_dance4, spr_dance5, spr_dance6, spr_dance7, spr_dance8);
		animation_timer = 0; // Reinicia el contador
		randomcolor = choose(global.primary_color_yellow, global.interface_color, global.secondary_color_purple);
    }
	if (animation_timer >= sprite_get_number(current_sprite)) animation_timer = 0;
	
	draw_sprite_ext(current_sprite, animation_timer, 775, 60, 1.8, 1.8, 0, randomcolor, 1);
	
} else {
	current_sprite = -1;
}

// Volumen
if (keyboard_check_pressed(vk_subtract) || keyboard_check_pressed(vk_add)) volume_message_timer = current_time + 1000;
draw_set_color(c_white);
// Si ha pasado menos de 1 segundo, muestra el volumen actual
if (volume_message_timer > current_time) {
	if (!keyboard_check(vk_control)) {
	    var padding = 10; // Espaciado interno del rectángulo
		var volume_text = "VOLUMEN: " + string(audio_sound_get_gain(global.current_song));
		if (global.current_language == "ENGLISH") volume_text = "VOLUME: " + string(audio_sound_get_gain(global.current_song));
    
	    var text_width = string_width(volume_text);
	    var text_height = string_height(volume_text);

		// Dibujar volumen
	    draw_set_color(c_black);
	    draw_rectangle(800 - padding, 380 - padding, 800 + text_width + padding, 380 + 30 + padding, false);
	    draw_set_color(c_white);
	    draw_text(800, 365, volume_text);
	} else {
		var padding = 10; // Espaciado interno del rectángulo
		var volume_text = "DELAY: " + string(global.sound_delay);
    
	    var text_width = string_width(volume_text);
	    var text_height = string_height(volume_text);

		// Dibujar volumen
	    draw_set_color(c_black);
	    draw_rectangle(800 - padding, 380 - padding, 800 + text_width + padding, 380 + 30 + padding, false);
	    draw_set_color(c_white);
	    draw_text(800, 365, volume_text);
	}
}

draw_set_color(global.primary_color_yellow);
if (global.practice_mode) {
	 if (global.current_language == "ENGLISH") draw_text(room_width-305, room_height - 354, "PRACTICE");
		else draw_text(room_width-305, room_height - 354, "PRACTICA");
}