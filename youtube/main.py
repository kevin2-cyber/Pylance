from pytube import YouTube

downloads = 'C:\\Downloads'

video_link = "https://youtu.be/xUodSGUkwGM"

try:
    video = YouTube(video_link)
except:
    print("video isn't downloading")

print(video.title)
print(video.views)
print(video.author)
print(video.description)

lst = video.streams.filter()
for x in lst:
    print(x)

print(video.streams.filter(progressive=True).get_highest_resolution().itag)
video_itag = video.streams.filter(progressive=True).get_highest_resolution().itag

try:
    video.streams.get_by_itag(video_itag).download(output_path=downloads)
except:
    print("Error downloading")

print("Video downloaded")




