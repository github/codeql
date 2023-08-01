private import ruby
private import codeql.files.FileSystem
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.security.CodeInjectionCustomizations
private import codeql.ruby.security.CommandInjectionCustomizations
private import codeql.ruby.security.XSS
private import codeql.ruby.security.PathInjectionCustomizations
private import codeql.ruby.security.ServerSideRequestForgeryCustomizations
private import codeql.ruby.security.UnsafeDeserializationCustomizations
private import codeql.ruby.security.UrlRedirectCustomizations
private import codeql.ruby.security.SqlInjectionCustomizations
private import Util as Util

// TODO: there is probably a more sensible central location for this module
module Sinks {
  private module SinkKinds {
    class Kind extends string {
      Kind() {
        this =
          [
            "code-injection", "command-injection", "path-injection", "sql-injection",
            "nosql-injection", "html-injection", "request-forgery", "url-redirection",
            "unsafe-deserialization"
          ]
      }
    }

    Kind codeInjection() { result = "code-injection" }

    Kind commandInjection() { result = "command-injection" }

    Kind pathInjection() { result = "path-injection" }

    Kind sqlInjection() { result = "sql-injection" }

    Kind nosqlInjection() { result = "nosql-injection" }

    Kind htmlInjection() { result = "html-injection" }

    Kind requestForgery() { result = "request-forgery" }

    Kind urlRedirection() { result = "url-redirection" }

    Kind unsafeDeserialization() { result = "unsafe-deserialization" }
  }

  private DataFlow::Node getTaintSinkOfKind(SinkKinds::Kind kind) {
    result.getLocation().getFile() instanceof Util::RelevantFile and
    (
      kind = SinkKinds::codeInjection() and result instanceof CodeInjection::Sink
      or
      kind = SinkKinds::commandInjection() and result instanceof CommandInjection::Sink
      or
      kind = SinkKinds::htmlInjection() and
      (result instanceof ReflectedXss::Sink or result instanceof StoredXss::Sink)
      or
      kind = SinkKinds::pathInjection() and result instanceof PathInjection::Sink
      or
      kind = SinkKinds::requestForgery() and result instanceof ServerSideRequestForgery::Sink
      or
      kind = SinkKinds::unsafeDeserialization() and result instanceof UnsafeDeserialization::Sink
      or
      kind = SinkKinds::urlRedirection() and result instanceof UrlRedirect::Sink
      or
      kind = SinkKinds::sqlInjection() and result instanceof SqlInjection::Sink
    ) and
    // the sink is not a string literal
    not exists(Ast::StringLiteral str |
      str = result.asExpr().getExpr() and
      // ensure there is no interpolation, as that is not a literal
      not str.getComponent(_) instanceof Ast::StringInterpolationComponent
    )
  }

  private predicate flowFromParameterToSink(
    DataFlow::ParameterNode param, DataFlow::Node knownSink, SinkKinds::Kind kind
  ) {
    knownSink = getTaintSinkOfKind(kind) and
    param.flowsTo(knownSink) and
    knownSink != param
  }

  predicate sinkModelFlowToKnownSink(string type, string path, string kind) {
    exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
      paramNode = methodNode.getParameter(_) and
      flowFromParameterToSink(paramNode, _, kind)
    |
      type = Util::getAnAccessPathPrefix(methodNode) and
      path = Util::getMethodParameterPath(methodNode, paramNode)
    )
  }

  predicate parameterIsSuspicious(DataFlow::ParameterNode param, string kind) {
    param.getName() = "sql" and kind = SinkKinds::sqlInjection()
  }

  predicate sinkModelSuspiciousParameterName(string type, string path, string kind) {
    exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
      paramNode = methodNode.getParameter(_) and
      parameterIsSuspicious(paramNode, kind) and
      methodNode.getLocation().getFile() instanceof Util::RelevantFile
    |
      type = Util::getAnAccessPathPrefix(methodNode) and
      path = "(!!)" + Util::getMethodParameterPath(methodNode, paramNode)
    )
  }

  predicate sinkModel(string type, string path, string kind) {
    sinkModelFlowToKnownSink(type, path, kind) or
    sinkModelSuspiciousParameterName(type, path, kind)
  }
}
