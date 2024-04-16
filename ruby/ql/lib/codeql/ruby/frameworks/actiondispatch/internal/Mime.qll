/**
 * Models MIME type handling using the `ActionDispatch` library, which is part of Rails.
 */

private import codeql.ruby.Regexp as RE
private import codeql.ruby.frameworks.data.ModelsAsData

/**
 * Models MIME type handling using the `ActionDispatch` library, which is part of Rails.
 */
module Mime {
  /**
   * An argument to `Mime::Type#match?`, which is converted to a RegExp via
   * `Regexp.new`.
   */
  class MimeTypeMatchRegExpInterpretation extends RE::RegExpInterpretation::Range {
    MimeTypeMatchRegExpInterpretation() {
      this = ModelOutput::getATypeNode("Mime::Type").getAMethodCall(["match?", "=~"]).getArgument(0)
    }
  }
}
