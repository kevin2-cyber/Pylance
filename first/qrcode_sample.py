import qrcode

img = qrcode.make('Hello World')
img.save('hello.png')

testing = qrcode.make('hi world')
testing.save('hi.png')

qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=10,
    border=4,
)
qr.add_data("https://abhijithchandradas.medium.com/")
qr.make(fit=True)

image = qr.make_image(fill_color="yellow", back_color="black")
image.save("medium.png")
