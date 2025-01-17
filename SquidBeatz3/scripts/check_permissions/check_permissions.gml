// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function check_permissions(){
	var test_file = working_directory + "test_permission.tmp"; // Archivo temporal para probar
    
    // Intentar crear el archivo
    var file = file_text_open_write(test_file);
    if (file == -1) {
        show_message("Para realizar esta acción, ejecuta el juego como administrador.");
        return false;
    }
    
    file_text_write_string(file, "Prueba de permisos"); // Escribe algo en el archivo
    file_text_close(file);
    
    // Intentar eliminar el archivo
    if (!file_delete(test_file)) {
        show_message("Para realizar esta acción, ejecuta el juego como administrador.");
        return false;
    }
    
	show_debug_message("ADMIN");
    return true; // Permisos verificados correctamente
}