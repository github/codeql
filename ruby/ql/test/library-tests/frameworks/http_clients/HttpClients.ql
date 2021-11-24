import codeql.ruby.Concepts
import codeql.ruby.DataFlow

query predicate httpRequests(
  HTTP::Client::Request r, string framework, DataFlow::Node url, DataFlow::Node responseBody
) {
  r.getFramework() = framework and
  r.getURL() = url and
  r.getResponseBody() = responseBody
}
