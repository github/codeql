import codeql_ruby.frameworks.ActionController

query predicate actionControllerControllerClasses(ActionControllerControllerClass cls) { any() }
query predicate actionControllerActionMethods(ActionControllerActionMethod m) { any() }
query predicate paramsCalls(ParamsCall c) { any() }
query predicate paramsSources(ParamsSource src) { any() }
query predicate redirectToCalls(RedirectToCall c) { any() }
query predicate responseBodySetterCalls(ResponseBodySetterCall c) { any() }
query predicate actionControllerHelperMethods(ActionControllerHelperMethod m) { any() }