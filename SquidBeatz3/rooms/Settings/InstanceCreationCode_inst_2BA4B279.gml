texto_en = "Delete data";
texto = "Borrar datos";

action = function() {
	if (!obj_handle_savedata.message_shown && !obj_handle_savedata.message_shown2 && !obj_background_show.message_shown && !obj_handle_sfx_change.message_shown && !obj_sync_color_sample.message_shown) {
		obj_handle_savedata.message_shown2 = 1;
	}
}