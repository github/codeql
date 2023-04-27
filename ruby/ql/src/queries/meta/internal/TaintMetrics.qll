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

class RelevantFile extends File {
  RelevantFile() { not getRelativePath().regexpMatch(".*/test(case)?s?/.*") }
}

RemoteFlowSource relevantTaintSource(string kind) {
  result.getLocation().getFile() instanceof RelevantFile and
  kind = result.getSourceType()
}

DataFlow::Node relevantTaintSink(string kind) {
  result.getLocation().getFile() instanceof RelevantFile and
  (
    kind = "CodeInjection" and result instanceof CodeInjection::Sink
    or
    kind = "CommandInjection" and result instanceof CommandInjection::Sink
    or
    kind = "XSS" and result instanceof ReflectedXss::Sink
    or
    kind = "PathInjection" and result instanceof PathInjection::Sink
    or
    kind = "ServerSideRequestForgery" and result instanceof ServerSideRequestForgery::Sink
    or
    kind = "UnsafeDeserialization" and result instanceof UnsafeDeserialization::Sink
    or
    kind = "UrlRedirect" and result instanceof UrlRedirect::Sink
  ) and
  // the sink is not a string literal
  not exists(Ast::StringLiteral str |
    str = result.asExpr().getExpr() and
    // ensure there is no interpolation, as that is not a literal
    not str.getComponent(_) instanceof Ast::StringInterpolationComponent
  )
}

/**
 * Gets the root folder of the snapshot.
 *
 * This is selected as the location for project-wide metrics.
 */
Folder projectRoot() { result.getRelativePath() = "" }
