/// @description Insert description here
// You can write your code in this editor

if (id == game_bar[0] && global.is_playing) {
	if (obj_play.play_music) {
		// Cuando ya esta sonando y le da a jugar de pronto
		if (audio_sound_get_track_position(obj_play.sound_playing) > 0 && !started) {
			var inicio_x = 0;

			// Ajustar base_x inicio_x y las posiciones iniciales de las barras
			if (obj_play.sound_playing != -1) {
				inicio_x = ((audio_sound_get_track_position(obj_play.sound_playing) * (global.tempo * proportion_bpm_to_speed * 60)) - global.start_point)
				show_debug_message("found sound " + string(inicio_x))
			}
			
			conteo_desplazamiento = inicio_x div 528;
			index_bar = 0;
			global.base_x = -inicio_x + sprite_width*conteo_desplazamiento + global.start_point+ global.sound_delay*10;
			game_bar[index_bar].x = -inicio_x;
			for (var i = 1; i < 4; i++) {
				var next_index = (index_bar + i) mod 4;
				var prev_index = (index_bar + i - 1) mod 4;
				game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
			}
			started = 1;
		}
		
		// AUTOMATICO
		if (((obj_sync.current_life > 0 && global.lifebar) || !global.lifebar)) {
			with(obj_game) {
				x += -global.tempo*proportion_bpm_to_speed;	// Desplazamiento a la izquierda de todas las barras
			}
		
			for (var i = 0; i < array_length(game_bar); i++) {
			    var bar = game_bar[i];

			    // Detectar cruce de x = 271.5
			    if (metronome_sfx) {
			        // Detectar el beat alto (High)
			        if (bar.x <= 271.5 && bar.x + (global.tempo * proportion_bpm_to_speed) > 271.5) {
			            var sound_id = audio_play_sound(metronome_high, 1, 0);
			        }

			        // Detectar los beats bajos (Low) usando offsets
			        else if (bar.x + 132 <= 271.5 && bar.x + 132 + (global.tempo * proportion_bpm_to_speed) > 271.5) {
			            var sound_id = audio_play_sound(metronome_low, 1, 0);
			        }
			        else if (bar.x + 264 <= 271.5 && bar.x + 264 + (global.tempo * proportion_bpm_to_speed) > 271.5) {
			            var sound_id = audio_play_sound(metronome_low, 1, 0);
			        }
			        else if (bar.x + 396 <= 271.5 && bar.x + 396 + (global.tempo * proportion_bpm_to_speed) > 271.5) {
			            var sound_id = audio_play_sound(metronome_low, 1, 0);
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
				conteo_desplazamiento += 1;
			}
		
			global.base_x = -game_bar[index_bar].x + sprite_width * conteo_desplazamiento + global.sound_delay*10;
		}
    } else {
		if (!global.practice_mode) {
			// AL PAUSAR vuelve todo a 0
	        index_bar = 0;
	        conteo_desplazamiento = 0;

	        global.tempo = global.charts[$ global.current_difficulty].tempo[global.current_chart_index];
	        global.start_point = global.charts[$ global.current_difficulty].start_point[global.current_chart_index];
			global.base_x = global.start_point - global.sound_delay*10;

	        // Configura las posiciones iniciales
	        game_bar[0].x = global.start_point;
	        for (var i = 1; i < 4; i++) {
	            game_bar[i].x = game_bar[i - 1].x + sprite_width;
	        }
			started = 1;
		} else {
			// MODO MANUAL PARA MODO PRACTICA EN PAUSA
			
			// Busca cual es el current element index para el proximo hit
			for (var j = 0; j < array_length(obj_sync.elements); j++) {
				var ele = obj_sync.elements[j];
				if ((ele.pos_x - global.base_x) > 274) {
					if (j - 1 < 0) {
						obj_sync.current_element_index = 0;
					} else {
						obj_sync.current_element_index = j;
					}
					obj_sync.local_count_silver = 0;
					obj_sync.local_count_gold = 0;
					obj_sync.local_total_hits = 0;
					obj_sync.combo_count = 0;
					break;
				}
			}
			
			if (mouse_check_button(mb_middle) && !global.is_gamepad && !has_changed) {
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
			if (mouse_wheel_up() && !global.is_gamepad) {
			    game_bar[index_bar].x += 1;
				for (var i = 1; i < 4; i++) {
			        var next_index = (index_bar + i) mod 4;
			        var prev_index = (index_bar + i - 1) mod 4;
			        game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
			    }
			}

			if (mouse_wheel_down() && !global.is_gamepad) {
			    game_bar[index_bar].x -= 1;
				for (var i = 1; i < 4; i++) {
				    var next_index = (index_bar + i) mod 4;
				    var prev_index = (index_bar + i - 1) mod 4;
				    game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
				}
			}
			
			if (mouse_check_button_released(mb_middle) && !global.is_gamepad) {
			    mouse_pressed = 0;
			    has_changed = 0;
			    xprev = game_bar[index_bar].x;
			}
			
			if (global.is_gamepad) {
			    var axis_value = gamepad_axis_value(global.current_gamepad, gp_axisrh);

			    if (axis_value > 0.5 || axis_value < -0.5) {
			        var dif = axis_value * 12; // Diferencia de movimiento basado en el eje del gamepad
			        game_bar[index_bar].x += dif;

			        show_debug_message("GAMEPAD MOVE  | x:  " + string(game_bar[index_bar].x) + " | Index: " + string(index_bar) + " | Dif: " + string(dif));

			        // Recalcular posiciones de las barras
			        for (var i = 1; i < 4; i++) {
			            var next_index = (index_bar + i) mod 4;
			            var prev_index = (index_bar + i - 1) mod 4;
			            game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
			        }

			        // Manejo de salida por la izquierda
			        if (dif < 0 && game_bar[index_bar].x + sprite_width < 0) {
			            game_bar[index_bar].x = game_bar[(index_bar + 3) mod 4].x + sprite_width;
			            index_bar = (index_bar + 1) mod 4;
			            conteo_desplazamiento += 1;
			            show_debug_message("LEFT OUT  | x:  " + string(game_bar[index_bar].x) + " | Index: " + string(index_bar) + " | Conteo: " + string(conteo_desplazamiento));
			            has_changed = 1;
			        }

			        // Manejo de salida por la derecha
			        if (dif > 0 && game_bar[index_bar].x > 0 && conteo_desplazamiento > 0) {
			            game_bar[(index_bar - 1 + 4) mod 4].x = game_bar[index_bar].x - sprite_width;
			            index_bar = (index_bar - 1 + 4) mod 4;
			            conteo_desplazamiento -= 1;
			            show_debug_message("RIGHT OUT  | x:  " + string(game_bar[index_bar].x) + " | Index: " + string(index_bar) + " | Conteo: " + string(conteo_desplazamiento));
			            has_changed = 1;
			        }
			    }
			}
			
			global.base_x = -game_bar[index_bar].x + sprite_width * conteo_desplazamiento + global.sound_delay*10;
		}
    }
	
	// En modo practica, al presionar C hace un checkpoint
	if (global.practice_mode && ((keyboard_check_pressed(ord("C")) && !global.is_gamepad)|| (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_stickr)))) {
	    if (checkpoint_start != -1) {
			// Se quita
			checkpoint_start = -1;
			checkpoint_text_x = -1;
			checkpoint_base_x = 0;
					
			index_bar_checkpoint = 0;
			conteo_d_checkpoint = 0;
			count_silver_checkpoint = 0;
			count_gold_checkpoint = 0;
			total_hits_checkpoint = 0;
			cei_1_checkpoint = 0;
		} else {
			// Se agrega
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
					
			count_silver_checkpoint = obj_sync.local_count_silver;
			count_gold_checkpoint = obj_sync.local_count_gold;
			total_hits_checkpoint = obj_sync.local_total_hits;
			cei_1_checkpoint = obj_sync.current_element_index;
		}
	}
	
	// Si pausa en modo practica, con checkpoint, vuelve a donde estaba el checkpoint
	if (((keyboard_check_pressed(vk_space) && !global.is_gamepad) || global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_start)) && global.practice_mode && checkpoint_start != -1) {
        if (checkpoint_start != -1) {
            global.base_x = checkpoint_base_x;
            conteo_desplazamiento = conteo_d_checkpoint;

            if (checkpoint_base_x > 0) game_bar[0].x = checkpoint_start - sprite_width;
			else game_bar[0].x = checkpoint_start;
			index_bar = 0;
			
			for (var i = 1; i < 4; i++) {
	            var next_index = (index_bar + i) mod 4;
	            var prev_index = (index_bar + i - 1) mod 4;
	            game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
	        }
		
	        xprev = checkpoint_start;
	        conteo_desplazamiento = conteo_d_checkpoint;
	        obj_sync.local_count_silver = count_silver_checkpoint;
	        obj_sync.local_count_gold = count_gold_checkpoint;
	        obj_sync.local_total_hits = total_hits_checkpoint;
	        obj_sync.current_element_index = cei_1_checkpoint;
			mouse_pressed = false;
			audio_stop_sound(obj_play.sound_playing);
            show_debug_message("Checkpoint restaurado en posición: " + string(global.base_x));
        }
    }
	
	// T para el tempo
	if ((keyboard_check_pressed(ord("T")) && !global.is_gamepad) || (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_stickl))) metronome_sfx = !metronome_sfx;
	
} else if (id == game_bar[0] && !global.is_playing) {
	// Cuando quita is playing
    var i = 0;
    with (obj_game) {
        x = room_width + (sprite_width * i);
        i += 1;
    }
	started = 0;
}