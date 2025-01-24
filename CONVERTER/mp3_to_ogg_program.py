import os
import json
from pydub import AudioSegment
from tkinter import filedialog, messagebox
from tkinter.font import Font
import numpy as np
import tkinter as tk
import math
import zipfile
import pywt
import librosa
from scipy import signal
import shutil
import matplotlib.pyplot as plt
from scipy.fft import fft
from tkinter import Tk, filedialog, messagebox
import librosa.display
import re

def update_progress(message):
    progress_text.config(state=tk.NORMAL)
    progress_text.insert(tk.END, f"{message}\n")
    progress_text.yview(tk.END)  # Desplazar hacia abajo
    progress_text.config(state=tk.DISABLED)

def sanitize_filename(filename):
    # Elimina los caracteres no válidos
    return re.sub(r'[<>:"|?*!]', '', filename)

def calculate_bpm(audio_path):
    # Función interna para detectar picos en la señal
    def peak_detect(data):
        max_val = np.amax(abs(data))
        peak_ndx = np.where(data == max_val)
        if len(peak_ndx[0]) == 0:
            peak_ndx = np.where(data == -max_val)
        return peak_ndx

    # Función interna para calcular el BPM con la técnica de Wavelet
    def bpm_detector(data, fs):
        cA = []
        cD = []
        correl = []
        cD_sum = []
        levels = 4
        max_decimation = 2 ** (levels - 1)
        min_ndx = math.floor(60.0 / 220 * (fs / max_decimation))
        max_ndx = math.floor(60.0 / 40 * (fs / max_decimation))

        for loop in range(0, levels):
            cD = []
            if loop == 0:
                [cA, cD] = pywt.dwt(data, "db4")
                cD_minlen = len(cD) / max_decimation + 1
                cD_sum = np.zeros(math.floor(cD_minlen))
            else:
                [cA, cD] = pywt.dwt(cA, "db4")

            cD = signal.lfilter([0.01], [1 - 0.99], cD)
            cD = abs(cD[:: (2 ** (levels - loop - 1))])
            cD = cD - np.mean(cD)

            cD_sum = cD[0 : math.floor(cD_minlen)] + cD_sum

        if [b for b in cA if b != 0.0] == []:
            return None

        cA = signal.lfilter([0.01], [1 - 0.99], cA)
        cA = abs(cA)
        cA = cA - np.mean(cA)
        cD_sum = cA[0 : math.floor(cD_minlen)] + cD_sum

        correl = np.correlate(cD_sum, cD_sum, "full")

        midpoint = math.floor(len(correl) / 2)
        correl_midpoint_tmp = correl[midpoint:]
        peak_ndx = peak_detect(correl_midpoint_tmp[min_ndx:max_ndx])

        if len(peak_ndx) > 1:
            return None

        peak_ndx_adjusted = peak_ndx[0] + min_ndx
        bpm = 60.0 / peak_ndx_adjusted * (fs / max_decimation)
        return bpm

    y, sr = librosa.load(audio_path, sr=None)  # Usamos la frecuencia de muestreo original
    nsamps = len(y)
    window_samps = int(3 * sr)  # Usamos una ventana de 3 segundos
    samps_ndx = 0
    max_window_ndx = math.floor(nsamps / window_samps)
    bpms = np.zeros(max_window_ndx)

    # Iterar por todas las ventanas de audio
    for window_ndx in range(0, max_window_ndx):
        data = y[samps_ndx : samps_ndx + window_samps]
        bpm = bpm_detector(data, sr)
        if bpm is not None:
            bpms[window_ndx] = bpm
        samps_ndx += window_samps

    # Calcular el BPM final como la mediana de los BPMs de las ventanas
    bpm_final = np.median(bpms)

    return round(bpm_final)


# Función para calcular el tiempo de sincronización
def calculate_sync_tempo(tempo, proportion_bpm_to_speed=132/3600, sprite_width=528, base_x=250):
    x_i = 250
    perfect_sync_x = -1
    x_speed = tempo * proportion_bpm_to_speed

    while perfect_sync_x == -1:
        if x_i - 250 <= sprite_width:
            d_to_input = x_i - 257
            beats_per_minute_to_input = d_to_input / 60 / proportion_bpm_to_speed
            if beats_per_minute_to_input // 1 == tempo:
                perfect_sync_x = x_i + 257
                break
        else:
            index_bar_to_sync = 1
            d_to_input = x_i + sprite_width - 257
            beats_per_minute_to_input = d_to_input / 60 / proportion_bpm_to_speed
            if beats_per_minute_to_input // 1 == tempo:
                perfect_sync_x = x_i - sprite_width + 257
                break
        if x_i == sprite_width * 2:
            break
        x_i += 1
    
    if perfect_sync_x != -1:
        distance_to_sync = perfect_sync_x - base_x
        time_to_sync = distance_to_sync / x_speed
        sync_tempo = time_to_sync * x_speed
        return int(sync_tempo)
    return None


def process_audio_to_matrix(file_path, output_json):
    audio = AudioSegment.from_file(file_path)
    audio = audio.set_channels(1)
    sample_rate = audio.frame_rate
    samples = np.array(audio.get_array_of_samples())
    duration = len(samples) / sample_rate
    block_duration = 0.5

    block_samples = int(block_duration * sample_rate)
    raw_matrix = []

    for start in range(0, len(samples), block_samples):
        end = start + block_samples
        if end > len(samples):
            end = len(samples)
        segment = samples[start:end]
        fft_result = np.abs(np.fft.fft(segment))[:len(segment) // 2]
        freqs = np.fft.fftfreq(len(segment), 1 / sample_rate)[:len(segment) // 2]

        band_limits = np.linspace(0, freqs[-1], 17)
        band_amplitudes = []
        for i in range(16):
            band_mask = (freqs >= band_limits[i]) & (freqs < band_limits[i + 1])
            band_amplitude = np.mean(fft_result[band_mask]) if np.any(band_mask) else 0
            band_amplitudes.append(band_amplitude)

        raw_matrix.append(band_amplitudes)

    raw_matrix = np.array(raw_matrix)
    band_max_values = np.max(raw_matrix, axis=0)
    band_mean_values = np.mean(raw_matrix, axis=0)

    normalized_matrix = []
    for row in raw_matrix:
        normalized_row = []
        for band_index, value in enumerate(row):
            if band_max_values[band_index] > 0:
                if value < band_mean_values[band_index]:
                    normalized_value = max(0, round((value / band_max_values[band_index]) * 17 * 0.8))
                else:
                    normalized_value = round((value / band_max_values[band_index]) * 17)
            else:
                normalized_value = 0
            normalized_row.append(normalized_value)
        normalized_matrix.append(normalized_row)

    visualizer_data = {"visualizer": normalized_matrix}
    with open(output_json, "w") as json_file:
        json.dump(visualizer_data, json_file, indent=4)


# Valores iniciales para las variables configurables
low_freq = 300
mid_freq = 1000
very_strong_intensity = 0.8
strong_intensity = 0.6
weak_intensity = 0.3
min_val = 0.15

# Inicialización de las notas por categoría
notes = {
    "Very high volume (> Very strong)": 8,
    "High frequency - High volume (> Mid frequency, > Strong Intensity)": 7,
    "High frequency - Mid volume (> Mid frequency, > Weak Intensity)": 1,
    "High frequency - Low volume (> Mid frequency, < Weak Intensity)": 3,
    "Mid frequency - High volume (< Mid frequency and > Low frequency, > Strong Intensity)": 5,
    "Mid frequency - Mid volume (< Mid frequency and > Low frequency, > Weak Intensity)": 3,
    "Mid frequency - Low volume (< Mid frequency and > Low frequency, < Weak Intensity)": 2,
    "Low frequency - High volume (< Low frequency, > Strong Intensity)": 6,
    "Low frequency - Mid volume (< Low frequency, > Weak Intensity)": 2,
    "Low frequency - Low volume (< Low frequency, < Weak Intensity)": 4
}
note_texts = {
        1: "LR simple (1)",
        2: "LR double (2)",
        3: "ABXY simple (3)",
        4: "ABXY double (4)",
        5: "LR simple - ABXY simple (5)",
        6: "LR simple - ABXY double (6)",
        7: "LR double - ABXY simple (7)",
        8: "LR double - ABXY double (8)"
    }

import tkinter as tk
from tkinter import messagebox

def customize_auto_chart():
    """Abre un menú para personalizar las variables del auto chart."""
    global low_freq, mid_freq, very_strong_intensity, strong_intensity, weak_intensity, min_val
    global notes, note_texts
   
     # Crear una nueva ventana
    customization_window = tk.Toplevel(root)
    customization_window.title("Customize Auto Chart")
    customization_window.geometry("500x400")
    customization_window.configure(bg="#444444")

    # Crear un canvas y un scrollbar
    canvas = tk.Canvas(customization_window)
    canvas.pack(side="left", fill="both", expand=True)

    scrollbar = tk.Scrollbar(customization_window, orient="vertical", command=canvas.yview)
    scrollbar.pack(side="right", fill="y")

    canvas.configure(yscrollcommand=scrollbar.set)
    
    frame = tk.Frame(canvas, bg="#444444")
    canvas.create_window((0, 0), window=frame, anchor="nw")

    # Función para crear campos de entrada con descripción y validación
    def create_input_field(label_text, default_value, min_value, max_value, step_type):
        label = tk.Label(frame, text=label_text, bg="#444444", fg="white", font=("Arial", 10))
        label.pack(pady=5, padx=10, anchor="w")
        entry = tk.Entry(frame, font=("Arial", 10))
        entry.insert(0, str(default_value))
        entry.pack(pady=5, anchor="w")

        def validate_input():
            try:
                value = float(entry.get().replace(",", "."))
                if step_type == "int":
                    value = int(value)
                if min_value <= value <= max_value:
                    return value
                else:
                    raise ValueError
            except ValueError:
                messagebox.showerror(
                    "Invalid Input",
                    f"Invalid input for {label_text}.\nMust be between {min_value} and {max_value}."
                )
                return None

        return entry, validate_input

    # Crear cuadros de entrada para frecuencias
    low_entry, validate_low = create_input_field("Low Frequency (0-20000Hz)", low_freq, 20, 20000, "int")
    low_entry.pack(pady=5, anchor="w")
    mid_entry, validate_mid = create_input_field("Mid Frequency (0-20000Hz):", mid_freq, 20, 20000, "int")
    mid_entry.pack(pady=5, anchor="w")

    # Muy fuerte intensidad
    very_strong_entry, validate_very_strong = create_input_field("Very Strong Intensity (min-1)", very_strong_intensity, min_val, 1, "float")
    very_strong_entry.pack(pady=5, anchor="w")
    # Fuerte intensidad
    strong_entry, validate_strong = create_input_field("Strong Intensity (min-1)", strong_intensity, min_val, 1, "float")
    strong_entry.pack(pady=5, anchor="w")
    # Débil intensidad
    weak_entry, validate_weak = create_input_field("Weak Intensity (min-1)", weak_intensity, min_val, 1, "float")
    weak_entry.pack(pady=5, anchor="w")
    # Menor intensidad
    min_entry, validate_min = create_input_field("Minimum Intensity (0-weak)", weak_intensity, 0, weak_intensity, "float")
    min_entry.pack(pady=5, anchor="w")


    # Crear dropdowns para todas las categorías de notas
    note_options = list(note_texts.keys())  # Usamos los números para los OptionMenu
    note_labels = list(notes.keys())  # Obtener las categorías de notas

    # Crear un frame para los dropdowns de notas
    notes_frame = tk.Frame(frame, bg="#444444")
    notes_frame.pack(pady=20, anchor="w")

    note_dropdowns = {}
    for i, label in enumerate(note_labels):
        note_label = tk.Label(notes_frame, text=label, bg="#444444", fg="white", font=("Arial", 10))
        note_label.pack(pady=5, padx=10, anchor="w")

        # Usar OptionMenu de Tkinter para crear el dropdown
        note_dropdown = tk.OptionMenu(
            notes_frame, 
            tk.StringVar(value=note_texts[notes[label]]), *[note_texts[note] for note in note_options]
        )
        note_dropdown.pack(pady=5, anchor="w")
        note_dropdowns[label] = note_dropdown

    # Función para guardar configuración
    def save_configuration():
        global low_freq, mid_freq, very_strong_intensity, strong_intensity, weak_intensity, min_val
        global notes, note_texts

        valid_low = validate_low()
        valid_mid = validate_mid()
        valid_very_strong = validate_very_strong()
        valid_strong = validate_strong()
        valid_weak = validate_weak()
        valid_min = validate_min()

        if None not in [valid_low, valid_mid, valid_very_strong, valid_strong, valid_weak, valid_min]:
            low_freq = valid_low
            mid_freq = valid_mid
            very_strong_intensity = valid_very_strong
            strong_intensity = valid_strong
            weak_intensity = valid_weak
            min_val = valid_min

            # Actualizar las notas seleccionadas en las categorías
            for label in note_labels:
                selected_note_text = note_dropdowns[label].cget("text")
                selected_note = [key for key, value in note_texts.items() if value == selected_note_text][0]
                notes[label] = selected_note

            customization_window.destroy()
            messagebox.showinfo("Configuration Saved", "Your changes have been saved successfully!")

    save_button = tk.Button(customization_window, text="Save", command=save_configuration, bg="#555555", fg="white", font=("Arial", 12))
    save_button.pack(pady=20)

    # Botón para cerrar la ventana sin guardar
    exit_button = tk.Button(
        customization_window,
        text="Exit",
        command=customization_window.destroy,
        bg="#555555",
        fg="white",
        font=("Arial", 12)
    )
    exit_button.pack(pady=20)

    # Actualizar el tamaño del canvas para incluir todo el contenido
    frame.update_idletasks()
    canvas.config(scrollregion=canvas.bbox("all"))


def generate_chart(audio_path, bpm, low, mid, very_strong, strong, weak, min_val):
    y, sr = librosa.load(audio_path, sr=None)
    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr, units="time")
    rms = librosa.feature.rms(y=y, frame_length=2048, hop_length=512)[0]
    stft = np.abs(librosa.stft(y))
    freqs = librosa.fft_frequencies(sr=sr)
    times = librosa.times_like(stft[0], sr=sr)
    rms_max = np.max(rms)
    normalized_rms = rms / rms_max if rms_max > 0 else rms
    
    chart = []
    last_pos_x = -np.inf
    for i, beat in enumerate(beat_frames):
        closest_idx = np.argmin(np.abs(times - beat))
        low_energy = np.sum(stft[freqs < low, closest_idx])
        mid_energy = np.sum(stft[(freqs >= low) & (freqs < mid), closest_idx])
        high_energy = np.sum(stft[freqs >= mid, closest_idx])
        avg_rms = normalized_rms[closest_idx] if closest_idx < len(normalized_rms) else 0
        index_type = None
        
        # Evaluación de la intensidad y la frecuencia
        if avg_rms > very_strong:
            index_type = notes["Very high volume (> Very strong)"]-1  # Usar el valor entero
        elif high_energy > low_energy and high_energy > mid_energy:
            if avg_rms > strong:
                index_type = notes["High frequency - High volume (> Mid frequency, > Strong Intensity)"]-1
            elif avg_rms > weak:
                index_type = notes["High frequency - Mid volume (> Mid frequency, > Weak Intensity)"]-1
            else:
                index_type = notes["High frequency - Low volume (> Mid frequency, < Weak Intensity)"]-1
        elif low_energy > high_energy and low_energy > mid_energy:
            if avg_rms > strong:
                index_type = notes["Low frequency - High volume (< Low frequency, > Strong Intensity)"]-1
            elif avg_rms > weak:
                index_type = notes["Low frequency - Mid volume (< Low frequency, > Weak Intensity)"]-1
            else:
                index_type = notes["Low frequency - Low volume (< Low frequency, < Weak Intensity)"]-1
        elif mid_energy > high_energy and mid_energy > low_energy:
            if avg_rms > strong:
                index_type = notes["Mid frequency - High volume (< Mid frequency and > Low frequency, > Strong Intensity)"]-1
            elif avg_rms > weak:
                index_type = notes["Mid frequency - Mid volume (< Mid frequency and > Low frequency, > Weak Intensity)"]-1
            else:
                index_type = notes["Mid frequency - Low volume (< Mid frequency and > Low frequency, < Weak Intensity)"]-1

        pos_x = round((beat * (bpm * 132 / 60)), 2)
        if avg_rms > min_val+0.1 and (pos_x - last_pos_x > 132) and index_type != None:
            chart.append({"pos_x": pos_x, "index_type": index_type})
            last_pos_x = pos_x

    return chart

def generate_chart_3(audio_path, bpm, low, mid, very_strong, strong, weak, min_val):
    # Cargar el audio
    y, sr = librosa.load(audio_path, sr=None)

    # Calcular características relevantes
    rms = librosa.feature.rms(y=y, frame_length=2048, hop_length=512)[0]
    stft = np.abs(librosa.stft(y))
    freqs = librosa.fft_frequencies(sr=sr)
    times = librosa.times_like(stft[0], sr=sr)

    # Normalizar RMS
    rms_max = np.max(rms)
    normalized_rms = rms / rms_max if rms_max > 0 else rms

    # Inicializar variables
    chart = []
    last_pos_x = -np.inf  # Última posición registrada en el gráfico

    # Procesar cada instante de tiempo
    for i, time in enumerate(times):
        # Calcular la energía en diferentes rangos de frecuencia
        low_energy = np.sum(stft[freqs < low, i])
        mid_energy = np.sum(stft[(freqs >= low) & (freqs < mid), i])
        high_energy = np.sum(stft[freqs >= mid, i])
        index_type = None
        
        # RMS promedio en este instante
        avg_rms = (normalized_rms[i] if i < len(normalized_rms) else 0 ) - 0.055

        # Determinar el tipo de nota usando el diccionario `notes`
        if avg_rms > very_strong:
            index_type = notes["Very high volume (> Very strong)"] - 1
        elif high_energy > low_energy and high_energy > mid_energy:
            if avg_rms > strong:
                index_type = notes["High frequency - High volume (> Mid frequency, > Strong Intensity)"] - 1
            elif avg_rms > weak:
                index_type = notes["High frequency - Mid volume (> Mid frequency, > Weak Intensity)"] - 1
            else:
                index_type = notes["High frequency - Low volume (> Mid frequency, < Weak Intensity)"] - 1
        elif low_energy > high_energy and low_energy > mid_energy:
            if avg_rms > strong:
                index_type = notes["Low frequency - High volume (< Low frequency, > Strong Intensity)"] - 1
            elif avg_rms > weak:
                index_type = notes["Low frequency - Mid volume (< Low frequency, > Weak Intensity)"] - 1
            else:
                index_type = notes["Low frequency - Low volume (< Low frequency, < Weak Intensity)"] - 1
        elif mid_energy > high_energy and mid_energy > low_energy:
            if avg_rms > strong:
                index_type = notes["Mid frequency - High volume (< Mid frequency and > Low frequency, > Strong Intensity)"] - 1
            elif avg_rms > weak:
                index_type = notes["Mid frequency - Mid volume (< Mid frequency and > Low frequency, > Weak Intensity)"] - 1
            else:
                index_type = notes["Mid frequency - Low volume (< Mid frequency and > Low frequency, < Weak Intensity)"] - 1

        # Calcular la posición x
        pos_x = round((time * (bpm * 132 / 60)), 2)

        # Aplicar las condiciones de filtrado
        if avg_rms > min_val and (pos_x - last_pos_x > 60) and index_type != None:
            chart.append({"pos_x": pos_x, "index_type": index_type})
            last_pos_x = pos_x

    return chart

def generate_chart_2(audio_path, bpm, low, mid, very_strong, strong, weak, min_val):
    # Cargar el audio
    y, sr = librosa.load(audio_path, sr=None)
    
    # Detectar beats
    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr, units="time")

    # Calcular características relevantes
    stft = np.abs(librosa.stft(y))
    freqs = librosa.fft_frequencies(sr=sr)
    times = librosa.times_like(stft[0], sr=sr)

    # Centroide espectral (indicador de tono y brillo)
    spectral_centroid = librosa.feature.spectral_centroid(S=stft, sr=sr)[0]
    spectral_centroid_max = np.max(spectral_centroid)
    normalized_centroid = spectral_centroid / spectral_centroid_max if spectral_centroid_max > 0 else spectral_centroid

    # RMS para medir la intensidad
    rms = librosa.feature.rms(y=y, frame_length=2048, hop_length=512)[0]
    rms_max = np.max(rms)
    normalized_rms = rms / rms_max if rms_max > 0 else rms

    chart = []

    for i, beat in enumerate(beat_frames):
        closest_idx = np.argmin(np.abs(times - beat))
        index_type = None
        # Valores relacionados con tono y melodía en el beat actual
        avg_centroid = normalized_centroid[closest_idx] if closest_idx < len(normalized_centroid) else 0
        avg_rms = normalized_rms[closest_idx] if closest_idx < len(normalized_rms) else 0

        # Evaluación de la intensidad tonal y melódica
        if avg_rms > very_strong:
            index_type = notes["Very high volume (> Very strong)"] - 1
        elif avg_centroid > mid and avg_rms > strong:
            index_type = notes["High frequency - High volume (> Mid frequency, > Strong Intensity)"] - 1
        elif avg_centroid > mid and avg_rms > weak:
            index_type = notes["High frequency - Mid volume (> Mid frequency, > Weak Intensity)"] - 1
        elif avg_centroid > mid:
            index_type = notes["High frequency - Low volume (> Mid frequency, < Weak Intensity)"] - 1
        elif avg_centroid > low and avg_rms > strong:
            index_type = notes["Mid frequency - High volume (< Mid frequency and > Low frequency, > Strong Intensity)"] - 1
        elif avg_centroid > low and avg_rms > weak:
            index_type = notes["Mid frequency - Mid volume (< Mid frequency and > Low frequency, > Weak Intensity)"] - 1
        elif avg_centroid > low:
            index_type = notes["Mid frequency - Low volume (< Mid frequency and > Low frequency, < Weak Intensity)"] - 1
        elif avg_rms > strong:
            index_type = notes["Low frequency - High volume (< Low frequency, > Strong Intensity)"] - 1
        elif avg_rms > weak:
            index_type = notes["Low frequency - Mid volume (< Low frequency, > Weak Intensity)"] - 1
        else:
            index_type = notes["Low frequency - Low volume (< Low frequency, < Weak Intensity)"] - 1

        # Posición en el gráfico
        pos_x = round((beat * (bpm * 132 / 60)), 2)
        if avg_rms > min_val and index_type != None:
            chart.append({"pos_x": pos_x, "index_type": index_type})

    return chart


# Export files
def create_unique_folder(base_name, parent_dir):
    index = 0
    while True:
        folder_name = f"{base_name}{f'_{index}' if index else ''}"
        folder_path = os.path.join(parent_dir, folder_name)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            return folder_path
        index += 1

def create_unique_zip(base_name, parent_dir):
    index = 0
    while True:
        zip_file_name = f"{base_name}{f'_{index}' if index else ''}.zip"
        zip_file_path = os.path.join(parent_dir, zip_file_name)
        if not os.path.exists(zip_file_path):
            return zip_file_path
        index += 1

def create_zip(output_folder, parent_dir):
    zip_file_path = create_unique_zip("converted_songs", parent_dir)

    with zipfile.ZipFile(zip_file_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        # Recorre todos los directorios y archivos en output_folder
        for root, _, files in os.walk(output_folder):
            for file in files:
                file_path = os.path.join(root, file)
                
                # Calcula la ruta relativa para mantener la estructura de carpetas
                arcname = os.path.relpath(file_path, start=output_folder+"/..")
                
                # Escribe el archivo en el ZIP manteniendo la estructura de carpetas
                zipf.write(file_path, arcname)
    
    return zip_file_path


def convert_mp3_to_ogg(files, output_folder, name_file_path, chart_folder, output_converted_songs):
    converted_files = []

    for index, file_path in enumerate(files, start=1):
        if file_path.endswith('.mp3'):
            base_name = os.path.splitext(os.path.basename(file_path))[0]
            progress_text.insert(tk.END, f"Processing file {index}/{len(files)}: {base_name}\n")
            progress_text.update_idletasks()

            # Crear una carpeta individual para la canción dentro de output_converted_songs
            MAX_FILENAME_LENGTH = 100
            sanitized_name = sanitize_filename(base_name)[:MAX_FILENAME_LENGTH]
            song_folder = os.path.join(output_converted_songs, sanitized_name)
            os.makedirs(song_folder, exist_ok=True)
            progress_text.insert(tk.END, f"Created folder for song: {sanitized_name}\n")
            progress_text.update()

            # Conversión a OGG
            output_file_name_ogg = f"{index}_song{index}.ogg"
            output_file_path_ogg = os.path.join(output_folder, output_file_name_ogg)
            audio = AudioSegment.from_mp3(file_path)
            audio.export(output_file_path_ogg, format="ogg")
            progress_text.insert(tk.END, f"Converted {base_name} to OGG format\n")
            progress_text.update()

            # Copiar el archivo OGG a la carpeta de la canción
            song_ogg_path = os.path.join(song_folder, "song.ogg")
            # Verificar si los archivos son iguales, existen y son distintos
            if os.path.exists(output_file_path_ogg) and os.path.exists(song_ogg_path):
                if os.path.samefile(output_file_path_ogg, song_ogg_path):
                    progress_text.insert(tk.END, f"Skipped copying OGG file as it's already the same in the song folder.\n")
                    progress_text.update()
                else:
                    progress_text.insert(tk.END, f"Skipped copying OGG file as both exist and are different.\n")
                    progress_text.update()
            else:
                shutil.copy(output_file_path_ogg, song_ogg_path)
                progress_text.insert(tk.END, f"Copied OGG file for {base_name} to song folder\n")
                progress_text.update()
            
            # Generar BPM y Chart JSON
            bpm_found = calculate_bpm(file_path)
            start_found = calculate_sync_tempo(bpm_found) if bpm_found else None
            global low_freq, mid_freq, very_strong_intensity, strong_intensity, weak_intensity, min_val
            easy_chart = generate_chart(file_path, bpm_found, low_freq, mid_freq, very_strong_intensity, strong_intensity, weak_intensity, min_val)
            normal_chart = generate_chart_2(file_path, bpm_found, low_freq, mid_freq, very_strong_intensity, strong_intensity, weak_intensity, min_val)
            hard_chart = generate_chart_3(file_path, bpm_found, low_freq, mid_freq, very_strong_intensity, strong_intensity, weak_intensity, min_val)
            progress_text.insert(tk.END, f"Generated chart and BPM data for {base_name}\n")
            progress_text.update()
            
            chart_data = {
                "easy": {
                    "chart": easy_chart,
                    "tempo": bpm_found,
                    "start_point": 272
                },
                "normal": {
                    "chart": normal_chart,
                    "tempo": bpm_found,
                    "start_point": 272
                },
                "hard": {
                    "chart": hard_chart,
                    "tempo": bpm_found,
                    "start_point": 272
                }
            }
            chart_file_name = f"{index}_song{index}.json"
            chart_file_path = os.path.join(chart_folder, chart_file_name)
            with open(chart_file_path, 'w', encoding='utf-8') as chart_file:
                json.dump(chart_data, chart_file, ensure_ascii=False, indent=4)
            progress_text.insert(tk.END, f"Saved chart JSON for {base_name}\n")
            progress_text.update()

            # Copiar el archivo Chart JSON
            chart_json_path = os.path.join(song_folder, "chart.json")
            if chart_file_path != chart_json_path:  # Verificar si no es el mismo archivo
                if os.path.exists(chart_json_path):
                    if not os.path.samefile(chart_file_path, chart_json_path):  # Si son distintos, no copiar
                        shutil.copy(chart_file_path, chart_json_path)
                        progress_text.insert(tk.END, f"Copied chart JSON for {base_name} to song folder\n")
                        progress_text.update()
                    else:
                        progress_text.insert(tk.END, f"Skipped copying chart JSON as it's already the same in the song folder.\n")
                        progress_text.update()
                else:
                    shutil.copy(chart_file_path, chart_json_path)
                    progress_text.insert(tk.END, f"Copied chart JSON for {base_name} to song folder\n")
                    progress_text.update()
            else:
                progress_text.insert(tk.END, f"Skipped copying chart JSON as it's the same source and destination.\n")
                progress_text.update()

            # Generar Visualizer JSON
            visualizer_json_path = os.path.join(output_folder, f"{index}_song{index}.json")
            process_audio_to_matrix(file_path, visualizer_json_path)
            progress_text.insert(tk.END, f"Generated visualizer JSON for {base_name}\n")
            progress_text.update()

            # Copiar el archivo Visualizer JSON
            visualizer_json_dest = os.path.join(song_folder, "visualizer.json")
            if visualizer_json_path != visualizer_json_dest:  # Verificar si no es el mismo archivo
                if os.path.exists(visualizer_json_dest):
                    if not os.path.samefile(visualizer_json_path, visualizer_json_dest):  # Si son distintos, no copiar
                        shutil.copy(visualizer_json_path, visualizer_json_dest)
                        progress_text.insert(tk.END, f"Copied visualizer JSON for {base_name} to song folder\n")
                        progress_text.update()
                    else:
                        progress_text.insert(tk.END, f"Skipped copying visualizer JSON as it's already the same in the song folder.\n")
                        progress_text.update()
                else:
                    shutil.copy(visualizer_json_path, visualizer_json_dest)
                    progress_text.insert(tk.END, f"Copied visualizer JSON for {base_name} to song folder\n")
                    progress_text.update()
            else:
                progress_text.insert(tk.END, f"Skipped copying visualizer JSON as it's the same source and destination.\n")
                progress_text.update()

            # Guardar nombre de la canción en TXT
            song_name_txt_path = os.path.join(song_folder, "song_name.txt")
            with open(song_name_txt_path, 'w', encoding='utf-8') as txt_file:
                txt_file.write(sanitized_name)
            progress_text.insert(tk.END, f"Saved song name file for {base_name}\n")
            progress_text.update()

            converted_files.append(base_name)

    # Escribir el archivo song_titles.json
    with open(name_file_path, 'w', encoding='utf-8') as name_file:
        json.dump({"song_names": converted_files}, name_file, ensure_ascii=False, indent=4)
    progress_text.insert(tk.END, "All songs processed successfully!\n")
    progress_text.update()


def clean_up(folder):
    for root, dirs, files in os.walk(folder, topdown=False):
        for file in files:
            os.remove(os.path.join(root, file))
        for dir in dirs:
            os.rmdir(os.path.join(root, dir))
    os.rmdir(folder)


def open_and_convert():
    try:
        update_progress("Starting file selection...")

        response = messagebox.askyesno(
            title="Selection Type",
            message="Do you want to select a single file?\nClick 'Yes' for a file or 'No' for a folder."
        )
        files = []
        input_folder = ""

        if response:
            file_or_folder = filedialog.askopenfilename(
                title="Select an MP3 file",
                filetypes=[("MP3 Files", "*.mp3")]
            )
            if file_or_folder:
                files = [file_or_folder]
                input_folder = os.path.dirname(file_or_folder)
        else:
            file_or_folder = filedialog.askdirectory(
                title="Select a folder with MP3 files"
            )
            if file_or_folder:
                input_folder = file_or_folder
                files = [os.path.join(input_folder, f) for f in os.listdir(input_folder) if f.endswith('.mp3')]

        if not files:
            messagebox.showerror("Error", "No files or folders selected.")
            return

        update_progress("Selected files successfully.")

        input_folder = os.path.join(input_folder, 'CONVERSION_OUTPUTS')

        # Crear directorios
        output_folder = os.path.join(input_folder, 'sounds/songs')
        chart_folder = os.path.join(output_folder, 'charts')
        os.makedirs(chart_folder, exist_ok=True)
        name_file_path = os.path.join(input_folder, 'sounds/song_titles.json')
        output_converted_songs = create_unique_folder('output_converted_songs', input_folder)

        update_progress("Converting MP3 files to OGG...")
        convert_mp3_to_ogg(files, output_folder, name_file_path, chart_folder, output_converted_songs)

        update_progress("Creating zip file...")
        zip_file_path = create_zip(os.path.join(input_folder, 'sounds/'), input_folder)

        update_progress("Cleaning up temporary files...")
        clean_up(os.path.join(input_folder, 'sounds/'))

        update_progress(f"Conversion completed. Files saved in {zip_file_path}.")
        messagebox.showinfo("Conversion Completed", f"Files have been successfully converted and saved in {zip_file_path}.")
        export_folder = os.path.dirname(zip_file_path)
        os.startfile(export_folder)

    except Exception as e:
        messagebox.showerror("Error", f"An error occurred: {str(e)}")
        update_progress(f"Error: {str(e)}")

def exit_program():
    root.destroy()

def show_instructions():
    instructions = (
        "Use this program to convert a .mp3 file or multiple files in a folder to .ogg format.\n"
        "It generates a base charting JSON with calculated BPM and start point, and a visualizer JSON.\n\n"
        "To load the songs into SquidBeatz3, load the zip created at the selected file(s)'s directory\n"
        "Or you can load each individual file for a song at the folder named as the original mp3 file.\n"
        "IMPORTANT: You must have ffmpeg and python installed at your PC. TO USE THIS PROGRAM YOU MUST HAVE ADMINISTRATOR PERMISSIONS\n"
    )
    messagebox.showinfo("How to Use", instructions)


def select_file():
    """Open a file dialog to select an audio file."""
    root = Tk()
    root.withdraw()
    messagebox.showinfo("File Selection", "Please select an MP3 file to generate frequency and intensity graphs.")
    file_path = filedialog.askopenfilename(filetypes=[("MP3 files", "*.mp3")])
    if file_path:
        process_audio(file_path)
    else:
        messagebox.showwarning("No File Selected", "No file selected.")
    

def process_audio(file_path):
    """Process the audio file and generate frequency, intensity, and spectral centroid graphs."""
    # Load the audio file with pydub and convert to mono
    audio = AudioSegment.from_file(file_path)
    sample_rate = audio.frame_rate
    samples = np.array(audio.get_array_of_samples())
    if audio.channels > 1:
        samples = samples[::audio.channels]  # Take only one channel if the audio is stereo

    # Convert to a format compatible with librosa
    y = samples.astype(float) / np.max(np.abs(samples))  # Normalize the samples
    sr = sample_rate

    # Calculate features with librosa
    stft = np.abs(librosa.stft(y, n_fft=2048, hop_length=512))
    times = librosa.times_like(stft[0], sr=sr)
    freqs = librosa.fft_frequencies(sr=sr)

    # Average frequency (peak)
    avg_frequencies = np.argmax(stft, axis=0) * (sr / 2) / (stft.shape[0] - 1)

    # Intensity (RMS)
    rms = librosa.feature.rms(y=y, frame_length=2048, hop_length=512)[0]

    # Normalize RMS by the maximum RMS of the entire song
    max_rms = np.max(rms)
    rms_normalized = rms / max_rms  # Normalize RMS to the max value

    # Spectral centroid
    spectral_centroid = librosa.feature.spectral_centroid(S=stft, sr=sr)[0]

    # Generate plots
    plt.figure(figsize=(12, 10))

    # Average frequency
    plt.subplot(3, 1, 1)
    plt.plot(times, avg_frequencies, label="Average Frequency")
    plt.xlabel("Time (s)")
    plt.ylabel("Frequency (Hz)")
    plt.title("Average Frequency vs Time")
    plt.legend()
    plt.grid()

    # Intensity (RMS)
    plt.subplot(3, 1, 2)
    plt.plot(times, rms_normalized, label="Intensity (RMS)", color="orange")
    plt.xlabel("Time (s)")
    plt.ylabel("Intensity (RMS)")
    plt.title("Intensity (RMS) vs Time")
    plt.legend()
    plt.grid()

    # Spectral centroid
    plt.subplot(3, 1, 3)
    plt.plot(times, spectral_centroid, label="Spectral Centroid", color="green")
    plt.xlabel("Time (s)")
    plt.ylabel("Frequency (Hz)")
    plt.title("Frequency vs Time (Normal Difficulty)")
    plt.legend()
    plt.grid()

    plt.tight_layout()
    plt.show()

    

# Create main application window
root = tk.Tk()
root.title("MP3 to SquidBeatz3 Format Converter")
root.geometry("500x440")
root.configure(bg="#333333")

# Load custom font (Splatoon2)
try:
    font_path = "Splatoon2"  # Update this path if needed
    splatoon_font = Font(file=font_path, size=16)
except Exception:
    splatoon_font = Font(family="Arial", size=16)

# Title
title_label = tk.Label(
    root,
    text="MP3 to SquidBeatz3 Format Converter",
    bg="#333333",
    fg="white",
    font=splatoon_font
)
title_label.pack(pady=20)

# Buttons
button_font = Font(family="Arial", size=12, weight="bold")

how_to_use_button = tk.Button(
    root,
    text="HOW TO USE",
    command=show_instructions,
    bg="#555555",
    fg="white",
    font=button_font
)
how_to_use_button.pack(pady=10)

open_convert_button = tk.Button(
    root,
    text="OPEN AND CONVERT",
    command=open_and_convert,
    bg="#555555",
    fg="white",
    font=button_font
)
open_convert_button.pack(pady=10)

customize_chart_button = tk.Button(
    root,
    text="CUSTOMIZE AUTO CHART",
    command=customize_auto_chart,
    bg="#555555",
    fg="white",
    font=button_font
)
customize_chart_button.pack(pady=10)

generator_button = tk.Button(
    root,
    text="FREQ AND INTENSITY HELPER",
    command=select_file,
    bg="#555555",
    fg="white",
    font=button_font
)
generator_button.pack(pady=10)

exit_button = tk.Button(
    root,
    text="EXIT",
    command=exit_program,
    bg="#555555",
    fg="white",
    font=button_font
)
exit_button.pack(pady=10)

# Progreso en la esquina inferior izquierda
progress_text = tk.Text(root, height=5, bg="#222222", fg="white", wrap=tk.WORD)
progress_text.place(x=10, y=350, width=480, height=80)
progress_text.insert(tk.END, "Ready to process files...\n")
progress_text.config(state=tk.DISABLED)

# Run the application
root.mainloop()