/// @description Insert description here
// You can write your code in this editor

draw_set_font(splat_font_title)

draw_self();
if (current_time - temporizador_presionado < 250) {
	draw_set_color(c_dkgrey); // Reset color
	draw_set_alpha(0.5);
    draw_rectangle_color(x, y, x + ancho, y + alto, color_presionado, color_presionado, color_presionado, color_presionado, false);
}
draw_set_color(c_white); // Reset color
draw_set_alpha(1);


// Cambiar color del texto si el mouse está encima
var color_actual = (mouse_encima || seleccionado) ? global.primary_color_yellow : color_normal;

// Dibujar texto centrado
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(color_actual);
if (global.current_language == "ENGLISH") draw_text(x + ancho / 2, y + alto / 2, texto_en);
else draw_text(x + ancho / 2, y + alto / 2, texto);