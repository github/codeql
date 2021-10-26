import codeql.ruby.frameworks.http_clients.NetHttp
import codeql.ruby.DataFlow

query DataFlow::Node netHttpRequests(NetHttpRequest e) { result = e.getResponseBody() }
