/// @description Insert description here
// You can write your code in this editor

shader_set(shader_hue_shift);
shader_set_uniform_f(shader_get_uniform(shader_hue_shift, "hue_shift"), global.hue_shift);

// Dibujar el sprite con el shader
draw_self();

shader_reset();
