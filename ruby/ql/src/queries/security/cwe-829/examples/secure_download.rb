require "net/http"

script = Net::HTTP.new("https://mydownload.example.org").get("/myscript.sh").body
system(script)