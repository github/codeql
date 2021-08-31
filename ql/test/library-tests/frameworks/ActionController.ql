private import ruby
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.frameworks.ActionView

query predicate actionControllerControllerClasses(ActionControllerControllerClass cls) { any() }

query predicate actionControllerActionMethods(ActionControllerActionMethod m) { any() }

query predicate paramsCalls(ParamsCall c) { any() }

query predicate paramsSources(ParamsSource src) { any() }

query predicate redirectToCalls(RedirectToCall c) { any() }

query predicate actionControllerHelperMethods(ActionControllerHelperMethod m) { any() }

// TODO: second parameter should be `ErbFile`
query predicate getAssociatedControllerClasses(ActionControllerControllerClass cls, File f) {
  cls = getAssociatedControllerClass(f)
}

query predicate controllerTemplatesFolders(ActionControllerControllerClass cls, Folder f) {
  controllerTemplatesFolder(cls, f)
}
