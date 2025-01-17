/// @description Insert description here
// You can write your code in this editor

if (global.first_load && current_time > 4000) {
	room_goto(Game);
}

if (!global.first_load && current_time > 1000) {
	load_songs_from_directory(working_directory + "sounds");
	if (array_length(global.song_text_list) - 1 > 0) global.current_song_index = 1;
	else global.current_song_index = 0;
	
	global.current_chart_index = global.current_song_index;
	global.current_song = global.song_list[global.current_song_index];
	
	load_bg();
	load_sfx();
	
	obj_handle_savedata.load_ini_data(,"all");

	global.first_load = true;
	
}