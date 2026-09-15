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

query predicate grapeRequestBodyRead(Grape::GrapeRequestBodyReadSource src) { any() }

query predicate grapeRequestBodyString(Grape::GrapeRequestBodyStringSource src) { any() }

query predicate grapeRequestParams(Grape::GrapeRequestParamsSource src) { any() }

query predicate grapeRequestGET(Grape::GrapeRequestGetSource src) { any() }

query predicate grapeRequestPOST(Grape::GrapeRequestPostSource src) { any() }

query predicate grapeRequestCookies(Grape::GrapeRequestCookiesSource src) { any() }

query predicate grapeRequestEnv(Grape::GrapeRequestEnvSource src) { any() }

query predicate grapeRequestQueryString(Grape::GrapeRequestQueryStringSource src) { any() }

query predicate grapeRequestPathInfo(Grape::GrapeRequestPathInfoSource src) { any() }
