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
   * Type summaries for the `Mime::Type` class, i.e. method calls that produce new
   * `Mime::Type` instances.
   */
  private class MimeTypeTypeSummary extends ModelInput::TypeModelCsv {
    override predicate row(string row) {
      // type1;type2;path
      row =
        [
          // Mime[type] : Mime::Type (omitted)
          // Method names with brackets like [] cannot be represented in MaD.
          // Mime.fetch(type) : Mime::Type
          "Mime::Type;Mime!;Method[fetch].ReturnValue",
          // Mime::Type.lookup(str) : Mime::Type
          "Mime::Type;Mime::Type!;Method[lookup].ReturnValue",
          // Mime::Type.lookup_by_extension(str) : Mime::Type
          "Mime::Type;Mime::Type!;Method[lookup_by_extension].ReturnValue",
          // Mime::Type.register(str) : Mime::Type
          "Mime::Type;Mime::Type!;Method[register].ReturnValue",
          // Mime::Type.register_alias(str) : Mime::Type
          "Mime::Type;Mime::Type!;Method[register_alias].ReturnValue",
        ]
    }
  }

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
