texto = "Exportar";
texto_en = "Export";

action = function() {
    if (array_length(global.current_chart) > 0 && global.new_song_id == undefined && global.new_song_name == "") {
		show_message(global.current_language == "ENGLISH" ? "IMPORTANT: This function exports the charting for the 3 difficulties in the current song." : "IMPORTANTE: Esta función exporta los charteos para las 3 dificultades en la canción actual.");
		obj_chart_game.message_shown = 1;
		obj_chart_game2.message_shown = 1;
		obj_editor_button.blocked = 1;
		
		obj_handle_chart_files.export_chart_to_file(global.tempo, global.current_chart, global.start_point);
		obj_chart_game.message_shown = 0;
		obj_chart_game2.message_shown = 0;
		obj_editor_button.blocked = 0;
   } else {
	   show_message(global.current_language == "ENGLISH" ? "You can only save the current chart as a file if there is an element present or if it's not a new song that hasn't been saved." : "Sólo es posible guardar el charteo actual en un archivo si hay algún elemento presente o si no es una nueva canción que no ha sido guardada.");
   }
};