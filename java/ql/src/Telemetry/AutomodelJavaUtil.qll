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
}

/** Gets the models-as-data description for the method argument with the index `index`. */
bindingset[index]
string getArgumentForIndex(int index) {
  index = -1 and result = "Argument[this]"
  or
  index >= 0 and result = "Argument[" + index + "]"
}

/**
 * By convention, the subtypes property of the MaD declaration should only be
 * true when there _can_ exist any subtypes with a different implementation.
 *
 * It would technically be ok to always use the value 'true', but this would
 * break convention.
 */
boolean considerSubtypes(Callable callable) {
  if
    callable.isStatic() or
    callable.getDeclaringType().isStatic() or
    callable.isFinal() or
    callable.getDeclaringType().isFinal()
  then result = false
  else result = true
}
