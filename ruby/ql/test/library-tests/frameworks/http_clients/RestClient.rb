require "rest-client"

resp1 = RestClient.get("http://example.com/")
resp1.body

resp2 = RestClient.post("http://example.com", some: "data")
resp2.body

resp3 = RestClient.put("http://example.com", some: "data")
resp3.body

resp4 = RestClient.patch("http://example.com", some: "data")
resp4.body

resp5 = RestClient.delete("http://example.com")
resp5.body

resp6 = RestClient.head("http://example.com")
resp6.body

resp7 = RestClient.options("http://example.com")
resp7.body

resource8 = RestClient::Resource.new "http://example.com"
resp8 = resource8.get
resp8.body

resp9 = RestClient::Request.execute(method: :get, url: 'http://example.com/resource')
resp9.body