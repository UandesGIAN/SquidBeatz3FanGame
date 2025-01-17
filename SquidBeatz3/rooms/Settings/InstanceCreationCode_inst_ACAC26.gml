texto_en = "Load savedata";
texto = "Cargar datos";

action = function() {
	if (global.is_gamepad) {
		with (obj_editor_button) {
			blocked = 1;
		}
		obj_sync_color_sample.blocked = 1;
		game_controller_message = 1;
	} else {
		if (!obj_handle_custom_sprites.message_shown && !obj_handle_savedata.message_shown && !obj_handle_savedata.message_shown2 && !obj_background_show.message_shown && !obj_handle_sfx_change.message_shown && !obj_sync_color_sample.message_shown  && check_permissions()) {
			
			show_message(global.current_language == "ENGLISH" ? "LOAD SAVE DATA\n\nNext, you will be asked to choose a save file (.ini). Then, you will have 4 options to load data from that file: charting data only (REPLACES THE CHART OF THE SONG INDEX FROM WHICH THE CHART WAS SAVED), progress data only (REPLACES THE GAME PROGRESS ONLY AT THE SONGS WITH THE SAME CHART DATA THAT WAS STORED AT THE SAVE FILE), settings data only, or everything." : "CARGAR DATOS DE GUARDADO\n\nA continuación se pide que elijas un archivo de guardado .ini, luego tendrás 4 opciones de cargar datos desde ese archivo. Sólo datos de charteo (REEMPLAZA EL CHARTEO DEL NÚMERO ORIGINAL DE LA CANCIÓN SOBRE LA QUE FUE GUARDADO EL CHART EN EL .INI), sólo datos de progreso (REEMPLAZA LOS DATOS DE PROGRESO DE LA CANCIÓN DONDE EL CHARTEO ES EL MISMO QUE EL QUE SE GUARDÓ EN EL ARCHIVO .INI), sólo datos de ajustes o todo.");
			if (1 == show_question(global.current_language == "ENGLISH" ? "IMPORTANT: Chart and progress data will REPLACE the current data for the same song number that was saved at the .ini file. Remember that with ctrl+E, you can export songs directly from the game files, and with ctrl+O, you can load them.\n\nDo you wish to continue?" : "IMPORTANTE: El charteo y progreso del archivo de guardado REEMPLAZARÁ los datos de la canción con el mismo número que aquellos guardados en el archivo .ini. Recuerda que con ctrl+E puedes exportar canciones directo de los arcivos del juego y con ctrl+O cargarlas.\n\n¿Deseas continuar?")) {
		        var filter = "*.ini|*.*";
				var file_path = get_open_filename_ext(filter, "save_data.ini", false, global.current_language == "ENGLISH" ? "Open a compatible .ini file" : "Abre un archivo .ini compatible");
				
				if (string_length(file_path) > 0) {
					if (string_pos(".ini", file_path)) {
						obj_handle_savedata.message_shown = 1;
						obj_handle_savedata.load_path = file_path;
					} else {
						show_message(global.current_language == "ENGLISH" ? "The selected file is invalid. Please select a file with the .ini extension." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo con la extensión .ini.");
					}
				} else {
					show_message(global.current_language == "ENGLISH" ? "No file was selected." : "No se seleccionó ningún archivo.");
				}
		    }
		}
	}
}