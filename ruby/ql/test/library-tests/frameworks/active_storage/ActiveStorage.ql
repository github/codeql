import ruby
import codeql.ruby.ApiGraphs
import codeql.ruby.DataFlow
import codeql.ruby.Concepts

query predicate attachmentInstances(DataFlow::Node n) {
  n =
    API::getTopLevelMember("ActiveStorage")
        .getMember("Attachment")
        .getInstance()
        .getAValueReachableFromSource()
}

query predicate httpRequests(HTTP::Client::Request r, string framework, DataFlow::Node responseBody) {
  r.getFramework() = framework and r.getResponseBody() = responseBody
}

query predicate commandExecutions(SystemCommandExecution c, DataFlow::Node arg) {
  arg = c.getAnArgument()
}

query predicate codeExecutions(CodeExecution e, DataFlow::Node code) { code = e.getCode() }

query predicate pathSanitizations(Path::PathSanitization p) { any() }
