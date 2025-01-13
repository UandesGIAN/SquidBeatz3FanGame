if (global.octo_icons) {
	texto_en = "Octoling icons: ON";
	texto = "Iconos octolings: SI";
} else {
	texto_en = "Octoling icons: OFF";
	texto = "Iconos octolings: NO";
}

action = function() {
	global.octo_icons = !global.octo_icons;
	if (global.octo_icons) {
		texto_en = "Octoling icons: ON";
		texto = "Iconos octolings: SI";
	} else {
		texto_en = "Octoling icons: OFF";
		texto = "Iconos octolings: NO";
	}
}