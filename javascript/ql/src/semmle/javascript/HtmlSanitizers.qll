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

/**
 * Matches HTML sanitizers from known NPM packages as well as home-made sanitizers (matched by name).
 */
private class DefaultHtmlSanitizerCall extends HtmlSanitizerCall {
  DefaultHtmlSanitizerCall() {
    exists(DataFlow::SourceNode callee | this = callee.getACall() |
      callee = DataFlow::moduleMember("ent", "encode")
      or
      callee = DataFlow::moduleMember("entities", "encodeHTML")
      or
      callee = DataFlow::moduleMember("entities", "encodeXML")
      or
      callee = DataFlow::moduleMember("escape-goat", "escape")
      or
      callee = DataFlow::moduleMember("he", "encode")
      or
      callee = DataFlow::moduleMember("he", "escape")
      or
      callee = DataFlow::moduleImport("sanitize-html")
      or
      callee = DataFlow::moduleMember("sanitizer", "escape")
      or
      callee = DataFlow::moduleMember("sanitizer", "sanitize")
      or
      callee = DataFlow::moduleMember("validator", "escape")
      or
      callee = DataFlow::moduleImport("xss")
      or
      callee = DataFlow::moduleMember("xss-filters", _)
      or
      callee = LodashUnderscore::member("escape")
      or
      exists(DataFlow::PropRead read | read = callee |
        read.getPropertyName() = "sanitize" and
        read.getBase().asExpr().(VarAccess).getName() = "DOMPurify"
      )
      or
      exists(string name | name = "encode" or name = "encodeNonUTF" |
        callee =
          DataFlow::moduleMember("html-entities", _).getAnInstantiation().getAPropertyRead(name) or
        callee = DataFlow::moduleMember("html-entities", _).getAPropertyRead(name)
      )
      or
      callee = Closure::moduleImport("goog.string.htmlEscape")
    )
    or
    // Match home-made sanitizers by name.
    exists(string calleeName | calleeName = getCalleeName() |
      calleeName.regexpMatch("(?i).*html.*") and
      calleeName.regexpMatch("(?i).*(?<!un)(saniti[sz]|escape|strip).*")
    )
  }

  override DataFlow::Node getInput() { result = getArgument(0) }
}
