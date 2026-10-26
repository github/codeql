import javascript
import semmle.javascript.frameworks.Sails

query predicate test_routeHandler(Http::RouteHandler rh) { any() }

query predicate test_requestInputAccess(Http::RequestInputAccess ria, string kind) {
  kind = ria.getKind()
}
