/// @description Insert description here
// You can write your code in this editor

// Al presionar Enter aparece el chart
if (global.current_song != undefined) {
    total_notes = array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]);
    if (((keyboard_check_pressed(vk_enter) && !global.is_gamepad) || (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_select)))) {
		global.tempo = global.charts[$ global.current_difficulty].tempo[global.current_chart_index];
        global.start_point = global.charts[$ global.current_difficulty].start_point[global.current_chart_index];
		
        if (global.is_playing == 1) {
            switch (global.current_difficulty) {
                case "easy":
                    global.current_difficulty = "normal";
					obj_play.play_music = 0;
					obj_play.sprite_index = spr_pause;
					audio_stop_sound(global.current_song);
                    break;
                case "normal":
                    global.current_difficulty = "hard";
					obj_play.play_music = 0;
					obj_play.sprite_index = spr_pause;
					audio_stop_sound(global.current_song);
                    break;
                case "hard":
                    global.current_difficulty = "easy";
                    global.is_playing = 0;  // Reiniciar juego
					obj_play.play_music = 0;
					obj_play.sprite_index = spr_pause;
					global.practice_mode = 0;
					audio_stop_sound(global.current_song);
					audio_stop_all();
                    break;
            }
        } else {
            global.is_playing = 1;  // Iniciar juego
			if (!global.practice_mode) {
	            if (!obj_play.play_music) {
		                global.base_x = global.start_point + global.sound_delay*10;
		                obj_game.game_bar[0].x = global.start_point;
		                obj_game.conteo_desplazamiento = 0;
		                obj_game.index_bar = 0;
	            } else {
	                // Ajustar base_x, inicio_x y las posiciones iniciales de las barras
	                var inicio_x = ((audio_sound_get_track_position(obj_play.sound_playing) * (global.tempo * proportion_bpm_to_speed * 60)) - global.start_point)
	                var conteo_desplazamiento = inicio_x div 528;
	                var index_bar = 0;
	                global.base_x = -inicio_x + obj_game.sprite_width * conteo_desplazamiento + global.sound_delay*10;
	                obj_game.game_bar[index_bar].x = -inicio_x;
	                for (var i = 1; i < 4; i++) {
	                    var next_index = (index_bar + i) mod 4;
	                    var prev_index = (index_bar + i - 1) mod 4;
	                    obj_game.game_bar[next_index].x = obj_game.game_bar[prev_index].x + obj_game.sprite_width;
	                }
	                obj_game.started = 1;
	            }
			} else {
				if (!obj_play.play_music && obj_game.checkpoint_start != -1) {
					global.base_x = obj_game.checkpoint_base_x; // Restaurar base_x guardada
			        if (obj_game.checkpoint_base_x > 0) obj_game.game_bar[0].x = obj_game.checkpoint_start - obj_game.sprite_width;
					else obj_game.game_bar[0].x = obj_game.checkpoint_start;
					obj_game.index_bar = 0;

			        // Recalcular las posiciones de las barras
			        for (var i = 1; i < 4; i++) {
			            var next_index = (obj_game.index_bar + i) mod 4;
			            var prev_index = (obj_game.index_bar + i - 1) mod 4;
			            obj_game.game_bar[next_index].x = obj_game.game_bar[prev_index].x + obj_game.sprite_width;
			        }

			        obj_game.mouse_pressed = false;
			        obj_game.xprev = checkpoint_start;
			        obj_game.conteo_desplazamiento = conteo_d_checkpoint;
				}
			}
        }
    }
} else {
    global.is_playing = 0;
}