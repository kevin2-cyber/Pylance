from pytube import YouTube, StreamQuery

downloads: str = '/Users/kelvineduful/Downloads/youtube'

audio_link: str = "https://youtu.be/Db-CF_rfZWs"

try:
    audio: YouTube = YouTube(audio_link)
except:
    print("Audio isn't downloading")
finally:
    print("Audio is downloading")

print(audio.title)
print(audio.views)
print(audio.author)
print(audio.description)

lst: StreamQuery = audio.streams.filter()
for x in lst:
    print(x)

print(audio.streams.filter(only_audio=True).get_audio_only().itag)
audio_itag: int = audio.streams.filter(only_audio=True).get_audio_only().itag

try:
    file_name: str = "Unending Love - Hillsong Worship.mp3"
    audio.streams.get_by_itag(audio_itag).download(output_path=downloads, filename=file_name)
except:
    print("Error downloading")
finally:
    print("Audio downloaded")
