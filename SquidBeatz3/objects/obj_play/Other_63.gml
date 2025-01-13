/// @description Insert description here
// You can write your code in this editor

// Función para manejar los pasos de exportación
if (async_load[? "id"] == global.export_async_id) {
    var user_input = async_load[? "result"];
        
    switch (export_step) {
        case 0: // Preguntar canción de inicio
            if (string_length(user_input) <= 0) break;
            // Validar si el input contiene solo números
            var is_numeric_text = true;
            for (var i = 1; i <= string_length(user_input); i++) {
                var char = string_char_at(user_input, i);
                if (!((char >= "0" && char <= "9") || (i == 1 && char == "-"))) {
                    is_numeric_text = false;
                    break;
                }
            }

            if (!is_numeric_text) {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. Letters or symbols are not allowed." : "Por favor, ingresa un número válido. No se permiten letras ni símbolos.");
                break;
            }
            var input_value = real(user_input);
            if (string(input_value) != user_input || !is_real(input_value)) {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. No symbols or non-numeric characters allowed." : "Por favor ingresa un número válido. No se permiten símbolos o caracteres no numéricos.");
                break;
            }
            
            // Verificar si el número es un entero y está dentro del rango
            if (floor(input_value) == input_value && input_value > 0 && input_value <= array_length(global.song_list)-1) {
                start_song_i = input_value;
                export_step++;
                global.export_async_id = get_string_async(global.current_language == "ENGLISH" ? "Enter the final song index:\nIt must be a number greater than or equal to " + string(start_song_i) + " and less than or equal to " + string(array_length(global.song_list)-1) + "." : "Ingresa el índice de la canción final:\nDebe ser un número mayor o igual a " + string(start_song_i) + " y menor o igual a " + string(array_length(global.song_list)-1) + ".", "");
            } else {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. It must be between 1 and " + string(array_length(global.song_list)-1) + "." : "Por favor ingresa un número válido. Debe estar entre 1 y " + string(array_length(global.song_list)-1) + ".");
            }
            break;

        case 1: // Preguntar canción de final
            if (string_length(user_input) <= 0) break;
            // Validar si el input contiene solo números
            is_numeric_text = true;
            for (var i = 1; i <= string_length(user_input); i++) {
                var char = string_char_at(user_input, i);
                if (!((char >= "0" && char <= "9") || (i == 1 && char == "-"))) {
                    is_numeric_text = false;
                    break;
                }
            }

            if (!is_numeric_text) {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. Letters or symbols are not allowed." : "Por favor, ingresa un número válido. No se permiten letras ni símbolos.");
                break;
            }
            input_value = real(user_input);
            if (!is_real(input_value)) {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. It must be between 1 and " + string(array_length(global.song_list)-1) + "." : "Por favor ingresa un número válido. Debe ir desde 1 a " + string(array_length(global.song_list)-1) + ".");
                break;
            }
            
            if ((floor(input_value) == input_value) && input_value > 0) {
                end_song_i = input_value;
                if (end_song_i >= start_song_i && end_song_i <= array_length(global.song_list)-1) {
                    export_step++;
                    global.export_async_id = get_string_async(global.current_language == "ENGLISH" ? "Enter the absolute path where you want to export the files (If it doesn't exist, it will export to the desktop):" : "Ingrese la ruta ABSOLUTA donde desea exportar los archivos (Si no existe se exportará al escritorio):", "");
                } else {
                    show_message(global.current_language == "ENGLISH" ? "The final song number must be greater than or equal to the starting song and less than or equal to " + string(array_length(global.song_list)-1) : "El número de canción final debe ser mayor o igual al de la canción de inicio y menor o igual a " + string(array_length(global.song_list)-1));
                }
            } else {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. It must be between " + string(start_song_i) + " and " + string(array_length(global.song_list)-1) : "Por favor ingresa un número válido. Debe ir desde " + string(start_song_i) + " a " + string(array_length(global.song_list)-1));
            }
            break;

        case 2: // Preguntar la ruta absoluta
            if (string_length(user_input) > 0) {
                export_dir = user_input;
                // Validar la ruta y proceder con la exportación
                if (!directory_exists(export_dir)) {
                    show_message(global.current_language == "ENGLISH" ? "The directory " + export_dir + " does not exist, is not valid, or was not found. Saving to the desktop." : "El directorio " + export_dir + " no existe, no es válido, o no fue encontrado. Guardando en el escritorio.");
                    export_dir = directory_get_desktop_path();
                }
                export_song_files_to_directory(export_dir, start_song_i, end_song_i);
                export_step = 0;
            } else {
                show_message(global.current_language == "ENGLISH" ? "Enter a path from your PC. You can do this from the explorer, right-click, 'Copy address as text'." : "Ingresa una ruta de tu PC. Puedes hacerlo desde el explorador, en la barra de direcciones, click derecho, 'Copiar dirección como texto'.");
            }
            break;
    }
}


if (async_load[? "id"] == global.delete_async_id) {
    var user_input = async_load[? "result"];
        
    switch (delete_step) {
        case 0: // Preguntar canción de inicio
            if (string_length(user_input) <= 0) break;
            // Validar si el input contiene solo números
            var is_numeric_text = true;
            for (var i = 1; i <= string_length(user_input); i++) {
                var char = string_char_at(user_input, i);
                if (!((char >= "0" && char <= "9") || (i == 1 && char == "-"))) {
                    is_numeric_text = false;
                    break;
                }
            }

            if (!is_numeric_text) {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. Letters or symbols are not allowed." : "Por favor, ingresa un número válido. No se permiten letras ni símbolos.");
                break;
            }
            var input_value = real(user_input);
            if (string(input_value) != user_input || !is_real(input_value)) {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. No symbols or non-numeric characters allowed." : "Por favor ingresa un número válido. No se permiten símbolos o caracteres no numéricos.");
                break;
            }
            
            // Verificar si el número es un entero y está dentro del rango
            if (floor(input_value) == input_value && input_value > 0 && input_value <= array_length(global.song_list)-1) {
                start_song_i = input_value;
                delete_step++;
                global.delete_async_id = get_string_async(global.current_language == "ENGLISH" ? "Enter the final song index:\nIt must be a number greater than or equal to " + string(start_song_i) + " and less than or equal to " + string(array_length(global.song_list)-1) + "." : "Ingresa el índice de la canción final:\nDebe ser un número mayor o igual a " + string(start_song_i) + " y menor o igual a " + string(array_length(global.song_list)-1) + ".", "");
            } else {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. It must be between 1 and " + string(array_length(global.song_list)-1) + "." : "Por favor ingresa un número válido. Debe estar entre 1 y " + string(array_length(global.song_list)-1) + ".");
            }
            break;

        case 1: // Preguntar canción de final
            if (string_length(user_input) <= 0) break;
            // Validar si el input contiene solo números
            is_numeric_text = true;
            for (var i = 1; i <= string_length(user_input); i++) {
                var char = string_char_at(user_input, i);
                if (!((char >= "0" && char <= "9") || (i == 1 && char == "-"))) {
                    is_numeric_text = false;
                    break;
                }
            }

            if (!is_numeric_text) {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. Letters or symbols are not allowed." : "Por favor, ingresa un número válido. No se permiten letras ni símbolos.");
                break;
            }
            input_value = real(user_input);
            if (!is_real(input_value)) {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. It must be between 1 and " + string(array_length(global.song_list)-1) + "." : "Por favor ingresa un número válido. Debe ir desde 1 a " + string(array_length(global.song_list)-1) + ".");
                break;
            }
            
            if ((floor(input_value) == input_value) && input_value > 0) {
                end_song_i = input_value;
                if (end_song_i >= start_song_i && end_song_i <= array_length(global.song_list)-1) {
                   handle_delete_files(start_song_i, end_song_i);
                } else {
                    show_message(global.current_language == "ENGLISH" ? "The final song number must be greater than or equal to the starting song and less than or equal to " + string(array_length(global.song_list)-1) : "El número de canción final debe ser mayor o igual al de la canción de inicio y menor o igual a " + string(array_length(global.song_list)-1));
                }
            } else {
                show_message(global.current_language == "ENGLISH" ? "Please enter a valid number. It must be between " + string(start_song_i) + " and " + string(array_length(global.song_list)-1) : "Por favor ingresa un número válido. Debe ir desde " + string(start_song_i) + " a " + string(array_length(global.song_list)-1));
            }
            break;
    }
}
