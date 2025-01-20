/// @description Insert description here
// You can write your code in this editor

if (!message_shown) {

	if (id == game_bar[0]) {
		tiempo_inicio = ((global.start_point + global.base_x) / (global.tempo * proportion_bpm_to_speed * 60));
    
		// TIPOS DE MOVIMIENTO
		if (keyboard_check_pressed(vk_space)) {
		    if (!toggle_checkpoint) {
		        playing_audio = !playing_audio;
		    } else {
				playing_audio = 1;
				
		        // Restaurar el estado del checkpoint
		        global.base_x = checkpoint_base_x; // Restaurar base_x guardada
		        if (checkpoint_base_x > 0) game_bar[0].x = checkpoint_start - sprite_width;
				else game_bar[0].x = checkpoint_start;
				index_bar = 0;

		        // Recalcular las posiciones de las barras
		        for (var i = 1; i < 4; i++) {
		            var next_index = (index_bar + i) mod 4;
		            var prev_index = (index_bar + i - 1) mod 4;
		            game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
		        }

		        mouse_pressed = false;
		        xprev = checkpoint_start;
		        conteo_desplazamiento = conteo_d_checkpoint;
				tiempo_inicio = ((global.start_point + global.base_x) / (global.tempo * proportion_bpm_to_speed * 60))
				audio_stop_sound(sound_id);
		    }
		
		    if (playing_audio) {
			    mode = "auto";
				sound_id = audio_play_sound(current_song, 1, false);
				audio_sound_set_track_position(sound_id, tiempo_inicio);
				show_debug_message("auto mode: " + string(tiempo_inicio) + " | " + string(audio_sound_get_track_position(sound_id)));
			} else {
			    mode = "manual";
				prev_element_sound = -1;
			    tiempo_inicio = audio_sound_get_track_position(sound_id);
				show_debug_message("manual mode: " + string(tiempo_inicio) + " | " + string(audio_sound_get_track_position(sound_id)));
				audio_stop_sound(sound_id);
			
			    // Restaurar estado desde checkpoint
			    if (checkpoint_start == -1) {
			        xprev = game_bar[index_bar].x;
			    } else {
			        playing_audio = 0;
		       
			        global.base_x = checkpoint_base_x; // Restaurar base_x guardada
					if (checkpoint_base_x > 0) game_bar[0].x = checkpoint_start - sprite_width
					else game_bar[0].x = checkpoint_start;
					index_bar = 0;
					 // Recalcular las posiciones de las barras
			        for (var i = 1; i < 4; i++) {
			            var next_index = (index_bar + i) mod 4;
			            var prev_index = (index_bar + i - 1) mod 4;
			            game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
			        }
				
			        xprev = checkpoint_start;
			        conteo_desplazamiento = conteo_d_checkpoint;
			    }
			}
		    mouse_pressed = 0;

		    show_debug_message("MODE CHANGE | Mode: " + mode + " | xprev: " + string(xprev) + " | Index: " + string(index_bar) + " | Conteo: " + string(conteo_desplazamiento));
		    has_changed = 0;
		}
	
		// AJUSTAR VELOCIDAD
		if (keyboard_check(vk_control) && !keyboard_check(vk_alt) && !keyboard_check(ord("V"))) {
			if (keyboard_check_pressed(vk_add) ) {
				global.tempo++;
				if (global.tempo > 300) global.tempo = 300;
				current_key_timer = current_time;
			}
			if (keyboard_check(vk_add) && (current_time - current_key_timer) > 500) {
				global.tempo++;
				if (global.tempo > 300) global.tempo = 300;
			}
	
			if (keyboard_check_pressed(vk_subtract)) {
				global.tempo--;
				if (global.tempo < 30) global.tempo = 30;
				current_key_timer = current_time;
		
			} else if (keyboard_check(vk_subtract) && (current_time - current_key_timer) > 500) {
				global.tempo--;
				if (global.tempo < 30) global.tempo = 30;
			}
		}

	
		// MARCAR PUNTO DE INICIO
		if (keyboard_check_pressed(ord("P"))) {
			if (game_bar[index_bar].x >= 272 && game_bar[index_bar].x < 1276) {
				global.start_point = game_bar[index_bar].x;
			} else if (game_bar[index_bar].x >= 1276) {
				global.start_point = 1276;
			} else if (game_bar[index_bar].x < 272) {
				global.start_point = 272;
			}
		
			index_bar = 0;
			game_bar[index_bar].x = global.start_point;
			for (var i = 1; i < 4; i++) {
		        var next_index = (index_bar + i) mod 4;
		        var prev_index = (index_bar + i - 1) mod 4;
		        game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
		    }
			mouse_pressed = false;
			xprev = global.start_point;
			conteo_desplazamiento = 0;
			has_changed = 0;
			global.base_x = global.start_point;
		}
	
		if (keyboard_check_pressed(ord("R")) && !keyboard_check(vk_control)) {
			index_bar = 0;
			game_bar[index_bar].x = global.start_point;
			for (var i = 1; i < 4; i++) {
		        var next_index = (index_bar + i) mod 4;
		        var prev_index = (index_bar + i - 1) mod 4;
		        game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
		    }
			mouse_pressed = false;
			xprev = global.start_point;
			conteo_desplazamiento = 0;
			has_changed = 0;
			global.base_x = global.start_point;
			audio_sound_set_track_position(sound_id,0);
			if (playing_audio) {
					audio_stop_sound(sound_id);
				    sound_id = audio_play_sound(current_song, 1, false);
			}
		
		}
	
		if (keyboard_check_pressed(ord("X")) && !keyboard_check(vk_control)) {
			if (!toggle_checkpoint) {
			    mode = "manual";
			    audio_stop_sound(sound_id);
			    playing_audio = 0;
			
			    xprev = game_bar[index_bar].x;
			    mouse_pressed = 0;
			    checkpoint_start = -1;
				checkpoint_text_x = -1;
				checkpoint_base_x = 0;
				index_bar_checkpoint = 0;
				conteo_d_checkpoint = 0;
			}
			
			if (global.base_x <= 0) {
			    index_bar_checkpoint = index_bar;
			    conteo_d_checkpoint = conteo_desplazamiento;

			    // Guardar el estado actual como checkpoint
			    checkpoint_start = game_bar[index_bar].x;
			    checkpoint_text_x = checkpoint_start;
			    checkpoint_base_x = global.base_x;

			} else if (global.base_x > 0) {
				index_bar_checkpoint = index_bar;
			    conteo_d_checkpoint = conteo_desplazamiento;

			    // Guardar el estado actual como checkpoint
			    checkpoint_base_x = global.base_x;
			    checkpoint_start = game_bar[index_bar].x + sprite_width;
				checkpoint_text_x = checkpoint_start;
			}
			
			toggle_checkpoint = !toggle_checkpoint;
		}

	
		if (!keyboard_check(vk_control) && keyboard_check_pressed(ord("C"))) {
			if (checkpoint_start != -1) {
				if (toggle_checkpoint) toggle_checkpoint = 0;
				checkpoint_start = -1;
				checkpoint_text_x = -1;
				checkpoint_base_x = 0;
				index_bar_checkpoint = 0;
				conteo_d_checkpoint = 0;
			} else {
				if (global.base_x < 0) {
				    index_bar_checkpoint = index_bar;
				    conteo_d_checkpoint = conteo_desplazamiento;

				    // Guardar el estado actual como checkpoint
				    checkpoint_start = game_bar[index_bar].x;
				    checkpoint_text_x = checkpoint_start;
				    checkpoint_base_x = global.base_x;

				} else {
					index_bar_checkpoint = index_bar;
				    conteo_d_checkpoint = conteo_desplazamiento;

				    // Guardar el estado actual como checkpoint
				    checkpoint_base_x = global.base_x;
				    checkpoint_start = game_bar[index_bar].x + sprite_width;
					checkpoint_text_x = checkpoint_start;
				}
			}
		}
	
	
		// MODO AUTOMATICO
		if (mode == "auto" && playing_audio) {
			show_debug_message("t_track: " + string(audio_sound_get_track_position(sound_id)) + " | t: " + string(tiempo_inicio));
		
		    // Actualizar posición de las barras
		    with (obj_chart_game) {
		        x += -global.tempo * proportion_bpm_to_speed; // Todas las barras usan la misma velocidad
		    }
		
			for (var i = 0; i < array_length(game_bar); i++) {
			    var bar = game_bar[i];

			    // Detectar cruce de x = 271.5
			    if (metronome_sfx) {
			        // Detectar el beat alto (High)
			        if (bar.x <= 271.5 && bar.x + (global.tempo * proportion_bpm_to_speed) > 271.5) {
			            var sfx_id = audio_play_sound(metronome_high, 1, 0);
			        }

			        // Detectar los beats bajos (Low) usando offsets
			        else if (bar.x + 132 <= 271.5 && bar.x + 132 + (global.tempo * proportion_bpm_to_speed) > 271.5) {
			            var sfx_id = audio_play_sound(metronome_low, 1, 0);
					}
			        else if (bar.x + 264 <= 271.5 && bar.x + 264 + (global.tempo * proportion_bpm_to_speed) > 271.5) {
			            var sfx_id = audio_play_sound(metronome_low, 1, 0);
					}
			        else if (bar.x + 396 <= 271.5 && bar.x + 396 + (global.tempo * proportion_bpm_to_speed) > 271.5) {
			            var sfx_id = audio_play_sound(metronome_low, 1, 0);
					}
			    }
			}
		
			for (var j = 0; j < array_length(global.current_chart); j++) {
				var element = global.current_chart[j];
			
				if (current_time - sfx_delay >= 80 && element.index_type == 0 && (element.pos_x - (global.base_x div 1)) < 310 && (element.pos_x - (global.base_x div 1)) > 296) {
					if (prev_element_sound != j) {
						prev_element_sound = j;
						var sfx_id = audio_play_sound(global.sound_effects[global.current_sfx_index][1], 1, 0);
						sfx_delay = current_time;
					}
				} else if (current_time - sfx_delay >= 80 && element.index_type == 1 &&  (element.pos_x - (global.base_x div 1)) < 310 && (element.pos_x - (global.base_x div 1)) > 296) {
					if (prev_element_sound != j) {
						prev_element_sound = j;
						var sfx_id = audio_play_sound(global.sound_effects[global.current_sfx_index][2], 1, 0);
						sfx_delay = current_time;
					}
				
				} else if (current_time - sfx_delay >= 80 && element.index_type > 1 && element.index_type < 4 && (element.pos_x - (global.base_x div 1)) < 310 && (element.pos_x - (global.base_x div 1)) > 296) {
					if (prev_element_sound != j) {
						prev_element_sound = j;
						var sfx_id = audio_play_sound(global.sound_effects[global.current_sfx_index][0], 1, 0);
						sfx_delay = current_time;
					}
				} else if (current_time - sfx_delay >= 80 && element.index_type > 3 && element.index_type < 6 && (element.pos_x - (global.base_x div 1)) < 310 && (element.pos_x - (global.base_x div 1)) > 296) {
					if (prev_element_sound != j) {
						prev_element_sound = j;
						var sfx_id = audio_play_sound(global.sound_effects[global.current_sfx_index][1], 1, 0);
						var sfx_id2 = audio_play_sound(global.sound_effects[global.current_sfx_index][0], 1, 0);
						sfx_delay = current_time;
					}
				} else if (current_time - sfx_delay >= 80 && element.index_type > 5 && element.index_type < 8 && (element.pos_x - (global.base_x div 1)) < 310 && (element.pos_x - (global.base_x div 1)) > 296) {
					if (prev_element_sound != j) {
						prev_element_sound = j;
						var sfx_id = audio_play_sound(global.sound_effects[global.current_sfx_index][2], 1, 0);
						var sfx_id2 = audio_play_sound(global.sound_effects[global.current_sfx_index][0], 1, 0);
						sfx_delay = current_time;
					}
				}
			}
		
			// Si la barra guia sale de la pantalla por la izquierda...
			if (game_bar[index_bar].x + sprite_width < 0) {
		        var max_x = -1;
				var max_index = 0;
		        for (var i = 0; i < 4; i++) {
		            if (game_bar[i].x > max_x) {
		                max_x = game_bar[i].x;	// Se determina la barra mas a la derecha
						max_index = i;
		            }
		        }
		
				// La barra se mueve hacia lo mas a la derecha y la barra guia pasa a ser la siguiente
		        game_bar[index_bar].x = max_x + sprite_width;
				index_bar = (max_index + 2) mod 4;
				conteo_desplazamiento += 1
				show_debug_message("AUTO  | x:  " + string(game_bar[index_bar].x) + " | xprev: " + string(xprev) + " | Index: " + string(index_bar) + " | Conteo: " + string(conteo_desplazamiento));
				has_changed = 1;
		    }
		}
	
		// MODO MANUAL
		if (mode == "manual" && mouse_check_button(mb_middle) && !has_changed) {
		    if (!mouse_pressed) {
		        mouse_pressed = 1;
		        start_mouse_x = mouse_x;
		    }

		    var dif = mouse_x - start_mouse_x;

		    // Si el mouse se desplaza, se actualiza la posición de las barras
		    if (dif != 0) {
		        show_debug_message("START MANUAL  | x:  " + string(game_bar[index_bar].x) + " | xprev: " + string(xprev) + " | Index: " + string(index_bar) + " | Conteo: " + string(conteo_desplazamiento));
		        game_bar[index_bar].x = xprev + dif;
		        show_debug_message("START MANUAL NEW  | x:  " + string(game_bar[index_bar].x) + " | xprev: " + string(xprev) + " | Index: " + string(index_bar) + " | Conteo: " + string(conteo_desplazamiento));
		        for (var i = 1; i < 4; i++) {
		            var next_index = (index_bar + i) mod 4;
		            var prev_index = (index_bar + i - 1) mod 4;
		            game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
		        }

		        // Si se sale de la pantalla por la izquierda
		        if (dif < 0 && game_bar[index_bar].x + sprite_width < 0) {
		            game_bar[index_bar].x = game_bar[(index_bar + 3) mod 4].x + sprite_width;
		            index_bar = (index_bar + 1) mod 4;
		            conteo_desplazamiento += 1;
		            show_debug_message("LEFT  | x:  " + string(game_bar[index_bar].x) + " | xprev: " + string(xprev) + " | Index: " + string(index_bar) + " | Conteo: " + string(conteo_desplazamiento));
		            has_changed = 1;
		        }
		        // Si se sale de la pantalla por la derecha
		        if (dif > 0 && game_bar[index_bar].x > 0 && conteo_desplazamiento > 0) {
		            game_bar[(index_bar - 1 + 4) mod 4].x = game_bar[index_bar].x - sprite_width;
		            index_bar = (index_bar - 1 + 4) mod 4;
		            conteo_desplazamiento -= 1;
		            show_debug_message("RIGHT  | x:  " + string(game_bar[index_bar].x) + " | xprev: " + string(xprev) + " | Index: " + string(index_bar) + " | Conteo: " + string(conteo_desplazamiento));
		            has_changed = 1;
		        }
		    }
		}

		// Control de la rueda del ratón
		if (mouse_wheel_up() && mode == "manual") {
		    game_bar[index_bar].x += 10;
			if(game_bar[index_bar].x > 0 && conteo_desplazamiento > 0) {
		        game_bar[(index_bar - 1 + 4) mod 4].x = game_bar[index_bar].x - sprite_width;
		        index_bar = (index_bar - 1 + 4) mod 4;
		        conteo_desplazamiento -= 1;
		        
		        has_changed = 1;
		    }
			
			for (var i = 1; i < 4; i++) {
		        var next_index = (index_bar + i) mod 4;
		        var prev_index = (index_bar + i - 1) mod 4;
		        game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
		    }

		}

		if (mouse_wheel_down() && mode == "manual") {
		    game_bar[index_bar].x -= 10;
			if (game_bar[index_bar].x + sprite_width < 0) {
		        game_bar[index_bar].x = game_bar[(index_bar + 3) mod 4].x + sprite_width;
		        index_bar = (index_bar + 1) mod 4;
		        conteo_desplazamiento += 1;
		        
		        has_changed = 1;
			}
			for (var i = 1; i < 4; i++) {
		        var next_index = (index_bar + i) mod 4;
		        var prev_index = (index_bar + i - 1) mod 4;
		        game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
		    }
		}

		if (mode == "manual" && mouse_check_button_released(mb_middle)) {
		    mouse_pressed = 0;
		    has_changed = 0;
		    xprev = game_bar[index_bar].x;
		}
	
		if (keyboard_check_pressed(ord("T"))) metronome_sfx = !metronome_sfx;

		global.base_x = -game_bar[index_bar].x + sprite_width * conteo_desplazamiento + global.sound_delay*10;
	}
}