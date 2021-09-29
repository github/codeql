import codeql.ruby.frameworks.http_clients.RestClient
import codeql.ruby.DataFlow

query DataFlow::Node restClientHttpRequests(RestClientHttpRequest e) {
  result = e.getResponseBody()
}
