from pytube import YouTube, StreamQuery

downloads: str = 'C:\\Downloads'

audio_link: str = "https://youtu.be/ivUb1K0B0zE"

try:
    audio: YouTube = YouTube(audio_link)
finally:
    print("Audio isn't downloading")

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
    file_name: str = "Yeshua.mp3"
    audio.streams.get_by_itag(audio_itag).download(output_path=downloads, filename=file_name)
finally:
    print("Error downloading")

print("Audio downloaded")
