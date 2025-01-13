import os
import json
from pydub import AudioSegment
from tkinter import filedialog, messagebox
from tkinter.font import Font
import numpy as np
import tkinter as tk
import math
import wave
import numpy as np
import pywt
import librosa
from scipy import signal


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

def convert_mp3_to_ogg(files, output_folder, name_file_path, chart_folder):
    converted_files = []
    for index, file_path in enumerate(files, start=1):
        if file_path.endswith('.mp3'):
            output_file_name_ogg = f"{index}_song{index}.ogg"
            output_file_path_ogg = os.path.join(output_folder, output_file_name_ogg)

            audio = AudioSegment.from_mp3(file_path)
            audio.export(output_file_path_ogg, format="ogg")
            print(f"Convertido: {file_path} -> {output_file_path_ogg}")
            converted_files.append(os.path.splitext(os.path.basename(file_path))[0])

            bpm_found = calculate_bpm(file_path)
            start_found = calculate_sync_tempo(bpm_found) if bpm_found else None

            chart_data = {
                "easy": {
                    "chart": [],
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

            visualizer_json_path = os.path.join(output_folder, chart_file_name)
            process_audio_to_matrix(file_path, visualizer_json_path)

    with open(name_file_path, 'w', encoding='utf-8') as name_file:
        json.dump({"song_names": converted_files}, name_file, ensure_ascii=False, indent=4)
    
    messagebox.showinfo("Conversion Completed", "Files have been successfully converted and saved.")

def show_instructions():
    instructions = (
        "Use this program to convert a .mp3 file or multiple files in a folder to .ogg format.\n"
        "It generates a base charting JSON with calculated BPM and start point, and a visualizer JSON.\n\n"
        "To load the songs into SquidBeatz3, compress the generated files in the 'to_ogg' folder into a .ZIP\n"
        "with the structure: sounds > songs > charts. Each .ogg or .json file should be named\n"
        "{number}_song{number}.format. Additionally, a 'song_titles.json' file must be included in the 'sounds' folder."
    )
    messagebox.showinfo("How to Use", instructions)


def open_and_convert():
    # Select file or folder
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

    # Create output structure
    output_folder = os.path.join(input_folder, 'sounds/songs')
    chart_folder = os.path.join(output_folder, 'charts')
    os.makedirs(chart_folder, exist_ok=True)
    name_file_path = os.path.join(input_folder, 'sounds/song_titles.json')

    # Convert files
    convert_mp3_to_ogg(files, output_folder, name_file_path, chart_folder)

def exit_program():
    root.destroy()

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