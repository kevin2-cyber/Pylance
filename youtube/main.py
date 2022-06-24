from pytube import YouTube, StreamQuery

downloads: str = 'C:\\Downloads'

video_link: str = "https://youtu.be/z3uAMxLXa7E"

try:
    video: YouTube = YouTube(video_link)
finally:
    print("video isn't downloading")

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
finally:
    print("Error downloading")

print("Video downloaded")
