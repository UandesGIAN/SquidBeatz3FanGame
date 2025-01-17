/// @description Insert description here
// You can write your code in this editor

if (global.first_load && current_time - time_delay > 1500) {
	room_goto(Game);
}

if (!global.first_load && current_time > 1000) {
	load_songs_from_directory(working_directory + "sounds");
	
	if (array_length(global.song_text_list) - 1 > 0) global.current_song_index = 1;
	else global.current_song_index = 0;
	
	global.current_chart_index = global.current_song_index;
	global.current_song = global.song_list[global.current_song_index];
	
	current_load = 1;
	load_sfx();
	current_load = 2;
	load_bg();
	current_load = 3;
	load_dances();
	current_load = 4;
	
	obj_handle_savedata.load_ini_data(,"all");
	
	current_load = 5;
	global.first_load = true;
	time_delay = current_time;
}