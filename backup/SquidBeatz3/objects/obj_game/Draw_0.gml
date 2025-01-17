/// @description Insert description here
// You can write your code in this editor

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(splat_font_title);
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, global.interface_color_secondary, 1);
draw_set_color(c_white);

draw_set_color(c_aqua);
draw_set_font(splat_font_small);
if (checkpoint_start != -1) draw_text(checkpoint_text_x - 1, 400, "C");