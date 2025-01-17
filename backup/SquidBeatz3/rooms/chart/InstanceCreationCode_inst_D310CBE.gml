texto = "Renombrar";
texto_en = "Rename";

action = function() {
	obj_chart_game.message_shown = 1;
	obj_chart_game2.message_shown = 1;
	obj_editor_button.blocked = 1;
    obj_handle_chart_files.replace_song_name();
	obj_chart_game.message_shown = 0;
	obj_chart_game2.message_shown = 0;
	obj_editor_button.blocked = 0;
};