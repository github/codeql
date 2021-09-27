import codeql.ruby.frameworks.http_clients.Typhoeus
import codeql.ruby.DataFlow

query DataFlow::Node typhoeusHTTPRequests(TyphoeusHTTPRequest e) { result = e.getResponseBody() }
