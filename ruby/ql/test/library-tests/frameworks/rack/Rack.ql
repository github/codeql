private import codeql.ruby.AST
private import codeql.ruby.frameworks.Rack
private import codeql.ruby.DataFlow

query predicate rackApps(Rack::App::AppCandidate c, DataFlow::ParameterNode env) {
  env = c.getEnv()
}

query predicate rackResponseStatusCodes(Rack::Response::ResponseNode resp, string status) {
  if exists(resp.getAStatusCode())
  then status = resp.getAStatusCode().toString()
  else status = "<unknown>"
}

query predicate rackResponseContentTypes(
  Rack::Response::ResponseNode resp, DataFlow::Node contentType
) {
  contentType = resp.getMimetypeOrContentTypeArg()
}

query predicate mimetypeCalls(Rack::Mime::MimetypeCall c, string mimetype) {
  mimetype = c.getMimeType()
}

query predicate redirectResponses(Rack::Response::RedirectResponse resp, DataFlow::Node location) {
  location = resp.getRedirectLocation()
}
