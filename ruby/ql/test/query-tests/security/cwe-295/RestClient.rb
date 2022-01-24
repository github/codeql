require "rest-client"

# BAD
resource = RestClient::Resource.new("https://example.com", verify_ssl: OpenSSL::SSL::VERIFY_NONE)
response = resource.get

# BAD
resource = RestClient::Resource.new("https://example.com", { verify_ssl: OpenSSL::SSL::VERIFY_NONE })
response = resource.get

# BAD
options = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
resource = RestClient::Resource.new("https://example.com", options)
response = resource.get

# GOOD
RestClient.get("https://example.com")

# GOOD
resource = RestClient::Resource.new("https://example.com")
response = resource.get

# GOOD
resource = RestClient::Resource.new("https://example.com", verify_ssl: OpenSSL::SSL::VERIFY_PEER)
response = resource.get
# BAD
resource = RestClient::Resource.new("https://example.com", { verify_ssl: OpenSSL::SSL::VERIFY_PEER })
response = resource.get

# GOOD
options = { verify_ssl: OpenSSL::SSL::VERIFY_PEER }
resource = RestClient::Resource.new("https://example.com", options)
response = resource.get