/// @description Insert description here
// You can write your code in this editor

draw_set_color(global.interface_color); 
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, global.interface_color, 1);
draw_set_color(c_white);

// Ocultar todas las capas inicialmente
layer_set_visible("SELECTED_ENGLISH_PC", false);
layer_set_visible("SELECTED_SPANISH_PC", false);
layer_set_visible("SELECTED_ENGLISH_CONTROLLER", false);
layer_set_visible("SELECTED_SPANISH_CONTROLLER", false);
draw_set_color(global.primary_color_yellow);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Determinar qué layer mostrar y aplicar el shader
if (global.current_language == "ENGLISH") {
    if (global.is_gamepad) {
        layer_set_visible("SELECTED_ENGLISH_CONTROLLER", true);
        layer_shader(layer_get_id("SELECTED_ENGLISH_CONTROLLER"), shader_hue_shift);
		draw_text(800,294,"ENGLISH");
    } else {
        layer_set_visible("SELECTED_ENGLISH_PC", true);
		layer_shader(layer_get_id("SELECTED_ENGLISH_PC"), shader_hue_shift);
		draw_text(800,294,"ENGLISH");
    }
} else {
    if (global.is_gamepad) {
        layer_set_visible("SELECTED_SPANISH_CONTROLLER", true);
        layer_shader(layer_get_id("SELECTED_SPANISH_CONTROLLER"), shader_hue_shift);
		draw_text(832,294,"CASTELLANO");
    } else {
        layer_set_visible("SELECTED_SPANISH_PC", true);
        layer_shader(layer_get_id("SELECTED_SPANISH_PC"), shader_hue_shift);
		draw_text(832,294,"CASTELLANO");
    }
}
