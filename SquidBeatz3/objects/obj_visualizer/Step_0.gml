/// @description Insert description here
// You can write your code in this editor
if (global.new_song_name == "" && global.new_song_id == undefined) {
	if (array_length(global.song_visualizer[global.current_chart_index]) > 0) {
		if (obj_play.play_music) {
			if (current_time - delay > 500) {
				current_col++;
				if (current_col == array_length(global.song_visualizer[global.current_chart_index])) {
					current_col = 0;
				}
		
				delay = current_time;
			}
		} else {
			delay = current_time;
			if (audio_is_playing(obj_play.sound_playing) || global.practice_mode) {
				if ((audio_sound_get_track_position(global.current_song)*1000) % 500 == 0) {
					current_col = ((audio_sound_get_track_position(global.current_song) div 1 + 1));
				}
			} else {
				current_col = 0;
			}
		}
	}
}
