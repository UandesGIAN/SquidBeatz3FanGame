texto = "Salir";
texto_en = "Exit";

action = function() {
	obj_chart_game.message_shown = 1;
	obj_chart_game2.message_shown = 1;
	obj_editor_button.blocked = 1;
	
	obj_exit_chart.message_shown = !obj_exit_chart.message_shown;
}