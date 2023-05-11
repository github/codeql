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
