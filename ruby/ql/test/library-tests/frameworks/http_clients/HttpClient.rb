require "httpclient"

resp1 = HTTPClient.get("http://example.com/")
resp1.body

resp2 = HTTPClient.post("http://example.com/", body: "some_data")
resp2.content

resp3 = HTTPClient.put("http://example.com/", body: "some_data")
resp3.http_body

resp5 = HTTPClient.delete("http://example.com/")
resp5.dump

resp6 = HTTPClient.head("http://example.com/")
resp6.body

resp7 = HTTPClient.options("http://example.com/")
resp7.content

resp8 = HTTPClient.trace("http://example.com/")
resp8.http_body

resp9 = HTTPClient.get_content("http://example.com/")

resp10 = HTTPClient.post_content("http://example.com/", body: "some_data")
