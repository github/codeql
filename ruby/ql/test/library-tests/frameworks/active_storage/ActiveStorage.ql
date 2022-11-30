import ruby
import codeql.ruby.ApiGraphs
import codeql.ruby.Concepts
import codeql.ruby.frameworks.ActiveStorage

query predicate attachmentInstances(ActiveStorage::AttachmentInstance n) { any() }

query predicate httpRequests(Http::Client::Request r, string framework, DataFlow::Node responseBody) {
  r.getFramework() = framework and r.getResponseBody() = responseBody
}

query predicate commandExecutions(SystemCommandExecution c, DataFlow::Node arg) {
  arg = c.getAnArgument()
}

query predicate codeExecutions(CodeExecution e, DataFlow::Node code) { code = e.getCode() }

query predicate pathSanitizations(Path::PathSanitization p) { any() }
