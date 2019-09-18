/**
 * Provides predicates for working with templating libraries.
 */

import javascript

module Templating {
  /**
   * Gets a string that is a known template delimiter.
   */
  string getADelimiter() {
    result = "<%" or
    result = "%>" or
    result = "{{" or
    result = "}}" or
    result = "{%" or
    result = "%}" or
    result = "<@" or
    result = "@>" or
    result = "<#" or
    result = "#>" or
    result = "{#" or
    result = "#}" or
    result = "{$" or
    result = "$}" or
    result = "[%" or
    result = "%]" or
    result = "[[" or
    result = "]]" or
    result = "<?" or
    result = "?>"
  }

  /**
   * Gets a regular expression that matches a string containing one
   * of the known template delimiters identified by `getADelimiter()`,
   * storing it in its first (and only) capture group.
   */
  string getDelimiterMatchingRegexp() {
    result = "(?s).*(" + concat("\\Q" + getADelimiter() + "\\E", "|") + ").*"
  }
}
