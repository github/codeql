import codeql.ruby.frameworks.http_clients.Faraday
import codeql.ruby.DataFlow

query DataFlow::Node faradayHttpRequests(FaradayHttpRequest e) { result = e.getResponseBody() }
