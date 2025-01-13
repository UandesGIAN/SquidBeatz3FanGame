texto = "Borrar todo";
texto_en = "Delete all";

action = function() {
	obj_chart_game.message_shown = 1;
	obj_chart_game2.message_shown = 1;
	obj_editor_button.blocked =1;
	
	if (show_question(global.current_language == "ENGLISH" ? "Are you sure?\nThis action will erase each element at the current chart.": "Estás seguro?\nEsta acción borrará todos los elementos del chart actual.")) {
		global.current_chart = [];
	}
	
	obj_chart_game.message_shown = 0;
	obj_chart_game2.message_shown = 0;
	obj_editor_button.blocked = 0;
};