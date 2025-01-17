/// @description Insert description here
// You can write your code in this editor
draw_set_font(splat_font_title);
draw_set_color(c_white);
draw_set_halign(fa_left);

shader_set(shader_hue_shift);
shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);

draw_sprite(spr_logo, 0, 256, 128);

shader_reset();

draw_set_halign(fa_right);
if (current_load != 5) {
	if (global.current_language == "ENGLISH") draw_text(room_width-20, room_height -50, "LOADING...")
	else draw_text(room_width-20, room_height -50, "CARGANDO...");
} else {
	draw_set_color(global.primary_color_yellow);
	if (global.current_language == "ENGLISH") draw_text(room_width-20, room_height -50, "LOADING: DONE.")
	else draw_text(room_width-20, room_height -50, "CARGANDO: TERMINADO.");
}

draw_set_halign(fa_left);


if (current_load != 5) {
	if (global.current_language == "ENGLISH") draw_text(5, room_height -50, "LOADING: Songs...SFX...Backgrounds...Dances...Save data...")
	else draw_text(5, room_height -50, "CARGANDO: Canciones...SFX...Fondos...Bailes...Datos de guardado...");
}
