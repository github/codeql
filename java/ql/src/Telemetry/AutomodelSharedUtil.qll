/**
 * A helper class to represent a string value that can be returned by a query using $@ notation.
 *
 * It extends `string`, but adds a mock `getURL` method that returns the string itself as a data URL.
 *
 * Use this, when you want to return a string value from a query using $@ notation — the string value
 * will be included in the sarif file.
 *
 * Note that the string should be URL-encoded, or the resulting URL will be invalid (this may be OK in your use case).
 *
 * Background information:
 *  - data URLs: https://developer.mozilla.org/en-US/docs/web/http/basics_of_http/data_urls
 *  - `getURL`:
 *      https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/#providing-urls
 */
class DollarAtString extends string {
  bindingset[this]
  DollarAtString() { any() }

  bindingset[this]
  string getURL() { result = "data:text/plain," + this }
}
