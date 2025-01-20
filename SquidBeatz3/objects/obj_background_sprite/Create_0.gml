/// @description Insert description here
// You can write your code in this editor

sprite_index = global.bg_options[global.current_bg_index];

if (room_width <= sprite_get_width(sprite_index)) image_xscale = (room_width / sprite_get_width(sprite_index)) + 0.15;
else image_xscale = (room_width / sprite_get_width(sprite_index))+1;

if (room_height <= sprite_get_height(sprite_index)) image_yscale = (room_height / sprite_get_height(sprite_index)) + 0.15;
else image_yscale = (room_height / sprite_get_height(sprite_index))+1;

if (global.current_bg_index >= 2) image_alpha = 0.64;