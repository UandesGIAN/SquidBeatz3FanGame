/// @description Insert description here
// You can write your code in this editor
var n_songs = get_directory_contents(working_directory+"\\sounds\\songs\\", "*.json")

if (array_length(n_songs)+1 == array_length(global.song_list)) {
	save_ini_data();
}