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
module Sources {
  private DataFlow::Node getSourceOfKind(string kind) {
    result.getLocation().getFile() instanceof Util::RelevantFile and
    kind = "remote" and
    result instanceof RemoteFlowSource
  }

  private predicate flowFromSourceToReturn(
    DataFlow::LocalSourceNode source, DataFlow::MethodNode methodNode, string kind
  ) {
    source.flowsTo(methodNode.getAReturnNode()) and
    source = getSourceOfKind(kind)
  }

  predicate sourceModelFlowFromKnownSource(string type, string path, string kind) {
    exists(DataFlow::MethodNode methodNode, DataFlow::LocalSourceNode source |
      flowFromSourceToReturn(source, methodNode, kind)
    |
      type = Util::getAnAccessPathPrefix(methodNode) and
      path = Util::getMethodPath(methodNode) + ".ReturnValue"
    )
  }

  predicate sourceModel(string type, string path, string kind) {
    sourceModelFlowFromKnownSource(type, path, kind)
  }
}
