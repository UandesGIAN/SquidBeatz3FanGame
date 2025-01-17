/// @description Insert description here
// You can write your code in this editor

message_shown = 0;

mouse_pressed = 0;
start_mouse_x = 0;
game_bar = [inst_4B98FD26, inst_3D8C673B, inst_4F7FC995, inst_483F5022];
index_bar = 0;
conteo_desplazamiento = 0;
prev_element_sound = -1;
sfx_delay = current_time;

has_changed = 0;
playing_audio = 0;
current_song = global.new_song_id;

checkpoint_start = -1;
toggle_checkpoint = 0;
checkpoint_text_x = -1;
conteo_d_checkpoint = 0;
index_bar_checkpoint = 0;
checkpoint_base_x = 0;

if (global.new_song_id == undefined || global.new_song_name == "") {
	global.tempo = global.charts[$ global.current_difficulty].tempo[global.current_chart_index];
	current_song = global.song_list[global.current_song_index];
	global.start_point = global.charts[$ global.current_difficulty].start_point[global.current_chart_index];
}

xprev = global.start_point;
global.base_x = 272;
game_bar[0].x = global.start_point;

for (var i = 1; i < 4; i++) {
	var next_index = (index_bar + i) mod 4;
	var prev_index = (index_bar + i - 1) mod 4;
	game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
}

metronome_sfx = 0;

sound_id = audio_play_sound(current_song, 1, false);
audio_stop_sound(sound_id);
tiempo_inicio = 0;

proportion_bpm_to_speed = 132 / 3600;	// pixels per step
mode = "manual";
current_key_timer = current_time;