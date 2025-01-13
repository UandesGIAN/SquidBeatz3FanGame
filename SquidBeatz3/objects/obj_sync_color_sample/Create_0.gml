/// @description Insert description here
// You can write your code in this editor

blocked = 0;
botones = [inst_3C176DDB,inst_166D24AD,inst_3CE10DF4,inst_178EA49E,inst_C7C044D, inst_6E921BA9, inst_634093B4,inst_ACAC26,inst_2BA4B279];
indice_actual = 0;
if (global.is_gamepad) botones[indice_actual].seleccionado = 1;

stick_moved = 0;

// Valores iniciales de color
red = color_get_red(global.interface_color); // Extrae el valor de rojo
green = color_get_green(global.interface_color);  // Extrae el valor de verde
blue = color_get_blue(global.interface_color);
color_actual = global.interface_color;

red_secondary = color_get_red(global.interface_color_secondary); // Extrae el valor de rojo
green_secondary = color_get_green(global.interface_color_secondary);  // Extrae el valor de verde
blue_secondary = color_get_blue(global.interface_color_secondary);
color_actual_secondary = global.interface_color_secondary;
hue_shift = global.hue_shift;

slider_color = [red, green, blue, red_secondary, green_secondary, blue_secondary, hue_shift];

dialog_width = 500;
dialog_height = 450;

// Centro de la pantalla
dialog_x = (room_width - dialog_width) / 2;
dialog_y = (room_height - dialog_height) / 2;

// Posiciones y dimensiones de los sliders
slider_width = 200;
slider_height = 10;
slider_spacing = 20;
slider_start_x = dialog_x + 40;
slider_start_y = 225;
salir_text_color = c_white;
// Posiciones de los manejadores (handles) de los sliders
handle_red_x = slider_start_x + (red / 255) * slider_width;
handle_green_x = slider_start_x + (green / 255) * slider_width;
handle_blue_x = slider_start_x + (blue / 255) * slider_width;

handle_red_x_secondary = slider_start_x + slider_width + 20 + (red_secondary / 255) * slider_width; // Corregido
handle_green_x_secondary = slider_start_x + slider_width + 20 + (green_secondary / 255) * slider_width; // Corregido
handle_blue_x_secondary = slider_start_x + slider_width + 20 + (blue_secondary / 255) * slider_width; // Corregido

handle_hue_shift = (dialog_x + (dialog_width / 2) - 150) + (hue_shift / 359) * 300;

// Variable para saber si un slider está siendo arrastrado
dragging = -1; // -1: ninguno, 0: rojo, 1: verde, 2: azul

message_shown = 0;
editing = false;
editing_manual = 0;
selected_item = 0;
start_delay = current_time;
exit_delay = current_time;
