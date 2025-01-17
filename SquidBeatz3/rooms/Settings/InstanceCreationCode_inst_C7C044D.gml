texto_en = "Change background";
texto = "Cambiar fondo";

action = function() {
	if (!obj_handle_custom_sprites.message_shown && !obj_handle_savedata.message_shown && !obj_handle_savedata.message_shown2 && !obj_background_show.message_shown && !obj_handle_sfx_change.message_shown && !obj_sync_color_sample.message_shown) {
       if (current_time - obj_background_show.close_time > 50) obj_background_show.message_shown = 1;
    }
}