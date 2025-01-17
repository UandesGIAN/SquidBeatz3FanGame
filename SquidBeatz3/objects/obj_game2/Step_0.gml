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
			
			if (!global.practice_mode) {
				obj_sync.game_win_for_first_time = 0;
				obj_sync.last_win_category = "";
				if ((array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]) - global.game_points[$ global.current_difficulty].total_hits[global.current_chart_index] == 0) || (global.lifebar && global.wins_lifebar[$ global.current_difficulty][global.current_chart_index]))
					obj_sync.game_win = 1;
				else
					obj_sync.game_win = 0;
			} else {
				global.base_x = global.start_point + global.sound_delay*10;
				
				obj_game.conteo_desplazamiento = 0;
		        obj_game.index_bar = 0;
		        obj_game.game_bar[0].x = global.start_point;
				// Recalcular las posiciones de las barras
			    for (var i = 1; i < 4; i++) {
			        var next_index = (obj_game.index_bar + i) mod 4;
			        var prev_index = (obj_game.index_bar + i - 1) mod 4;
			        obj_game.game_bar[next_index].x = obj_game.game_bar[prev_index].x + obj_game.sprite_width;
			    }
	            obj_game.started = 1;
			}
        } else {
			if (!global.practice_mode && obj_play.play_music) {
				obj_play.sprite_index = spr_pause;
				audio_stop_sound(global.current_song);
				obj_play.play_music = 0;
				obj_play.sound_playing = -1;
				obj_game2.processed_elements = [];
				obj_play.sprite_index_local = -1;
				
				global.is_playing = 1;  // Iniciar juego
				obj_play.sprite_index = spr_play;
				obj_play.sound_playing = audio_play_sound(global.current_song, 1, 0);
				obj_play.play_music = 1;
		        global.base_x = global.start_point + global.sound_delay*10;
				
				obj_game.conteo_desplazamiento = 0;
		        obj_game.index_bar = 0;
		        obj_game.game_bar[0].x = global.start_point;
				// Recalcular las posiciones de las barras
			    for (var i = 1; i < 4; i++) {
			        var next_index = (obj_game.index_bar + i) mod 4;
			        var prev_index = (obj_game.index_bar + i - 1) mod 4;
			        obj_game.game_bar[next_index].x = obj_game.game_bar[prev_index].x + obj_game.sprite_width;
			    }
	            obj_game.started = 1;
			} else {
				global.is_playing = 1;  // Iniciar juego
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