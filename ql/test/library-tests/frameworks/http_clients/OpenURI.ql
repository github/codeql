import codeql.ruby.frameworks.http_clients.OpenURI
import codeql.ruby.DataFlow

query DataFlow::Node openURIRequests(OpenURIRequest e) { result = e.getResponseBody() }
