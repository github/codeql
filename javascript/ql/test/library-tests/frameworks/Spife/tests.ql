import javascript
import semmle.javascript.security.dataflow.CleartextStorageCustomizations
import semmle.javascript.security.dataflow.CorsMisconfigurationForCredentialsCustomizations
import semmle.javascript.security.dataflow.StackTraceExposureCustomizations
import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations
import semmle.javascript.security.dataflow.RequestForgeryCustomizations
import semmle.javascript.security.dataflow.ReflectedXssCustomizations
import semmle.javascript.security.dataflow.ReflectedXssQuery as XssConfig

class InlineTest extends LineComment {
  string tests;

  InlineTest() { tests = this.getText().regexpCapture("\\s*test:(.*)", 1) }

  string getPositiveTest() {
    result = tests.trim().splitAt(",").trim() and not result.matches("!%")
  }

  string getNegativeTest() { result = tests.trim().splitAt(",").trim() and result.matches("!%") }

  predicate hasPositiveTest(string test) { test = this.getPositiveTest() }

  predicate hasNegativeTest(string test) { test = this.getNegativeTest() }

  predicate inNode(DataFlow::Node n) {
    this.getLocation().getFile() = n.getFile() and
    this.getLocation().getStartLine() = n.getStartLine()
  }
}

query predicate passingPositiveTests(string res, string expectation, InlineTest t) {
  res = "PASSED" and
  t.hasPositiveTest(expectation) and
  (
    expectation = "responseBody" and
    exists(Http::ResponseBody n | t.inNode(n))
    or
    expectation = "headerDefinition" and
    exists(DataFlow::Node n, Http::ExplicitHeaderDefinition h |
      t.inNode(n) and
      h.definesHeaderValue(_, n)
    )
    or
    expectation = "cookieDefinition" and
    exists(Http::CookieDefinition n | t.inNode(n))
    or
    expectation = "templateInstantiation" and
    exists(Templating::TemplateInstantiation::Range n | t.inNode(n))
    or
    expectation = "source" and
    exists(RemoteFlowSource n | t.inNode(n))
    or
    expectation = "routeSetup" and
    exists(Http::RouteSetup n | t.inNode(n))
    or
    expectation = "handler" and
    exists(Http::RouteHandler n | t.inNode(n))
    or
    expectation = "candidateHandler" and
    exists(Http::RouteHandlerCandidate n | t.inNode(n))
    or
    expectation = "xssSink" and
    exists(ReflectedXss::Sink n | t.inNode(n))
    or
    expectation = "xss" and
    exists(DataFlow::Node sink | XssConfig::ReflectedXssFlow::flowTo(sink) and t.inNode(sink))
    or
    expectation = "cleartextStorageSink" and
    exists(CleartextStorage::Sink n | t.inNode(n))
    or
    expectation = "corsMiconfigurationSink" and
    exists(CorsMisconfigurationForCredentials::Sink n | t.inNode(n))
    or
    expectation = "stackTraceExposureSink" and
    exists(StackTraceExposure::Sink n | t.inNode(n))
    or
    expectation = "redirectSink" and
    exists(ServerSideUrlRedirect::Sink n | t.inNode(n))
    or
    expectation = "ssrfSink" and
    exists(RequestForgery::Sink n | t.inNode(n))
  )
}

query predicate failingPositiveTests(string res, string expectation, InlineTest t) {
  res = "FAILED" and
  t.hasPositiveTest(expectation) and
  (
    expectation = "responseBody" and
    not exists(Http::ResponseBody n | t.inNode(n))
    or
    expectation = "headerDefinition" and
    not exists(DataFlow::Node n, Http::ExplicitHeaderDefinition h |
      t.inNode(n) and
      h.definesHeaderValue(_, n)
    )
    or
    expectation = "cookieDefinition" and
    not exists(Http::CookieDefinition n | t.inNode(n))
    or
    expectation = "templateInstantiation" and
    not exists(Templating::TemplateInstantiation::Range n | t.inNode(n))
    or
    expectation = "source" and
    not exists(RemoteFlowSource n | t.inNode(n))
    or
    expectation = "routeSetup" and
    not exists(Http::RouteSetup n | t.inNode(n))
    or
    expectation = "handler" and
    not exists(Http::RouteHandler n | t.inNode(n))
    or
    expectation = "candidateHandler" and
    not exists(Http::RouteHandlerCandidate n | t.inNode(n))
    or
    expectation = "xssSink" and
    not exists(ReflectedXss::Sink n | t.inNode(n))
    or
    expectation = "xss" and
    not exists(DataFlow::Node sink | XssConfig::ReflectedXssFlow::flowTo(sink) and t.inNode(sink))
    or
    expectation = "cleartextStorageSink" and
    not exists(CleartextStorage::Sink n | t.inNode(n))
    or
    expectation = "corsMiconfigurationSink" and
    not exists(CorsMisconfigurationForCredentials::Sink n | t.inNode(n))
    or
    expectation = "stackTraceExposureSink" and
    not exists(StackTraceExposure::Sink n | t.inNode(n))
    or
    expectation = "redirectSink" and
    not exists(ServerSideUrlRedirect::Sink n | t.inNode(n))
    or
    expectation = "ssrfSink" and
    not exists(RequestForgery::Sink n | t.inNode(n))
  )
}

query predicate passingNegativeTests(string res, string expectation, InlineTest t) {
  res = "PASSED" and
  t.hasNegativeTest(expectation) and
  (
    expectation = "!responseBody" and
    not exists(Http::ResponseBody n | t.inNode(n))
    or
    expectation = "!headerDefinition" and
    not exists(DataFlow::Node n, Http::ExplicitHeaderDefinition h |
      t.inNode(n) and
      h.definesHeaderValue(_, n)
    )
    or
    expectation = "!cookieDefinition" and
    not exists(Http::CookieDefinition n | t.inNode(n))
    or
    expectation = "!templateInstantiation" and
    not exists(Templating::TemplateInstantiation::Range n | t.inNode(n))
    or
    expectation = "!source" and
    not exists(RemoteFlowSource n | t.inNode(n))
    or
    expectation = "!routeSetup" and
    not exists(Http::RouteSetup n | t.inNode(n))
    or
    expectation = "!handler" and
    not exists(Http::RouteHandler n | t.inNode(n))
    or
    expectation = "!candidateHandler" and
    not exists(Http::RouteHandlerCandidate n | t.inNode(n))
    or
    expectation = "!xssSink" and
    not exists(ReflectedXss::Sink n | t.inNode(n))
    or
    expectation = "!xss" and
    not exists(DataFlow::Node sink | XssConfig::ReflectedXssFlow::flowTo(sink) and t.inNode(sink))
    or
    expectation = "!cleartextStorageSink" and
    not exists(CleartextStorage::Sink n | t.inNode(n))
    or
    expectation = "!corsMiconfigurationSink" and
    not exists(CorsMisconfigurationForCredentials::Sink n | t.inNode(n))
    or
    expectation = "!stackTraceExposureSink" and
    not exists(StackTraceExposure::Sink n | t.inNode(n))
    or
    expectation = "!redirectSink" and
    not exists(ServerSideUrlRedirect::Sink n | t.inNode(n))
    or
    expectation = "!ssrfSink" and
    not exists(RequestForgery::Sink n | t.inNode(n))
  )
}

query predicate failingNegativeTests(string res, string expectation, InlineTest t) {
  res = "FAILED" and
  t.hasNegativeTest(expectation) and
  (
    expectation = "!responseBody" and
    exists(Http::ResponseBody n | t.inNode(n))
    or
    expectation = "!headerDefinition" and
    not exists(DataFlow::Node n, Http::ExplicitHeaderDefinition h |
      t.inNode(n) and
      h.definesHeaderValue(_, n)
    )
    or
    expectation = "!cookieDefinition" and
    exists(Http::CookieDefinition n | t.inNode(n))
    or
    expectation = "!templateInstantiation" and
    exists(Templating::TemplateInstantiation::Range n | t.inNode(n))
    or
    expectation = "!source" and
    exists(RemoteFlowSource n | t.inNode(n))
    or
    expectation = "!routeSetup" and
    exists(Http::RouteSetup n | t.inNode(n))
    or
    expectation = "!handler" and
    exists(Http::RouteHandler n | t.inNode(n))
    or
    expectation = "!candidateHandler" and
    exists(Http::RouteHandlerCandidate n | t.inNode(n))
    or
    expectation = "!xssSink" and
    exists(ReflectedXss::Sink n | t.inNode(n))
    or
    expectation = "!xss" and
    exists(DataFlow::Node sink | XssConfig::ReflectedXssFlow::flowTo(sink) and t.inNode(sink))
    or
    expectation = "!cleartextStorageSink" and
    exists(CleartextStorage::Sink n | t.inNode(n))
    or
    expectation = "!corsMiconfigurationSink" and
    exists(CorsMisconfigurationForCredentials::Sink n | t.inNode(n))
    or
    expectation = "!stackTraceExposureSink" and
    exists(StackTraceExposure::Sink n | t.inNode(n))
    or
    expectation = "!redirectSink" and
    exists(ServerSideUrlRedirect::Sink n | t.inNode(n))
    or
    expectation = "!ssrfSink" and
    exists(RequestForgery::Sink n | t.inNode(n))
  )
}
