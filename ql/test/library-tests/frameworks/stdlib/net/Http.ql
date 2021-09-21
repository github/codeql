import codeql.ruby.frameworks.stdlib.net.HTTP
import codeql.ruby.DataFlow

query DataFlow::Node netHTTPRequests(NetHTTPRequest e) { result = e.getResponseBody() }
