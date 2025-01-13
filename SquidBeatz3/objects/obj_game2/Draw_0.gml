/// @description Insert description here
// You can write your code in this editor

if (global.is_playing) {
	// Color y fuente para el texto
	draw_set_color(global.secondary_color_purple);
	draw_set_font(splat_font_title);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	switch (global.current_difficulty) {
		case ("easy"):
			if (global.current_language == "ENGLISH") draw_text(x+25, y+20, "Easy");
			else draw_text(x+25, y+20, "Facil");
			break;
		case ("normal"):
			draw_text(x+25, y+20, "Normal");
			break;
		case ("hard"):
			if (global.current_language == "ENGLISH") draw_text(x+25, y+20, "Hard");
			else draw_text(x+25, y+20, "Dificil");
			break;
	}
	
	draw_set_color(c_white);
	
	var text_y = y + 15;
	
	if (obj_play.play_music) {
		// 2. Dibujar el sprite de plata (spr_silver) con su contador
		if (global.octo_icons) draw_sprite(spr_silver_octo, 0, x, text_y + 55);
		else draw_sprite(spr_silver, 0, x, text_y + 55); // Ajusta la posición según tu diseño
		draw_text(x + 100, text_y + 50, string(obj_sync.local_count_silver)); // Texto al lado del sprite
	
		// 3. Dibujar el sprite de oro (spr_gold) con su contador
		if (global.octo_icons) draw_sprite(spr_gold_octo, 0, x, text_y + 110);
		else draw_sprite(spr_gold, 0, x, text_y + 110); // Ajusta la posición según tu diseño
		draw_text(x + 100, text_y + 100, string(obj_sync.local_count_gold)); // Texto al lado del sprite

		// 4. Dibujar el texto "/total_notes" alineado debajo a la derecha
		draw_text(x + 125, text_y + 150, string(obj_sync.local_total_hits) + "/" + string(total_notes)); // Ajusta la posición
	} else {
		if (global.octo_icons) draw_sprite(spr_silver_octo, 0, x, text_y + 55);
		else draw_sprite(spr_silver, 0, x, text_y + 55); // Ajusta la posición según tu diseño
		draw_text(x + 100, text_y + 50, string(global.game_points[$ global.current_difficulty].count_silver[global.current_chart_index])); // Texto al lado del sprite
	
		// 3. Dibujar el sprite de oro (spr_gold) con su contador
		if (global.octo_icons) draw_sprite(spr_gold_octo, 0, x, text_y + 110);
		else draw_sprite(spr_gold, 0, x, text_y + 110); // Ajusta la posición según tu diseño
		draw_text(x + 100, text_y + 100, string(global.game_points[$ global.current_difficulty].count_gold[global.current_chart_index])); // Texto al lado del sprite

		// 4. Dibujar el texto "/total_notes" alineado debajo a la derecha
		draw_text(x + 125, text_y + 150, string(global.game_points[$ global.current_difficulty].total_hits[global.current_chart_index]) + "/" + string(total_notes)); // Ajusta la posición
	}
}
