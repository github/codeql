import codeql.ruby.frameworks.http_clients.Faraday
import codeql.ruby.DataFlow

query DataFlow::Node faradayHTTPRequests(FaradayHTTPRequest e) { result = e.getResponseBody() }
