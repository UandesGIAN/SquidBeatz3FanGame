if (global.current_song != undefined && (!global.practice_mode && global.is_playing || global.practice_mode)) {
    var elements = global.charts[$ global.current_difficulty].charts[global.current_chart_index];
    if (array_length(elements) > 0) {
        for (var i = 0; i < array_length(elements); i++) {
            var element = elements[i];
            var fixed_x = 0;

            if (global.practice_mode) {
                fixed_x = element.pos_x - global.base_x;
            } else {
                if (obj_play.play_music) fixed_x = element.pos_x - global.base_x;
                else {
					fixed_x = element.pos_x + global.base_x;
					pos_y_lose = 0;
				}
            }

            // Vderifica si el elemento está dentro de los límites del cuarto
            if (fixed_x >= 0 && fixed_x <= room_width) {
                // Verifica si el índice coincide con el actual y si el hit es positivo
				if (!global.practice_mode) {
					var idx = -1;
					for (var j = 0; j < array_length(obj_sync.already_hit); j++) {
						if (obj_sync.already_hit[j].pos_x == element.pos_x) {
							idx = j;
							break;
						}
					}
					if (idx != -1) continue;
				}

                // Dibuja el sprite del elemento si no se eliminó
                draw_set_font(splat_font_small);
                draw_set_halign(fa_left);
				
				shader_set(shader_hue_shift);
				shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);

				if ((obj_sync.current_life > 0 && global.lifebar) || !global.lifebar) {
					draw_sprite(type_spr[element.index_type], 0, fixed_x - (((element.index_type) mod 2) * 10 + 20), pos_y[element.index_type]);
				} else {
					draw_sprite(type_spr[element.index_type], 0, fixed_x - (((element.index_type) mod 2) * 10 + 20), pos_y[element.index_type] - pos_y_lose);
					pos_y_lose -= 2;
				}
				shader_reset();
			}
        }
    }
}