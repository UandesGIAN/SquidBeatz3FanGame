/// @description Controles para hacer charts

var elements = global.current_chart;
if (!message_shown) {
	
	// AGREGAR ELEMENTO
	if (mouse_check_button_pressed(mb_left) && (mouse_x + global.base_x > 0 && mouse_y > 512) && !obj_exit_chart.message_shown) {
		if (editing_element == -1 && array_length(editing_elements) == 0) {
			if (selected_type == 0 || selected_type == 4 || selected_type == 5) audio_play_sound(global.sound_effects[global.current_sfx_index][1], 1, 0);
			if (selected_type == 1 || selected_type == 6 || selected_type == 7) audio_play_sound(global.sound_effects[global.current_sfx_index][2], 1, 0);
			if (selected_type >= 2) audio_play_sound(global.sound_effects[global.current_sfx_index][0], 1, 0);
	
			add_charteo_element(selected_type, (mouse_x + global.base_x) div 1);
			editing_element = array_length(elements) - 1;
			editing_elements = [];
			selected_element = 0;
			prev_type_backup = -1;
			prev_pos_x_backup = -1;
		} else {
			if (array_length(elements) > 0 && editing_element != -1  && array_length(editing_elements) == 0) {
				if (abs(elements[editing_element].pos_x div 1 - (mouse_x + global.base_x) div 1) > 20) {
					if (selected_type == 0 || selected_type == 4 || selected_type == 5) audio_play_sound(global.sound_effects[global.current_sfx_index][1], 1, 0);
					if (selected_type == 1 || selected_type == 6 || selected_type == 7) audio_play_sound(global.sound_effects[global.current_sfx_index][2], 1, 0);
					if (selected_type >= 2) audio_play_sound(global.sound_effects[global.current_sfx_index][0], 1, 0);
	
					add_charteo_element(selected_type, (mouse_x + global.base_x) div 1);
					editing_element = array_length(elements) - 1;
					editing_elements = [];
					selected_element = 0;
					prev_type_backup = -1;
					prev_pos_x_backup = -1;
				}
			} else if (array_length(elements) > 0 && array_length(editing_elements) > 0) {
				var found_element = -1;
				for (var j = 0; j < array_length(editing_elements); j++) {
					var edit_element = editing_elements[j];
					if (abs(elements[edit_element].pos_x div 1 - (mouse_x + global.base_x) div 1) <= 20) {
						found_element = edit_element;
						break;
					}
				}
				if (found_element == -1) {
					if (selected_type == 0 || selected_type == 4 || selected_type == 5) audio_play_sound(global.sound_effects[global.current_sfx_index][1], 1, 0);
					if (selected_type == 1 || selected_type == 6 || selected_type == 7) audio_play_sound(global.sound_effects[global.current_sfx_index][2], 1, 0);
					if (selected_type >= 2) audio_play_sound(global.sound_effects[global.current_sfx_index][0], 1, 0);
					
					add_charteo_element(selected_type, (mouse_x + global.base_x) div 1);
					editing_element = array_length(elements) - 1;
					editing_elements = [];
					selected_element = 0;
					prev_type_backup = -1;
					prev_pos_x_backup = -1;
				}
			}
		}
	}


	// CONTROLES AL EDITAR UN ELEMENTO
	if (editing_element != -1 && array_length(elements) > 0 && array_length(editing_elements) == 0) {
	    var element = elements[editing_element];
		var pos_edited = 0;
	
		// Mueve el elemento con las flechas
		if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
			element.pos_x -= 1;
			if (element.pos_x < 0) element.pos_x = 0;
			current_key_timer = current_time;
			pos_edited = 1;
		}
		if ((keyboard_check(vk_left) || keyboard_check(ord("A"))) && (current_time - current_key_timer) > 500) {
			element.pos_x -= 1;
			if (element.pos_x < 0) element.pos_x = 0;
			pos_edited = 1;
		}

		if (keyboard_check_pressed(vk_right) || (keyboard_check_pressed(ord("D")) && !keyboard_check(vk_control))) {
			element.pos_x += 1;
			current_key_timer = current_time;
			pos_edited = 1;
		}
		if ((keyboard_check(vk_right) || (keyboard_check(ord("D")) && !keyboard_check(vk_control))) && (current_time - current_key_timer) > 500) {
			element.pos_x += 1;
			pos_edited = 1;
		}
	
		// Comprobar si hay conflictos en pos_x
		if (pos_edited == 1) {
			var conflict_found = true;
	        while (conflict_found) {
	            conflict_found = false;

	            for (var i = 0; i < array_length(elements); i++) {
	                if (i == editing_element) continue; // Saltar el elemento que estamos editando
					
	                var other_element = elements[i];
	                if (other_element.pos_x div 1 == element.pos_x div 1) {
	                    conflict_found = true;
	                    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
	                        element.pos_x -= 1; // Mover hacia la izquierda
	                    } else if (keyboard_check(vk_right) || (keyboard_check(ord("D")) && !keyboard_check(vk_control))) {
	                        element.pos_x += 1; // Mover hacia la derecha
	                    }
						break;
	                }
	            }
				
				if ((keyboard_check(vk_left) || keyboard_check(ord("A"))) && element.pos_x < 0) {
				    // Encuentra la primera posición disponible a la derecha
				    element.pos_x = 0;
				    while (true) {
				        var position_occupied = false;
				        for (var i = 0; i < array_length(elements); i++) {
							if (i == editing_element) continue;
				            if (elements[i].pos_x == element.pos_x) {
				                position_occupied = true;
				                break;
				            }
				        }
				        if (!position_occupied) break; // Salir si se encuentra una posición disponible
				        element.pos_x += 1;
				    }
				}
	        }
			
			// Actualizar las listas de max/min
			sort_elements_max_min_1 = [];
			sort_elements_max_min_2 = [];

			if (array_length(elements) > 0) {
			    for (var i = 0; i < array_length(elements); i++) {
			        var local_element = elements[i];
			        if (local_element.index_type != 2 && local_element.index_type != 3) {
			            array_push(sort_elements_max_min_1, local_element);
			        }
					if (local_element.index_type != 0 && local_element.index_type != 1) {
			            array_push(sort_elements_max_min_2, local_element);
			        }
			    }

			    // Ordenar las listas por pos_x de mayor a menor
			    array_sort(sort_elements_max_min_1, function(a, b) { return b.pos_x - a.pos_x; });
			    array_sort(sort_elements_max_min_2, function(a, b) { return b.pos_x - a.pos_x; });
			}
		}
	
		// Eliminar elemento si supr
		if (keyboard_check_pressed(vk_delete) || (keyboard_check(vk_control) && keyboard_check_pressed(ord("D")))) {
			prev_type_backup = element.index_type;
			prev_pos_x_backup = element.pos_x;
		    remove_charteo_element({"index_type":  element.index_type, "pos_x": element.pos_x});
			editing_element = -1;
			editing_elements = [];
		}
		
		if (keyboard_check_pressed(vk_escape)) editing_element = -1;
	}


	// SELECCIONAR UN ELEMENTO
	if (mouse_check_button_pressed(mb_right) && !keyboard_check(vk_control) && !keyboard_check(vk_shift) && editing_element == -1 && array_length(elements) > 0 && array_length(editing_elements) == 0) {
	    // Busca un elemento cercano al mouse_x para editar
	    for (var i = 0; i < array_length(elements); i++) {
	        var element = elements[i];
	        if (abs(element.pos_x - global.base_x - mouse_x) <= 10) {
	            if (mouse_y > 577) {
	                if (element.index_type >= 2) {
	                    editing_element = i;
	                    selected_element = element.index_type;
	                    break;
	                }
	            } else {
	                if (element.index_type < 2 || element.index_type > 3) {
	                    editing_element = i;
	                    selected_element = element.index_type;
	                    break;
	                }
	            }
	        }
	    } 
	
		if (editing_element != -1) show_debug_message("SELECTED: " + string(editing_element) + "| x: " + string(elements[editing_element].pos_x));
	} else if (editing_element != -1 && ((mouse_check_button_pressed(mb_left) && (mouse_y < 512 || mouse_x + global.base_x <= 0)) || (mouse_check_button_pressed(mb_right) && !keyboard_check(vk_control) && !keyboard_check(vk_shift)) || keyboard_check_pressed(vk_enter))) {
	    editing_element = -1; 
	} else if (editing_element != -1 && mouse_check_button(mb_left) && mouse_y > 512 && mouse_y < 642) {
	    var element = elements[editing_element];

	    // Verificar si el mouse está sobre el elemento en el eje X
	    if (abs(element.pos_x div 1 - (mouse_x + global.base_x) div 1) <= 20) {
	        // Evitar crash al mover repetidamente en la misma posición
	        if (!click_to_move) {
	            click_to_move = 1;
	        }
	    }

	    if (click_to_move) {
	        // Actualizar la posición del elemento para que siga el cursor
			var prev_pos_x = element.pos_x;
	        element.pos_x = global.base_x + mouse_x;

	        // Asegurar que no salga de los límites del espacio permitido
	        if (element.pos_x < 0) element.pos_x = 0;
			
			var conflict_found = true;
			// Comprobar si hay conflictos en pos_x
		    while (conflict_found) {
	           conflict_found = false;

	            for (var i = 0; i < array_length(elements); i++) {
	                if (i == editing_element) continue; // Saltar el elemento que estamos editando

	                var other_element = elements[i];
	                if (other_element.pos_x div 1 == element.pos_x div 1) {
	                    conflict_found = true;
	                    if (element.pos_x < prev_pos_x) {
	                        element.pos_x -= 1; // Mover hacia la izquierda
	                    } else if (element.pos_x > prev_pos_x) {
	                        element.pos_x += 1; // Mover hacia la derecha
	                    }
	                    break; // Salir del bucle para reiniciar la búsqueda
	                }
	            }
				
				if (element.pos_x < prev_pos_x && element.pos_x < 0) {
				    // Encuentra la primera posición disponible a la derecha
				    element.pos_x = 0;
				    while (true) {
				        var position_occupied = false;
				        for (var i = 0; i < array_length(elements); i++) {
							if (i == editing_element) continue;
				            if (elements[i].pos_x == element.pos_x) {
				                position_occupied = true;
				                break;
				            }
				        }
				        if (!position_occupied) break; // Salir si se encuentra una posición disponible
				        element.pos_x += 1;
				    }
				}
	        }
		
	        // Evitar conflictos en las listas y actualizarlas solo si es necesario
	        sort_elements_max_min_1 = [];
	        sort_elements_max_min_2 = [];

	        if (array_length(elements) > 0) {
	            for (var i = 0; i < array_length(elements); i++) {
	                var local_element = elements[i];
	                if (local_element.index_type != 2 && local_element.index_type != 3) {
	                    array_push(sort_elements_max_min_1, local_element);
	                }
					if (local_element.index_type != 0 && local_element.index_type != 1) {
	                    array_push(sort_elements_max_min_2, local_element);
	                }
	            }

	            // Ordenar las listas por pos_x de mayor a menor
	            array_sort(sort_elements_max_min_1, function(a, b) { return b.pos_x - a.pos_x; });
	            array_sort(sort_elements_max_min_2, function(a, b) { return b.pos_x - a.pos_x; });
	        }
	    }
	} else if (click_to_move && mouse_check_button_released(mb_left) && array_length(editing_elements) == 0) {
	    click_to_move = 0;
	}

	
	// SELECCIONAR VARIOS ELEMENTOS A LA VEZ
	if (keyboard_check(vk_control) && mouse_check_button_pressed(mb_right) && array_length(elements) > 0) {
		 if (editing_element != -1) {
			 array_push(editing_elements, editing_element);
			 editing_element = -1;
		 }
		 
		 for (var i = 0; i < array_length(elements); i++) {
	        var element = elements[i];
	        if (abs(element.pos_x - global.base_x - mouse_x) <= 10) {
	            if (mouse_y > 577) {
	                if (element.index_type >= 2) {
	                    array_push(editing_elements, i);
	                    selected_element = element.index_type;
						show_debug_message("SELECTED: " + string(i) + "| x: " + string(elements[i].pos_x));
	                    break;
	                }
	            } else {
	                if (element.index_type < 2 || element.index_type > 3) {
	                    array_push(editing_elements, i);
	                    selected_element = element.index_type;
						show_debug_message("SELECTED: " + string(i) + "| x: " + string(elements[i].pos_x));
	                    break;
	                }
	            }
	        }
	    } 
	} else if (editing_element != -1 && array_length(editing_elements) == 0 && keyboard_check(vk_shift) && mouse_check_button_pressed(mb_right) && array_length(elements) > 0) {
		editing_elements = [];
		array_push(editing_elements, editing_element);
		editing_element = -1;
		
		// Crear una copia ordenada por posición x
	    var sorted_indices = [];
	    for (var i = 0; i < array_length(elements); i++) {
	        array_push(sorted_indices, i);
	    }

	    // Ordenar el arreglo `sorted_indices` basado en `pos_x` de los elementos
	    array_sort(sorted_indices, function(a, b) { return global.current_chart[a].pos_x - global.current_chart[b].pos_x; });

	    // Determinar el elemento clickeado basado en mouse_x y mouse_y
	    var clicked_index = -1;
	    for (var i = 0; i < array_length(elements); i++) {
	        var idx = sorted_indices[i];
	        var element = elements[idx];
	        if (abs(element.pos_x - global.base_x - mouse_x) <= 20 && mouse_y > 500) {
	            clicked_index = idx;
	            break;
	        }
	    }

	    // Si no se encontró un clic válido, salir
	    if (clicked_index != -1) {
			var first_index = -1;
			var last_index = -1;
	        for (var i = 0; i < array_length(sorted_indices); i++) {
	            var elem = sorted_indices[i];
				show_debug_message("i_og: " + string(elem) + "; i_sorted: " + string(i));
	            if (elem == editing_elements[0]) first_index = i;
				if (elem == clicked_index) last_index = i;
				if (first_index != -1 && last_index != -1) break;
	        }
	        
	        show_debug_message("prev: " + string(editing_elements[0]) + "   " + string(clicked_index));
	        show_debug_message("first: " + string(first_index) + "  last: " + string(last_index));
        
	        if (first_index > last_index) {
	            var temp = first_index;
	            first_index = last_index;
	            last_index = temp;
	        }

	        // Agregar elementos seleccionados al rango
	        for (var i = first_index; i <= last_index; i++) {
	            var idx = sorted_indices[i];
	            if (!array_contains(editing_elements, idx)) {
	                array_push(editing_elements, idx);
	            }
	        }
		}
	} else if (array_length(editing_elements) > 0 && ((mouse_check_button_pressed(mb_left) && (mouse_y < 512 || mouse_x + global.base_x <= 0)) || (mouse_check_button_pressed(mb_right) && !keyboard_check(vk_control) && !keyboard_check(vk_shift)) || keyboard_check_pressed(vk_enter))) {
		editing_elements = []; 
	} else if (mouse_check_button(mb_left) && mouse_y > 512 && mouse_y < 642 && array_length(editing_elements) > 0) {
	    
		// Inicializar la posición del mouse y los offsets al comenzar el movimiento
		if (!click_to_move) {
	        click_to_move = true;
	        for (var i = 0; i < array_length(editing_elements); i++) {
	            var index = editing_elements[i];
	            var element = elements[index];
	            array_push(offsets, element.pos_x - mouse_x);
	        }
	    }
		
		if (click_to_move) {
		    // Actualizar la posición de cada elemento seleccionado
		    for (var i = 0; i < array_length(editing_elements); i++) {
		        var index = editing_elements[i];
		        var element = elements[index];

		        // Actualizar posición con el offset correspondiente
		        element.pos_x = mouse_x + offsets[i];

		        // Asegurar que no salga de los límites
		        if (element.pos_x < 0) element.pos_x = 0;

		        // Manejar conflictos con otros elementos
		        var conflict_found = true;
		        while (conflict_found) {
		            conflict_found = false;
		            for (var j = 0; j < array_length(elements); j++) {
		                if (j == index) continue;
		                var other_element = elements[j];
		                if (other_element.pos_x == element.pos_x) {
		                    conflict_found = true;
		                    element.pos_x += 1; // Mover ligeramente
		                    break;
		                }
		            }
		        }
		    }
			
			// Actualizar las listas de max/min
			sort_elements_max_min_1 = [];
			sort_elements_max_min_2 = [];

			if (array_length(elements) > 0) {
				for (var i = 0; i < array_length(elements); i++) {
				    var local_element = elements[i];
				    if (local_element.index_type != 2 && local_element.index_type != 3) {
				        array_push(sort_elements_max_min_1, local_element);
				    }
					if (local_element.index_type != 0 && local_element.index_type != 1) {
				        array_push(sort_elements_max_min_2, local_element);
				    }
				}

				// Ordenar las listas por pos_x de mayor a menor
				array_sort(sort_elements_max_min_1, function(a, b) { return b.pos_x - a.pos_x; });
				array_sort(sort_elements_max_min_2, function(a, b) { return b.pos_x - a.pos_x; });
			}
		}
	} else if (mouse_check_button_released(mb_left) && click_to_move && array_length(editing_elements) > 0) {
	    click_to_move = false;
	    offsets = [];
	}


	// EDITAR VARIOS ELEMENTOS A LA VEZ
	if (array_length(editing_elements) > 0 && array_length(elements) > 0) {
		var pos_edited = 0;
	    for (var j = 0; j < array_length(editing_elements); j++) {
			if (editing_elements[j] < array_length(elements)) {
				var element = elements[editing_elements[j]];
			
				// Mueve el elemento con las flechas
				if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
				    element.pos_x -= 1;
				    if (element.pos_x < 0) element.pos_x = 0;
				    current_key_timer = current_time;
					pos_edited = 1;
				}
				if ((keyboard_check(vk_left) || keyboard_check(ord("A"))) && (current_time - current_key_timer) > 500) {
				    element.pos_x -= 1;
				    if (element.pos_x < 0) element.pos_x = 0;
					pos_edited = 1;
				}

				if (keyboard_check_pressed(vk_right) || (keyboard_check_pressed(ord("D")) && !keyboard_check(vk_control))) {
				    element.pos_x += 1;
				    current_key_timer = current_time;
					pos_edited = 1;
				}
				if ((keyboard_check(vk_right)  || (keyboard_check(ord("D")) && !keyboard_check(vk_control))) && (current_time - current_key_timer) > 500) {
				    element.pos_x += 1;
					pos_edited = 1;
				}
	
				if (pos_edited == 1) {
					var conflict_found = false;
					while (conflict_found) {
			            conflict_found = false;

			            for (var i = 0; i < array_length(elements); i++) {
			                if (i == editing_element) continue; // Saltar el elemento que estamos editando

			                var other_element = elements[i];
			                if (other_element.pos_x  div 1 == element.pos_x  div 1) {
			                    conflict_found = true;
			                    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
			                        element.pos_x -= 1; // Mover hacia la izquierda
			                    } else if (keyboard_check(vk_right) || (keyboard_check(ord("D")) && !keyboard_check(vk_control))) {
			                        element.pos_x += 1; // Mover hacia la derecha
			                    }
			                    break; // Salir del bucle para reiniciar la búsqueda
			                }
						}
						if ((keyboard_check(vk_left) || keyboard_check(ord("A"))) && element.pos_x < 0) {
				            // Encuentra la primera posición disponible a la derecha
				            element.pos_x = 0;
				            while (true) {
				                var position_occupied = false;
				                for (var i = 0; i < array_length(elements); i++) {
									if (i == editing_element[j]) continue;
				                    if (elements[i].pos_x == element.pos_x) {
				                        position_occupied = true;
				                        break;
				                    }
				                }
				                if (!position_occupied) break; // Salir si se encuentra una posición disponible
				                element.pos_x += 1;
				            }
				        }
			        }
				}
			}
		}
		
		if (pos_edited == 1) {
			// Actualizar las listas de max/min
			sort_elements_max_min_1 = [];
			sort_elements_max_min_2 = [];

			if (array_length(elements) > 0) {
				for (var i = 0; i < array_length(elements); i++) {
				    var local_element = elements[i];
				    if (local_element.index_type != 2 && local_element.index_type != 3) {
				        array_push(sort_elements_max_min_1, local_element);
				    }
					if (local_element.index_type != 0 && local_element.index_type != 1) {
				        array_push(sort_elements_max_min_2, local_element);
				    }
				}

				// Ordenar las listas por pos_x de mayor a menor
				array_sort(sort_elements_max_min_1, function(a, b) { return b.pos_x - a.pos_x; });
				array_sort(sort_elements_max_min_2, function(a, b) { return b.pos_x - a.pos_x; });
			}
		}
	
		// Eliminar elemento si supr
		if ((keyboard_check_pressed(vk_delete) || (keyboard_check(vk_control) && keyboard_check_pressed(ord("D")))) && array_length(editing_elements) > 0) {
			array_sort(editing_elements, function(a, b) { return b - a; });
			for (var j = 0; j < array_length(editing_elements); j++) {
				if (editing_elements[j] < array_length(elements)) {
					show_debug_message("j " + string(editing_elements[j]));
					var element = elements[editing_elements[j]];
				
				    remove_charteo_element({"index_type":  element.index_type, "pos_x": element.pos_x});
				}
			}
			editing_element = -1;
			editing_elements = [];
			show_debug_message(json_stringify(editing_elements));
		}
		
		if (keyboard_check_pressed(vk_escape)) { 
			editing_elements = [];
			editing_element = -1;
		}
	}

	// CONTROLES PARA SELECCIONAR TIPO
	if (editing_element == -1 && array_length(editing_elements) == 0) {
	    if (keyboard_check_pressed(vk_left)) {
	        selected_type = (selected_type - 1 + 8) mod 8;
	    }
	    if (keyboard_check_pressed(vk_right)) {
	        selected_type = (selected_type + 1) mod 8;
	    }
		if (keyboard_check_pressed(ord("A"))) {
	        selected_type = (selected_type - 1 + 8) mod 8;
	    }
	    if (keyboard_check_pressed(ord("D")) && !keyboard_check(vk_control)) {
	        selected_type = (selected_type + 1) mod 8;
	    }
		
		var numbers = ["1", "2", "3", "4", "5", "6", "7", "8"];
		
		for (var i = 0; i < 8; i++) {
			if (keyboard_check_pressed(ord(numbers[i]))) {
				selected_type = i;
				break;
			}
		}
	}


	// Control para bajar/subir volumen
	if (!keyboard_check(vk_control) && !keyboard_check(ord("V"))) {
		if (keyboard_check_pressed(vk_subtract)) audio_set_master_gain(0, max(0, audio_get_master_gain(0)-0.2));
		if (keyboard_check_pressed(vk_add)) audio_set_master_gain(0, min(audio_get_master_gain(0)+0.2, 2));
	} else if (keyboard_check(vk_control) && keyboard_check(ord("V"))) {
		if (keyboard_check_pressed(vk_add)) {
			global.sound_delay += 0.05;
			if (global.sound_delay > 10) global.sound_delay = 10;
			current_key_timer = current_time;
		}
		if (keyboard_check(vk_add) && (current_time - current_key_timer) > 500) {
			global.sound_delay += 0.05;
			if (global.sound_delay > 10) global.sound_delay = 10;
		}
	
		if (keyboard_check_pressed(vk_subtract)) {
			global.sound_delay -= 0.05;
			if (global.sound_delay < -10) global.sound_delay = -10;
			current_key_timer = current_time;
		} else if (keyboard_check(vk_subtract) && (current_time - current_key_timer) > 500) {
			global.sound_delay -= 0.05;
			if (global.sound_delay < -10) global.sound_delay = -10;
		}
	}
	
	// Re hacer 1
	if (keyboard_check(vk_control) && keyboard_check_pressed(ord("Y")) && prev_type_backup != -1 && prev_pos_x_backup != -1) {
		add_charteo_element(prev_type_backup, prev_pos_x_backup div 1);
		editing_element = array_length(elements) - 1;
		editing_elements = [];
		selected_element = 0;
	} else if (keyboard_check(vk_control) && keyboard_check_pressed(ord("Z"))) {
		if (global.new_song_id != undefined && global.new_song_name != "") {
			prev_type_backup = elements[array_length(elements) - 1].index_type;
			prev_pos_x_backup = elements[array_length(elements) - 1].pos_x;
			remove_charteo_element(elements[array_length(elements) - 1]);
			editing_element = array_length(elements) - 1;
			editing_elements = [];
			selected_element = 0;
		} else {
			if (array_length(elements) > array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index])) {
				prev_type_backup = elements[array_length(elements) - 1].index_type;
				prev_pos_x_backup = elements[array_length(elements) - 1].pos_x;
				remove_charteo_element(elements[array_length(elements) - 1]);
				editing_element = array_length(elements) - 1;
				editing_elements = [];
				selected_element = 0;
			}
		}
		
	}

	// SELECCIONAR INPUT
	if (array_length(elements) > 0 && array_length(editing_elements) == 0) {
		if (keyboard_check_pressed(ord("Q"))) {
		    array_sort(sort_elements_max_min_1, function(a, b) { return a.pos_x - b.pos_x; });
		    var sorted_elements = sort_elements_max_min_1;
		    if (editing_element == -1) {
		        // Si no hay elemento seleccionado, elegir el mayor de todos con index_type <= 1, dentro de la pantalla
		        for (var i = array_length(sorted_elements) - 1; i >= 0; i--) {
		            if ((sorted_elements[i].index_type <= 1 || sorted_elements[i].index_type > 3) && ((sorted_elements[i].pos_x - global.base_x) >= 0) && ((sorted_elements[i].pos_x - global.base_x) <= room_width)) {
		                for (var j = 0; j < array_length(elements); j++) {
		                    if (elements[j].pos_x == sorted_elements[i].pos_x && elements[j].index_type == sorted_elements[i].index_type) {
		                        editing_element = j;
		                        selected_element = 0;
		                        break;
		                    }
		                }
		                break;
		            }
		        }
		    } else {
		        // Si hay un elemento seleccionado, elegir el siguiente menor con index_type <= 1, dentro de la pantalla
		        var current_element = elements[editing_element];
		        var found_next = false;

		        for (var i = array_length(sorted_elements) - 1; i >= 0; i--) {
		            if ((sorted_elements[i].pos_x < current_element.pos_x) && (sorted_elements[i].index_type <= 1 || sorted_elements[i].index_type > 3) && (sorted_elements[i].pos_x - global.base_x >= 0) && ((sorted_elements[i].pos_x - global.base_x) <= room_width)) {
		                for (var j = 0; j < array_length(elements); j++) {
		                    if ((elements[j].pos_x == sorted_elements[i].pos_x) && (elements[j].index_type == sorted_elements[i].index_type)) {
		                        editing_element = j;
		                        found_next = true;
		                        selected_element = 0;
		                        break;
		                    }
		                }
		                if (found_next) break;
		            }
		        }

		        // Si no hay un menor válido, regresar a -1
		        if (!found_next) {
		            editing_element = -1;
					editing_elements = [];
		        }
		    }
		}

	    if (keyboard_check_pressed(ord("E")) && !keyboard_check(vk_control)) {
			array_sort(sort_elements_max_min_1, function(a, b) { return a.pos_x - b.pos_x; });
			var sorted_elements = sort_elements_max_min_1;
	        if (editing_element == -1) {
	            // Si no hay elemento seleccionado, empezar desde el menor con index_type <= 1, dentro de la pantalla
	            for (var i = 0; i < array_length(sorted_elements); i++) {
	                if ((sorted_elements[i].index_type <= 1 || sorted_elements[i].index_type > 3) && ((sorted_elements[i].pos_x - global.base_x) >= 0) && ((sorted_elements[i].pos_x - global.base_x) <= room_width)) {
	                    for (var j = 0; j < array_length(elements); j++) {
	                        if (elements[j].pos_x == sorted_elements[i].pos_x && elements[j].index_type == sorted_elements[i].index_type) {
	                            editing_element = j;
								selected_element = 0;
	                            break;
	                        }
	                    }
	                    break;
	                }
	            }
	        } else {
	            // Si hay un elemento seleccionado, elegir el siguiente mayor con index_type <= 1, dentro de la pantalla
	            var current_element = elements[editing_element];
	            var found_next = false;

	            for (var i = 0; i < array_length(sorted_elements); i++) {
		            if ((sorted_elements[i].pos_x > current_element.pos_x) && (sorted_elements[i].index_type <= 1 || sorted_elements[i].index_type > 3) && ((sorted_elements[i].pos_x - global.base_x) >= 0) && ((sorted_elements[i].pos_x - global.base_x) <= room_width)) {
	                    for (var j = 0; j < array_length(elements); j++) {
	                        if (elements[j].pos_x == sorted_elements[i].pos_x && elements[j].index_type == sorted_elements[i].index_type) {
	                            editing_element = j;
	                            found_next = true;
								selected_element = 0;
	                            break;
	                        }
	                    }
	                    if (found_next) break;
	                }
	            }

	            // Si no hay un siguiente mayor válido, reiniciar a -1
	            if (!found_next) {
	                editing_element = -1;
					editing_elements = [];
	            }
	        }
	    }
	
		if (keyboard_check_pressed(ord("S"))) {
			array_sort(sort_elements_max_min_2, function(a, b) { return a.pos_x - b.pos_x; });
			var sorted_elements = sort_elements_max_min_2;
		    if (editing_element == -1) {
		        // Si no hay elemento seleccionado, elegir el mayor de todos con index_type >= 2, dentro de la pantalla
		        for (var i = array_length(sorted_elements) - 1; i >= 0; i--) {
		            if ((sorted_elements[i].index_type >= 2) && ((sorted_elements[i].pos_x - global.base_x) >= 0) && ((sorted_elements[i].pos_x - global.base_x) <= room_width)) {
			            for (var j = 0; j < array_length(elements); j++) {
		                    if (elements[j].pos_x == sorted_elements[i].pos_x && elements[j].index_type == sorted_elements[i].index_type) {
		                        editing_element = j;
								selected_element = 0;
		                        break;
		                    }
		                }
		                break;
		            }
		        }
		    } else {
		        // Si hay un elemento seleccionado, elegir el siguiente menor con index_type >= 2, dentro de la pantalla
		        var current_element = elements[editing_element];
		        var found_next = false;

		        for (var i = array_length(sorted_elements) - 1; i >= 0; i--) {
		            if ((sorted_elements[i].pos_x < current_element.pos_x) && sorted_elements[i].index_type >= 2) && ((sorted_elements[i].pos_x - global.base_x) >= 0) && ((sorted_elements[i].pos_x - global.base_x <= room_width)) {
		                for (var j = 0; j < array_length(elements); j++) {
		                    if (elements[j].pos_x == sorted_elements[i].pos_x && elements[j].index_type == sorted_elements[i].index_type) {
		                        editing_element = j;
		                        found_next = true;
								selected_element = 0;
		                        break;
		                    }
		                }
		                if (found_next) break;
		            }
		        }

		        // Si no hay un menor válido, regresar a -1
		        if (!found_next) {
		            editing_element = -1;
					editing_elements = [];
		        }
		    }
		}

		if (keyboard_check_pressed(ord("W"))) {
			array_sort(sort_elements_max_min_2, function(a, b) { return a.pos_x - b.pos_x; });
			var sorted_elements = sort_elements_max_min_2;
		    if (editing_element == -1) {
		        // Si no hay elemento seleccionado, empezar desde el menor con index_type >= 2, dentro de la pantalla
		        for (var i = 0; i < array_length(sorted_elements); i++) {
		            if ((sorted_elements[i].index_type >= 2)&& ((sorted_elements[i].pos_x - global.base_x) >= 0) && ((sorted_elements[i].pos_x - global.base_x) <= room_width)) {
		                for (var j = 0; j < array_length(elements); j++) {
		                    if (elements[j].pos_x == sorted_elements[i].pos_x && elements[j].index_type == sorted_elements[i].index_type) {
		                        editing_element = j;
								selected_element = 0;
		                        break;
		                    }
		                }
		                break;
		            }
		        }
		    } else {
		        // Si hay un elemento seleccionado, elegir el siguiente mayor con index_type >= 2, dentro de la pantalla
		        var current_element = elements[editing_element];
		        var found_next = false;

		        for (var i = 0; i < array_length(sorted_elements); i++) {
		            if ((sorted_elements[i].pos_x > current_element.pos_x) && (sorted_elements[i].index_type >= 2) && ((sorted_elements[i].pos_x - global.base_x) >= 0) && ((sorted_elements[i].pos_x - global.base_x) <= room_width)) {
		                for (var j = 0; j < array_length(elements); j++) {
		                    if (elements[j].pos_x == sorted_elements[i].pos_x && elements[j].index_type == sorted_elements[i].index_type) {
		                        editing_element = j;
		                        found_next = true;
								selected_element = 0;
		                        break;
		                    }
		                }
		                if (found_next) break;
		            }
		        }

		        // Si no hay un siguiente mayor válido, reiniciar a -1
		        if (!found_next) {
		            editing_element = -1;
					editing_elements = [];
		        }
		    }
		}
	}
}