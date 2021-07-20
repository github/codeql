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
  string getDelimiterMatchingRegexp() { result = getDelimiterMatchingRegexpWithPrefix(".*") }

  /**
   * Gets a regular expression that matches a string containing one
   * of the known template delimiters identified by `getADelimiter()`,
   * storing it in its first (and only) capture group.
   * Where the string prior to the template delimiter matches the regexp `prefix`.
   */
  bindingset[prefix]
  string getDelimiterMatchingRegexpWithPrefix(string prefix) {
    result = "(?s)" + prefix + "(" + concat("\\Q" + getADelimiter() + "\\E", "|") + ").*"
  }

  /** A placeholder tag for a templating engine. */
  class TemplatePlaceholderTag extends @template_placeholder_tag, Locatable {
    override Location getLocation() { hasLocation(this, result) }

    override string toString() { template_placeholder_tag_info(this, _, result) }

    /** Gets the full text of the template tag, including delimiters. */
    string getRawText() { template_placeholder_tag_info(this, _, result) }

    /** Gets the enclosing HTML element, attribute, or file. */
    Locatable getParent() { template_placeholder_tag_info(this, result, _) }

    /** Gets a data flow node representing the value plugged into this placeholder. */
    DataFlow::TemplatePlaceholderTagNode asDataFlowNode() { result.getTag() = this }

    /** Gets the top-level containing the template expression to be inserted at this placeholder. */
    Angular2::TemplateTopLevel getInnerTopLevel() { toplevel_parent_xml_node(result, this) }
  }
}
