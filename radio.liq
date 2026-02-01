set("log.stdout", true)

s = playlist(mode="random", reload_mode="watch", "/music")
s = crossfade(s)

output.icecast(
  %mp3(bitrate=128),
  host="icecast",
  port=8000,
  password="sourcepass_change_me",
  mount="/stream.mp3",
  name="Home Radio",
  s
)
