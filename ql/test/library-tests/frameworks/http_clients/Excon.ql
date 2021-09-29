import codeql.ruby.frameworks.http_clients.Excon
import codeql.ruby.DataFlow

query DataFlow::Node exconHttpRequests(ExconHttpRequest e) { result = e.getResponseBody() }
