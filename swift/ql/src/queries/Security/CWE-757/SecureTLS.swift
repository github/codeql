// Set TLS version explicitly
func createURLSession() -> URLSession {
  let config = URLSessionConfiguration.default
  config.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv13
  return URLSession(configuration: config)
}

// Use the secure OS defaults
func createURLSession() -> URLSession {
  let config = URLSessionConfiguration.default
  return URLSession(configuration: config)
}
