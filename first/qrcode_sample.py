import qrcode

img = qrcode.make('Hello World')
img.save('hello.png')

testing = qrcode.make('hi world')
testing.save('hi.png')
