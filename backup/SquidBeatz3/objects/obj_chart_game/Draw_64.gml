/// @description Insert description here
// You can write your code in this editor

layer_set_visible("EDITOR_PC", false);
layer_set_visible("EDITOR_PC_ENGLISH", false);
layer_set_visible("BG_2", false);
layer_set_visible("BG_2_ENGLISH", false);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(splat_font_title);
draw_set_color(global.primary_color_yellow);
draw_text_ext_transformed(289, 98, global.current_language == "ENGLISH" ? "Controls" : "Controles", 0, 100, 0.964, 0.896839, 0)

layer_set_visible(global.current_language == "ENGLISH" ? "BG_2_ENGLISH" : "BG_2", true);
layer_set_visible(global.current_language == "ENGLISH" ? "EDITOR_PC_ENGLISH" : "EDITOR_PC", true);
layer_shader(global.current_language == "ENGLISH" ? "EDITOR_PC_ENGLISH" : "EDITOR_PC", shader_hue_shift);