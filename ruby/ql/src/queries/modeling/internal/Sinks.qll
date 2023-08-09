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
private import codeql.ruby.typetracking.TypeTracker

// TODO: there is probably a more sensible central location for this module
module Sinks {
  private module Configs {
    abstract class Kind extends string {
      Kind() {
        this =
          [
            "code-injection", "command-injection", "path-injection", "sql-injection",
            "sql-injection", "request-forgery", "url-redirection", "unsafe-deserialization",
          ]
      }

      abstract DataFlow::Node getASink();

      abstract DataFlow::Node getASanitizer();

      string getKind() { result = this }
    }

    class CodeInjectionKind extends Kind {
      CodeInjectionKind() { this = "code-injection" }

      override DataFlow::Node getASink() { result instanceof CodeInjection::Sink }

      override DataFlow::Node getASanitizer() { result instanceof CodeInjection::Sanitizer }
    }

    class CommandInjectionKind extends Kind {
      CommandInjectionKind() { this = "command-injection" }

      override DataFlow::Node getASink() { result instanceof CommandInjection::Sink }

      override DataFlow::Node getASanitizer() { result instanceof CommandInjection::Sanitizer }
    }

    class PathInjectionKind extends Kind {
      PathInjectionKind() { this = "path-injection" }

      override DataFlow::Node getASink() { result instanceof PathInjection::Sink }

      override DataFlow::Node getASanitizer() { result instanceof PathInjection::Sanitizer }
    }

    class SqlInjectionKind extends Kind {
      SqlInjectionKind() { this = "sql-injection" }

      override DataFlow::Node getASink() { result instanceof SqlInjection::Sink }

      override DataFlow::Node getASanitizer() { result instanceof SqlInjection::Sanitizer }
    }

    class HtmlInjectionKind extends Kind {
      HtmlInjectionKind() { this = "html-injection" }

      override DataFlow::Node getASink() {
        result instanceof ReflectedXss::Sink or result instanceof StoredXss::Sink
      }

      override DataFlow::Node getASanitizer() {
        result instanceof ReflectedXss::Sanitizer or result instanceof StoredXss::Sanitizer
      }
    }

    class RequestForgeryKind extends Kind {
      RequestForgeryKind() { this = "request-forgery" }

      override DataFlow::Node getASink() { result instanceof ServerSideRequestForgery::Sink }

      override DataFlow::Node getASanitizer() {
        result instanceof ServerSideRequestForgery::Sanitizer
      }
    }

    class UrlRedirectionKind extends Kind {
      UrlRedirectionKind() { this = "url-redirection" }

      override DataFlow::Node getASink() { result instanceof UrlRedirect::Sink }

      override DataFlow::Node getASanitizer() { result instanceof UrlRedirect::Sanitizer }
    }

    class UnsafeDeserializationKind extends Kind {
      UnsafeDeserializationKind() { this = "unsafe-deserialization" }

      override DataFlow::Node getASink() { result instanceof UnsafeDeserialization::Sink }

      override DataFlow::Node getASanitizer() { result instanceof UnsafeDeserialization::Sanitizer }
    }
  }

  private DataFlow::Node getTaintSinkOfKind(Configs::Kind kind) {
    result.getLocation().getFile() instanceof Util::RelevantFile and
    result = kind.getASink() and
    // the sink is not a string literal
    not exists(Ast::StringLiteral str |
      str = result.asExpr().getExpr() and
      // ensure there is no interpolation, as that is not a literal
      not str.getComponent(_) instanceof Ast::StringInterpolationComponent
    )
  }

  private predicate flowFromParameterToSink(
    DataFlow::ParameterNode param, DataFlow::Node knownSink, Configs::Kind kind
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
    param.getName() = "sql" and kind instanceof Configs::SqlInjectionKind
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

  predicate sinkModelFlowToKnownSinkTypeTracker(string type, string path, string kind) {
    exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
      paramNode = methodNode.getParameter(_) and
      paramNode = taintType(kind)
    |
      type = Util::getAnAccessPathPrefix(methodNode) and
      path = "(TT)" + Util::getMethodParameterPath(methodNode, paramNode)
    )
  }

  predicate sinkModel(string type, string path, string kind) {
    sinkModelFlowToKnownSink(type, path, kind)
    or
    sinkModelFlowToKnownSinkTypeTracker(type, path, kind)
    //  or
    //  sinkModelSuspiciousParameterName(type, path, kind)
  }

  DataFlow::Node taintType(TypeBackTracker t, Configs::Kind kind) {
    t.start() and
    result = kind.getASink()
    or
    exists(TypeBackTracker t2 | t = t2.smallstep(result, taintType(t2, kind)))
  }

  DataFlow::Node taintType(Configs::Kind kind) { result = taintType(TypeBackTracker::end(), kind) }
}
