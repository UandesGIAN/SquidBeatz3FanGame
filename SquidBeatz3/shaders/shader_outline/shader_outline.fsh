varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_texture_size; // Tamaño de la textura
uniform vec4 u_edge_color;   // Color del borde (pasado desde el código)

void main() {
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
    float alpha = color.a;  // Canal alfa del píxel actual

    // Variable para detectar bordes
    float is_edge = 0.0;

    // Revisamos los píxeles vecinos de 1 píxel a los lados (solo 8 vecinos)
    for (float x = -2.0; x <= 2.0; x++) { // Revisar -1 y 1
        for (float y = -2.0; y <= 2.0; y++) { // Revisar -1 y 1
            // Aseguramos que el desplazamiento se haga por un píxel
            vec2 offset = vec2(x, y) / u_texture_size; // Desplazamiento basado en el tamaño de la textura
            vec4 neighbor_color = texture2D(gm_BaseTexture, v_vTexcoord + offset);

            // Si el color del vecino es transparente y el alfa del píxel actual es mayor a 0
            if (neighbor_color.a < 0.5 && alpha > 0.5) {
                is_edge = 1.0; // Marcamos un borde
            }
        }
    }

    // Si es un borde, dibujamos el color del borde, si no, el sprite negro
    if (is_edge > 0.0) {
        gl_FragColor = u_edge_color; // Usar el color del borde pasado dinámicamente
    } else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, alpha); // Sprite negro con alfa original
    }
}
