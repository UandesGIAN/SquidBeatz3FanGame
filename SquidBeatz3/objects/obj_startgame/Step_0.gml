/// @description Insert description here
// You can write your code in this editor

if (global.first_load && current_time - time_delay > 1500) {
	room_goto(Game);
}

if (!global.first_load && current_time > 1000) {
	if (current_load == 0 && current_time - time_delay > 30 && gradual_load == 0) {
		load_songs_from_directory(working_directory + "sounds");
	
		if (array_length(global.song_text_list) - 1 > 0) global.current_song_index = 1;
		else global.current_song_index = 0;
	
		global.current_chart_index = global.current_song_index;
		global.current_song = global.song_list[global.current_song_index];
		current_load = 1;
		gradual_load = 0;
		time_delay = current_time;
	}
	
	if (current_load == 1 && current_time - time_delay > 30 && gradual_load == 0) {
	    load_sfx();
	    current_load = 2;
		gradual_load = 0;
		time_delay = current_time;
	}

	if (current_load == 2 && current_time - time_delay > 30 && gradual_load == 0) {
	    load_bg();
	    current_load = 3;
		gradual_load = 0;
		time_delay = current_time;
	}

	if (current_load == 3 && current_time - time_delay > 30 && gradual_load == 0) {
	    load_dances();
	    current_load = 4;
		gradual_load = 0;
		time_delay = current_time;
	}

	if (current_load == 4 && current_time - time_delay > 30 && gradual_load == 0) {
	    obj_handle_savedata.load_ini_data(,"all");
	    current_load = 5;
	}

	if (current_load == 5) {
	    global.first_load = true;
		time_delay = current_time;
	}
}