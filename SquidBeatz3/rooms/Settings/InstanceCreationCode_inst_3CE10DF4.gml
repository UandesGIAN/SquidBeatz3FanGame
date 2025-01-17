texto_en = "Change language";
texto = "Cambiar idioma";

action = function() {
	if (!obj_handle_custom_sprites.message_shown && !obj_handle_savedata.message_shown && !obj_handle_savedata.message_shown2 && !obj_background_show.message_shown && !obj_handle_sfx_change.message_shown && !obj_sync_color_sample.message_shown) {
		if (global.current_language == "ENGLISH") {
			global.current_language = "CASTELLANO";
			global.song_text_list[0] = (global.current_language == "ENGLISH" ? "0. Add a new song (Shift)" : "0. Agregar nueva cancion (Shift)");
		} else {
			global.current_language = "ENGLISH"
			global.song_text_list[0] = (global.current_language == "ENGLISH" ? "0. Add a new song (Shift)" : "0. Agregar nueva cancion (Shift)");
		}
	}
}