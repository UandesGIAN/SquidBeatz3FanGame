import os
import json
from pydub import AudioSegment
from tkinter import filedialog, messagebox
from tkinter.font import Font
import numpy as np
import tkinter as tk
import math
import zipfile
import numpy as np
import pywt
import librosa
from scipy import signal
import shutil


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


def generate_easy_chart(audio_path, bpm, start):
    y, sr = librosa.load(audio_path, sr=None)
    onset_env = librosa.onset.onset_strength(y=y, sr=sr)
    onset_frames = librosa.onset.onset_detect(onset_envelope=onset_env, sr=sr, units='time')

    # Calcular características adicionales
    rms = librosa.feature.rms(y=y, frame_length=2048, hop_length=512)[0]
    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr, units='time')
    beat_intervals = np.diff(beat_frames) if len(beat_frames) > 1 else [0]

    stft = np.abs(librosa.stft(y))
    freqs = librosa.fft_frequencies(sr=sr)
    times = librosa.times_like(stft[0], sr=sr)

    chart = []
    previous_note_pos = -100  # Posición inicial fuera del rango de aparición
    repetition_count = 0

    for onset in onset_frames:
        closest_idx = np.argmin(np.abs(times - onset))
        low_energy = np.sum(stft[freqs < 200, closest_idx])
        mid_energy = np.sum(stft[(freqs >= 200) & (freqs < 2000), closest_idx])
        high_energy = np.sum(stft[freqs >= 2000, closest_idx])
        avg_rms = rms[closest_idx] if closest_idx < len(rms) else 0
        beat_interval = beat_intervals[closest_idx % len(beat_intervals)] if beat_intervals.size > 0 else 0

        # Determinar tipo de nota con mayor variedad
        if repetition_count >= 4 and onset - previous_note_pos < 50:
            # Si hay repetición reciente, generar notas altas o especiales
            index_type = np.random.randint(4, 8)
            repetition_count = 0
        elif high_energy > mid_energy and high_energy > low_energy:
            index_type = np.random.randint(0, 2)  # Notas bajas o normales
        elif low_energy > mid_energy and low_energy > high_energy:
            index_type = 2
        elif mid_energy > high_energy and mid_energy > low_energy:
            index_type = np.random.randint(1, 3)
        elif avg_rms > 0.05 and beat_interval < 0.5:
            index_type = np.random.choice([2, 4, 5])  # Ritmos marcados
        else:
            index_type = np.random.randint(4, 8)  # Notas especiales

        # Posición en el chart (relativa al tempo y sincronización)
        pos_x = round((onset * (bpm * 132 / 60)), 1)

        # Evitar duplicados consecutivos
        if pos_x - previous_note_pos >= 30:  # Mantener espacio mínimo entre notas
            chart.append({"pos_x": pos_x, "index_type": index_type})
            previous_note_pos = pos_x
            repetition_count += 1
        else:
            repetition_count = 0

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

            # Crear una carpeta individual para la canción dentro de output_converted_songs
            song_folder = os.path.join(output_converted_songs, base_name)
            os.makedirs(song_folder, exist_ok=True)

            # Conversión a OGG
            output_file_name_ogg = f"{index}_song{index}.ogg"
            output_file_path_ogg = os.path.join(output_folder, output_file_name_ogg)
            audio = AudioSegment.from_mp3(file_path)
            audio.export(output_file_path_ogg, format="ogg")

            # Copiar el archivo OGG tanto a sounds/songs como a output_converted_songs
            song_ogg_path = os.path.join(song_folder, f"song.ogg")
            if not os.path.exists(song_ogg_path):
                shutil.copy(output_file_path_ogg, song_ogg_path)
            if not os.path.exists(os.path.join(output_folder, f"{index}_song{index}.ogg")):
                shutil.copy(output_file_path_ogg, os.path.join(output_folder, f"{index}_song{index}.ogg"))

            # BPM y Chart JSON
            bpm_found = calculate_bpm(file_path)
            start_found = calculate_sync_tempo(bpm_found) if bpm_found else None
            easy_chart = generate_easy_chart(file_path, bpm_found, start_found)

            chart_data = {
                "easy": {
                    "chart": easy_chart,
                    "tempo": bpm_found,
                    "start_point": start_found
                },
                "normal": {
                    "chart": [],
                    "tempo": bpm_found,
                    "start_point": start_found
                },
                "hard": {
                    "chart": [],
                    "tempo": bpm_found,
                    "start_point": start_found
                }
            }
            chart_file_name = f"{index}_song{index}.json"
            chart_file_path = os.path.join(chart_folder, chart_file_name)
            with open(chart_file_path, 'w', encoding='utf-8') as chart_file:
                json.dump(chart_data, chart_file, ensure_ascii=False, indent=4)

            # Copiar el archivo Chart JSON tanto a sounds/songs/charts como a output_converted_songs
            chart_json_path = os.path.join(song_folder, "chart.json")
            if not os.path.exists(chart_json_path):
                shutil.copy(chart_file_path, chart_json_path)
            if not os.path.exists(os.path.join(chart_folder, chart_file_name)):
                shutil.copy(chart_file_path, os.path.join(chart_folder, chart_file_name))

            # Visualizer JSON
            visualizer_json_path = os.path.join(output_folder, f"{index}_song{index}.json")
            process_audio_to_matrix(file_path, visualizer_json_path)

            # Copiar el archivo Visualizer JSON tanto a sounds/songs como a output_converted_songs
            visualizer_json_dest = os.path.join(song_folder, "visualizer.json")
            if not os.path.exists(visualizer_json_dest):
                shutil.copy(visualizer_json_path, visualizer_json_dest)
            if not os.path.exists(os.path.join(output_folder, f"{index}_song{index}.json")):
                shutil.copy(visualizer_json_path, os.path.join(output_folder, f"{index}_song{index}.json"))

            # Archivo de nombre de la canción TXT
            song_name_txt_path = os.path.join(song_folder, f"{base_name}.txt")
            with open(song_name_txt_path, 'w', encoding='utf-8') as txt_file:
                txt_file.write(base_name)

            converted_files.append(base_name)

    # Escribir el archivo song_titles.json en sounds/
    with open(name_file_path, 'w', encoding='utf-8') as name_file:
        json.dump({"song_names": converted_files}, name_file, ensure_ascii=False, indent=4)


def clean_up(folder):
    for root, dirs, files in os.walk(folder, topdown=False):
        for file in files:
            os.remove(os.path.join(root, file))
        for dir in dirs:
            os.rmdir(os.path.join(root, dir))
    os.rmdir(folder)


def open_and_convert():
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

    input_folder = os.path.join(input_folder, 'CONVERSION_OUTPUTS')

    # Crear directorios
    output_folder = os.path.join(input_folder, 'sounds/songs')
    chart_folder = os.path.join(output_folder, 'charts')
    os.makedirs(chart_folder, exist_ok=True)
    name_file_path = os.path.join(input_folder, 'sounds/song_titles.json')
    output_converted_songs = create_unique_folder('output_converted_songs', input_folder)

    convert_mp3_to_ogg(files, output_folder, name_file_path, chart_folder, output_converted_songs)

    zip_file_path = create_zip(os.path.join(input_folder, 'sounds/'), input_folder)
    
    clean_up(os.path.join(input_folder, 'sounds/'))

    messagebox.showinfo("Conversion Completed", f"Files have been successfully converted and saved in {zip_file_path}.")

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


# Create main application window
root = tk.Tk()
root.title("MP3 to SquidBeatz3 Format Converter")
root.geometry("500x300")
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

exit_button = tk.Button(
    root,
    text="EXIT",
    command=exit_program,
    bg="#555555",
    fg="white",
    font=button_font
)
exit_button.pack(pady=10)

# Run the application
root.mainloop()