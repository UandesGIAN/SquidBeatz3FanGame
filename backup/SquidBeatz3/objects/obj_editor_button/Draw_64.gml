/// @description Insert description here
// You can write your code in this editor

if (game_controller_message) {
	draw_set_color(c_dkgrey);
	draw_rectangle(room_width / 2 - 250,room_height / 2 - 100, room_width / 2 + 250, room_height / 2 + 100, 0);
	draw_set_color(c_white);
	draw_rectangle(room_width / 2 - 250,room_height / 2 - 100, room_width / 2 + 250, room_height / 2 + 100, 1);
	draw_set_halign(fa_center);
	
	draw_set_font(splat_font_title);
	if (global.current_language == "ENGLISH") {
		draw_text(room_width / 2, room_height / 2-15, "You can not use this function with a")
		draw_text(room_width / 2, room_height / 2+15, "game controller, switch to keyboard.")
	} else {
		draw_text(room_width / 2, room_height / 2-15, "No puedes acceder a esta funcion usando")
		draw_text(room_width / 2, room_height / 2+15, "un control, cambia a teclado.")
	}
	
	// Botón de "SALIR"
    draw_set_color(global.secondary_color_purple);
    if (global.current_language == "ENGLISH") draw_text(room_width / 2, room_height / 2 + 100 - 25, "EXIT");
	else draw_text(room_width / 2, room_height / 2 + 100 - 25, "SALIR");
	draw_set_color(c_white);
	draw_sprite(spr_b_button, 0, room_width / 2 + 50, room_height / 2 + 64);
}