import os
import json
from pydub import AudioSegment
from tkinter import filedialog, Tk, messagebox
import librosa
import numpy as np

# Función para calcular el BPM de una canción
def calculate_bpm(audio_path):
    try:
        y, sr = librosa.load(audio_path, sr=None)
        tempo, _ = librosa.beat.beat_track(y=y, sr=sr)
        
        # Asegurarse de que `tempo` sea un valor escalar
        if isinstance(tempo, (list, tuple, np.ndarray)):  # Verificar si es un arreglo
            tempo = tempo[0]  # Seleccionar el primer valor si es un arreglo
        
        return int(tempo)
    except Exception as e:
        print(f"Error al procesar el archivo de audio: {e}")
        return None

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
        json.dump({"song_titles": converted_files}, name_file, ensure_ascii=False, indent=4)



root = Tk()
root.withdraw()

# Preguntar al usuario si desea seleccionar un archivo o una carpeta
response = messagebox.askyesno(
    title="Tipo de selección",
    message="¿Deseas seleccionar un archivo?\nSelecciona 'Sí' para un archivo y 'No' para una carpeta."
)

files = []
input_folder = ""

if response:  # Si selecciona "Sí", elegir un archivo
    file_or_folder = filedialog.askopenfilename(
        title="Selecciona un archivo MP3",
        filetypes=[("Archivos MP3", "*.mp3")]
    )
    if file_or_folder:
        files = [file_or_folder]
        input_folder = os.path.dirname(file_or_folder)
    else:
        print("No se seleccionó ningún archivo.")
else:  # Si selecciona "No", elegir una carpeta
    file_or_folder = filedialog.askdirectory(
        title="Selecciona una carpeta con archivos MP3"
    )
    if file_or_folder:
        input_folder = file_or_folder
        files = [os.path.join(input_folder, f) for f in os.listdir(input_folder) if f.endswith('.mp3')]
    else:
        print("No se seleccionó ninguna carpeta.")

if files:
    output_folder = os.path.join(input_folder, 'to_ogg')
    os.makedirs(output_folder, exist_ok=True)

    chart_folder = os.path.join(output_folder, 'charts')
    os.makedirs(chart_folder, exist_ok=True)

    name_file_path = os.path.join(output_folder, 'song_titles.json')

    # Aquí llamas a tu función de conversión
    convert_mp3_to_ogg(files, output_folder, name_file_path, chart_folder)
else:
    print("No se seleccionaron archivos ni carpetas.")