import codeql.ruby.frameworks.http_clients.HttpClient
import codeql.ruby.DataFlow

query DataFlow::Node httpClientRequests(HttpClientRequest e) { result = e.getResponseBody() }
