/**
 * Defines extensible predicates for contributing dynamic-style library models from data extensions.
 */
overlay[local]
module;

/**
 * Holds if the value at `(type, path)` should be seen as a flow source of the given `kind`.
 */
extensible predicate sourceModel(
  string type, string path, string kind, QlBuiltins::ExtensionId madId
);

/**
 * Holds if the value at `(type, path)` should be seen as a flow sink of the given `kind`.
 */
extensible predicate sinkModel(string type, string path, string kind, QlBuiltins::ExtensionId madId);

/**
 * Holds if calls to `(type, path)` propagate flow from `input` to `output`.
 *
 * `kind` is either `value`, `taint`, or `type`. A summary of kind `type` indicates that the value at
 * `output` (relative to `(type, path)`) has the same type as the value at `input`.
 */
extensible predicate summaryModel(
  string type, string path, string input, string output, string kind, QlBuiltins::ExtensionId madId
);

/**
 * Holds if the value at `(type2, path)` should be seen as an instance of `type1`.
 */
extensible predicate typeModel(string type1, string type2, string path);
