require "open-uri"

resp1 = Kernel.open("http://example.com")
resp1.read

resp2 = open("http://example.com")
resp2.readlines

resp3 = URI.open("http://example.com")
resp3.read

resp4 = URI.parse("https://example.com").open
resp4.read

resp5 = OpenURI.open_uri("https://example.com")
resp5.read