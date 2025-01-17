
dialog_width = 550;
dialog_height = 450;

// Centro de la pantalla
dialog_x = (room_width - dialog_width) / 2;
dialog_y = (room_height - dialog_height) / 2;

salir_text_color = c_white;
message_shown = 0;
inputs_delay = current_time;

selected_row = 1;
selected_col = 0;
gamepad_message = 0;
stick_moved = 0;

closed = 0;
close_time = current_time;


function change_or_add_bg(bg_index) {
	show_message(global.current_language == "ENGLISH" ? "CHANGE BACKGROUND\nIt is recommended to use squared pictures. RECOMMENDED SIZE IS 1280x720 pixels. Formats allowed are: .png and .jpg." : "CAMBIAR FONDOS DE PANTALLA\nSe pedira que eligas un archivo de imagen. Se recomienda usar imagenes cuadradas. EL TAMAÑO RECOMENDADO ES 1280x720 pixeles. Los formatos permitidos son .png y .jpg.")
	 // Ask the user to select an audio file, only .ogg allowed
    var filter = "(*.png; *.jpg)|*.png;*.jpg|*.*";
    var file_path = get_open_filename_ext(filter, "Picture File", false, global.current_language == "ENGLISH" ? "Upload an picture file." : "Sube un archivo de imagen.");
	var sprite_id = undefined;
	
    // If a valid file is selected
    if (string_length(file_path) != 0) {
        // Validate that the file has a .ogg extension
        if (string_pos(".png", file_path) || string_pos(".jpg", file_path)) {
			var folder = "user1"; 
	        if (bg_index == 2) folder = "user2"; 
			var sprite_path = working_directory + "sprites\\" + folder + "\\background.png";
			if (string_pos(".jpg", file_path) && !string_pos(".png", file_path)) sprite_path = working_directory + "sprites\\" + folder + "\\background.jpg";
			
			if (file_exists(working_directory + "sprites\\" + folder + "\\background.png")) {
		        file_delete(working_directory + "sprites\\" + folder + "\\background.png");
		    }
			if (file_exists(working_directory + "sprites\\" + folder + "\\background.jpg")) {
		        file_delete(working_directory + "sprites\\" + folder + "\\background.jpg");
		    }
				
            file_copy(file_path, sprite_path);
			sprite_id = sprite_add(sprite_path, 0, 0, 0, 0, 0);
            global.bg_options[bg_index] = sprite_id;
        } else {
            show_message(global.current_language == "ENGLISH" ? "The selected file is not valid. Please select a .png or .jpg file." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo .png o .jpg.");
        }
    } else {
        show_message(global.current_language == "ENGLISH" ? "No file selected." : "No se seleccionó ningún archivo.");
    }
}