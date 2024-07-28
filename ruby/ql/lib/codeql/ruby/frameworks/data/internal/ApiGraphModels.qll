/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * Provides classes and predicates for dealing with flow models specified in extensible predicates.
 *
 * The extensible predicates have the following columns:
 * - Sources:
 *   `type, path, kind`
 * - Sinks:
 *   `type, path, kind`
 * - Summaries:
 *   `type, path, input, output, kind`
 * - Types:
 *   `type1, type2, path`
 *
 * The interpretation of a row is similar to API-graphs with a left-to-right
 * reading.
 * 1. The `type` column selects all instances of a named type. The syntax of this column is language-specific.
 *    The language defines some type names that the analysis knows how to identify without models.
 *    It can also be a synthetic type name defined by a type definition (see type definitions below).
 * 2. The `path` column is a `.`-separated list of "access path tokens" to resolve, starting at the node selected by `type`.
 *
 *    Every language supports the following tokens:
 *     - Argument[n]: the n-th argument to a call. May be a range of form `x..y` (inclusive) and/or a comma-separated list.
 *                    Additionally, `N-1` refers to the last argument, `N-2` refers to the second-last, and so on.
 *     - Parameter[n]: the n-th parameter of a callback. May be a range of form `x..y` (inclusive) and/or a comma-separated list.
 *     - ReturnValue: the value returned by a function call
 *     - WithArity[n]: match a call with the given arity. May be a range of form `x..y` (inclusive) and/or a comma-separated list.
 *
 *    The following tokens are common and should be implemented for languages where it makes sense:
 *     - Member[x]: a member named `x`; exactly what a "member" is depends on the language. May be a comma-separated list of names.
 *     - Instance: an instance of a class
 *     - Subclass: a subclass of a class
 *     - ArrayElement: an element of array
 *     - Element: an element of a collection-like object
 *     - MapKey: a key in map-like object
 *     - MapValue: a value in a map-like object
 *     - Awaited: the value from a resolved promise/future-like object
 *
 *    For the time being, please consult `ApiGraphModelsSpecific.qll` to see which language-specific tokens are currently supported.
 *
 * 3. The `input` and `output` columns specify how data enters and leaves the element selected by the
 *    first `(type, path)` tuple. Both strings are `.`-separated access paths
 *    of the same syntax as the `path` column.
 * 4. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources `"remote"` indicates a default remote flow source, and for summaries
 *    `"taint"` indicates a default additional taint step and `"value"` indicates a
 *    globally applicable value-preserving step.
 *
 * ### Types
 *
 * A type row of form `type1; type2; path` indicates that `type2; path`
 * should be seen as an instance of the type `type1`.
 *
 * A type may refer to a static type or a synthetic type name used internally in the model.
 * Synthetic type names can be used to reuse intermediate sub-paths, when there are multiple ways to access the same
 * element.
 * See `ModelsAsData.qll` for the language-specific interpretation of type names.
 *
 * By convention, if one wants to avoid clashes with static types, the type name
 * should be prefixed with a tilde character (`~`). For example, `~Bar` can be used to indicate that
 * the type is not intended to match a static type.
 */

private import codeql.util.Unit
private import ApiGraphModelsSpecific as Specific

private module API = Specific::API;

private module DataFlow = Specific::DataFlow;

private import ApiGraphModelsExtensions as Extensions
private import codeql.dataflow.internal.AccessPathSyntax

/** Module containing hooks for providing input data to be interpreted as a model. */
module ModelInput {
  /**
   * DEPRECATED: Use the extensible predicate `sourceModel` instead.
   *
   * A unit class for adding additional source model rows.
   *
   * Extend this class to add additional source definitions.
   */
  deprecated class SourceModelCsv extends Unit {
    /**
     * Holds if `row` specifies a source definition.
     *
     * A row of form
     * ```
     * type;path;kind
     * ```
     * indicates that the value at `(type, path)` should be seen as a flow
     * source of the given `kind`.
     *
     * The kind `remote` represents a general remote flow source.
     */
    abstract deprecated predicate row(string row);
  }

  /**
   * A unit class for adding additional sink model rows.
   *
   * Extend this class to add additional sink definitions.
   *
   * DEPRECATED: Use the extensible predicate `sinkModel` instead.
   */
  deprecated class SinkModelCsv extends Unit {
    /**
     * Holds if `row` specifies a sink definition.
     *
     * A row of form
     * ```
     * type;path;kind
     * ```
     * indicates that the value at `(type, path)` should be seen as a sink
     * of the given `kind`.
     */
    abstract deprecated predicate row(string row);
  }

  /**
   * A unit class for adding additional summary model rows.
   *
   * Extend this class to add additional flow summary definitions.
   *
   * DEPRECATED: Use the extensible predicate `summaryModel` instead.
   */
  deprecated class SummaryModelCsv extends Unit {
    /**
     * Holds if `row` specifies a summary definition.
     *
     * A row of form
     * ```
     * type;path;input;output;kind
     * ```
     * indicates that for each call to `(type, path)`, the value referred to by `input`
     * can flow to the value referred to by `output`.
     *
     * `kind` should be either `value` or `taint`, for value-preserving or taint-preserving steps,
     * respectively.
     */
    abstract deprecated predicate row(string row);
  }

  /**
   * A unit class for adding additional type model rows.
   *
   * Extend this class to add additional type definitions.
   *
   * DEPRECATED: Use the extensible predicate `typeModel` or the class
   * `TypeModel` instead.
   */
  deprecated class TypeModelCsv extends Unit {
    /**
     * Holds if `row` specifies a type definition.
     *
     * A row of form,
     * ```
     * type1;type2;path
     * ```
     * indicates that `(type2, path)` should be seen as an instance of `type1`.
     */
    abstract deprecated predicate row(string row);
  }

  /**
   * A unit class for adding additional type model rows from CodeQL models.
   */
  class TypeModel extends Unit {
    /**
     * Holds if any of the other predicates in this class might have a result
     * for the given `type`.
     *
     * The implementation of this predicate should not depend on `DataFlow::Node`.
     */
    bindingset[type]
    predicate isTypeUsed(string type) { none() }

    /**
     * Gets a data-flow node that is a source of the given `type`.
     *
     * Note that `type` should also be included in `isTypeUsed`.
     *
     * This must not depend on API graphs, but ensures that an API node is generated for
     * the source.
     */
    DataFlow::Node getASource(string type) { none() }

    /**
     * Gets a data-flow node that is a sink of the given `type`,
     * usually because it is an argument passed to a parameter of that type.
     *
     * Note that `type` should also be included in `isTypeUsed`.
     *
     * This must not depend on API graphs, but ensures that an API node is generated for
     * the sink.
     */
    DataFlow::Node getASink(string type) { none() }

    /**
     * Gets an API node that is a source or sink of the given `type`.
     *
     * Note that `type` should also be included in `isTypeUsed`.
     *
     * Unlike `getASource` and `getASink`, this may depend on API graphs.
     */
    API::Node getAnApiNode(string type) { none() }
  }

  /**
   * A unit class for adding additional type variable model rows.
   *
   * DEPRECATED: Use the extensible predicate `typeVariableModel` instead.
   */
  deprecated class TypeVariableModelCsv extends Unit {
    /**
     * Holds if `row` specifies a path through a type variable.
     *
     * A row of form,
     * ```
     * name;path
     * ```
     * means `path` can be substituted for a token `TypeVar[name]`.
     */
    abstract deprecated predicate row(string row);
  }
}

private import ModelInput

/**
 * An empty class, except in specific tests.
 *
 * If this is non-empty, all models are parsed even if the type name is not
 * considered relevant for the current database.
 */
abstract class TestAllModels extends Unit { }

/**
 * Append `;dummy` to the value of `s` to work around the fact that `string.split(delim,n)`
 * does not preserve empty trailing substrings.
 */
bindingset[result]
deprecated private string inversePad(string s) { s = result + ";dummy" }

deprecated private predicate sourceModel(string row) { any(SourceModelCsv s).row(inversePad(row)) }

deprecated private predicate sinkModel(string row) { any(SinkModelCsv s).row(inversePad(row)) }

deprecated private predicate summaryModel(string row) {
  any(SummaryModelCsv s).row(inversePad(row))
}

deprecated private predicate typeModel(string row) { any(TypeModelCsv s).row(inversePad(row)) }

deprecated private predicate typeVariableModel(string row) {
  any(TypeVariableModelCsv s).row(inversePad(row))
}

private class DeprecationAdapter extends Unit {
  abstract predicate sourceModel(string type, string path, string kind);

  abstract predicate sinkModel(string type, string path, string kind);

  abstract predicate summaryModel(string type, string path, string input, string output, string kind);

  abstract predicate typeModel(string type1, string type2, string path);

  abstract predicate typeVariableModel(string name, string path);
}

private class DeprecationAdapterImpl extends DeprecationAdapter {
  deprecated override predicate sourceModel(string type, string path, string kind) {
    exists(string row |
      sourceModel(row) and
      row.splitAt(";", 0) = type and
      row.splitAt(";", 1) = path and
      row.splitAt(";", 2) = kind
    )
  }

  deprecated override predicate sinkModel(string type, string path, string kind) {
    exists(string row |
      sinkModel(row) and
      row.splitAt(";", 0) = type and
      row.splitAt(";", 1) = path and
      row.splitAt(";", 2) = kind
    )
  }

  deprecated override predicate summaryModel(
    string type, string path, string input, string output, string kind
  ) {
    exists(string row |
      summaryModel(row) and
      row.splitAt(";", 0) = type and
      row.splitAt(";", 1) = path and
      row.splitAt(";", 2) = input and
      row.splitAt(";", 3) = output and
      row.splitAt(";", 4) = kind
    )
  }

  deprecated override predicate typeModel(string type1, string type2, string path) {
    exists(string row |
      typeModel(row) and
      row.splitAt(";", 0) = type1 and
      row.splitAt(";", 1) = type2 and
      row.splitAt(";", 2) = path
    )
  }

  deprecated override predicate typeVariableModel(string name, string path) {
    exists(string row |
      typeVariableModel(row) and
      row.splitAt(";", 0) = name and
      row.splitAt(";", 1) = path
    )
  }
}

/** Holds if a source model exists for the given parameters. */
predicate sourceModel(string type, string path, string kind, string model) {
  any(DeprecationAdapter a).sourceModel(type, path, kind) and
  model = "SourceModelCsv"
  or
  exists(QlBuiltins::ExtensionId madId |
    Extensions::sourceModel(type, path, kind, madId) and
    model = "MaD:" + madId.toString()
  )
}

/** Holds if a sink model exists for the given parameters. */
private predicate sinkModel(string type, string path, string kind, string model) {
  any(DeprecationAdapter a).sinkModel(type, path, kind) and
  model = "SinkModelCsv"
  or
  exists(QlBuiltins::ExtensionId madId |
    Extensions::sinkModel(type, path, kind, madId) and
    model = "MaD:" + madId.toString()
  )
}

/** Holds if a summary model `row` exists for the given parameters. */
private predicate summaryModel(
  string type, string path, string input, string output, string kind, string model
) {
  any(DeprecationAdapter a).summaryModel(type, path, input, output, kind) and
  model = "SummaryModelCsv"
  or
  exists(QlBuiltins::ExtensionId madId |
    Extensions::summaryModel(type, path, input, output, kind, madId) and
    model = "MaD:" + madId.toString()
  )
}

/** Holds if a type model exists for the given parameters. */
predicate typeModel(string type1, string type2, string path) {
  any(DeprecationAdapter a).typeModel(type1, type2, path)
  or
  Extensions::typeModel(type1, type2, path)
}

/** Holds if a type variable model exists for the given parameters. */
private predicate typeVariableModel(string name, string path) {
  any(DeprecationAdapter a).typeVariableModel(name, path)
  or
  Extensions::typeVariableModel(name, path)
}

/**
 * Holds if the given extension tuple `madId` should pretty-print as `model`.
 *
 * This predicate should only be used in tests.
 */
predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) {
  exists(string type, string path, string kind |
    Extensions::sourceModel(type, path, kind, madId) and
    model = "Source: " + type + "; " + path + "; " + kind
  )
  or
  exists(string type, string path, string kind |
    Extensions::sinkModel(type, path, kind, madId) and
    model = "Sink: " + type + "; " + path + "; " + kind
  )
  or
  exists(string type, string path, string input, string output, string kind |
    Extensions::summaryModel(type, path, input, output, kind, madId) and
    model = "Summary: " + type + "; " + path + "; " + input + "; " + output + "; " + kind
  )
}

/**
 * Holds if rows involving `type` might be relevant for the analysis of this database.
 */
predicate isRelevantType(string type) {
  (
    sourceModel(type, _, _, _) or
    sinkModel(type, _, _, _) or
    summaryModel(type, _, _, _, _, _) or
    typeModel(_, type, _)
  ) and
  (
    Specific::isTypeUsed(type)
    or
    any(TypeModel model).isTypeUsed(type)
    or
    exists(TestAllModels t)
  )
  or
  exists(string other | isRelevantType(other) |
    typeModel(type, other, _)
    or
    Specific::hasImplicitTypeModel(type, other)
  )
}

/**
 * Holds if `type,path` is used in some row.
 */
pragma[nomagic]
predicate isRelevantFullPath(string type, string path) {
  isRelevantType(type) and
  (
    sourceModel(type, path, _, _) or
    sinkModel(type, path, _, _) or
    summaryModel(type, path, _, _, _, _) or
    typeModel(_, type, path)
  )
}

/** A string from a row that should be parsed as an access path. */
private predicate accessPathRange(string s) {
  isRelevantFullPath(_, s)
  or
  exists(string type | isRelevantType(type) |
    summaryModel(type, _, s, _, _, _) or
    summaryModel(type, _, _, s, _, _)
  )
  or
  typeVariableModel(_, s)
}

import AccessPath<accessPathRange/1>

/**
 * Gets a successor of `node` in the API graph.
 */
bindingset[token]
API::Node getSuccessorFromNode(API::Node node, AccessPathTokenBase token) {
  // API graphs use the same label for arguments and parameters. An edge originating from a
  // use-node represents an argument, and an edge originating from a def-node represents a parameter.
  // We just map both to the same thing.
  token.getName() = ["Argument", "Parameter"] and
  result = node.getParameter(parseIntUnbounded(token.getAnArgument()))
  or
  token.getName() = "ReturnValue" and
  result = node.getReturn()
  or
  // Language-specific tokens
  result = Specific::getExtraSuccessorFromNode(node, token)
}

/**
 * Gets an API-graph successor for the given invocation.
 */
bindingset[token]
API::Node getSuccessorFromInvoke(Specific::InvokeNode invoke, AccessPathTokenBase token) {
  token.getName() = "Argument" and
  result = invoke.getParameter(parseIntWithArity(token.getAnArgument(), invoke.getNumArgument()))
  or
  token.getName() = "ReturnValue" and
  result = invoke.getReturn()
  or
  // Language-specific tokens
  result = Specific::getExtraSuccessorFromInvoke(invoke, token)
}

/**
 * Holds if `invoke` invokes a call-site filter given by `token`.
 */
bindingset[token]
private predicate invocationMatchesCallSiteFilter(
  Specific::InvokeNode invoke, AccessPathTokenBase token
) {
  token.getName() = "WithArity" and
  invoke.getNumArgument() = parseIntUnbounded(token.getAnArgument())
  or
  Specific::invocationMatchesExtraCallSiteFilter(invoke, token)
}

private class TypeModelUseEntry extends API::EntryPoint {
  private string type;

  TypeModelUseEntry() {
    exists(any(TypeModel tm).getASource(type)) and
    this = "TypeModelUseEntry;" + type
  }

  override DataFlow::LocalSourceNode getASource() { result = any(TypeModel tm).getASource(type) }

  API::Node getNodeForType(string type_) { type = type_ and result = this.getANode() }
}

private class TypeModelDefEntry extends API::EntryPoint {
  private string type;

  TypeModelDefEntry() {
    exists(any(TypeModel tm).getASink(type)) and
    this = "TypeModelDefEntry;" + type
  }

  override DataFlow::Node getASink() { result = any(TypeModel tm).getASink(type) }

  API::Node getNodeForType(string type_) { type = type_ and result = this.getANode() }
}

/**
 * Gets an API node identified by the given `type`.
 */
pragma[nomagic]
private API::Node getNodeFromType(string type) {
  exists(string type2, AccessPath path2 |
    typeModel(type, type2, path2) and
    result = getNodeFromPath(type2, path2)
  )
  or
  result = any(TypeModelUseEntry e).getNodeForType(type)
  or
  result = any(TypeModelDefEntry e).getNodeForType(type)
  or
  result = any(TypeModel t).getAnApiNode(type)
  or
  result = Specific::getExtraNodeFromType(type)
}

/**
 * Gets the API node identified by the first `n` tokens of `path` in the given `(type, path)` tuple.
 */
pragma[nomagic]
API::Node getNodeFromPath(string type, AccessPath path, int n) {
  isRelevantFullPath(type, path) and
  (
    n = 0 and
    result = getNodeFromType(type)
    or
    result = Specific::getExtraNodeFromPath(type, path, n)
  )
  or
  result = getSuccessorFromNode(getNodeFromPath(type, path, n - 1), path.getToken(n - 1))
  or
  // Similar to the other recursive case, but where the path may have stepped through one or more call-site filters
  result = getSuccessorFromInvoke(getInvocationFromPath(type, path, n - 1), path.getToken(n - 1))
  or
  // Apply a subpath
  result = getNodeFromSubPath(getNodeFromPath(type, path, n - 1), getSubPathAt(path, n - 1))
  or
  // Apply a type step
  typeStep(getNodeFromPath(type, path, n), result)
  or
  // Apply a fuzzy step (without advancing 'n')
  path.getToken(n).getName() = "Fuzzy" and
  result = Specific::getAFuzzySuccessor(getNodeFromPath(type, path, n))
  or
  // Skip a fuzzy step (advance 'n' without changing the current node)
  path.getToken(n - 1).getName() = "Fuzzy" and
  result = getNodeFromPath(type, path, n - 1)
}

/**
 * Gets a subpath for the `TypeVar` token found at the `n`th token of `path`.
 */
pragma[nomagic]
private AccessPath getSubPathAt(AccessPath path, int n) {
  exists(string typeVarName |
    path.getToken(n).getAnArgument("TypeVar") = typeVarName and
    typeVariableModel(typeVarName, result)
  )
}

/**
 * Gets a node that is found by evaluating the first `n` tokens of `subPath` starting at `base`.
 */
pragma[nomagic]
private API::Node getNodeFromSubPath(API::Node base, AccessPath subPath, int n) {
  exists(AccessPath path, int k |
    base = [getNodeFromPath(_, path, k), getNodeFromSubPath(_, path, k)] and
    subPath = getSubPathAt(path, k) and
    result = base and
    n = 0
  )
  or
  exists(string type, AccessPath basePath |
    typeStepModel(type, basePath, subPath) and
    base = getNodeFromPath(type, basePath) and
    result = base and
    n = 0
  )
  or
  result = getSuccessorFromNode(getNodeFromSubPath(base, subPath, n - 1), subPath.getToken(n - 1))
  or
  result =
    getSuccessorFromInvoke(getInvocationFromSubPath(base, subPath, n - 1), subPath.getToken(n - 1))
  or
  result =
    getNodeFromSubPath(getNodeFromSubPath(base, subPath, n - 1), getSubPathAt(subPath, n - 1))
  or
  typeStep(getNodeFromSubPath(base, subPath, n), result) and
  // Only apply type-steps strictly between the steps on the sub path, not before and after.
  // Steps before/after lead to unnecessary transitive edges, which the user of the sub-path
  // will themselves find by following type-steps.
  n > 0 and
  n < subPath.getNumToken()
  or
  // Apply a fuzzy step (without advancing 'n')
  subPath.getToken(n).getName() = "Fuzzy" and
  result = Specific::getAFuzzySuccessor(getNodeFromSubPath(base, subPath, n))
  or
  // Skip a fuzzy step (advance 'n' without changing the current node)
  subPath.getToken(n - 1).getName() = "Fuzzy" and
  result = getNodeFromSubPath(base, subPath, n - 1)
}

/**
 * Gets a call site that is found by evaluating the first `n` tokens of `subPath` starting at `base`.
 */
private Specific::InvokeNode getInvocationFromSubPath(API::Node base, AccessPath subPath, int n) {
  result = Specific::getAnInvocationOf(getNodeFromSubPath(base, subPath, n))
  or
  result = getInvocationFromSubPath(base, subPath, n - 1) and
  invocationMatchesCallSiteFilter(result, subPath.getToken(n - 1))
}

/**
 * Gets a node that is found by evaluating `subPath` starting at `base`.
 */
pragma[nomagic]
private API::Node getNodeFromSubPath(API::Node base, AccessPath subPath) {
  result = getNodeFromSubPath(base, subPath, subPath.getNumToken())
}

/** Gets the node identified by the given `(type, path)` tuple. */
private API::Node getNodeFromPath(string type, AccessPath path) {
  result = getNodeFromPath(type, path, path.getNumToken())
}

pragma[nomagic]
private predicate typeStepModel(string type, AccessPath basePath, AccessPath output) {
  summaryModel(type, basePath, "", output, "type", _)
}

pragma[nomagic]
private predicate typeStep(API::Node pred, API::Node succ) {
  exists(string type, AccessPath basePath, AccessPath output |
    typeStepModel(type, basePath, output) and
    pred = getNodeFromPath(type, basePath) and
    succ = getNodeFromSubPath(pred, output)
  )
}

/**
 * Gets an invocation identified by the given `(type, path)` tuple.
 *
 * Unlike `getNodeFromPath`, the `path` may end with one or more call-site filters.
 */
private Specific::InvokeNode getInvocationFromPath(string type, AccessPath path, int n) {
  result = Specific::getAnInvocationOf(getNodeFromPath(type, path, n))
  or
  result = getInvocationFromPath(type, path, n - 1) and
  invocationMatchesCallSiteFilter(result, path.getToken(n - 1))
}

/** Gets an invocation identified by the given `(type, path)` tuple. */
private Specific::InvokeNode getInvocationFromPath(string type, AccessPath path) {
  result = getInvocationFromPath(type, path, path.getNumToken())
}

/**
 * Holds if `name` is a valid name for an access path token in the identifying access path.
 */
bindingset[name]
private predicate isValidTokenNameInIdentifyingAccessPath(string name) {
  name = ["Argument", "Parameter", "ReturnValue", "WithArity", "TypeVar", "Fuzzy"]
  or
  Specific::isExtraValidTokenNameInIdentifyingAccessPath(name)
}

/**
 * Holds if `name` is a valid name for an access path token with no arguments, occurring
 * in an identifying access path.
 */
bindingset[name]
private predicate isValidNoArgumentTokenInIdentifyingAccessPath(string name) {
  name = ["ReturnValue", "Fuzzy"]
  or
  Specific::isExtraValidNoArgumentTokenInIdentifyingAccessPath(name)
}

/**
 * Holds if `argument` is a valid argument to an access path token with the given `name`, occurring
 * in an identifying access path.
 */
bindingset[name, argument]
private predicate isValidTokenArgumentInIdentifyingAccessPath(string name, string argument) {
  name = ["Argument", "Parameter"] and
  argument.regexpMatch("(N-|-)?\\d+(\\.\\.((N-|-)?\\d+)?)?")
  or
  name = "WithArity" and
  argument.regexpMatch("\\d+(\\.\\.(\\d+)?)?")
  or
  name = "TypeVar" and
  exists(argument)
  or
  Specific::isExtraValidTokenArgumentInIdentifyingAccessPath(name, argument)
}

/**
 * Module providing access to the imported models in terms of API graph nodes.
 */
module ModelOutput {
  cached
  private module Cached {
    /**
     * Holds if a source model contributed `source` with the given `kind`.
     */
    cached
    API::Node getASourceNode(string kind, string model) {
      exists(string type, string path |
        sourceModel(type, path, kind, model) and
        result = getNodeFromPath(type, path)
      )
    }

    /**
     * Holds if a sink model contributed `sink` with the given `kind`.
     */
    cached
    API::Node getASinkNode(string kind, string model) {
      exists(string type, string path |
        sinkModel(type, path, kind, model) and
        result = getNodeFromPath(type, path)
      )
    }

    /**
     * Holds if a relevant summary exists for these parameters.
     */
    cached
    predicate relevantSummaryModel(
      string type, string path, string input, string output, string kind, string model
    ) {
      isRelevantType(type) and
      summaryModel(type, path, input, output, kind, model)
    }

    /**
     * Holds if a `baseNode` is an invocation identified by the `type,path` part of a summary row.
     */
    cached
    predicate resolvedSummaryBase(string type, string path, Specific::InvokeNode baseNode) {
      summaryModel(type, path, _, _, _, _) and
      baseNode = getInvocationFromPath(type, path)
    }

    /**
     * Holds if a `baseNode` is a callable identified by the `type,path` part of a summary row.
     */
    cached
    predicate resolvedSummaryRefBase(string type, string path, API::Node baseNode) {
      summaryModel(type, path, _, _, _, _) and
      baseNode = getNodeFromPath(type, path)
    }

    /**
     * Holds if `node` is seen as an instance of `type` due to a type definition
     * contributed by a model.
     */
    cached
    API::Node getATypeNode(string type) { result = getNodeFromType(type) }
  }

  import Cached
  import Specific::ModelOutputSpecific
  private import codeql.mad.ModelValidation as SharedModelVal

  /**
   * Holds if a CSV source model contributed `source` with the given `kind`.
   */
  API::Node getASourceNode(string kind) { result = getASourceNode(kind, _) }

  /**
   * Holds if a CSV sink model contributed `sink` with the given `kind`.
   */
  API::Node getASinkNode(string kind) { result = getASinkNode(kind, _) }

  private module KindValConfig implements SharedModelVal::KindValidationConfigSig {
    predicate summaryKind(string kind) { summaryModel(_, _, _, _, kind, _) }

    predicate sinkKind(string kind) { sinkModel(_, _, kind, _) }

    predicate sourceKind(string kind) { sourceModel(_, _, kind, _) }
  }

  private module KindVal = SharedModelVal::KindValidation<KindValConfig>;

  /**
   * Gets an error message relating to an invalid CSV row in a model.
   */
  string getAWarning() {
    // Check names and arguments of access path tokens
    exists(AccessPath path, AccessPathToken token |
      (isRelevantFullPath(_, path) or typeVariableModel(_, path)) and
      token = path.getToken(_)
    |
      not isValidTokenNameInIdentifyingAccessPath(token.getName()) and
      result = "Invalid token name '" + token.getName() + "' in access path: " + path
      or
      isValidTokenNameInIdentifyingAccessPath(token.getName()) and
      exists(string argument |
        argument = token.getAnArgument() and
        not isValidTokenArgumentInIdentifyingAccessPath(token.getName(), argument) and
        result =
          "Invalid argument '" + argument + "' in token '" + token + "' in access path: " + path
      )
      or
      isValidTokenNameInIdentifyingAccessPath(token.getName()) and
      token.getNumArgument() = 0 and
      not isValidNoArgumentTokenInIdentifyingAccessPath(token.getName()) and
      result = "Invalid token '" + token + "' is missing its arguments, in access path: " + path
    )
    or
    // Check for invalid model kinds
    result = KindVal::getInvalidModelKind()
  }
}
