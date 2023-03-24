require "faraday"

# BAD
connection = Faraday.new("http://example.com", ssl: { verify: false })
response = connection.get("/")

# BAD
connection = Faraday.new("http://example.com", ssl: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
response = connection.get("/")

# GOOD
connection = Faraday.new("http://example.com")
response = connection.get("/")

# GOOD
response = Faraday.get("http://example.com")

# GOOD
connection = Faraday.new("http://example.com", ssl: { version: :TLSv1 })
response = connection.get("/")

# GOOD
connection = Faraday.new("http://example.com", ssl: { verify: true })
response = connection.get("/")

# GOOD
connection = Faraday.new("http://example.com", ssl: { verify_mode: OpenSSL::SSL::VERIFY_PEER })
response = connection.get("/")

# -- example of passing verify as argument --

def verify_as_arg(host, path, arg)
    # BAD, due to the call below
    connection = Faraday.new(host, ssl: { verify: arg })
    response = connection.get(path)
end

verify_as_arg("http://example.com", "/", false)


def verify_mode_as_arg(host, path, arg)
    # BAD, due to the call below
    connection = Faraday.new(host, ssl: { verify_mode: arg })
    response = connection.get(path)
end

verify_mode_as_arg("http://example.com", "/", OpenSSL::SSL::VERIFY_NONE)
