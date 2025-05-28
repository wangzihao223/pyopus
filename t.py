import pyopus


CHANNELS = 1
RATE = 48000

res = pyopus.create_encoder(RATE, CHANNELS, 2048)
print(res)