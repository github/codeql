import codeql.ruby.frameworks.http_clients.HTTParty
import codeql.ruby.DataFlow

query DataFlow::Node httpartyRequests(HTTPartyRequest e) { result = e.getResponseBody() }
