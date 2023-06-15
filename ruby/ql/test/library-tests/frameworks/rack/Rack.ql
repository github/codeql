private import codeql.ruby.AST
private import codeql.ruby.frameworks.Rack
private import codeql.ruby.DataFlow

query predicate rackApps(Rack::App::App app, DataFlow::ParameterNode env) { env = app.getEnv() }

query predicate rackResponseContentTypes(
  Rack::Response::ResponseNode resp, DataFlow::Node contentType
) {
  contentType = resp.getMimetypeOrContentTypeArg()
}

query predicate redirectResponses(Rack::Response::RedirectResponse resp, DataFlow::Node location) {
  location = resp.getRedirectLocation()
}
