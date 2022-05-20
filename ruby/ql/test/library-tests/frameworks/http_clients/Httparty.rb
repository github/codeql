require "httparty"

# If the response body is not nil or an empty string, it will be parsed and returned directly.

HTTParty.get("http://example.com/")

HTTParty.post("http://example.com/", body: "some_data")

HTTParty.put("http://example.com/", body: "some_data")

HTTParty.patch("http://example.com/", body: "some_data")

# Otherwise, `HTTParty::Response` will be returned, which has a `#body` method.

resp5 = HTTParty.delete("http://example.com/")
resp5.body

resp6 = HTTParty.head("http://example.com/")
resp6.body

resp7 = HTTParty.options("http://example.com/")
resp7.body

# HTTParty methods can also be included in other classes.
# This is not yet modelled.

class MyClient
  inlcude HTTParty
end

MyClient.get("http://example.com")
