import librosa
import numpy as np
from scipy.signal import find_peaks
from pydub import AudioSegment
from tkinter import Tk, filedialog
import matplotlib.pyplot as plt
import os
import subprocess
import shutil

def open_file():
    Tk().withdraw()
    file_path = filedialog.askopenfilename(title="Seleccionar archivo MP3",
                                           filetypes=[("Archivos MP3", "*.mp3")])
    return file_path

def convert_mp3_to_wav(mp3_path):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    wav_path = os.path.join(script_dir, os.path.splitext(os.path.basename(mp3_path))[0] + "_converted.wav")
    
    if not os.path.exists(wav_path):
        audio = AudioSegment.from_mp3(mp3_path)
        audio.export(wav_path, format="wav")
        print(f"Archivo convertido a WAV: {wav_path}")
    else:
        print(f"El archivo WAV ya existe: {wav_path}")
    return os.path.relpath(wav_path)

def extract_drums(mp3_path):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    drums_output_path = os.path.join(script_dir, "drums.wav")  # Ruta final para drums.wav

    if os.path.exists(drums_output_path):
        print(f"drums.wav ya existe en {drums_output_path}.")
        return os.path.relpath(drums_output_path)

    print(f"Generando drums.wav a partir de {mp3_path}...")
    try:
        demucs_output_dir = os.path.join(script_dir, "separated", "htdemucs", os.path.splitext(os.path.basename(mp3_path))[0])
        generated_drums_path = os.path.join(demucs_output_dir, "drums.wav")
        if os.path.exists(generated_drums_path):
            # Copiar drums.wav al directorio del script
            shutil.copy(generated_drums_path, drums_output_path)
            print(f"drums.wav copiado correctamente a {drums_output_path}.")
        else:
            # Ejecutar Demucs
            subprocess.run(["demucs", "--two-stems", "drums", mp3_path], check=True)

            # Carpeta generada por Demucs
            
            if os.path.exists(generated_drums_path):
                # Copiar drums.wav al directorio del script
                shutil.copy(generated_drums_path, drums_output_path)
                print(f"drums.wav copiado correctamente a {drums_output_path}.")
    except Exception as e:
        print(f"Error al ejecutar Demucs: {e}")
        return None

    return os.path.relpath(drums_output_path)



def detect_peaks(file_path, filter_high_freq=False, threshold=0.02, sr_target=None):
    y, sr = librosa.load(file_path, sr=sr_target)
    if filter_high_freq:
        y = librosa.effects.preemphasis(y, coef=0.97)
    frame_length = 2048
    hop_length = 512
    rms = librosa.feature.rms(y=y, frame_length=frame_length, hop_length=hop_length)[0]
    times = librosa.frames_to_time(np.arange(len(rms)), sr=sr, hop_length=hop_length)
    peaks, properties = find_peaks(rms, height=threshold)
    intensity_list = [(times[p], properties["peak_heights"][i]) for i, p in enumerate(peaks)]
    return intensity_list

def filter_peaks(peaks, min_intensity):
    return [peak for peak in peaks if peak[1] >= min_intensity]

def plot_peaks(peaks):
    times = [p[0] for p in peaks]
    intensities = [p[1] for p in peaks]

    plt.figure(figsize=(12, 6))
    plt.scatter(times, intensities, c="blue", alpha=0.7)
    plt.title("Intensidad de los picos detectados", fontsize=16)
    plt.xlabel("Tiempo (s)", fontsize=14)
    plt.ylabel("Intensidad", fontsize=14)
    plt.grid(True, linestyle="--", alpha=0.6)
    plt.tight_layout()
    plt.show()

def main():
    print("Selecciona el archivo MP3 original:")
    mp3_path = open_file()
    if not mp3_path:
        print("No se seleccionó ningún archivo.")
        return

    drums_path = extract_drums(mp3_path)
    wav_path = convert_mp3_to_wav(mp3_path)

    print("Detectando picos en drums.wav...")
    drums_peaks = detect_peaks(drums_path, threshold=0.02)
    min_intensity_drums = 0.05
    drums_filtered = filter_peaks(drums_peaks, min_intensity=min_intensity_drums)

    print("Detectando picos en el archivo original...")
    original_peaks = detect_peaks(wav_path, filter_high_freq=True, threshold=0.02)

    combined_peaks = drums_filtered + original_peaks
    combined_peaks_sorted = sorted(combined_peaks, key=lambda x: x[0])

    print("\nListado combinado (ordenado por tiempo):")
    for time, intensity in combined_peaks_sorted:
        print(f"Tiempo: {time:.3f}s, Intensidad: {intensity:.4f}")

    plot_peaks(combined_peaks_sorted)

if __name__ == "__main__":
    main()
