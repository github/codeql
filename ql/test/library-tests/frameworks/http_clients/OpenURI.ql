import codeql.ruby.frameworks.http_clients.OpenURI
import codeql.ruby.DataFlow

query DataFlow::Node openUriRequests(OpenUriRequest e) { result = e.getResponseBody() }

query DataFlow::Node openUriKernelOpenRequests(OpenUriKernelOpenRequest e) {
  result = e.getResponseBody()
}
