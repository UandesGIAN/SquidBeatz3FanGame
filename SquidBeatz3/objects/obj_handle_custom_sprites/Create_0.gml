
dialog_width = 1000;
dialog_height = 425;

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


function loadGIF(dance_index) {
	show_message(global.current_language == "ENGLISH" ? "CHANGE DANCES\nYou must provide a GIF file, it's highly recommended to selected images wwith tranparent background." : "CAMBIAR BAILES\nDeberás proporcionar un GIF, es muy recomendable que sea un gif con imagenes sin fondo, tal de integrarse bien en la interfaz.")

    var filter = "(*.GIF)|*.GIF|*.*";
    var file_path = get_open_filename_ext(filter, "GIF File", false, global.current_language == "ENGLISH" ? "Upload a GIF file." : "Sube un archivo GIF.");
	var gif_frame_sprites = undefined;
	var gif_delays = [0]; // delays per frame, in centiseconds
	
	if (string_length(file_path) != 0) {
        if (string_pos(".gif", file_path)) {
            var sprite_path = working_directory + "sprites\\custom_dances\\dance" + string(dance_index+1) + ".gif";

            // Borrar GIF anterior si existe
            if (file_exists(sprite_path)) {
                file_delete(sprite_path);
            }
            
            // Copiar nuevo GIF
            file_copy(file_path, sprite_path);

            var gif_sprite = sprite_add_gif(sprite_path, 0, 0, gif_delays, gif_frame_sprites);

            if (sprite_exists(global.dance_sprites[1][dance_index]) && global.dance_sprites[1][dance_index] != global.dance_sprites[0][dance_index]) {
                sprite_delete(global.dance_sprites[1][dance_index]);
            }

            // Guardar el GIF en el arreglo global
            global.dance_sprites[1][dance_index] = gif_sprite;
			show_debug_message(gif_sprite);
			
			show_message(global.current_language == "ENGLISH" ? "Sprite dance " + string(dance_index+1) + " successfully updated." : "Baile para el sprite " + string(dance_index+1) + " actualizado con éxito.");
		} else {
			show_message(global.current_language == "ENGLISH" ? "The selected file is not valid. Please select a .gif file." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo .gif.");
		}
	} 
	else {
		show_message(global.current_language == "ENGLISH" ? "No file selected." : "No se seleccionó ningún archivo.");
	}
}
