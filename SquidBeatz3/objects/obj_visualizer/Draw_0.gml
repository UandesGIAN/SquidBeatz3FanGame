/// @description Insert description here
// You can write your code in this editor

draw_self();

if (global.new_song_name == "" && global.new_song_id == undefined) {
	if (obj_play.play_music && array_length(global.song_visualizer[global.current_chart_index]) > 0 && current_col < array_length(global.song_visualizer[global.current_chart_index]) && ((obj_sync.current_life > 0 && global.lifebar) || !global.lifebar) && obj_sync.current_element_index < array_length(obj_sync.elements)) {
		var number_of_rows = global.song_visualizer[global.current_chart_index][current_col];
		for (var i = 0; i < 16; i++) {
			for (var j = 0; j < global.song_visualizer[global.current_chart_index][current_col][i]; j++) {
				var x_position = start_pos_x + (sprite_visualizer_width * i) - (2 * i);
		        var y_position = start_pos_y - (sprite_visualizer_height * j) + (1 * j);
				if (i > 9) {
					x_position = start_pos_x + (sprite_visualizer_width * i) - (2 * i);
					y_position = start_pos_y - (sprite_visualizer_height * j) + (1 * j);
				}

		        if (j > 10) {
		            if (j == global.song_visualizer[global.current_chart_index][current_col][i] - 1) {
						draw_sprite_ext(spr_visualizer_high, 0, x_position, y_position, 1, 1, 0, global.secondary_color_purple, 1);
		            } else {
		                draw_sprite_ext(spr_visualizer_low, 0, x_position, y_position, 1, 1, 0, global.primary_color_yellow, 1);
		            }
		        } else {
		            draw_sprite_ext(spr_visualizer_low, 0, x_position, y_position, 1, 1, 0, global.primary_color_yellow, 1);
		        }
		    }
		}
	}
}