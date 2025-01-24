import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft
from pydub import AudioSegment
from tkinter import Tk, filedialog, messagebox
import librosa
import librosa.display


def select_file():
    """Open a file dialog to select an audio file."""
    root = Tk()
    root.withdraw()
    file_path = filedialog.askopenfilename(filetypes=[("Audio files", "*.mp3")])
    return file_path


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


# Main
if __name__ == "__main__":
    root = Tk()
    root.withdraw()
    messagebox.showinfo("File Selection", "Please select an MP3 or WAV file to generate frequency and intensity graphs.")
    file_path = select_file()
    if file_path:
        process_audio(file_path)
    else:
        messagebox.showwarning("No File Selected", "No file selected.")
