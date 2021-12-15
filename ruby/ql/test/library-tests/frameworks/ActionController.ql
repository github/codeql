private import ruby
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.frameworks.ActionView

query predicate actionControllerControllerClasses(ActionControllerControllerClass cls) { any() }

query predicate actionControllerActionMethods(ActionControllerActionMethod m) { any() }

query predicate paramsCalls(ParamsCall c) { any() }

query predicate paramsSources(ParamsSource src) { any() }

query predicate cookiesCalls(CookiesCall c) { any() }

query predicate cookiesSources(CookiesSource src) { any() }

query predicate redirectToCalls(RedirectToCall c) { any() }

query predicate actionControllerHelperMethods(ActionControllerHelperMethod m) { any() }

query predicate getAssociatedControllerClasses(ActionControllerControllerClass cls, ErbFile f) {
  cls = getAssociatedControllerClass(f)
}

query predicate controllerTemplateFiles(ActionControllerControllerClass cls, ErbFile templateFile) {
  controllerTemplateFile(cls, templateFile)
}
