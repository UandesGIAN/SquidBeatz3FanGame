
sprite_index = global.bg_options[global.current_bg_index];
image_xscale = 64 / sprite_get_width(sprite_index);
image_yscale = 64 / sprite_get_height(sprite_index);

draw_self();
draw_set_color(c_white);
draw_rectangle(x, y, x + sprite_width, y + sprite_height, true);
