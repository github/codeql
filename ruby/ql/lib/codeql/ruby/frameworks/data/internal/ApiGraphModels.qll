/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * Provides classes and predicates for dealing with flow models specified in CSV format.
 *
 * The CSV specification has the following columns:
 * - Sources:
 *   `package; type; path; kind`
 * - Sinks:
 *   `package; type; path; kind`
 * - Summaries:
 *   `package; type; path; input; output; kind`
 * - Types:
 *   `package1; type1; package2; type2; path`
 *
 * The interpretation of a row is similar to API-graphs with a left-to-right
 * reading.
 * 1. The `package` column selects a package name, as it would be referenced in the source code,
 *    such as an NPM package, PIP package, or Ruby gem. (See `ModelsAsData.qll` for language-specific details).
 *    It may also be a synthetic package used for a type definition (see type definitions below).
 * 2. The `type` column selects all instances of a named type originating from that package,
 *    or the empty string if referring to the package itself.
 *    It can also be a synthetic type name defined by a type definition (see type definitions below).
 * 3. The `path` column is a `.`-separated list of "access path tokens" to resolve, starting at the node selected by `package` and `type`.
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
 * 4. The `input` and `output` columns specify how data enters and leaves the element selected by the
 *    first `(package, type, path)` tuple. Both strings are `.`-separated access paths
 *    of the same syntax as the `path` column.
 * 5. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources `"remote"` indicates a default remote flow source, and for summaries
 *    `"taint"` indicates a default additional taint step and `"value"` indicates a
 *    globally applicable value-preserving step.
 *
 * ### Types
 *
 * A type row of form `package1; type1; package2; type2; path` indicates that `package2; type2; path`
 * should be seen as an instance of the type `package1; type1`.
 *
 * A `(package,type)` pair may refer to a static type or a synthetic type name used internally in the model.
 * Synthetic type names can be used to reuse intermediate sub-paths, when there are multiple ways to access the same
 * element.
 * See `ModelsAsData.qll` for the language-specific interpretation of packages and static type names.
 *
 * By convention, if one wants to avoid clashes with static types from the package, the type name
 * should be prefixed with a tilde character (`~`). For example, `(foo, ~Bar)` can be used to indicate that
 * the type is related to the `foo` package but is not intended to match a static type.
 */

private import ApiGraphModelsSpecific as Specific

private class Unit = Specific::Unit;

private module API = Specific::API;

private module DataFlow = Specific::DataFlow;

private import Specific::AccessPathSyntax

/** Module containing hooks for providing input data to be interpreted as a model. */
module ModelInput {
  /**
   * A unit class for adding additional source model rows.
   *
   * Extend this class to add additional source definitions.
   */
  class SourceModelCsv extends Unit {
    /**
     * Holds if `row` specifies a source definition.
     *
     * A row of form
     * ```
     * package;type;path;kind
     * ```
     * indicates that the value at `(package, type, path)` should be seen as a flow
     * source of the given `kind`.
     *
     * The kind `remote` represents a general remote flow source.
     */
    abstract predicate row(string row);
  }

  /**
   * A unit class for adding additional sink model rows.
   *
   * Extend this class to add additional sink definitions.
   */
  class SinkModelCsv extends Unit {
    /**
     * Holds if `row` specifies a sink definition.
     *
     * A row of form
     * ```
     * package;type;path;kind
     * ```
     * indicates that the value at `(package, type, path)` should be seen as a sink
     * of the given `kind`.
     */
    abstract predicate row(string row);
  }

  /**
   * A unit class for adding additional summary model rows.
   *
   * Extend this class to add additional flow summary definitions.
   */
  class SummaryModelCsv extends Unit {
    /**
     * Holds if `row` specifies a summary definition.
     *
     * A row of form
     * ```
     * package;type;path;input;output;kind
     * ```
     * indicates that for each call to `(package, type, path)`, the value referred to by `input`
     * can flow to the value referred to by `output`.
     *
     * `kind` should be either `value` or `taint`, for value-preserving or taint-preserving steps,
     * respectively.
     */
    abstract predicate row(string row);
  }

  /**
   * A unit class for adding additional type model rows.
   *
   * Extend this class to add additional type definitions.
   */
  class TypeModelCsv extends Unit {
    /**
     * Holds if `row` specifies a type definition.
     *
     * A row of form,
     * ```
     * package1;type1;package2;type2;path
     * ```
     * indicates that `(package2, type2, path)` should be seen as an instance of `(package1, type1)`.
     */
    abstract predicate row(string row);
  }

  /**
   * A unit class for adding additional type model rows from CodeQL models.
   */
  class TypeModel extends Unit {
    /**
     * Gets a data-flow node that is a source of the type `package;type`.
     *
     * This must not depend on API graphs, but ensures that an API node is generated for
     * the source.
     */
    DataFlow::Node getASource(string package, string type) { none() }

    /**
     * Gets a data-flow node that is a sink of the type `package;type`,
     * usually because it is an argument passed to a parameter of that type.
     *
     * This must not depend on API graphs, but ensures that an API node is generated for
     * the sink.
     */
    DataFlow::Node getASink(string package, string type) { none() }

    /**
     * Gets an API node that is a source or sink of the type `package;type`.
     *
     * Unlike `getASource` and `getASink`, this may depend on API graphs.
     */
    API::Node getAnApiNode(string package, string type) { none() }
  }

  /**
   * A unit class for adding additional type variable model rows.
   */
  class TypeVariableModelCsv extends Unit {
    /**
     * Holds if `row` specifies a path through a type variable.
     *
     * A row of form,
     * ```
     * name;path
     * ```
     * means `path` can be substituted for a token `TypeVar[name]`.
     */
    abstract predicate row(string row);
  }
}

private import ModelInput

/**
 * An empty class, except in specific tests.
 *
 * If this is non-empty, all models are parsed even if the package is not
 * considered relevant for the current database.
 */
abstract class TestAllModels extends Unit { }

/**
 * Append `;dummy` to the value of `s` to work around the fact that `string.split(delim,n)`
 * does not preserve empty trailing substrings.
 */
bindingset[result]
private string inversePad(string s) { s = result + ";dummy" }

private predicate sourceModel(string row) { any(SourceModelCsv s).row(inversePad(row)) }

private predicate sinkModel(string row) { any(SinkModelCsv s).row(inversePad(row)) }

private predicate summaryModel(string row) { any(SummaryModelCsv s).row(inversePad(row)) }

private predicate typeModel(string row) { any(TypeModelCsv s).row(inversePad(row)) }

private predicate typeVariableModel(string row) { any(TypeVariableModelCsv s).row(inversePad(row)) }

/** Holds if a source model exists for the given parameters. */
predicate sourceModel(string package, string type, string path, string kind) {
  exists(string row |
    sourceModel(row) and
    row.splitAt(";", 0) = package and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = path and
    row.splitAt(";", 3) = kind
  )
}

/** Holds if a sink model exists for the given parameters. */
private predicate sinkModel(string package, string type, string path, string kind) {
  exists(string row |
    sinkModel(row) and
    row.splitAt(";", 0) = package and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = path and
    row.splitAt(";", 3) = kind
  )
}

/** Holds if a summary model `row` exists for the given parameters. */
private predicate summaryModel(
  string package, string type, string path, string input, string output, string kind
) {
  exists(string row |
    summaryModel(row) and
    row.splitAt(";", 0) = package and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = path and
    row.splitAt(";", 3) = input and
    row.splitAt(";", 4) = output and
    row.splitAt(";", 5) = kind
  )
}

/** Holds if a type model exists for the given parameters. */
private predicate typeModel(
  string package1, string type1, string package2, string type2, string path
) {
  exists(string row |
    typeModel(row) and
    row.splitAt(";", 0) = package1 and
    row.splitAt(";", 1) = type1 and
    row.splitAt(";", 2) = package2 and
    row.splitAt(";", 3) = type2 and
    row.splitAt(";", 4) = path
  )
}

/** Holds if a type variable model exists for the given parameters. */
private predicate typeVariableModel(string name, string path) {
  exists(string row |
    typeVariableModel(row) and
    row.splitAt(";", 0) = name and
    row.splitAt(";", 1) = path
  )
}

/**
 * Gets a package that should be seen as an alias for the given other `package`,
 * or the `package` itself.
 */
bindingset[package]
bindingset[result]
string getAPackageAlias(string package) {
  typeModel(package, "", result, "", "")
  or
  result = package
}

/**
 * Holds if CSV rows involving `package` might be relevant for the analysis of this database.
 */
private predicate isRelevantPackage(string package) {
  (
    sourceModel(package, _, _, _) or
    sinkModel(package, _, _, _) or
    summaryModel(package, _, _, _, _, _) or
    typeModel(_, _, package, _, _)
  ) and
  (
    Specific::isPackageUsed(package)
    or
    exists(TestAllModels t)
  )
  or
  exists(string other |
    isRelevantPackage(other) and
    typeModel(package, _, other, _, _)
  )
}

/**
 * Holds if `package,type,path` is used in some CSV row.
 */
pragma[nomagic]
predicate isRelevantFullPath(string package, string type, string path) {
  isRelevantPackage(package) and
  (
    sourceModel(package, type, path, _) or
    sinkModel(package, type, path, _) or
    summaryModel(package, type, path, _, _, _) or
    typeModel(_, _, package, type, path)
  )
}

/** A string from a CSV row that should be parsed as an access path. */
private class AccessPathRange extends AccessPath::Range {
  AccessPathRange() {
    isRelevantFullPath(_, _, this)
    or
    exists(string package | isRelevantPackage(package) |
      summaryModel(package, _, _, this, _, _) or
      summaryModel(package, _, _, _, this, _)
    )
    or
    typeVariableModel(_, this)
  }
}

/**
 * Gets a successor of `node` in the API graph.
 */
bindingset[token]
API::Node getSuccessorFromNode(API::Node node, AccessPathToken token) {
  // API graphs use the same label for arguments and parameters. An edge originating from a
  // use-node represents an argument, and an edge originating from a def-node represents a parameter.
  // We just map both to the same thing.
  token.getName() = ["Argument", "Parameter"] and
  result = node.getParameter(AccessPath::parseIntUnbounded(token.getAnArgument()))
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
API::Node getSuccessorFromInvoke(Specific::InvokeNode invoke, AccessPathToken token) {
  token.getName() = "Argument" and
  result =
    invoke
        .getParameter(AccessPath::parseIntWithArity(token.getAnArgument(), invoke.getNumArgument()))
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
pragma[inline]
private predicate invocationMatchesCallSiteFilter(Specific::InvokeNode invoke, AccessPathToken token) {
  token.getName() = "WithArity" and
  invoke.getNumArgument() = AccessPath::parseIntUnbounded(token.getAnArgument())
  or
  Specific::invocationMatchesExtraCallSiteFilter(invoke, token)
}

private class TypeModelUseEntry extends API::EntryPoint {
  private string package;
  private string type;

  TypeModelUseEntry() {
    exists(any(TypeModel tm).getASource(package, type)) and
    this = "TypeModelUseEntry;" + package + ";" + type
  }

  override DataFlow::LocalSourceNode getASource() {
    result = any(TypeModel tm).getASource(package, type)
  }

  API::Node getNodeForType(string package_, string type_) {
    package = package_ and type = type_ and result = this.getANode()
  }
}

private class TypeModelDefEntry extends API::EntryPoint {
  private string package;
  private string type;

  TypeModelDefEntry() {
    exists(any(TypeModel tm).getASink(package, type)) and
    this = "TypeModelDefEntry;" + package + ";" + type
  }

  override DataFlow::Node getASink() { result = any(TypeModel tm).getASink(package, type) }

  API::Node getNodeForType(string package_, string type_) {
    package = package_ and type = type_ and result = this.getANode()
  }
}

/**
 * Gets an API node identified by the given `(package,type)` pair.
 */
pragma[nomagic]
private API::Node getNodeFromType(string package, string type) {
  exists(string package2, string type2, AccessPath path2 |
    typeModel(package, type, package2, type2, path2) and
    result = getNodeFromPath(package2, type2, path2)
  )
  or
  result = any(TypeModelUseEntry e).getNodeForType(package, type)
  or
  result = any(TypeModelDefEntry e).getNodeForType(package, type)
  or
  result = any(TypeModel t).getAnApiNode(package, type)
  or
  result = Specific::getExtraNodeFromType(package, type)
}

/**
 * Gets the API node identified by the first `n` tokens of `path` in the given `(package, type, path)` tuple.
 */
pragma[nomagic]
private API::Node getNodeFromPath(string package, string type, AccessPath path, int n) {
  isRelevantFullPath(package, type, path) and
  (
    n = 0 and
    result = getNodeFromType(package, type)
    or
    result = Specific::getExtraNodeFromPath(package, type, path, n)
  )
  or
  result = getSuccessorFromNode(getNodeFromPath(package, type, path, n - 1), path.getToken(n - 1))
  or
  // Similar to the other recursive case, but where the path may have stepped through one or more call-site filters
  result =
    getSuccessorFromInvoke(getInvocationFromPath(package, type, path, n - 1), path.getToken(n - 1))
  or
  // Apply a subpath
  result =
    getNodeFromSubPath(getNodeFromPath(package, type, path, n - 1), getSubPathAt(path, n - 1))
  or
  // Apply a type step
  typeStep(getNodeFromPath(package, type, path, n), result)
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
    base = [getNodeFromPath(_, _, path, k), getNodeFromSubPath(_, path, k)] and
    subPath = getSubPathAt(path, k) and
    result = base and
    n = 0
  )
  or
  exists(string package, string type, AccessPath basePath |
    typeStepModel(package, type, basePath, subPath) and
    base = getNodeFromPath(package, type, basePath) and
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

/** Gets the node identified by the given `(package, type, path)` tuple. */
private API::Node getNodeFromPath(string package, string type, AccessPath path) {
  result = getNodeFromPath(package, type, path, path.getNumToken())
}

pragma[nomagic]
private predicate typeStepModel(string package, string type, AccessPath basePath, AccessPath output) {
  summaryModel(package, type, basePath, "", output, "type")
}

pragma[nomagic]
private predicate typeStep(API::Node pred, API::Node succ) {
  exists(string package, string type, AccessPath basePath, AccessPath output |
    typeStepModel(package, type, basePath, output) and
    pred = getNodeFromPath(package, type, basePath) and
    succ = getNodeFromSubPath(pred, output)
  )
}

/**
 * Gets an invocation identified by the given `(package, type, path)` tuple.
 *
 * Unlike `getNodeFromPath`, the `path` may end with one or more call-site filters.
 */
private Specific::InvokeNode getInvocationFromPath(
  string package, string type, AccessPath path, int n
) {
  result = Specific::getAnInvocationOf(getNodeFromPath(package, type, path, n))
  or
  result = getInvocationFromPath(package, type, path, n - 1) and
  invocationMatchesCallSiteFilter(result, path.getToken(n - 1))
}

/** Gets an invocation identified by the given `(package, type, path)` tuple. */
private Specific::InvokeNode getInvocationFromPath(string package, string type, AccessPath path) {
  result = getInvocationFromPath(package, type, path, path.getNumToken())
}

/**
 * Holds if `name` is a valid name for an access path token in the identifying access path.
 */
bindingset[name]
private predicate isValidTokenNameInIdentifyingAccessPath(string name) {
  name = ["Argument", "Parameter", "ReturnValue", "WithArity", "TypeVar"]
  or
  Specific::isExtraValidTokenNameInIdentifyingAccessPath(name)
}

/**
 * Holds if `name` is a valid name for an access path token with no arguments, occurring
 * in an identifying access path.
 */
bindingset[name]
private predicate isValidNoArgumentTokenInIdentifyingAccessPath(string name) {
  name = "ReturnValue"
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
     * Holds if a CSV source model contributed `source` with the given `kind`.
     */
    cached
    API::Node getASourceNode(string kind) {
      exists(string package, string type, string path |
        sourceModel(package, type, path, kind) and
        result = getNodeFromPath(package, type, path)
      )
    }

    /**
     * Holds if a CSV sink model contributed `sink` with the given `kind`.
     */
    cached
    API::Node getASinkNode(string kind) {
      exists(string package, string type, string path |
        sinkModel(package, type, path, kind) and
        result = getNodeFromPath(package, type, path)
      )
    }

    /**
     * Holds if a relevant CSV summary exists for these parameters.
     */
    cached
    predicate relevantSummaryModel(
      string package, string type, string path, string input, string output, string kind
    ) {
      isRelevantPackage(package) and
      summaryModel(package, type, path, input, output, kind)
    }

    /**
     * Holds if a `baseNode` is an invocation identified by the `package,type,path` part of a summary row.
     */
    cached
    predicate resolvedSummaryBase(
      string package, string type, string path, Specific::InvokeNode baseNode
    ) {
      summaryModel(package, type, path, _, _, _) and
      baseNode = getInvocationFromPath(package, type, path)
    }

    /**
     * Holds if `node` is seen as an instance of `(package,type)` due to a type definition
     * contributed by a CSV model.
     */
    cached
    API::Node getATypeNode(string package, string type) { result = getNodeFromType(package, type) }
  }

  import Cached

  /**
   * Gets an error message relating to an invalid CSV row in a model.
   */
  string getAWarning() {
    // Check number of columns
    exists(string row, string kind, int expectedArity, int actualArity |
      any(SourceModelCsv csv).row(row) and kind = "source" and expectedArity = 4
      or
      any(SinkModelCsv csv).row(row) and kind = "sink" and expectedArity = 4
      or
      any(SummaryModelCsv csv).row(row) and kind = "summary" and expectedArity = 6
      or
      any(TypeModelCsv csv).row(row) and kind = "type" and expectedArity = 5
      or
      any(TypeVariableModelCsv csv).row(row) and kind = "type-variable" and expectedArity = 2
    |
      actualArity = count(row.indexOf(";")) + 1 and
      actualArity != expectedArity and
      result =
        "CSV " + kind + " row should have " + expectedArity + " columns but has " + actualArity +
          ": " + row
    )
    or
    // Check names and arguments of access path tokens
    exists(AccessPath path, AccessPathToken token |
      (isRelevantFullPath(_, _, path) or typeVariableModel(_, path)) and
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
  }
}
