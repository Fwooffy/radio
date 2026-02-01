set("log.stdout", true)
set("server.telnet", false)

# Folder-based source (reloads when files change)
music = playlist(mode="random", reload=60, "/srv/radio/music")

# Safety wrapper so the stream never crashes if a file is weird
radio = mksafe(music)

# Send to Icecast
output.icecast(
  %mp3(bitrate=128, samplerate=44100, stereo=true),
  host="127.0.0.1",
  port=8000,
  password="CHANGE_ME_SOURCE",
  mount="stream.mp3",
  name="My Radio",
  description="24/7 stream powered by Liquidsoap + Icecast",
  genre="Radio",
  url="https://radio.yourdomain.com",
  radio
)
