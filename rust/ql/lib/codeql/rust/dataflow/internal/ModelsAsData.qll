/**
 * Defines extensible predicates for contributing library models from data extensions.
 */

private import rust
private import codeql.rust.dataflow.FlowSummary

/**
 * Holds if in a call to the function with canonical path `path`, defined in the
 * crate `crate`, the value referred to by `output` is a flow source of the given
 * `kind`.
 *
 * `output = "ReturnValue"` simply means the result of the call itself.
 *
 * The following kinds are supported:
 *
 * - `remote`: a general remote flow source.
 */
extensible predicate sourceModel(
  string crate, string path, string output, string kind, string provenance,
  QlBuiltins::ExtensionId madId
);

/**
 * Holds if in a call to the function with canonical path `path`, defined in the
 * crate `crate`, the value referred to by `input` is a flow sink of the given
 * `kind`.
 *
 * For example, `input = Argument[0]` means the first argument of the call.
 *
 * The following kinds are supported:
 *
 * - `sql-injection`: a flow sink for SQL injection.
 */
extensible predicate sinkModel(
  string crate, string path, string input, string kind, string provenance,
  QlBuiltins::ExtensionId madId
);

/**
 * Holds if in a call to the function with canonical path `path`, defined in the
 * crate `crate`, the value referred to by `input` can flow to the value referred
 * to by `output`.
 *
 * `kind` should be either `value` or `taint`, for value-preserving or taint-preserving
 * steps, respectively.
 */
extensible predicate summaryModel(
  string crate, string path, string input, string output, string kind, string provenance,
  QlBuiltins::ExtensionId madId
);

/**
 * Holds if the given extension tuple `madId` should pretty-print as `model`.
 *
 * This predicate should only be used in tests.
 */
predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) {
  exists(string crate, string path, string output, string kind |
    sourceModel(crate, path, kind, output, _, madId) and
    model = "Source: " + crate + "; " + path + "; " + output + "; " + kind
  )
  or
  exists(string crate, string path, string input, string kind |
    sinkModel(crate, path, kind, input, _, madId) and
    model = "Sink: " + crate + "; " + path + "; " + input + "; " + kind
  )
  or
  exists(string type, string path, string input, string output, string kind |
    summaryModel(type, path, input, output, kind, _, madId) and
    model = "Summary: " + type + "; " + path + "; " + input + "; " + output + "; " + kind
  )
}

private class SummarizedCallableFromModel extends SummarizedCallable::Range {
  private string crate;
  private string path;

  SummarizedCallableFromModel() {
    summaryModel(crate, path, _, _, _, _, _) and
    this = crate + "::_::" + path
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    exists(string kind, QlBuiltins::ExtensionId madId |
      summaryModel(crate, path, input, output, kind, _, madId) and
      model = "MaD:" + madId.toString()
    |
      kind = "value" and
      preservesValue = true
      or
      kind = "taint" and
      preservesValue = false
    )
  }
}
