from pytube import YouTube, StreamQuery

downloads: str = 'C:\\Downloads'

video_link: str = "https://youtu.be/8Dn2UQ__8QM"

try:
    video: YouTube = YouTube(video_link)
except:
    print("video isn't downloading")

finally:
    print("Downloading Successful")

print(video.title)
print(video.views)
print(video.author)
print(video.description)

lst: StreamQuery = video.streams.filter()
for x in lst:
    print(x)

print(video.streams.filter(progressive=True).get_highest_resolution().itag)
video_itag: int = video.streams.filter(progressive=True).get_highest_resolution().itag

try:
    video.streams.get_by_itag(video_itag).download(output_path=downloads)
except:
    print("Error downloading")

finally:
    print("Video downloaded")


