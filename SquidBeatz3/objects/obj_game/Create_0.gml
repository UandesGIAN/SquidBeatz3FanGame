/// @description Insert description here
// You can write your code in this editor

game_bar = [inst_7063B2E0, inst_3BEFF7A, inst_287756EA, inst_39344EC6];
proportion_bpm_to_speed = 132 / 3600;

has_changed = 0;
mouse_pressed = 0;
start_mouse_x = 0;
tiempo_inicio = 0;

checkpoint_start = -1;
toggle_checkpoint = 0;
checkpoint_text_x = -1;
conteo_d_checkpoint = 0;
index_bar_checkpoint = 0;
checkpoint_base_x = 0;
count_silver_checkpoint = 0;
count_gold_checkpoint = 0;
total_hits_checkpoint = 0;
cei_1_checkpoint = 0;

global.time_music_playing = 0;
global.tempo = 120;
global.base_x = 272;
global.start_point = 272;

index_bar = 0;
conteo_desplazamiento = 0;
started = 0;
xprev = global.start_point;
game_bar[0].x = global.start_point;
for (var i = 1; i < 4; i++) {
	var next_index = (index_bar + i) mod 4;
	var prev_index = (index_bar + i - 1) mod 4;
	game_bar[next_index].x = game_bar[prev_index].x + sprite_width;
}

metronome_sfx = 0;