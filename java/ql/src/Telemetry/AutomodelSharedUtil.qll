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

predicate isKnownKind(
  string kind, string humanReadableKind, AutomodelEndpointTypes::EndpointType type
) {
  kind = "read-file" and
  humanReadableKind = "read file" and
  type instanceof AutomodelEndpointTypes::TaintedPathSinkType
  or
  kind = "create-file" and
  humanReadableKind = "create file" and
  type instanceof AutomodelEndpointTypes::TaintedPathSinkType
  or
  kind = "sql" and
  humanReadableKind = "mad modeled sql" and
  type instanceof AutomodelEndpointTypes::SqlSinkType
  or
  kind = "open-url" and
  humanReadableKind = "open url" and
  type instanceof AutomodelEndpointTypes::RequestForgerySinkType
  or
  kind = "jdbc-url" and
  humanReadableKind = "jdbc url" and
  type instanceof AutomodelEndpointTypes::RequestForgerySinkType
  or
  kind = "command-injection" and
  humanReadableKind = "command injection" and
  type instanceof AutomodelEndpointTypes::CommandInjectionSinkType
}
