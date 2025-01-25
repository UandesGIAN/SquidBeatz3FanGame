if (global.current_song != undefined && (global.is_playing || global.practice_mode)) {
    var elements = global.charts[$ global.current_difficulty].charts[global.current_chart_index];

    if (array_length(elements) > 0) {
        var life_active = (obj_sync.current_life > 0 && global.lifebar) || !global.lifebar; // Determina si la barra de vida está activa
        var hue_uniform = shader_get_uniform(shader_hue_shift, "hue_shift"); // Obtén el uniforme una vez

        for (var i = 0; i < array_length(elements); i++) {
            var element = elements[i];
            var fixed_x = element.pos_x - (global.practice_mode || obj_play.play_music ? global.base_x : -global.base_x);

            if (fixed_x >= 0 && fixed_x <= room_width) { // Verifica si está dentro del cuarto
                if (!global.practice_mode) {
                    // Verifica si el elemento ya fue golpeado
                    var already_hit = false;
                    for (var j = 0; j < array_length(obj_sync.already_hit); j++) {
                        if (obj_sync.already_hit[j].pos_x == element.pos_x) {
                            already_hit = true;
                            break;
                        }
                    }
                    if (already_hit) continue;
                }

                // Configura el sombreado y dibuja el sprite
                draw_set_font(splat_font_small);
                draw_set_halign(fa_left);

                shader_set(shader_hue_shift);
                shader_set_uniform_f(hue_uniform, global.hue_shift);

                var sprite_x_offset = (((element.index_type) mod 2) * 10 + 20);
                var draw_y = life_active ? pos_y[element.index_type] : pos_y[element.index_type] - pos_y_lose;

                draw_sprite(type_spr[element.index_type], 0, fixed_x - sprite_x_offset, draw_y);

                if (!life_active) pos_y_lose -= 2; // Ajusta el desplazamiento de y cuando la vida no está activa

                shader_reset();
            }
        }
    }
}
