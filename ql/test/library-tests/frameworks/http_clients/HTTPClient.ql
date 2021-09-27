import codeql.ruby.frameworks.http_clients.HTTPClient
import codeql.ruby.DataFlow

query DataFlow::Node httpClientRequests(HTTPClientRequest e) { result = e.getResponseBody() }
