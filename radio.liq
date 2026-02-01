############################################
# Neon Radio: playlist + crossfade + metadata JSON
# Paths:
#   Music:   /srv/radio/music
#   Meta:    /srv/radio/meta/now.json
#            /srv/radio/meta/history.json
############################################

set("log.stdout", true)
set("server.telnet", false)

# --- CONFIG YOU SHOULD EDIT ---
music_dir = "/srv/radio/music"
meta_dir  = "/srv/radio/meta"

icecast_host = "127.0.0.1"
icecast_port = 8000
icecast_password = "CHANGE_ME_SOURCE_PASSWORD"
icecast_mount = "stream.mp3"

station_name = "Neon Radio"
station_desc = "24/7 stream powered by Liquidsoap + Icecast"
station_genre = "Radio"
station_url = "https://radio.yourdomain.com"
# ------------------------------

# Keep last 10 played tracks (in memory)
history = ref([])

# JSON-escape helper (minimal but effective)
def json_escape(s) =
  s = string.replace(pattern="\\", repl="\\\\", s)
  s = string.replace(pattern="\"", repl="\\\"", s)
  s = string.replace(pattern="\n", repl=" ", s)
  s
end

# Safe getter from metadata map-like object
def mget(m, k, d) =
  v = m[k]
  if v == "" then d else v end
end

# Write now playing + history JSON files
def write_now_and_history(m) =
  artist = mget(m, "artist", "Unknown Artist")
  title  = mget(m, "title",  "Unknown Title")
  album  = mget(m, "album",  "")

  display =
    if album == "" then
      "#{artist} — #{title}"
    else
      "#{artist} — #{title} (#{album})"
    end

  # Prepend new track, keep last 10
  history := list.take(10, [display] @ !history)

  now_json =
    "{\"artist\":\"#{json_escape(artist)}\",\"title\":\"#{json_escape(title)}\",\"album\":\"#{json_escape(album)}\",\"display\":\"#{json_escape(display)}\",\"ts\":#{int_of_float(time())}}"
  file.write("#{meta_dir}/now.json", now_json)

  items = list.map(fun(x) -> "\"#{json_escape(x)}\"", !history)
  hist_json =
    "{\"items\":[#{string.concat(separator=\",\", items)}],\"ts\":#{int_of_float(time())}}"
  file.write("#{meta_dir}/history.json", hist_json)
end

# Playlist:
# mode="randomize" = s
