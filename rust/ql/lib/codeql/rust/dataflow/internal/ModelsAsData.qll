/**
 * Defines extensible predicates for contributing library models from data extensions.
 *
 * The extensible relations have the following columns:
 *
 * - Sources:
 *   `crate; path; output; kind; provenance`
 * - Sinks:
 *   `crate; path; input; kind; provenance`
 * - Summaries:
 *   `crate; path; input; output; kind; provenance`
 *
 * The interpretation of a row is similar to API-graphs with a left-to-right
 * reading.
 *
 * 1. The `crate` column selects a crate.
 * 2. The `path` column selects a function with the given canonical path within
 *    the crate.
 * 3. The `input` column specifies how data enters the element selected by the
 *    first 2 columns, and the `output` column specifies how data leaves the
 *    element selected by the first 2 columns. Both `input` and `output` are
 *    `.`-separated lists of "access path tokens" to resolve, starting at the
 *    selected function.
 *
 *    The following tokens are supported:
 *     - `Argument[n]`: the `n`-th argument to a call. May be a range of form `x..y` (inclusive)
 *                      and/or a comma-separated list.
 *     - `Parameter[n]`: the `n`-th parameter of a callback. May be a range of form `x..y` (inclusive)
 *                       and/or a comma-separated list.
 *     - `ReturnValue`: the value returned by a function call.
 *     - `Element`: an element in a collection.
 *     - `Variant[v::f]`: field `f` of the variant with canonical path `v`, for example
 *                        `Variant[crate::ihex::Record::Data::value]`.
 *     - `Variant[v(i)]`: position `i` inside the variant with canonical path `v`, for example
 *                        `Variant[crate::option::Option::Some(0)]`.
 *     - `Struct[s::f]`: field `f` of the struct with canonical path `v`, for example
 *                       `Struct[crate::process::Child::stdin]`.
 *     - `Tuple[i]`: the `i`th element of a tuple.
 * 4. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources `"remote"` indicates a default remote flow source, and for summaries
 *    `"taint"` indicates a default additional taint step and `"value"` indicates a
 *    globally applicable value-preserving step.
 * 5. The `provenance` column is mainly used internally, and should be set to `"manual"` for
 *    all custom models.
 */

private import rust
private import codeql.rust.dataflow.FlowSummary
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.dataflow.FlowSink

/**
 * Holds if in a call to the function with canonical path `path`, defined in the
 * crate `crate`, the value referred to by `output` is a flow source of the given
 * `kind`.
 *
 * `output = "ReturnValue"` simply means the result of the call itself.
 *
 * For more information on the `kind` parameter, see
 * https://github.com/github/codeql/blob/main/docs/codeql/reusables/threat-model-description.rst.
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

private class FlowSourceFromModel extends FlowSource::Range {
  private string crate;
  private string path;

  FlowSourceFromModel() {
    sourceModel(crate, path, _, _, _, _) and
    this.callResolvesTo(crate, path)
  }

  override predicate isSource(string output, string kind, Provenance provenance, string model) {
    exists(QlBuiltins::ExtensionId madId |
      sourceModel(crate, path, output, kind, provenance, madId) and
      model = "MaD:" + madId.toString()
    )
  }
}

private class FlowSinkFromModel extends FlowSink::Range {
  private string crate;
  private string path;

  FlowSinkFromModel() {
    sinkModel(crate, path, _, _, _, _) and
    this.callResolvesTo(crate, path)
  }

  override predicate isSink(string input, string kind, Provenance provenance, string model) {
    exists(QlBuiltins::ExtensionId madId |
      sinkModel(crate, path, input, kind, provenance, madId) and
      model = "MaD:" + madId.toString()
    )
  }
}
