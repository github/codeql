/**
 * Provides classes for working with HTML sanitizers.
 */

import javascript

/**
 * A call that sanitizes HTML in a string, either by replacing
 * meta characters with their HTML entities, or by removing
 * certain HTML tags entirely.
 */
abstract class HtmlSanitizerCall extends DataFlow::CallNode {
  /**
   * Gets the data flow node referring to the input that gets sanitized.
   */
  abstract DataFlow::Node getInput();
}

pragma[noinline]
private DataFlow::SourceNode htmlSanitizerFunction() {
  result = DataFlow::moduleMember("ent", "encode")
  or
  result = DataFlow::moduleMember("entities", "encodeHTML")
  or
  result = DataFlow::moduleMember("entities", "encodeXML")
  or
  result = DataFlow::moduleMember("escape-goat", "escape")
  or
  result = DataFlow::moduleMember("he", "encode")
  or
  result = DataFlow::moduleMember("he", "escape")
  or
  result = DataFlow::moduleImport("sanitize-html")
  or
  result = DataFlow::moduleMember("sanitizer", "escape")
  or
  result = DataFlow::moduleMember("sanitizer", "sanitize")
  or
  result = DataFlow::moduleMember("validator", "escape")
  or
  result = DataFlow::moduleImport("xss")
  or
  result = DataFlow::moduleMember("xss-filters", _)
  or
  result = LodashUnderscore::member("escape")
  or
  exists(DataFlow::PropRead read | read = result |
    read.getPropertyName() = "sanitize" and
    read.getBase().asExpr().(VarAccess).getName() = "DOMPurify"
  )
  or
  exists(string name | name = "encode" or name = "encodeNonUTF" |
    result = DataFlow::moduleMember("html-entities", _).getAnInstantiation().getAPropertyRead(name) or
    result = DataFlow::moduleMember("html-entities", _).getAPropertyRead(name)
  )
  or
  result = Closure::moduleImport("goog.string.htmlEscape")
}

/**
 * Matches HTML sanitizers from known NPM packages as well as home-made sanitizers (matched by name).
 */
private class DefaultHtmlSanitizerCall extends HtmlSanitizerCall {
  DefaultHtmlSanitizerCall() {
    this = htmlSanitizerFunction().getACall()
    or
    // Match home-made sanitizers by name.
    exists(string calleeName | calleeName = this.getCalleeName() |
      calleeName.regexpMatch("(?i).*html.*") and
      calleeName.regexpMatch("(?i).*(?<!un)(saniti[sz]|escape|strip).*")
    )
  }

  override DataFlow::Node getInput() { result = this.getArgument(0) }
}
