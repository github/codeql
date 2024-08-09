/**
 * Defines extensible predicates for contributing library models from data extensions.
 */

/**
 * Holds if the value at `(type, path)` should be seen as a flow
 * source of the given `kind`.
 *
 * The kind `remote` represents a general remote flow source.
 */
extensible predicate sourceModel(
  string type, string path, string kind, QlBuiltins::ExtensionId madId
);

/**
 * Holds if the value at `(type, path)` should be seen as a sink
 * of the given `kind`.
 */
extensible predicate sinkModel(string type, string path, string kind, QlBuiltins::ExtensionId madId);

/**
 * Holds if in calls to `(type, path)`, the value referred to by `input`
 * can flow to the value referred to by `output`.
 *
 * `kind` should be either `value` or `taint`, for value-preserving or taint-preserving steps,
 * respectively.
 */
extensible predicate summaryModel(
  string type, string path, string input, string output, string kind, QlBuiltins::ExtensionId madId
);

/**
 * Holds if calls to `(type, path)` should be considered neutral. The meaning of this depends on the `kind`.
 * If `kind` is `summary`, the call does not propagate data flow. If `kind` is `source`, the call is not a source.
 * If `kind` is `sink`, the call is not a sink.
 */
extensible predicate neutralModel(string type, string path, string kind);

/**
 * Holds if `(type2, path)` should be seen as an instance of `type1`.
 */
extensible predicate typeModel(string type1, string type2, string path);

/**
 * Holds if `path` can be substituted for a token `TypeVar[name]`.
 */
extensible predicate typeVariableModel(string name, string path);

/**
 * Holds if the given extension tuple `madId` should pretty-print as `model`.
 *
 * This predicate should only be used in tests.
 */
predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) {
  exists(string type, string path, string kind |
    sourceModel(type, path, kind, madId) and
    model = "Source: " + type + "; " + path + "; " + kind
  )
  or
  exists(string type, string path, string kind |
    sinkModel(type, path, kind, madId) and
    model = "Sink: " + type + "; " + path + "; " + kind
  )
  or
  exists(string type, string path, string input, string output, string kind |
    summaryModel(type, path, input, output, kind, madId) and
    model = "Summary: " + type + "; " + path + "; " + input + "; " + output + "; " + kind
  )
}
