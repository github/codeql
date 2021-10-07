import codeql.ruby.frameworks.http_clients.Httparty
import codeql.ruby.DataFlow

query DataFlow::Node httpartyRequests(HttpartyRequest e) { result = e.getResponseBody() }
