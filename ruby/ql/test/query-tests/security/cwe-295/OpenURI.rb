require "open-uri"

# BAD
Kernel.open("https://example.com", ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)

# BAD
Kernel.open("https://example.com", { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE })

# BAD
options = { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }
Kernel.open("https://example.com", options)

# BAD
URI.parse("https://example.com").open(ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)

# BAD
URI.parse("https://example.com").open({ ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE })

# BAD
options = { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }
URI.parse("https://example.com").open(options)

# GOOD
Kernel.open("https://example.com")

# GOOD
Kernel.open("https://example.com", ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER)

# GOOD
Kernel.open("https://example.com", { ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER })

# GOOD
options = { ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER }
Kernel.open("https://example.com", options)

# GOOD
URI.parse("https://example.com").open

# GOOD
URI.parse("https://example.com").open(ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER)

# GOOD
URI.parse("https://example.com").open({ ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER })

# GOOD
options = { ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER }
URI.parse("https://example.com").open(options)