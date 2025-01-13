/// @description Insert description here
// You can write your code in this editor

// Al presionar espacio inicia/detiene la musica
if (((keyboard_check_pressed(vk_space) && !global.is_gamepad) || (global.is_gamepad && gamepad_button_check_pressed(global.current_gamepad, gp_start))) && global.current_song != undefined) {
    if (sprite_index == spr_pause) {
        sprite_index = spr_play;
		
		var tiempo_inicio = 0;
		if (global.practice_mode) {
            tiempo_inicio = ((global.start_point + global.base_x) / (global.tempo * (132 / 60)));
        }
		audio_sound_set_track_position(global.current_song, tiempo_inicio);
		sound_playing = audio_play_sound(global.current_song, 1, 0);
		play_music = 1;
    }
    else if (sprite_index == spr_play) {
        sprite_index = spr_pause;
		audio_stop_sound(global.current_song);
		play_music = 0;
		sound_playing = -1;
		obj_game2.processed_elements = [];
    }
}

if (((keyboard_check_pressed(ord("P")) && !global.is_gamepad) || (global.is_gamepad && (gamepad_button_check(global.current_gamepad, gp_shoulderr)) && gamepad_button_check_pressed(global.current_gamepad, gp_padd))) && global.is_playing && !play_music) {
	global.practice_mode = !global.practice_mode
	if (obj_game.checkpoint_start != -1) {
		obj_game.checkpoint_start = -1;
		obj_game.checkpoint_text_x = -1;
		obj_game.checkpoint_base_x = 0;
		obj_game.index_bar_checkpoint = 0;
		obj_game.conteo_d_checkpoint = 0;
		obj_game.count_silver_checkpoint = 0;
		obj_game.count_gold_checkpoint = 0;
		obj_game.total_hits_checkpoint = 0;
		obj_game.cei_1_checkpoint = 0;
	}
}

if (((keyboard_check_pressed(ord("1")) && !global.is_gamepad) || (global.is_gamepad && (gamepad_button_check(global.current_gamepad, gp_shoulderl)) && gamepad_button_check_pressed(global.current_gamepad, gp_face4))) && (!global.is_playing || !play_music)) {
	if (global.current_song != undefined) audio_stop_sound(global.current_song);
	if (audio_is_playing(game_over_sfx)) audio_stop_sound(game_over_sfx);
	
	global.practice_mode = 0;
	room_goto(Settings);
}

// Controles para manejar la seleccion de canciones
if (!play_music && ((keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_down)) && !global.is_gamepad) || !play_music && ((global.is_gamepad && !stick_moved && ((gamepad_axis_value(global.current_gamepad, gp_axislh) < -0.5)
	|| (gamepad_axis_value(global.current_gamepad, gp_axislv) > 0.5)) ) )) {

	global.current_song_index--;
	if (global.current_song_index == -1) {
		global.current_song_index = array_length(global.song_text_list)-1
	}
	if (play_music == 1) {	// Al cambiar de cancion se detiene la musica y charteo
		audio_stop_sound(global.current_song);
		global.is_playing = 0;
		sprite_index = spr_pause;
		play_music = 0;
		sound_playing = -1;
	}
	global.current_song = global.song_list[global.current_song_index]
    global.current_chart_index = global.current_song_index;
	global.tempo = global.charts[$ global.current_difficulty].tempo[global.current_chart_index];
	global.start_point = global.charts[$ global.current_difficulty].start_point[global.current_chart_index];
	
	if (global.practice_mode) {
		obj_game.checkpoint_start = -1;
		obj_game.checkpoint_text_x = -1;
		obj_game.checkpoint_base_x = 0;
					
		obj_game.index_bar_checkpoint = 0;
		obj_game.conteo_d_checkpoint = 0;
		obj_game.count_silver_checkpoint = 0;
		obj_game.count_gold_checkpoint = 0;
		obj_game.total_hits_checkpoint = 0;
		obj_game.cei_1_checkpoint = 0;
	}
	global.practice_mode = 0;
	
	
	stick_moved = 1;
	obj_sync.game_win_for_first_time = 0;
	if (array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]) - global.game_points[$ global.current_difficulty].total_hits[global.current_chart_index] == 0)
		obj_sync.game_win = 1;
	else
		obj_sync.game_win = 0;
}

if (!play_music && ((keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_up)) && !global.is_gamepad) || !play_music && ((global.is_gamepad && !stick_moved && ((gamepad_axis_value(global.current_gamepad, gp_axislh) > 0.5) ||
	(gamepad_axis_value(global.current_gamepad, gp_axislv) < -0.5)) ) )) {

	global.current_song_index++;
	if (global.current_song_index == array_length(global.song_text_list)) {
		global.current_song_index = 0
	}
	
	if (play_music == 1) { // Al cambiar de cancion se detiene la musica y charteo
		audio_stop_sound(global.current_song);
		global.is_playing = 0;
		sprite_index = spr_pause;
		play_music = 0;
		sound_playing = -1;
	}
	global.current_song = global.song_list[global.current_song_index]
	global.current_chart_index = global.current_song_index;
	
	if (global.practice_mode) {
		obj_game.checkpoint_start = -1;
		obj_game.checkpoint_text_x = -1;
		obj_game.checkpoint_base_x = 0;
					
		obj_game.index_bar_checkpoint = 0;
		obj_game.conteo_d_checkpoint = 0;
		obj_game.count_silver_checkpoint = 0;
		obj_game.count_gold_checkpoint = 0;
		obj_game.total_hits_checkpoint = 0;
		obj_game.cei_1_checkpoint = 0;
	}
	global.practice_mode = 0;
	
	global.tempo = global.charts[$ global.current_difficulty].tempo[global.current_chart_index];
	global.start_point = global.charts[$ global.current_difficulty].start_point[global.current_chart_index];
	
	stick_moved = 1;
	obj_sync.game_win_for_first_time = 0;
	if (array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]) - global.game_points[$ global.current_difficulty].total_hits[global.current_chart_index] == 0)
		obj_sync.game_win = 1;
	else
		obj_sync.game_win = 0;
}

if (global.is_gamepad && abs(gamepad_axis_value(global.current_gamepad, gp_axislh)) < 0.5 && abs(gamepad_axis_value(global.current_gamepad, gp_axislv)) < 0.5) stick_moved = false;
// Shift to enter the chart editor
if (keyboard_check_pressed(vk_shift) && !global.is_gamepad) {
    // If it's a new song
    if (global.current_song == undefined) {
        // Prompt the user to add the song's audio file
        show_message(global.current_language == "ENGLISH" 
		    ? "To add a new song, include the audio file of the song. It must be in .ogg format; other formats are not supported.\nAdditionally, you need to add a .json visualizer file for the song. If it is not included, the song will not have a waveform visualizer." 
		    : "Para agregar una nueva canción, incluye el archivo de audio de la canción. Debe estar en formato .ogg; otros formatos no son compatibles.\nAdemás, debes agregar un archivo .json de visualizador para la canción. Si no se agrega, la canción no tendrá un visualizador de onda.");
        var result = obj_handle_add_song.add_song();
        if (result) {
            global.current_chart_index = array_length(global.song_list);
            global.current_difficulty = "easy";
        }
    } else {
		if (audio_is_playing(game_over_sfx)) audio_stop_sound(game_over_sfx);
        audio_stop_sound(global.current_song);
        global.practice_mode = 0;
		
        room_goto(Chart);
    }
}

// Volume control
if (keyboard_check_pressed(vk_subtract) && !keyboard_check(vk_control) && global.current_song != undefined) {
	volume_count -= 0.2;
    audio_sound_gain(global.current_song, max(0, volume_count), 0);
}
if (keyboard_check_pressed(vk_add) && !keyboard_check(vk_control) && global.current_song != undefined) {
	volume_count += 0.2;
    audio_sound_gain(global.current_song, min(volume_count, 2), 0);
}
// Sound delay control
if (keyboard_check_pressed(vk_subtract) && keyboard_check(vk_control)) {
	global.sound_delay -= 0.5;
	if (global.sound_delay < -10) global.sound_delay = -10;
}
if (keyboard_check_pressed(vk_add) && keyboard_check(vk_control)) {
	global.sound_delay += 0.5;
	if (global.sound_delay > 10) global.sound_delay = 10;
}

// Control for loading/exporting songs
// Load all song files from a zip if they have the necessary structure
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("O")) && !global.is_gamepad) {
    show_message(global.current_language == "ENGLISH" ? "LOAD SONGS\n\nTo load songs, select a ZIP file with a parent folder named 'sounds' that contains 'songs/charts/', .ogg, .json files, and a 'song_titles.json' file.\n\nTHIS ACTION WILL MODIFY LOCAL GAME FILES AND ADD SONGS THAT DO NOT HAVE DUPLICATE NAMES." : "CARGAR CANCIONES\n\nPara cargar canciones debes seleccionar un archivo ZIP que posea una carpeta padre llamada 'sounds', que debe poseer las rutas 'songs/charts/', archivos .ogg, .json compatibles y un archivo llamado 'song_titles.json'.\n\nESTA ACCIÓN MODIFICARÁ LOS ARCHIVOS DEL JUEGO LOCAL Y AGREGARÁ LAS CANCIONES A LAS QUE YA EXISTEN, SI ES QUE NO POSEEN NOMBRES DUPLICADOS.");
        
    var filter = "(*.zip)|*.zip|*.*";
    var file_path = get_open_filename_ext(filter, ".zip", false, "Select a compatible ZIP file");
        
    if (file_path != "") {
        if (string_pos(".zip", file_path)) {
            directory_create(working_directory + "load_songs");
            var ret = zip_unzip(file_path, working_directory + "load_songs");
                
            if (ret <= 0) {
                show_message(global.current_language == "ENGLISH" ? "An error occurred while extracting the .zip file." : "Ocurrió un error al extraer el archivo .zip.");
            }
                
            load_songs_from_directory(working_directory + "load_songs\\sounds");
            directory_destroy(working_directory + "load_songs");
			
        } else {
            show_message(global.current_language == "ENGLISH" ? "The selected file is not valid. Please select a compatible .zip file." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo .zip compatible.");
        }
    } else {
        show_message(global.current_language == "ENGLISH" ? "No file selected." : "No se seleccionó ningún archivo.");
    }
}
    
// Export songs from a start to end range defined by the user
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("E")) && !global.is_gamepad) {
    show_message(global.current_language == "ENGLISH" ? "EXPORT SONGS\n\nTo export songs, select a range of songs to export, from 1 to " + string(array_length(global.song_list) - 1) + ". Then, you will be prompted for a directory to save the files compressed into a zip.\n\nYOU CAN LOAD THIS ZIP AT ANY TIME WITH CTRL+O." : "EXPORTAR CANCIONES\n\nPara exportar canciones debes seleccionar un rango de canciones para exportar, puede ir desde 1 a " + string(array_length(global.song_list) - 1) + ". Luego se te pedirá que indiques una ruta donde exportar los archivos comprimidos en un zip.\n\nLUEGO PUEDES CARGAR ESE ZIP EN CUALQUIER MOMENTO CON CTRL+O.");
    export_step = 0; // Reset step
    start_song_i = -1;
    end_song_i = -1;
    global.export_async_id = get_string_async(global.current_language == "ENGLISH" ? "Enter the number of the song from which to export.\nMust be a number between 1 and " + string(array_length(global.song_list) - 1) + "." : "Ingrese el número de la canción desde la cual se exportará.\nDebe ser un número entre 1 y " + string(array_length(global.song_list) - 1) + ".", "");
}
    
// Delete songs in a range from the user
if (keyboard_check(vk_control) && keyboard_check(vk_alt) && keyboard_check_pressed(ord("D")) && !global.is_gamepad) {
    show_message(global.current_language == "ENGLISH" ? "DELETE SONGS\n\nWarning! Deleting songs is IRREVERSIBLE. If you want to save a backup of the songs, charts, and names, you should export them using Ctrl+E.\n\nTo delete songs, you'll be prompted to enter a range of songs to delete. They will be removed from the game files, along with their progress and chart data." : "ELIMINAR CANCIONES\n\nAdvertencia! Eliminar canciones es una acción IRREVERSIBLE, si quieres guardar una copia de las canciones, charteos y nombres, debes exportar las canciones que deseas con ctrl+E.\n\nPara eliminar canciones se te pedirá que ingreses el rango de canciones a borrar y luego se elimninarán de los archivos del juego, junto al progreso.");
    delete_step = 0; // Reset step
    start_song_i = -1;
    end_song_i = -1;
    global.delete_async_id = get_string_async(global.current_language == "ENGLISH" ? "Enter the number of the song from which to delete.\nMust be a number between 1 and " + string(array_length(global.song_list) - 1) + "." : "Ingrese el número de la canción desde la cual se borrará.\nDebe ser un número entre 1 y " + string(array_length(global.song_list) - 1) + ".", "");
}


// Delete a specific song directly without further prompts
if (keyboard_check(vk_control) && !global.is_gamepad && keyboard_check_pressed(ord("D")) && global.current_chart_index != 0 && global.current_song_index != 0) {
    show_message(global.current_language == "ENGLISH" ? "DELETE SONG\n\nWarning! Deleting a song is IRREVERSIBLE. If you want to save a copy of this song, you should export it using Ctrl+E." : "ELIMINAR CANCIÓN\n\n¡Advertencia! Eliminar una canción es una acción IRREVERSIBLE, si quieres guardar una copia de esta canción, debes exportar las canciones que deseas con ctrl+E.");
    if (1 == show_question(global.current_language == "ENGLISH" ? "Are you sure you want to continue?\n\nDeleting this song will remove its files, progress, and chart data. Remember, you can make a backup in ZIP format with Ctrl+E and then load it with Ctrl+O." : "Seguro que quieres continuar?\n\nEliminar esta canción borrará sus archivos, datos de progreso y datos de charteo. Recuerda que puedes hacer una copia en formato ZIP con ctrl+E y el índice de la canción, y luego cargarlo con ctrl+O.")) {
        handle_delete_files(global.current_song_index, global.current_song_index);
    }
}
if (keyboard_check(vk_control) && !global.is_gamepad && keyboard_check_pressed(ord("S")) && !global.practice_mode) {
    show_message(global.current_language == "ENGLISH" ? "SAVE PROGRESS DATA\n\nYou will now be prompted to save a file containing information about each song, your score, and any changes you’ve made to the settings. To load this file, you must do so from the settings menu using the mouse and keyboard.\nIf you wish to back up your data and game files, you must export the songs first and then load the save file. This is because, for the data to load, the song chart in the save file and in the game files are compared, if they match, the data is loaded; else, it is not.\n\n" : "GUARDAR DATOS DE PROGRESO\n\nA continuación se te pedirá que guardes un archivo de guardado con información de cada canción, tu puntaje y los cambios que hayas realizado en los ajustes. Para cargar este archivo debes hacerlo desde los ajustes y usando el mouse y teclado.\nSi deseas guardar una copia de seguridad de tus datos y los archivos del juego, debes exportar las canciones primero, luego cargar el archivo de guardado, pues para que se carguen los datos, se comparan los datos de charteo en el archivo de guardado y en los archivos del juego, si coinciden, se cargan los datos, si no, no.");
    
	if (1 == show_question(global.current_language == "ENGLISH" ? "Do you want to REPLACE the file with data AT the game files?\nIf you choose no, you will be prompted to create a .ini file to save the game data." : "¿Deseas REEMPLAZAR el archivo de guardado EN los archivos del juego?\nSi eliges que no, se te pedirá que crees un archivo .ini donde guardar los datos del juego.")) {
		obj_handle_savedata.save_ini_data();
		show_message(global.current_language == "ENGLISH" ?  "Game data saved successfully." : "Datos de guardado exportados éxitosamente.")
	} else {
		// Abrir explorador de archivos para guardar
	    var filter = "*.ini|*.*";
	    var file_name = get_save_filename(filter, "save_data.ini");
	
		if (string_length(file_name) > 0) {
			if (string_pos(".ini", file_name)) {
				obj_handle_savedata.save_ini_data(file_name);
				show_message(global.current_language == "ENGLISH" ?  "Game data saved successfully at " + string(file_name) + "." : "Datos de guardado exportados éxitosamente en " + string(file_name) + ".")
			} else {
				show_message(global.current_language == "ENGLISH" ? "The selected file is invalid. Please select a file with the .ini extension." : "El archivo seleccionado no es válido. Por favor, selecciona un archivo con la extensión .ini.");
			}
		} else {
			show_message(global.current_language == "ENGLISH" ? "No file was created." : "No se creó ningún archivo.");
		}
	}

}