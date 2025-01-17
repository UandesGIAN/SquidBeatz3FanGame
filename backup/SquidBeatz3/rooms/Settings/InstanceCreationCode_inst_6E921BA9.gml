if (global.lifebar) {
	texto_en = "Life bar: ON";
	texto = "Barra de vida: SI";
} else {
	texto_en = "Life bar: OFF";
	texto = "Barra de vida: NO";
}

action = function() {
	global.lifebar = !global.lifebar;
	if (global.lifebar) {
		texto_en = "Life bar: ON";
		texto = "Barra de vida: SI";
	} else {
		texto_en = "Life bar: OFF";
		texto = "Barra de vida: NO";
	}
}