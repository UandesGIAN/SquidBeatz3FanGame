texto_en = "Change SFX";
texto = "Cambiar sonidos";

action = function() {
	if (!obj_handle_savedata.message_shown && !obj_handle_savedata.message_shown2 && !obj_background_show.message_shown && !obj_handle_sfx_change.message_shown && !obj_sync_color_sample.message_shown) {
	    obj_handle_sfx_change.message_shown = 1;
	    obj_handle_sfx_change.inputs_delay = current_time;
		obj_handle_sfx_change.selected_col = 0;
		obj_handle_sfx_change.selected_row = 1;
	}
}