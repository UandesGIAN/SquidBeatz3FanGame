/// @description Insert description here
// You can write your code in this editor

var controller_found = false;

for (var i = 0; i < 5; i++) {
    if (gamepad_is_connected(i)) {
        controller_found = true;
        gamepad_connected_now = 1;

        if (global.current_language == "ENGLISH") add_message("Controller " + string(i) + " found.", 120);
        else add_message("Control " + string(i) + " encontrado.", 120);

        global.is_gamepad = true;
        global.current_gamepad = i;
        already_shown = 1;
        break;
    }
}

if (!controller_found) {
    if (global.current_language == "ENGLISH") add_message("Game controllers not found", 120);
    else add_message("No se encontraron controles", 120);
}