import codeql.ruby.frameworks.http_clients.RestClient
import codeql.ruby.DataFlow

query DataFlow::Node restClientHTTPRequests(RestClientHTTPRequest e) {
  result = e.getResponseBody()
}
