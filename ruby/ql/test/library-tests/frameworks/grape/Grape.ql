import ruby
import codeql.ruby.frameworks.Grape
import codeql.ruby.Concepts
import codeql.ruby.AST

query predicate grapeApiClasses(Grape::GrapeApiClass api) { any() }

query predicate grapeEndpoints(
  Grape::GrapeApiClass api, Grape::GrapeEndpoint endpoint, string method, string path
) {
  endpoint = api.getAnEndpoint() and
  method = endpoint.getHttpMethod() and
  path = endpoint.getPath()
}

query predicate grapeParams(Grape::GrapeParamsSource params) { any() }

query predicate grapeHeaders(Grape::GrapeHeadersSource headers) { any() }

query predicate grapeRequest(Grape::GrapeRequestSource request) { any() }

query predicate grapeRouteParam(Grape::GrapeRouteParamSource routeParam) { any() }

query predicate grapeCookies(Grape::GrapeCookiesSource cookies) { any() }

query predicate grapeRequestBodyRead(Grape::GrapeRequestBodyReadSource src, string kind) {
  kind = src.getKind()
}

query predicate grapeRequestBodyString(Grape::GrapeRequestBodyStringSource src, string kind) {
  kind = src.getKind()
}

query predicate grapeRequestParams(Grape::GrapeRequestParamsSource src, string kind) {
  kind = src.getKind()
}

query predicate grapeRequestGet(Grape::GrapeRequestGetSource src, string kind) {
  kind = src.getKind()
}

query predicate grapeRequestPost(Grape::GrapeRequestPostSource src, string kind) {
  kind = src.getKind()
}

query predicate grapeRequestCookies(Grape::GrapeRequestCookiesSource src, string kind) {
  kind = src.getKind()
}

query predicate grapeRequestEnv(Grape::GrapeRequestEnvSource src, string kind) {
  kind = src.getKind()
}

query predicate grapeRequestQueryString(Grape::GrapeRequestQueryStringSource src, string kind) {
  kind = src.getKind()
}

query predicate grapeRequestPathInfo(Grape::GrapeRequestPathInfoSource src, string kind) {
  kind = src.getKind()
}
