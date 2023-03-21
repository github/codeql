/** Provides modeling for the `json` gem. */

private import codeql.ruby.frameworks.data.ModelsAsData

/** Provides modeling for the `json` gem. */
module Json {
  /**
   * Flow summaries for common `JSON` methods.
   * Not all of these methods are strictly defined in the `json` gem.
   * The `JSON` namespace is heavily overloaded by other JSON parsing gems such as `oj`, `json_pure`, `multi_json` etc.
   * This summary covers common methods we've seen called on `JSON` in the wild.
   */
  private class JsonSummary extends ModelInput::SummaryModelCsv {
    override predicate row(string row) {
      row =
        [
          "JSON!;Method[parse,parse!,load,restore];Argument[0];ReturnValue;taint",
          "JSON!;Method[generate,fast_generate,pretty_generate,dump,unparse,fast_unparse];Argument[0];ReturnValue;taint",
        ]
    }
  }
}
