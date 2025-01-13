/// @description Insert description here
// You can write your code in this editor
if (file_exists(alarm_zip_path)) {
    directory_destroy(alarm_dir_path + "\\sounds");
    show_debug_message(global.current_language == "ENGLISH" ? "ZIP file created: " + alarm_zip_path : "Archivo ZIP creado: " + alarm_zip_path);
}