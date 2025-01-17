/// @description Insert description here
// You can write your code in this editor

sprite_index = global.bg_options[global.current_bg_index];

if (sprite_get_width(sprite_index) > room_width) {
	image_xscale = (sprite_get_width(sprite_index) / room_width) - 0.8;
	show_debug_message("w: " + string(sprite_get_width(sprite_index)) + " | c: " + string(sprite_get_width(sprite_index) / room_width));
} else {
	image_xscale = (room_width / sprite_get_width(sprite_index)) + 1;
}


if (sprite_get_height(sprite_index) > room_height) {
	image_yscale = (sprite_get_height(sprite_index) / room_height) - 0.6;
	show_debug_message("h: " + string(sprite_get_height(sprite_index)) + " | c: " + string(sprite_get_height(sprite_index) / room_height));
} else {
	image_yscale = (room_height / sprite_get_height(sprite_index)) + 1;
}


if (global.current_bg_index >= 2) image_alpha = 0.64;