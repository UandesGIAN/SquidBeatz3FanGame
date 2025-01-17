if (global.new_song_id == undefined && global.new_song_name == "") {
	elements = global.charts[$ global.current_difficulty].charts[global.current_chart_index];
	array_sort(elements, function(a, b) { return a.pos_x - b.pos_x; });
	if (global.is_playing == 1 && ((obj_play.play_music && !global.practice_mode || global.practice_mode))) {
		player_input = ["A", "S", "D", "F", "H", "J", "K", "L"];
		if (global.is_gamepad) player_input = [gp_shoulderlb, gp_shoulderrb, gp_shoulderl, gp_shoulderr, gp_face1, gp_face2, gp_face3, gp_face4, gp_padu, gp_padd, gp_padl, gp_padr];

		if (current_life <= 0 && game_over_timer == -1 && global.lifebar) {
			var sound_id = audio_play_sound(game_over_sfx, 1, 0);
			audio_sound_gain(global.current_song, 0, 800);
			audio_sound_gain(sound_id, 1, 0);
			game_over_message = 1;
			game_over_timer = current_time;
		} else if ((current_life > 0 && global.lifebar) || !global.lifebar) {
			if (array_length(elements) > 0 && current_element_index < array_length(elements)) {
			    var element = elements[current_element_index];
			    var sprite = type_spr[element.index_type];
			    var sprite_x_start = element.pos_x - global.base_x + 28 + (element.index_type == 1 || element.index_type == 3 ? 10: 0) + (element.index_type > 3 ? 7 : 0) + (element.index_type == 6 ? 8 : 0) - (element.index_type == 7 ? 5 : 0);
			    var sprite_x_end = sprite_x_start + sprite_get_width(sprite) + (element.index_type > 3 ? 10 : 0);
				
				// Inicializar variables para el estado de reproducción
				var abxy_pressed = false;
				var lr_pressed = false;
				var lr2_pressed = false;

				if (auto_bot_enabled) {
					var pressed_return = auto_bot_action(element, sprite_x_start, sprite_x_end);
					abxy_pressed = pressed_return[0];
					lr_pressed = pressed_return[1];
					lr2_pressed = pressed_return[2];
				}
				
				// Registrar inputs en el buffer y manejar sonidos
				for (var j = 0; j < array_length(player_input); j++) {
				    var is_pressed = false;

				    if (global.is_gamepad) {
				        is_pressed = gamepad_button_check_pressed(global.current_gamepad, player_input[j]);
				    } else {
				        is_pressed = keyboard_check_pressed(ord(player_input[j]));
				    }

				    if (is_pressed) {
				        // Determinar el tipo de input
				        var input_type = (j < 2 || (j >= 2 && j < 4)) ? "lr" : "abxy";
				        array_push(input_buffer, {type: input_type, time: current_time});

				        // Marcar que se ha detectado un input del tipo correspondiente
				        if (input_type == "abxy") {
				            abxy_pressed = true;
				        } else if (input_type == "lr" && j < 2) {
				            lr2_pressed = true;
				        } else if (input_type == "lr" && j < 4) {
							lr_pressed = true;
						}
				    }
				}

				// Reproducción de sonidos después del bucle
				if (abxy_pressed && (current_time - sound_delay_abxy > 60)) {
				    var sound_id = audio_play_sound(global.sound_effects[global.current_sfx_index][0], 1, 0);
				    sound_delay_abxy = current_time;
				}

				if (lr_pressed && (current_time - sound_delay_lr > 60)) {
				    var sound_id = audio_play_sound(global.sound_effects[global.current_sfx_index][2], 1, 0);
					sound_delay_lr = current_time;
				}
				
				if (lr2_pressed && (current_time - sound_delay_lr2 > 60)) {
				    // Determinar qué sonido de LR se debe reproducir
				    var sound_id = audio_play_sound(global.sound_effects[global.current_sfx_index][1], 1, 0);
					sound_delay_lr2 = current_time;
				}
				
			    // Limpiar inputs viejos del buffer
				var filtred_buffer = array_filter(input_buffer, function (input) {
				    return current_time - input.time <= 100;
				});

				// Variables para conteo y detección
				var count_lr = 0, count_abxy = 0;
				var double_lr = false, double_abxy = false;

				// Procesar inputs del buffer
				var lr_times = [];
				var abxy_times = [];
				for (var i = 0; i < array_length(filtred_buffer); i++) {
				    var input = filtred_buffer[i];
				    if (input.type == "lr") {
				        count_lr++;
				        array_push(lr_times, input.time);
				    } else if (input.type == "abxy") {
				        count_abxy++;
				        array_push(abxy_times, input.time);
				    }
				}

				// Detectar dobles verificando proximidad temporal
				double_lr = array_length(lr_times) >= 2 && abs(lr_times[array_length(lr_times) - 1] - lr_times[array_length(lr_times) - 2]) <= 50;
				double_abxy = array_length(abxy_times) >= 2 && abs(abxy_times[array_length(abxy_times) - 1] - abxy_times[array_length(abxy_times) - 2]) <= 50;

				// Determinar tipo de sincronización
				 var input_sync_type = -1;
			    if (element.index_type == 0 && double_lr) {
			        input_sync_type = 0; // Tipo 0: Solo dobles LR
			    } else if (element.index_type == 2 && double_abxy) {
			        input_sync_type = 2; // Tipo 2: Solo dobles ABXY
			    } else if (element.index_type == 4 && (double_lr || count_lr > 0) && (double_abxy || count_abxy > 0)) {
			        input_sync_type = 4; // Tipo 4: Dobles LR y ABXY
			    } else if (element.index_type == 5 && count_lr > 0 && double_abxy) {
			        input_sync_type = 5; // Tipo 5: Dobles LR o ABXY (o ambos)
			    } else if (element.index_type == 6 && double_lr && count_abxy > 0) {
			        input_sync_type = 6; // Tipo 6: Dobles LR o ABXY (o ambos)
			    } else if (double_lr && double_abxy) {
			        input_sync_type = 7; // Doble LR + Doble ABXY (general)
			    } else if (double_lr) {
			        input_sync_type = 1; // Doble LR
			    } else if (double_abxy) {
			        input_sync_type = 3; // Doble ABXY
			    } else if (count_lr > 0 && count_abxy > 0) {
			        input_sync_type = 4; // 1 LR + 1 ABXY
			    } else if (count_lr > 0 && count_abxy == 0) {
			        input_sync_type = 0; // 1 LR
			    } else if (count_abxy > 0 && count_lr == 0) {
			        input_sync_type = 2; // 1 ABXY
			    }
		
			    // Verificar si el input sync type coincide con el tipo del elemento y si está dentro del rango
			    if (sprite_x_start <= x + sprite_width + 20 && sprite_x_end >= x) {
			        show_debug_message("x_og: " + string(element.pos_x) + " | real type: " + string(element.index_type) + " | hit type: " + string(input_sync_type) + " | inicio: " + string(sprite_x_start) + " | fin: " + string(sprite_x_end) + " | index: " + string(current_element_index));

			        // Si el tipo de entrada coincide con el tipo del elemento, se considera un hit
			        if (input_sync_type != -1) {
						var error = abs(sprite_x_start - 272) / (sprite_width);
						if (sprite_x_start < x) error = abs(sprite_x_end - 272) / (sprite_width);
						show_debug_message("error" + string(error) + " start: " + string(sprite_x_start));	
				
						if ((error <= 0.65 && error > 0.2) || error > 0.94 && input_sync_type == element.index_type) {
							show_debug_message("GOOD");
							local_count_silver++;
							type_of_hit = 2;
					
							if (element.index_type == 0 || element.index_type == 1) missed_or_pressed_type = 0;
							else if (element.index_type == 2 || element.index_type == 3) missed_or_pressed_type = 1;
							else missed_or_pressed_type = 2; 
							array_push(already_hit, element);
							array_push(pos_y_hit, 0);
							array_push(pos_x_hit, element.pos_x - global.base_x - ((element.index_type mod 2) * 10 + 20));
							array_push(alpha_hit, 1);
					
							combo_count++;
							if (!global.practice_mode || !global.lifebar) {
								if (element.index_type == 0 || element.index_type == 2) current_life += 2;
								else if (element.index_type > 4) current_life += 7;
								else current_life += 5;
								if (current_life >= 100) current_life = 100;
							}
						} else if (error > 0.65 && error <= 0.94 && input_sync_type == element.index_type) {
							show_debug_message("FRESH");
							local_count_gold++;
							type_of_hit = 3;
					
							if (element.index_type == 0 || element.index_type == 1) missed_or_pressed_type = 0;
							else if (element.index_type == 2 || element.index_type == 3) missed_or_pressed_type = 1;
							else missed_or_pressed_type = 2; 
							array_push(already_hit, element);
							array_push(pos_y_hit, 0);
							array_push(pos_x_hit, element.pos_x - global.base_x - ((element.index_type mod 2) * 10 + 20));
							array_push(alpha_hit, 1);
					
							combo_count++;
							
							if (!global.practice_mode || !global.lifebar) {
								if (element.index_type == 0 || element.index_type == 2) current_life += 5;
								else if (element.index_type > 4) current_life += 15;
								else current_life += 10;
								if (current_life >= 100) current_life = 100;
							}
						} else if (error <= 0.2 || input_sync_type != element.index_type) {
							show_debug_message("BAD");
							type_of_hit = 1;
							if (element.index_type == 0 || element.index_type == 1) {
						        if (count_lr == 0) {
						            missed_or_pressed_type = 0; // Se esperaba L/R pero no se presionó
						        } else if (element.index_type == 0 && double_lr > 0) {
						            missed_or_pressed_type = 0; // Se esperaba solo un L/R, pero hubo más de uno
						        } else if (element.index_type == 1 && double_lr == 0 && count_lr > 0) {
						            missed_or_pressed_type = 0; // Se esperaban ambos L/R, pero solo hubo uno
						        }
						    } else if (element.index_type == 2 || element.index_type == 3) {
						        if (count_abxy == 0) {
						            missed_or_pressed_type = 1; // Se esperaba ABXY pero no se presionó
						        } else if (element.index_type == 2 && double_abxy > 0) {
						            missed_or_pressed_type = 1; // Se esperaba solo un ABXY, pero hubo más de uno
						        } else if (element.index_type == 3 && double_abxy == 0 && count_abxy > 0) {
						            missed_or_pressed_type = 1; // Se esperaban ambos ABXY, pero solo hubo uno
						        }
						    } else if (element.index_type >= 4 && element.index_type <= 7) {
						        // Casos donde se combinan L/R y ABXY
						        if (element.index_type == 4 && ( (count_lr == 0 && count_abxy > 0) || (count_lr > 0 && count_abxy = 0) || (count_lr == 0 && count_abxy == 0) )) {
						            missed_or_pressed_type = 2; // Se esperaba L/R y ABXY, pero faltó o sobró
						        } else if (element.index_type == 5 && ( (double_lr > 0 && double_abxy > 0) || (double_abxy == 0))) {
						            missed_or_pressed_type = 2; // Se esperaba L/R y ambos ABXY, pero faltó o sobró
						        } else if (element.index_type == 6 && ( (double_lr > 0 && double_abxy > 0) || (double_lr == 0))) {
						            missed_or_pressed_type = 2; // Se esperaba ambos L/R y ABXY, pero faltó o sobró
						        } else if (element.index_type == 7 && ( (double_lr == 0 && double_abxy > 0) || (double_lr > 0 && double_abxy == 0) || (double_lr == 0 && double_abxy == 0) )) {
						            missed_or_pressed_type = 2; // Se esperaba ambos L/R y ambos ABXY, pero faltó o sobró
						        }
						    }
							combo_count = 0;
							pos_y_hit = [];
							pos_x_hit = [];
							alpha_hit = [];
							if (!global.practice_mode || !global.lifebar) {
								if (element.index_type == 0 || element.index_type == 2) current_life -= 25;
								else if (element.index_type > 4) current_life -= 30;
								else current_life -= 20;
								if (current_life <= 0) current_life = 0;
							}
						}
						local_total_hits = local_count_silver + local_count_gold;
						if ((!global.practice_mode && !auto_bot_enabled) && global.game_points[$ global.current_difficulty].total_hits[global.current_chart_index] <= local_total_hits) {
							if (local_count_silver >= global.game_points[$ global.current_difficulty].count_silver[global.current_chart_index]) global.game_points[$ global.current_difficulty].count_silver[global.current_chart_index] = local_count_silver;
							if (local_count_gold >= global.game_points[$ global.current_difficulty].count_gold[global.current_chart_index]) global.game_points[$ global.current_difficulty].count_gold[global.current_chart_index] = local_count_gold;
							global.game_points[$ global.current_difficulty].total_hits[global.current_chart_index] = local_total_hits;
						}
						current_element_index++;
						text_timer = current_time;
						animation_timer = current_time;
						animation_frame = 0;
						input_buffer = [];
						hit_timer = current_time;
					}
				} else {
					if (((current_time - start_delay) > 100 && (sprite_x_end < x) || (count_lr > 0 && count_abxy > 0 && input_sync_type == -1)) && obj_play.play_music) {
						current_element_index++;
						show_debug_message("MISS");
						type_of_hit = 0;
						combo_count = 0;
						hit_timer = current_time;
						input_buffer = [];
						pos_y_hit = [];
						pos_x_hit = [];
						alpha_hit = [];
						text_timer = current_time;
						if (!global.practice_mode || !global.lifebar) {
							current_life -= 20;
							if (current_life <= 0) current_life = 0;
						}
					}
				}
				input_sync_type = -1;
			}
	
			if (song_end_delay == -1 && (obj_game2.total_notes == local_total_hits || (global.lifebar && !global.wins_lifebar[$ global.current_difficulty][global.current_chart_index])) && current_element_index == array_length(elements) && (!global.practice_mode && !auto_bot_enabled)) {
				if ((array_length(elements) - global.game_points[$ global.current_difficulty].count_gold[global.current_chart_index]) == 0) {
			        if (last_win_category != "gold") {
			            game_win = 1;
			            game_win_for_first_time = 1;
			        }
			        last_win_category = "gold"; // Actualizar la categoría ganada
			    }
			    // Verificar si ganó en la categoría Bronze
			    else if ((array_length(elements) - global.game_points[$ global.current_difficulty].count_silver[global.current_chart_index]) == 0 || (global.lifebar && !global.wins_lifebar[$ global.current_difficulty][global.current_chart_index])) {
					if (last_win_category != "bronze") {
			            game_win = 1;
			            game_win_for_first_time = 1;
			        }
			        last_win_category = "bronze"; // Actualizar la categoría ganada
					if (global.lifebar && current_element_index == array_length(elements)) {
						global.wins_lifebar[$ global.current_difficulty][global.current_chart_index] = 1;
					}
			    }
			    // Verificar si ganó en la categoría Silver
			    else if ((array_length(elements) - (global.game_points[$ global.current_difficulty].count_gold[global.current_chart_index] + global.game_points[$ global.current_difficulty].count_silver[global.current_chart_index])) == 0) {
			        if (last_win_category != "silver") {
			            game_win = 1;
			            game_win_for_first_time = 1;
			        }
			        last_win_category = "silver"; // Actualizar la categoría ganada
			    }
				obj_play.animation_start_time = current_time;
				obj_handle_savedata.save_ini_data();
			}
			
			if (current_element_index == array_length(elements) && song_end_delay == -1) song_end_delay = current_time;
		}
	} else {
		if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check(ord("B")) && keyboard_check_pressed(ord("N"))) {
		    auto_bot_enabled = !auto_bot_enabled;
		    show_message("Auto bot: " + (auto_bot_enabled ? "ENABLED" : "DISSABLED"));
		}
		if (!global.practice_mode) {
			local_count_silver = 0;
			local_count_gold = 0;
			local_total_hits = 0;
		}
		current_element_index = 0;
		song_end_delay = -1;
		start_delay = current_time;
		type_of_hit = -1;
		combo_count = 0;
		missed_or_pressed_type = -1;
		game_win_for_first_time = 0;
		already_hit = [];
		input_buffer = [];
		elements = [];
		for (var i = 0; i < array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]); i++) {
			var element = global.charts[$ global.current_difficulty].charts[global.current_chart_index][i];
			array_push(elements, element);
		}
		array_sort(elements, function(a, b) { return a.pos_x - b.pos_x; });
		pos_y_hit = [];
		pos_x_hit = [];
		alpha_hit = [];

		if (global.current_song != undefined) audio_sound_gain(global.current_song, obj_play.volume_count, 0);
		current_life = 100;
		game_over_message = 0;
		y_gameover = 0;
		x_gameover = 0;
		rot_gameover = 0;
		game_over_timer = -1;
		if (audio_is_playing(game_over_sfx)) audio_stop_sound(game_over_sfx);
	}
}