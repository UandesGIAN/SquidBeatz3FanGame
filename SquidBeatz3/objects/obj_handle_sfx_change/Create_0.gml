/// @description Insert description here
// You can write your code in this editor

selected_col = 0;
selected_row = 1;
stick_moved = 0;

dialog_width = 820;
dialog_height = 400;

// Centro de la pantalla
dialog_x = (room_width - dialog_width) / 2;
dialog_y = (room_height - dialog_height) / 2;

salir_text_color = c_white;
message_shown = 0;
inputs_delay = current_time;

gamepad_message = 0;

function change_or_add_sfx(sfx_index) {
	show_message(global.current_language == "ENGLISH" ? "CHANGE SOUND EFFECTS\nYou will be asked to add 3 .ogg files, ideally less than 1.5 seconds long and with no delay at the beginning.\nThe first file corresponds to the sound played when pressing circular yellow notes. The second is for squared yellow notes. And the third is for purple notes." : "CAMBIAR EFECTOS DE SONIDO\nSe pedira que agregues 3 archivos .ogg, idealmente de menos de 1.5 segundos y sin retraso al inicio.\nEl primer archivo corresponde al sonido que suena al presionar notas amarillas circulares. El segundo para notas amarillas cuadradas. Y el tercero para notas moradas.")
	 // Ask the user to select an audio file, only .ogg allowed
    var filter = "(*.ogg)|*.ogg|*.*";
	show_message(global.current_language == "ENGLISH" ? "Now select the .ogg for circular yellow notes. If you don't choose one, it will be skipped and won't change." : "Ahora selecciona el archivo .ogg para las notas amarillas circulares. Si no eliges ninguno se omitirá y no cambiará.");
    var file_path = get_open_filename_ext(filter, ".ogg", false, global.current_language == "ENGLISH" ? "Upload an .ogg audio file for squared yellow notes." : "Sube un archivo de audio .ogg para notas amarillas circulares.");
    var sound_id = undefined;
    // If a valid file is selected
    if (string_length(file_path) != 0) {
        // Validate that the file has a .ogg extension
        if (string_pos(".ogg", file_path)) {
			var folder = "user1";
			if (sfx_index == 2) folder = "user2";
			var file_name1 = working_directory + "sounds\\sfx\\"+folder+"\\clap_drum.ogg"
            file_copy(file_path, file_name1);
            sound_id = audio_create_stream(file_name1); // Create an audio stream to access the file
            global.sound_effects[sfx_index][1] = sound_id;
        } else {
            show_message(global.current_language == "ENGLISH" ? "The selected file is not valid. Please select a file with the .ogg extension." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo con la extensión .ogg.");
        }
    } else {
        show_message(global.current_language == "ENGLISH" ? "No file selected." : "No se seleccionó ningún archivo.");
    }
	
	show_message(global.current_language == "ENGLISH" ? "Now select the .ogg for squared yellow notes. If you don't choose one, it will be skipped and won't change." : "Ahora selecciona el archivo .ogg para las notas amarillas cuadradas. Si no eliges ninguno se omitirá y no cambiará.");
	var file_path2 = get_open_filename_ext(filter, ".ogg", false, global.current_language == "ENGLISH" ? "Upload an .ogg audio file for squared yellow notes." : "Sube un archivo de audio .ogg para notas amarillas cuadradas.");
    var sound_id2 = undefined;
    // If a valid file is selected
    if (string_length(file_path2) != 0) {
        // Validate that the file has a .ogg extension
        if (string_pos(".ogg", file_path2)) {
			var folder = "user1";
			if (sfx_index == 2) folder = "user2";
			var file_name2 = working_directory + "sounds\\sfx\\"+folder+"\\snare_drum.ogg"
            file_copy(file_path2, file_name2);
            sound_id2 = audio_create_stream(file_name2); // Create an audio stream to access the file
            global.sound_effects[sfx_index][2] = sound_id2;
        } else {
            show_message(global.current_language == "ENGLISH" ? "The selected file is not valid. Please select a file with the .ogg extension." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo con la extensión .ogg.");
        }
    } else {
        show_message(global.current_language == "ENGLISH" ? "No file selected." : "No se seleccionó ningún archivo.");
    }
	
	show_message(global.current_language == "ENGLISH" ? "Now select the .ogg for purple notes. If you don't choose one, it will be skipped and won't change." : "Ahora selecciona el archivo .ogg para las notas moradas. Si no eliges ninguno se omitirá y no cambiará.");
	var file_path3 = get_open_filename_ext(filter, ".ogg", false, global.current_language == "ENGLISH" ? "Upload an .ogg audio file for purple notes." : "Sube un archivo de audio .ogg para notas moradas.");
    var sound_id3 = undefined;
    // If a valid file is selected
    if (string_length(file_path3) != 0) {
        // Validate that the file has a .ogg extension
        if (string_pos(".ogg", file_path3)) {
			var folder = "user1";
			if (sfx_index == 2) folder = "user2";
			var file_name3 = working_directory + "sounds\\sfx\\"+folder+"\\tambourine.ogg"
            file_copy(file_path3, file_name3);
            sound_id3 = audio_create_stream(file_name3); // Create an audio stream to access the file
            global.sound_effects[sfx_index][0] = sound_id3;
        } else {
            show_message(global.current_language == "ENGLISH" ? "The selected file is not valid. Please select a file with the .ogg extension." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo con la extensión .ogg.");
        }
    } else {
        show_message(global.current_language == "ENGLISH" ? "No file selected." : "No se seleccionó ningún archivo.");
    }
}