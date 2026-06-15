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
