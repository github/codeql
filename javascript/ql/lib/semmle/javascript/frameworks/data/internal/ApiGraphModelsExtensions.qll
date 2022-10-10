/**
 * Defines extensible predicates for contributing library models from data extensions.
 */

/**
 * Holds if the value at `(package, type, path)` should be seen as a flow
 * source of the given `kind`.
 *
 * The kind `remote` represents a general remote flow source.
 */
extensible predicate internal_sourceModel(string package, string type, string path, string kind);

/**
 * Holds if the value at `(package, type, path)` should be seen as a sink
 * of the given `kind`.
 */
extensible predicate internal_sinkModel(string package, string type, string path, string kind);

/**
 * Holds if calls to `(package, type, path)`, the value referred to by `input`
 * can flow to the value referred to by `output`.
 *
 * `kind` should be either `value` or `taint`, for value-preserving or taint-preserving steps,
 * respectively.
 */
extensible predicate internal_summaryModel(
  string package, string type, string path, string input, string output, string kind
);

/**
 * Holds if `(package2, type2, path)` should be seen as an instance of `(package1, type1)`.
 */
extensible predicate internal_typeModel(
  string package1, string type1, string package2, string type2, string path
);

/**
 * Holds if `path` can be substituted for a token `TypeVar[name]`.
 */
extensible predicate internal_typeVariableModel(string name, string path);
