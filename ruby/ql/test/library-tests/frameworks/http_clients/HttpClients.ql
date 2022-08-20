import codeql.ruby.Concepts
import codeql.ruby.DataFlow

query predicate httpRequests(
  HTTP::Client::Request r, string framework, DataFlow::Node urlPart, DataFlow::Node responseBody
) {
  r.getFramework() = framework and
  r.getAUrlPart() = urlPart and
  r.getResponseBody() = responseBody
}
