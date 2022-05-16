from pytube import YouTube

downloads = 'C:\\Downloads'

audio_link = "https://youtu.be/dQl4izxPeNU"

try:
    audio = YouTube(audio_link)
except:
    print("Audio isn't downloading")

print(audio.title)
print(audio.views)
print(audio.author)
print(audio.description)

lst = audio.streams.filter()
for x in lst:
    print(x)

print(audio.streams.filter(only_audio=True).get_audio_only().itag)
audio_itag = audio.streams.filter(only_audio=True).get_audio_only().itag

try:
    file_name = "King of Kings.mp3"
    audio.streams.get_by_itag(audio_itag).download(output_path=downloads, filename=file_name)
except:
    print("Error downloading")

print("Audio downloaded")




