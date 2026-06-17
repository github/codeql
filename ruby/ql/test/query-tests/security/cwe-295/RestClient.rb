require "rest-client"

# BAD
resource = RestClient::Resource.new("https://example.com", verify_ssl: OpenSSL::SSL::VERIFY_NONE)
response = resource.get # $ Alert

# BAD
resource = RestClient::Resource.new("https://example.com", { verify_ssl: OpenSSL::SSL::VERIFY_NONE })
response = resource.get # $ Alert

# BAD
options = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
resource = RestClient::Resource.new("https://example.com", options)
response = resource.get # $ Alert

# BAD
value = OpenSSL::SSL::VERIFY_NONE
resource = RestClient::Resource.new("https://example.com", verify_ssl: value)
response = resource.get # $ Alert

# GOOD
RestClient.get("https://example.com")

# GOOD
resource = RestClient::Resource.new("https://example.com")
response = resource.get

# GOOD
resource = RestClient::Resource.new("https://example.com", verify_ssl: OpenSSL::SSL::VERIFY_PEER)
response = resource.get
# GOOD
resource = RestClient::Resource.new("https://example.com", { verify_ssl: OpenSSL::SSL::VERIFY_PEER })
response = resource.get

# GOOD
options = { verify_ssl: OpenSSL::SSL::VERIFY_PEER }
resource = RestClient::Resource.new("https://example.com", options)
response = resource.get
