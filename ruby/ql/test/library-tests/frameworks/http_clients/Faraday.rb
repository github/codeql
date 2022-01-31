require "faraday"

resp1 = Faraday.get("http://example.com/")
resp1.body

resp2 = Faraday.post("http://example.com/", body: "some_data")
resp2.body

resp3 = Faraday.put("http://example.com/", body: "some_data")
resp3.body

resp4 = Faraday.patch("http://example.com/", body: "some_data")
resp4.body

resp5 = Faraday.delete("http://example.com/")
resp5.body

resp6 = Faraday.head("http://example.com/")
resp6.body

resp7 = Faraday.options("http://example.com/")
resp7.body

resp8 = Faraday.trace("http://example.com/")
resp8.body

connection = Faraday.new("http://example.com")
resp9 = connection.get("/")
resp9.body

resp10 = connection.post("/foo", some: "data")
resp10.body

connection = Faraday.new(url: "http://example.com")
resp11 = connection.get("/")
resp11.body