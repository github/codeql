private import java
private import AutomodelEndpointTypes as AutomodelEndpointTypes

/**
 * A helper class to represent a string value that can be returned by a query using $@ notation.
 *
 * It extends `string`, but adds a mock `hasLocationInfo` method that returns the string itself as the file name.
 *
 * Use this, when you want to return a string value from a query using $@ notation - the string value
 * will be included in the sarif file.
 *
 *
 * Background information on `hasLocationInfo`:
 * https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/#providing-location-information
 */
class DollarAtString extends string {
  bindingset[this]
  DollarAtString() { any() }

  bindingset[this]
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = this and sl = 1 and sc = 1 and el = 1 and ec = 1
  }
}

/**
 * Holds for all combinations of MaD kinds (`kind`) and their human readable
 * descriptions.
 */
predicate isKnownKind(string kind, AutomodelEndpointTypes::EndpointType type) {
  kind = "path-injection" and
  type instanceof AutomodelEndpointTypes::PathInjectionSinkType
  or
  kind = "sql-injection" and
  type instanceof AutomodelEndpointTypes::SqlInjectionSinkType
  or
  kind = "request-forgery" and
  type instanceof AutomodelEndpointTypes::RequestForgerySinkType
  or
  kind = "command-injection" and
  type instanceof AutomodelEndpointTypes::CommandInjectionSinkType
  or
  kind = "remote" and
  type instanceof AutomodelEndpointTypes::RemoteSourceType
}

/**
 * By convention, the subtypes property of the MaD declaration should only be
 * true when there _can_ exist any subtypes with a different implementation.
 *
 * It would technically be ok to always use the value 'true', but this would
 * break convention.
 */
pragma[nomagic]
boolean considerSubtypes(Callable callable) {
  if
    callable.isStatic() or
    callable.getDeclaringType().isStatic() or
    callable.isFinal() or
    callable.getDeclaringType().isFinal()
  then result = false
  else result = true
}

/**
 * Holds if the given package, type, name and signature is a candidate for automodeling.
 *
 * This predicate is extensible, so that different endpoints can be selected at runtime.
 */
extensible predicate automodelCandidateFilter(
  string package, string type, string name, string signature
);

/**
 * Holds if the given package, type, name and signature is a candidate for automodeling.
 *
 * This relies on an extensible predicate, and if that is not supplied then
 * all endpoints are considered candidates.
 */
bindingset[package, type, name, signature]
predicate includeAutomodelCandidate(string package, string type, string name, string signature) {
  not automodelCandidateFilter(_, _, _, _) or
  automodelCandidateFilter(package, type, name, signature)
}
