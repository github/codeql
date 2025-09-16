import ruby
import codeql.ruby.frameworks.Grape
import codeql.ruby.Concepts
import codeql.ruby.AST

query predicate grapeApiClasses(GrapeApiClass api) { any() }

query predicate grapeEndpoints(GrapeApiClass api, GrapeEndpoint endpoint, string method, string path) {
  endpoint = api.getAnEndpoint() and
  method = endpoint.getHttpMethod() and
  path = endpoint.getPath()
}

query predicate grapeParams(GrapeParamsSource params) { any() }

query predicate grapeHeaders(GrapeHeadersSource headers) { any() }

query predicate grapeRequest(GrapeRequestSource request) { any() }

query predicate grapeRouteParam(GrapeRouteParamSource routeParam) { any() }

query predicate grapeCookies(GrapeCookiesSource cookies) { any() }