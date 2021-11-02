import codeql.ruby.frameworks.http_clients.Excon
import codeql.ruby.DataFlow

query DataFlow::Node exconHTTPRequests(ExconHTTPRequest e) { result = e.getResponseBody() }
