require "httpclient"

# BAD
client = HTTPClient.new
client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
client.get("https://example.com")

# GOOD
client = HTTPClient.new
client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_PEER
client.get("https://example.com")

# GOOD
client = HTTPClient.new
client.get("https://example.com")

# GOOD
HTTPClient.get("https://example.com/")