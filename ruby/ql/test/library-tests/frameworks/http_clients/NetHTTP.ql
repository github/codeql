import codeql.ruby.frameworks.http_clients.NetHTTP
import codeql.ruby.DataFlow

query DataFlow::Node netHTTPRequests(NetHTTPRequest e) { result = e.getResponseBody() }
