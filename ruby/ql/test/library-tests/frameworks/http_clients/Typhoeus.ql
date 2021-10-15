import codeql.ruby.frameworks.http_clients.Typhoeus
import codeql.ruby.DataFlow

query DataFlow::Node typhoeusHttpRequests(TyphoeusHttpRequest e) { result = e.getResponseBody() }
