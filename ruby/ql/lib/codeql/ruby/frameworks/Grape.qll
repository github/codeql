private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts

private DataFlow::ConstRef apiClass() { result = DataFlow::getConstant("Grape").getConstant("API") }

private DataFlow::LocalSourceNode apiInstance() {
  result = apiClass().getADescendentModule().getAnOwnModuleSelf()
}

private class Params extends Http::Server::RequestInputAccess::Range {
  Params() {
    this =
      any(DataFlow::CallNode c |
        c = apiInstance().getAMethodCall("params") and
        // ignore `params` calls which are part of the DSL for specifying request params,
        // rather than an actual params access.
        not exists(c.getBlock())
      )
  }

  override string getSourceType() { result = "Grape::API#params" }

  override Http::Server::RequestInputKind getKind() { result = Http::Server::parameterInputKind() }
}
