private import codeql.ruby.AST
private import codeql.ruby.frameworks.ActionDispatch
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.data.ModelsAsData
private import codeql.ruby.DataFlow
private import codeql.ruby.Regexp as RE

query predicate actionDispatchRoutes(
  ActionDispatch::Routing::Route r, string method, string path, string controller, string action
) {
  r.getHttpMethod() = method and
  r.getPath() = path and
  r.getController() = controller and
  r.getAction() = action
}

query predicate actionDispatchControllerMethods(
  ActionDispatch::Routing::Route r, ActionControllerActionMethod m
) {
  m.getARoute() = r
}

query predicate underscore(string input, string output) {
  output = ActionDispatch::Routing::underscore(input) and
  input in [
      "Foo", "FooBar", "Foo::Bar", "FooBar::Baz", "Foo::Bar::Baz", "Foo::Bar::BazQuux", "invalid",
      "HTTPServerRequest", "LotsOfCapitalLetters"
    ]
}

query predicate mimeTypeInstances(API::Node n) { n = ModelOutput::getATypeNode("Mime::Type") }

query predicate mimeTypeMatchRegExpInterpretations(
  ActionDispatch::MimeTypeMatchRegExpInterpretation s
) {
  any()
}

query predicate requestInputAccesses(Http::Server::RequestInputAccess a) { any() }
