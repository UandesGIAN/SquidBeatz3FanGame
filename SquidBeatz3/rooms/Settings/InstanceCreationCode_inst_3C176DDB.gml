texto_en = "Go back";
texto = "Volver";

action = function() {
	if (!obj_handle_savedata.message_shown && !obj_handle_savedata.message_shown2 && !obj_background_show.message_shown && !obj_handle_sfx_change.message_shown && !obj_sync_color_sample.message_shown) {
	    room_goto(Game);
	}
}