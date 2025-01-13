/// @description Insert description here
// You can write your code in this editor

// Variables del botón
texto = "";       // Texto por defecto
texto_en = "";       // Texto por defecto
color_normal = c_dkgrey; // Color normal del texto

color_presionado = make_color_rgb(50, 50, 50); // Color temporal al presionar

game_controller_message = 0;
ancho = sprite_width; // Ancho del botón (basado en el sprite)
alto = sprite_height; // Alto del botón (basado en el sprite)
seleccionado = 0;
action = noone;
blocked = 0;
// Estados
mouse_encima = false;
presionado = false;
tiempo_presionado = 500; // Duración en segundos
temporizador_presionado = 0;

salir_text_color = c_white;