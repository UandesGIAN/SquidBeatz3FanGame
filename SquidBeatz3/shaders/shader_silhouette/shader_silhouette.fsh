// Hacer el sprite completamente negro
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Hacer todo el sprite negro, pero mantener la transparencia
    gl_FragColor = vec4(0.0, 0.0, 0.0, color.a);  // Negro con alfa original
}