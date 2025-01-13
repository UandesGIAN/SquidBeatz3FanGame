/// @description Insert description here
// You can write your code in this editor

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(global.interface_color); 
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, global.interface_color, 1);

draw_set_color(c_white);

if (global.lifebar && (global.is_playing || global.practice_mode)) {
	
	draw_set_color(global.primary_color_yellow);
	draw_set_font(splat_font_title);
	if (!auto_bot_enabled) draw_text(85 - (global.current_language == "ENGLISH" ? string_width("LIFE") : 3+string_width("VIDA")), 360, global.current_language == "ENGLISH" ? "LIFE" : "VIDA");
	else draw_text(85 - string_width("BOT"), 360, "BOT");; 
	draw_rectangle(63, 358, 65, 158, 0);
	if (obj_play.play_music && !global.practice_mode) {
		draw_set_color(global.secondary_color_purple);
		draw_rectangle(52, 352, 78, 352-current_life*2, 0);
		for (var i = 0; i < current_life/10; i++) {
			draw_set_color(c_white);
			draw_rectangle(52, 352-i*20, 78, 352-(i*20) - 20, 1);
		}
	}
	draw_set_color(c_white);
	draw_rectangle(32, 358, 94, 352, 0);
}