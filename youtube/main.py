from pytube import YouTube

video_link = "https://youtu.be/YY-_yrZdjGc"

video = YouTube(video_link)

video.streams.filter(res='1080p').first().download('C:\\Downloads')
