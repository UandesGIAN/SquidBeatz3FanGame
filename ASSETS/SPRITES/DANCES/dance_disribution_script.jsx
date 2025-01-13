#target photoshop

var columns = 12; // Número de columnas
var rows = 15;     // Número de filas (calculado automáticamente si no alcanza)
var spacing = 2;  // Espaciado entre las imágenes (en píxeles)

var doc = app.activeDocument;
var layers = doc.artLayers;

// Tamaño de cada imagen (basado en la primera capa)
var layerWidth = layers[0].bounds[2] - layers[0].bounds[0];
var layerHeight = layers[0].bounds[3] - layers[0].bounds[1];

var x = 0, y = 0;

for (var i = 0; i < layers.length; i++) {
    var layer = layers[i];
    layer.visible = true;
    
    // Mover la capa a la posición calculada
    layer.translate(x * (layerWidth + spacing) - layer.bounds[0],
                    y * (layerHeight + spacing) - layer.bounds[1]);
    
    // Incrementar posición en la matriz
    x++;
    if (x >= columns) {
        x = 0;
        y++;
    }
}
