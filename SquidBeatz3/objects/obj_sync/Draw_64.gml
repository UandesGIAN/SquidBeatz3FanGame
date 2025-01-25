/// @description Insert description here
// You can write your code in this editor

if (type_of_hit != -1 && current_element_index > 0) {
    // Configurar colores y transparencia según el tipo de golpe
    var alpha = 0;

    switch (type_of_hit) {
        case 0: // Miss
            alpha = 0.2; // Opacidad completa
            break;
        case 1: // Bad
            alpha = 0.4; // 50% opacidad
            break;
        case 2: // Good
            alpha = 0.6; // 25% opacidad
            break;
        case 3: // Fresh
            alpha = 0.8; // Totalmente transparente
            break;
    }
	if (current_element_index >= 0 && current_element_index < array_length(elements) && !global.low_detail) {
		if (elements[current_element_index-1].index_type <= 1) {  // L_R
		    rect_color = global.primary_color_yellow;
		} else if (elements[current_element_index-1].index_type > 1 && elements[current_element_index-1].index_type <= 3) {  // ABXY
		    rect_color = global.secondary_color_purple;
		} else if (elements[current_element_index-1].index_type > 3 && current_time - text_timer >= 800) {  // BOTH
			rect_color = choose(global.primary_color_yellow, global.secondary_color_purple)
		} else if (elements[current_element_index-1].index_type > 3 && current_element_index == 0) {  // BOTH but its first
			rect_color = choose(global.primary_color_yellow, global.secondary_color_purple)
		}
		
		if (current_time - text_timer < 800) {
			// Dibujar el rectángulo de fondo
		    draw_set_alpha(alpha);
		    draw_set_color(rect_color);

		    // Dibujar rectángulos por fuera del rango del sprite
		    draw_rectangle(x, 0, x + sprite_width, y, false);
		    draw_rectangle(x, y + sprite_height, x + sprite_width, room_height, false);

		    draw_set_alpha(1); // Restaurar opacidad a completa
		    draw_set_color(c_white); // Restaurar color blanco para otros dibujos
		}
	}
	
	shader_set(shader_hue_shift);
	shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);

	// Casos hits
	if (missed_or_pressed_type == 0) {
		if (current_time - animation_timer >= 30) {
			animation_frame++;
			animation_timer = current_time;
		}
		if (animation_frame < 6) {
			if (global.octo_icons) draw_sprite(spr_hit1_octo, animation_frame, x-10, 459);
			else draw_sprite(spr_hit1, animation_frame, x-10, 459);
		}
	} else if (missed_or_pressed_type == 1) {
		if (current_time - animation_timer >= 30) {
			animation_frame++;
			animation_timer = current_time;
		}
		if (animation_frame < 6) {
			if (global.octo_icons) draw_sprite(spr_hit2_octo, animation_frame, x-10, 518);
			else draw_sprite(spr_hit2, animation_frame, x-10, 518);
		}
	} else if (missed_or_pressed_type > 1) {
		if (current_time - animation_timer >= 30) {
			animation_frame++;
			animation_timer = current_time;
		}
		if (animation_frame < 6) {
			if (global.octo_icons) {
				draw_sprite(spr_hit1_octo, animation_frame, x-10, 459);
				draw_sprite(spr_hit2_octo, animation_frame, x-10, 518);
			} else {
				draw_sprite(spr_hit1, animation_frame, x-10, 459);
				draw_sprite(spr_hit2, animation_frame, x-10, 518);
			}
		}
	}
	
	shader_reset();
	
	// Dibujar el sprite correspondiente
	if (type_of_hit == 0 && (current_time - text_timer) < 1200) {
		draw_sprite(spr_miss, 0, x, y - 32);
	} else if (type_of_hit == 1 && (current_time - text_timer) < 1200) {
		draw_sprite(spr_bad, 0, x, y - 32);
	} else if (type_of_hit == 2 && (current_time - text_timer) < 1200) {
		if (!global.low_detail) {
			array_sort(pos_x_hit, function(a, b) { return a - b; })
			for (var j = 0; j < array_length(pos_y_hit); j++) {
				if (current_time - hit_timer > 500 && j == array_length(pos_y_hit) - 1 && (pos_y[elements[current_element_index-1].index_type] + pos_y_hit[j] < 0 || pos_y[elements[current_element_index-1].index_type] - pos_y_hit > room_height)) {
					hit_timer = current_time;
					pos_y_hit = [];
					pos_x_hit = [];
					alpha_hit = [];
					break;
				}
			
				if (missed_or_pressed_type == 0) {
					draw_set_alpha(alpha_hit[j]);
					draw_set_color(global.primary_color_yellow);
					draw_circle(pos_x_hit[j]+10, (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 0 ? pos_y[0] : pos_y[1]) + 26, 20,0);
					alpha_hit[j]-=0.05;
				
					shader_set(shader_hue_shift);
					shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);
					draw_set_alpha(1);
					draw_sprite(type_spr[0], 0, pos_x_hit[j], pos_y[elements[current_element_index-1].index_type] + pos_y_hit[j]);
					pos_y_hit[j] -= 25;
					shader_reset();
				} else if (missed_or_pressed_type == 1) {
					draw_set_alpha(alpha_hit[j]);
					draw_set_color(global.secondary_color_purple);
					draw_circle(pos_x_hit[j]+10, (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 2 ? pos_y[2] : pos_y[3]) + 26, 20,0);
					alpha_hit[j]-=0.05;
				
					shader_set(shader_hue_shift);
					shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);
					draw_set_alpha(1);
					draw_sprite(type_spr[2], 0, pos_x_hit[j], pos_y[elements[current_element_index-1].index_type] - pos_y_hit[j]);
					pos_y_hit[j] -= 25;
					shader_reset();
				} else {
					draw_set_alpha(alpha_hit[j]);
					draw_set_color(global.primary_color_yellow);
					if (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 4) {
						draw_circle(pos_x_hit[j]+10, pos_y[0] + 26, 20,0);
						draw_set_color(global.secondary_color_purple);
						draw_circle(pos_x_hit[j]+10, pos_y[2] + 26, 20,0);
					} else if (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 5) {
						draw_circle(pos_x_hit[j]+10, pos_y[1] + 26, 20,0);
						draw_set_color(global.secondary_color_purple);
						draw_circle(pos_x_hit[j]+10, pos_y[2] + 26, 20,0);
					} else if (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 6) {
						draw_circle(pos_x_hit[j]+10, pos_y[0] + 26, 20,0);
						draw_set_color(global.secondary_color_purple);
						draw_circle(pos_x_hit[j]+10, pos_y[3] + 26, 20,0);
					} else {
						draw_circle(pos_x_hit[j]+10, pos_y[1] + 26, 20,0);
						draw_set_color(global.secondary_color_purple);
						draw_circle(pos_x_hit[j]+10, pos_y[3] + 26, 20,0);
					}
					alpha_hit[j]-=0.05;
				
					shader_set(shader_hue_shift);
					shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);
					draw_set_alpha(1);
					draw_sprite(type_spr[0], 0, pos_x_hit[j], pos_y[elements[current_element_index-1].index_type] + pos_y_hit[j]);
					draw_sprite(type_spr[2], 0, pos_x_hit[j], pos_y[elements[current_element_index-1].index_type] - pos_y_hit[j]);
					pos_y_hit[j] -= 25;
					shader_reset();
				}
			}
			shader_reset();
		}
		
		draw_sprite(spr_good, 0, x, y - 32);
		draw_set_font(fnt_splat_points);
		draw_set_color(c_white);
		draw_text(x + sprite_get_width(spr_good) + 5, y - 32, string(combo_count)); // Dibujar el texto a la derecha del sprite
	} else if ( type_of_hit == 3 && (current_time - text_timer) < 1200){
		if (!global.low_detail) {
			array_sort(pos_x_hit, function(a, b) { return a - b; })
			for (var j = 0; j < array_length(pos_y_hit); j++) {
				if (current_time - hit_timer > 1000 && j == array_length(pos_y_hit) - 1 && (pos_y[elements[current_element_index-1].index_type] + pos_y_hit[j] < 0 || pos_y[elements[current_element_index-1].index_type] - pos_y_hit > room_height)) {
					hit_timer = current_time;
					pos_y_hit = [];
					pos_x_hit = [];
					break;
				}
			
				if (missed_or_pressed_type == 0) {
					draw_set_alpha(alpha_hit[j]);
					draw_set_color(global.primary_color_yellow);
					draw_circle(pos_x_hit[j]+10, (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 0 ? pos_y[0] : pos_y[1])+26, 20,0);
					alpha_hit[j]-=0.05;
				
					shader_set(shader_hue_shift);
					shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);
					draw_set_alpha(1);
					draw_sprite(type_spr[0], 0, pos_x_hit[j], pos_y[elements[current_element_index-1].index_type] + pos_y_hit[j]);
					pos_y_hit[j] -= 25;
					shader_reset();
				} else if (missed_or_pressed_type == 1) {
					draw_set_alpha(alpha_hit[j]);
					draw_set_color(global.secondary_color_purple);
					draw_circle(pos_x_hit[j]+10, (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 2 ? pos_y[2] : pos_y[3])+26, 20,0);
					alpha_hit[j]-=0.05;
				
					shader_set(shader_hue_shift);
					shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);
					draw_set_alpha(1);
					draw_sprite(type_spr[2], 0, pos_x_hit[j], pos_y[elements[current_element_index-1].index_type] - pos_y_hit[j]);
					pos_y_hit[j] -= 25;
					shader_reset();
				} else {
					draw_set_alpha(alpha_hit[j]);
					draw_set_color(global.primary_color_yellow);
					if (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 4) {
						draw_circle(pos_x_hit[j]+10, pos_y[0]+26, 20,0);
						draw_set_color(global.secondary_color_purple);
						draw_circle(pos_x_hit[j]+10, pos_y[2]+26, 20,0);
					} else if (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 5) {
						draw_circle(pos_x_hit[j]+10, pos_y[1]+26, 20,0);
						draw_set_color(global.secondary_color_purple);
						draw_circle(pos_x_hit[j]+10, pos_y[2]+26, 20,0);
					} else if (elements[current_element_index-array_length(pos_y_hit)+j].index_type == 6) {
						draw_circle(pos_x_hit[j]+10, pos_y[0]+26, 20,0);
						draw_set_color(global.secondary_color_purple);
						draw_circle(pos_x_hit[j]+10, pos_y[3]+26, 20,0);
					} else {
						draw_circle(pos_x_hit[j]+10, pos_y[1]+26, 20,0);
						draw_set_color(global.secondary_color_purple);
						draw_circle(pos_x_hit[j]+10, pos_y[3]+26, 20,0);
					}
					alpha_hit[j]-=0.05;
				
					shader_set(shader_hue_shift);
					shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);
					draw_set_alpha(1);
					draw_sprite(type_spr[0], 0, pos_x_hit[j], pos_y[elements[current_element_index-1].index_type] + pos_y_hit[j]);
					draw_sprite(type_spr[2], 0, pos_x_hit[j], pos_y[elements[current_element_index-1].index_type] - pos_y_hit[j]);
					pos_y_hit[j] -= 25;
					shader_reset();
				}
			}
		}
		
		draw_sprite(spr_fresh, 0, x, y - 32);
		draw_set_font(fnt_splat_points); // Establecer la fuente
		draw_set_color(make_color_rgb(242, 255, 184));
		draw_text(x + sprite_get_width(spr_fresh) + 6, y - 34, string(combo_count)); // Dibujar el texto a la derecha del sprite
		draw_set_color(make_color_rgb(255, 184, 245));
		draw_text(x + sprite_get_width(spr_fresh) + 5, y - 32, string(combo_count)); // Dibujar el texto a la derecha del sprite
	}
}

if (game_over_message && global.lifebar) {
	if (current_time - game_over_timer < 2000) {
		draw_sprite_ext(spr_bad, 0, x_gameover,room_height/2-50,4,4,0,c_white,1);
		x_gameover += 25;
		x_gameover = min(-5+room_width/2-sprite_get_width(spr_bad)*1.5, x_gameover);
	} else if (current_time - game_over_timer < 4000) {
		draw_sprite_ext(spr_bad, 0, -5+room_width/2-sprite_get_width(spr_bad)*1.5,-50+room_height/2+y_gameover,4,4,rot_gameover,c_white,1);
		rot_gameover += 1;
		y_gameover += 20;
	} else {
		game_over_message = 0;
		global.tempo = global.charts[$ global.current_difficulty].tempo[global.current_chart_index];
        global.start_point = global.charts[$ global.current_difficulty].start_point[global.current_chart_index];
        global.is_playing = 1;
		audio_stop_sound(global.current_song);
		audio_sound_gain(global.current_song, obj_play.volume_count, 0);
	    obj_play.play_music = 0;
		obj_play.sprite_index = spr_pause;
		global.base_x = global.start_point;
		obj_game.game_bar[0].x = global.start_point;
		obj_game.conteo_desplazamiento = 0;
		obj_game.index_bar = 0;
	    for (var i = 1; i < 4; i++) {
	        obj_game.game_bar[i].x = obj_game.game_bar[i-1].x + obj_game.sprite_width;
	    }
	    obj_game.started = 1;
		rot_gameover = 0;
		y_gameover = 0;
		game_over_timer = -1;
	}
}