private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.Rack
private import codeql.ruby.DataFlow

query predicate rackRequestHandlers(
  Rack::App::RequestHandler handler, DataFlow::ParameterNode env, Rack::Response::ResponseNode resp
) {
  env = handler.getEnv() and resp = handler.getAResponse()
}

query predicate rackResponseContentTypes(
  Rack::Response::ResponseNode resp, DataFlow::Node contentType
) {
  contentType = resp.getMimetypeOrContentTypeArg()
}

query predicate redirectResponses(Rack::Response::RedirectResponse resp, DataFlow::Node location) {
  location = resp.getRedirectLocation()
}

query predicate requestInputAccesses(Http::Server::RequestInputAccess ria) { any() }
