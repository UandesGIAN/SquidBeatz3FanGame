texto_en = "Change background";
texto = "Cambiar fondo";

action = function() {
	if (!obj_handle_savedata.message_shown && !obj_handle_savedata.message_shown2 && !obj_background_show.message_shown && !obj_handle_sfx_change.message_shown && !obj_sync_color_sample.message_shown) {
        obj_background_show.message_shown = 1;
    }
}