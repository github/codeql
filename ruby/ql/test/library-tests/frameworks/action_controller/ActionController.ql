private import codeql.ruby.AST
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.frameworks.Rails
private import codeql.ruby.frameworks.ActionView
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow

query predicate actionControllerControllerClasses(ActionControllerClass cls) { any() }

query predicate actionControllerActionMethods(ActionControllerActionMethod m) { any() }

query predicate paramsCalls(Rails::ParamsCall c) { any() }

query predicate paramsSources(ParamsSource src) { any() }

query predicate httpInputAccesses(Http::Server::RequestInputAccess a, string sourceType) {
  sourceType = a.getSourceType()
}

query predicate cookiesCalls(Rails::CookiesCall c) { any() }

query predicate cookiesSources(CookiesSource src) { any() }

query predicate redirectToCalls(RedirectToCall c) { any() }

query predicate renderCalls(Rails::RenderCall c) { any() }

query predicate httpResponses(Http::Server::HttpResponse r, DataFlow::Node body) {
  body = r.getBody()
}

query predicate actionControllerHelperMethods(ActionControllerHelperMethod m) { any() }

query predicate getAssociatedControllerClasses(ActionControllerClass cls, ErbFile f) {
  cls = getAssociatedControllerClass(f)
}

query predicate controllerTemplateFiles(ActionControllerClass cls, ErbFile templateFile) {
  controllerTemplateFile(cls, templateFile)
}

query predicate headerWriteAccesses(
  Http::Server::HeaderWriteAccess a, string name, DataFlow::Node value
) {
  name = a.getName() and value = a.getValue()
}

query predicate loggingCalls(Logging c, DataFlow::Node input) { input = c.getAnInput() }
