require "typhoeus"

resp1 = Typhoeus.get("http://example.com/")
resp1.body

resp2 = Typhoeus.post("http://example.com/", body: "some_data")
resp2.body

resp3 = Typhoeus.put("http://example.com/", body: "some_data")
resp3.body

resp4 = Typhoeus.patch("http://example.com/", body: "some_data")
resp4.body

resp5 = Typhoeus.delete("http://example.com/")
resp5.body

resp6 = Typhoeus.head("http://example.com/")
resp6.body

resp7 = Typhoeus.options("http://example.com/")
resp7.body