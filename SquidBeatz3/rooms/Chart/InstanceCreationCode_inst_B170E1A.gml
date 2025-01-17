texto = "Cargar previo";
texto_en = "Load previous";

action = function() {
	if (global.new_song_id == undefined || global.new_song_name == "") {
		switch (global.current_difficulty) {
			case "easy":
				if ((array_length(global.charts.normal.charts[global.current_chart_index]) > 0 ||
					array_length(global.charts.hard.charts[global.current_chart_index]) > 0)) {
					obj_exit_chart.load_shown = !obj_exit_chart.load_shown;
					obj_chart_game.message_shown = 1;
					obj_chart_game2.message_shown = 1;
					obj_editor_button.blocked = 1;
					obj_exit_chart.already_check_load = 1;
				} else {
					show_message(global.current_language == "ENGLISH" ? "It is only possible to load a previous chart if there's a previous difficulty with a chart" : "Sólo es posible cargar un charteo anterior si alguno tiene elementos.");
				}
				break;
			case "normal":
				if ((array_length(global.charts.easy.charts[global.current_chart_index]) > 0 ||
					array_length(global.charts.hard.charts[global.current_chart_index]) > 0)) {
					obj_exit_chart.load_shown = !obj_exit_chart.load_shown;
					obj_exit_chart.already_check_load = 1;
					obj_chart_game.message_shown = 1;
					obj_chart_game2.message_shown = 1;
					obj_editor_button.blocked = 1;
				} else {
					show_message(global.current_language == "ENGLISH" ? "It is only possible to load a previous chart if there's a previous difficulty with a chart" : "Sólo es posible cargar un charteo anterior si alguno tiene elementos.");
				}
				break;
			case "hard":
				if ((array_length(global.charts.easy.charts[global.current_chart_index]) > 0 ||
					array_length(global.charts.normal.charts[global.current_chart_index]) > 0)) {
					obj_exit_chart.load_shown = !obj_exit_chart.load_shown
					obj_chart_game.message_shown = 1;
					obj_chart_game2.message_shown = 1;
					obj_editor_button.blocked = 1;
					obj_exit_chart.already_check_load = 1;
				} else {
					show_message(global.current_language == "ENGLISH" ? "It is only possible to load a previous chart if there's a previous difficulty with a chart" : "Sólo es posible cargar un charteo anterior si alguno tiene elementos.");
				}
				break;
		}
	} else {
		show_message(global.current_language == "ENGLISH" ? "It is only possible to load a previous chart after saving the new song." : "Sólo es posible cargar un charteo anterior tras guardar la nueva canción.");
	}
};