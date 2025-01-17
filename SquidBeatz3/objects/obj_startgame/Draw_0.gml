/// @description Insert description here
// You can write your code in this editor
draw_set_font(splat_font_title);
draw_set_color(c_white);
draw_set_halign(fa_left);

shader_set(shader_hue_shift);
shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);

draw_sprite(spr_logo, 0, 256, 128);

shader_reset();

show_debug_message(string(current_load) + "  " + string(gradual_load));

draw_set_halign(fa_right);

if (current_load == 0) {
	draw_set_color(global.primary_color_yellow);
	if (global.current_language == "ENGLISH") draw_text(room_width-20, room_height -60, "Songs...")
	else draw_text(room_width-20, room_height -60, "Canciones...");
} else if (current_load = 1) {
	draw_set_color(global.primary_color_yellow);
	if (global.current_language == "ENGLISH") draw_text(room_width-20, room_height -60, "SFX...")
	else draw_text(room_width-20, room_height -60, "Sonidos...");
} else if (current_load = 2) {
	draw_set_color(global.primary_color_yellow);
	if (global.current_language == "ENGLISH") draw_text(room_width-20, room_height -60, "Backgrounds...")
	else draw_text(room_width-20, room_height -60, "Fondos...");
} else if (current_load = 3) {
	draw_set_color(global.primary_color_yellow);
	if (global.current_language == "ENGLISH") draw_text(room_width-20, room_height -60, "Dances...")
	else draw_text(room_width-20, room_height -60, "Bailes...");
} else if (current_load = 4) {
	draw_set_color(global.primary_color_yellow);
	if (global.current_language == "ENGLISH") draw_text(room_width-20, room_height -60, "Save data...")
	else draw_text(room_width-20, room_height -60, "Datos de guardado...");
} else {
	draw_set_color(global.primary_color_yellow);
	if (global.current_language == "ENGLISH") draw_text(room_width-20, room_height -60, "DONE.")
	else draw_text(room_width-20, room_height -60, "TERMINADO.");
}


draw_set_halign(fa_left);
// Dibujar barra de progreso
var bar_width = room_width - 40; // Ancho total de la barra
var bar_height = 20; // Altura de la barra
var bar_x = 20; // Posición X de la barra
var bar_y = room_height - 80; // Posición Y de la barra
var progress = (current_load + gradual_load) / 5; // Progreso (0 a 1)
if (current_load == 5)  progress = (current_load) / 5;

// Fondo de la barra
draw_set_color(c_black);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

// Progreso de la barra
draw_set_color(global.primary_color_yellow);
draw_rectangle(bar_x, bar_y, bar_x + (bar_width * progress), bar_y + bar_height, false);

// Borde de la barra
draw_set_color(c_white);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);