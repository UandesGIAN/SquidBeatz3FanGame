from PIL import Image
import imageio
from tkinter import simpledialog
import tkinter as tk


def sprite_sheet_to_gif(sprite_sheet_path, sprite_width, sprite_height, gif_path, fps):
    # Calcular la duración de cada frame en milisegundos
    duration = 1000 / fps
    
    # Cargar la imagen del sprite sheet
    sprite_sheet = Image.open(sprite_sheet_path)
    
    # Obtener el tamaño de la imagen
    sheet_width, sheet_height = sprite_sheet.size
    
    # Calcular cuántos frames hay en la imagen
    frames_x = sheet_width // sprite_width
    frames_y = sheet_height // sprite_height
    
    # Lista para almacenar los frames
    frames = []
    
    # Dividir el sprite sheet en frames
    for y in range(frames_y):
        for x in range(frames_x):
            # Cortar cada frame del sprite sheet
            left = x * sprite_width
            upper = y * sprite_height
            right = left + sprite_width
            lower = upper + sprite_height
            frame = sprite_sheet.crop((left, upper, right, lower))
            frames.append(frame)
    
    # Guardar como GIF sin que se sobrepongan los frames
    frames[0].save(gif_path, save_all=True, append_images=frames[1:], duration=duration, loop=0, disposal=2)


# Crear una ventana para que el usuario ingrese los valores
def get_sprite_dimensions():
    # Crear la ventana de entrada
    root = tk.Tk()
    root.withdraw()  # Ocultar la ventana principal

    # Pide al usuario que ingrese el ancho y alto del sprite
    sprite_width = simpledialog.askinteger("Ancho del Sprite", "Introduce el ancho de cada sprite (en píxeles):")
    sprite_height = simpledialog.askinteger("Alto del Sprite", "Introduce el alto de cada sprite (en píxeles):")

    # Solicitar la ruta del sprite sheet
    sprite_sheet_path = simpledialog.askstring("Ruta del Sprite Sheet", "Introduce la ruta del archivo PNG del sprite sheet:")
    
    # Solicitar la ruta donde guardar el GIF
    gif_path = simpledialog.askstring("Ruta del GIF", "Introduce la ruta donde guardar el archivo GIF (ej. 'output.gif'):")

    # Solicitar los FPS para la animación
    fps = simpledialog.askinteger("FPS de la Animación", "Introduce los FPS (frames por segundo) de la animación:")

    return sprite_sheet_path, sprite_width, sprite_height, gif_path, fps

# Ejemplo de uso
sprite_sheet_path, sprite_width, sprite_height, gif_path, fps = get_sprite_dimensions()

# Ejecutar la función con los parámetros ingresados
sprite_sheet_to_gif(sprite_sheet_path, sprite_width, sprite_height, gif_path, fps)