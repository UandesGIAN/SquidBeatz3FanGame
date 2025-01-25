if (global.low_detail) {
	texto_en = "LOW DETAIL: ON";
	texto = "RENDIMIENTO: SI";
} else {
	texto_en = "LOW DETAIL: OFF";
	texto = "RENDIMIENTO: NO";
}

action = function() {
	global.low_detail = !global.low_detail;
	if (global.low_detail) {
		texto_en = "LOW DETAIL: ON";
		texto = "RENDIMIENTO: SI";
	} else {
		texto_en = "LOW DETAIL: OFF";
		texto = "RENDIMIENTO: NO";
	}
}