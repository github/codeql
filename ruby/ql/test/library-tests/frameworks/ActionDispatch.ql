private import ruby
private import codeql.ruby.frameworks.ActionDispatch
private import codeql.ruby.frameworks.ActionController

query predicate actionDispatchRoutes(
  ActionDispatch::Route r, string method, string path, string controller, string action
) {
  r.getHttpMethod() = method and
  r.getPath() = path and
  r.getController() = controller and
  r.getAction() = action
}

query predicate actionDispatchControllerMethods(
  ActionDispatch::Route r, ActionControllerActionMethod m
) {
  m.getARoute() = r
}

query predicate underscore(string input, string output) {
  output = ActionDispatch::underscore(input) and
  input in [
      "Foo", "FooBar", "Foo::Bar", "FooBar::Baz", "Foo::Bar::Baz", "Foo::Bar::BazQuux", "invalid",
      "HTTPServerRequest", "LotsOfCapitalLetters"
    ]
}
