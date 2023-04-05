require "net/http"

uri = URI.parse("https://example.com")
Net::HTTP.get(uri)

resp = Net::HTTP.post(URI.parse(uri), "some_body")
resp.body
resp.read_body
resp.entity

req = Net::HTTP.new("https://example.com")

r1 = req.get("/")
r2 = req.post("/")
r3 = req.put("/")
r4 = req.patch("/")

r1.body
r2.read_body
r3.entity
r4.foo

def get(domain, path)
  Net::HTTP.new(domain).get(path)
end

get("example.com", "/").body

Net::HTTP.post(uri, "some_body") # note: response body not accessed
