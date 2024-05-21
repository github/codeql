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

req8 = Typhoeus::Request.new("http://example.com")
req8.run.body

req9 = Typhoeus::Request.new("http://example.com")
req9.run
req9.response.body

req10 = Typhoeus::Request.new("http://example.com")
req10.run.response_body

req11 = Typhoeus::Request.new("http://example.com")
req11.on_complete do |resp11| 
    resp11.body
end

req12 = Typhoeus::Request.new("http://example.com")
req12.on_success do |resp12| 
    resp12.body
end

req13 = Typhoeus::Request.new("http://example.com")
req13.on_failure do |resp13| 
    resp13.body
end

req14 = Typhoeus::Request.new("http://example.com")
req14.on_progress do |resp14| 
    resp14.body
end

req15 = Typhoeus::Request.new("http://example.com")
req15.on_body do |body15| 
    # ...
end