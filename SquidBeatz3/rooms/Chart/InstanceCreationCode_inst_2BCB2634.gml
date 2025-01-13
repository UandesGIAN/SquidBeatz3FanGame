texto = "Abrir";
texto_en = "Open";

action = function() {
	obj_chart_game.message_shown = 1;
	obj_chart_game2.message_shown = 1;
	obj_editor_button.blocked = 1;
	
    var char_data = obj_handle_chart_files.load_chart_from_file();
	if (char_data != undefined) {
		global.tempo = char_data[$ global.current_difficulty].tempo;
		global.current_chart = [];
		for (var i = 0; i < array_length(char_data[$ global.current_difficulty].chart); i++) {
			var element = char_data[$ global.current_difficulty].chart[i];
			array_push(global.current_chart, element);
		}
		global.start_point = char_data[$ global.current_difficulty].start_point;
		global.base_x = global.start_point;
		obj_chart_game.index_bar = 0;
		obj_chart_game.conteo_desplazamiento = 0;
		obj_chart_game.game_bar[0].x = global.start_point;
		for (var i = 1; i < 4; i++) {
		    obj_chart_game.game_bar[i].x = obj_chart_game.game_bar[i-1].x + obj_chart_game.sprite_width;
		}
	}
	
	obj_chart_game.message_shown = 0;
	obj_chart_game2.message_shown = 0;
	obj_editor_button.blocked = 0;
};