varying vec2 v_vTexcoord;
uniform float hue_shift; // El valor del cambio de tono (en grados, 0 a 300)

void main() {
    vec4 tex_color = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Convertir de RGB a HSV
    float cmax = max(max(tex_color.r, tex_color.g), tex_color.b);
    float cmin = min(min(tex_color.r, tex_color.g), tex_color.b);
    float delta = cmax - cmin;

    float h = 0.0;
    if (delta > 0.0) {
        if (cmax == tex_color.r) {
            h = mod(((tex_color.g - tex_color.b) / delta), 6.0);
        } else if (cmax == tex_color.g) {
            h = ((tex_color.b - tex_color.r) / delta) + 2.0;
        } else {
            h = ((tex_color.r - tex_color.g) / delta) + 4.0;
        }
        h = h * 60.0; // Convertir a grados
    }

    float s = (cmax == 0.0) ? 0.0 : delta / cmax;
    float v = cmax;

    // Aplicar el hue shift con rango de 0 a 300
    float adjusted_hue_shift = mod(hue_shift, 300.0); // Asegura que sea de 0 a 300

    float hue_shift_factor = 0.0;

    // Aplicar shift de manera separada para amarillos y morados
    if (h < 60.0) { // Amarillos
        hue_shift_factor = adjusted_hue_shift; // Hue shift positivo para amarillo
    } else if (h < 180.0) { // Colores entre amarillo y azul/morado
        hue_shift_factor = 0.0; // Sin cambio o aplicar otro factor si deseas
    } else if (h < 300.0) { // Morados y azules
        hue_shift_factor = -adjusted_hue_shift; // Hue shift negativo para morado
    } else {
        hue_shift_factor = 0.0;
    }

    h = mod(h + hue_shift_factor, 300.0); // Mantener la corrección de h entre 0 y 300
    if (h < 0.0) h += 300.0;

    // Convertir de HSV a RGB
    float c = v * s;
    float x = c * (1.0 - abs(mod(h / 60.0, 2.0) - 1.0));
    float m = v - c;

    vec3 rgb;
    if (h < 60.0) {
        rgb = vec3(c, x, 0.0);
    } else if (h < 120.0) {
        rgb = vec3(x, c, 0.0);
    } else if (h < 180.0) {
        rgb = vec3(0.0, c, x);
    } else if (h < 240.0) {
        rgb = vec3(0.0, x, c);
    } else if (h < 300.0) {
        rgb = vec3(x, 0.0, c);
    } else {
        rgb = vec3(c, 0.0, x);
    }
    rgb = rgb + m;

    // Restaurar los grises (sin saturación)
    if (s == 0.0) {
        rgb = vec3(v); // Mantener los grises intactos
    }

    gl_FragColor = vec4(rgb, tex_color.a);
}