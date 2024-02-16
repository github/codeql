/**
 * Provides predicates for generating names for classes and functions that are part
 * of the public API of a library.
 *
 * When possible, we try to use the qualified name by which a class/function can be accessed
 * from client code.
 *
 * However, there are cases where classes and functions can be exposed to client
 * code without being accessible as a qualified name. For example;
 * ```js
 * // 'Foo' is internal, but clients can call its methods, e.g. `getFoo().m()`
 * class Foo {
 *   m() {}
 * }
 * export function getFoo() {
 *   return new Foo();
 * }
 *
 * // Clients can call m() via getObj().m()
 * export function getObj() {
 *   return {
 *     m() {}
 *   }
 * }
 * ```
 *
 * In these cases, we try to make up human-readable names for the endpoints.
 * We make an effort to make these unambiguous in practice, though this is not always guaranteed.
 */

private import javascript

/** Concatenates two access paths. */
bindingset[x, y]
private string join(string x, string y) {
  if x = "" or y = "" then result = x + y else result = x + "." + y
}

private predicate isPackageExport(API::Node node) { node = API::moduleExport(_) }

private predicate relevantEdge(API::Node pred, API::Node succ) {
  succ = pred.getMember(_) and
  not isPrivateLike(succ)
  or
  succ = pred.getInstance()
}

/** Gets the shortest distance from a packaeg export to `nd` in the API graph. */
private int distanceFromPackageExport(API::Node nd) =
  shortestDistances(isPackageExport/1, relevantEdge/2)(_, nd, result)

private predicate isExported(API::Node node) { exists(distanceFromPackageExport(node)) }

/**
 * Holds if `node` is a default export that can be reinterpreted as a namespace export,
 * because the enclosing module has no named exports.
 */
private predicate defaultExportCanBeInterpretedAsNamespaceExport(API::Node node) {
  exists(ES2015Module mod |
    node.asSink() = mod.getAnExportedValue("default") and
    not mod.hasBothNamedAndDefaultExports()
  )
}

private predicate isPrivateAssignment(DataFlow::Node node) {
  exists(MemberDeclaration decl |
    node = decl.getInit().flow() and
    decl.isPrivate()
  )
  or
  exists(DataFlow::PropWrite write |
    write.isPrivateField() and
    node = write.getRhs()
  )
}

private predicate isPrivateLike(API::Node node) { isPrivateAssignment(node.asSink()) }

private API::Node getASuccessor(API::Node node, string name, int badness) {
  isExported(node) and
  isExported(result) and
  (
    exists(string member |
      result = node.getMember(member) and
      if member = "default"
      then
        if defaultExportCanBeInterpretedAsNamespaceExport(node)
        then (
          badness = 5 and name = ""
        ) else (
          badness = 10 and name = "default"
        )
      else (
        name = member and badness = 0
      )
    )
    or
    result = node.getInstance() and
    name = "prototype" and
    badness = 0
  )
}

private API::Node getAPredecessor(API::Node node, string name, int badness) {
  node = getASuccessor(result, name, badness)
}

/**
 * Gets the predecessor of `node` to use when constructing a qualified name for it,
 * and binds `name` and `badness` corresponding to the label on that edge.
 */
private API::Node getPreferredPredecessor(API::Node node, string name, int badness) {
  // For root nodes, we prefer not having a predecessor, as we use the package name.
  not isPackageExport(node) and
  // Rank predecessors by name-badness, export-distance, and name.
  // Since min() can only return a single value, we need a separate min() call per column.
  badness =
    min(API::Node pred, int b |
      pred = getAPredecessor(node, _, b) and
      // ensure the preferred predecessor is strictly closer to a root export, even if it means accepting more badness
      distanceFromPackageExport(pred) < distanceFromPackageExport(node)
    |
      b
    ) and
  result =
    min(API::Node pred, string name1 |
      pred = getAPredecessor(node, name1, badness)
    |
      pred order by distanceFromPackageExport(pred), name1
    ) and
  name = min(string n | result = getAPredecessor(node, n, badness) | n)
}

/**
 * Holds if `(package, name)` is a potential name to associate with `sink`.
 *
 * `badness` is bound to the associated badness of the name.
 */
private predicate sinkHasNameCandidate(API::Node sink, string package, string name, int badness) {
  sink = API::moduleExport(package) and
  name = "" and
  badness = 0
  or
  exists(API::Node baseNode, string baseName, int baseBadness, string step, int stepBadness |
    sinkHasNameCandidate(baseNode, package, baseName, baseBadness) and
    baseNode = getPreferredPredecessor(sink, step, stepBadness) and
    badness = baseBadness + stepBadness and
    name = join(baseName, step)
  )
}

/**
 * Holds if `(package, name)` is the primary name to associate with `sink`.
 *
 * `badness` is bound to the associated badness of the name.
 */
private predicate sinkHasPrimaryName(API::Node sink, string package, string name, int badness) {
  badness = min(int b | sinkHasNameCandidate(sink, _, _, b) | b) and
  package = min(string p | sinkHasNameCandidate(sink, p, _, badness) | p) and
  name = min(string n | sinkHasNameCandidate(sink, package, n, badness) | n order by n.length(), n)
}

/**
 * Holds if `(package, name)` is the primary name to associate with `node`.
 */
predicate sinkHasPrimaryName(API::Node sink, string package, string name) {
  sinkHasPrimaryName(sink, package, name, _)
}

/** Gets a source node that can flow to `sink` without using a return step. */
private DataFlow::SourceNode nodeReachingSink(API::Node sink, DataFlow::TypeBackTracker t) {
  t.start() and
  result = sink.asSink().getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2 |
    result = nodeReachingSink(sink, t2).backtrack(t2, t) and
    t.hasReturn() = false
  )
}

/** Gets a source node that can flow to `sink` without using a return step. */
DataFlow::SourceNode nodeReachingSink(API::Node sink) {
  result = nodeReachingSink(sink, DataFlow::TypeBackTracker::end())
}

/** Gets a sink node reachable from `node`. */
private API::Node getASinkNode(DataFlow::SourceNode node) { node = nodeReachingSink(result) }

/**
 * Holds if `node` is assigned to a global access path. Note that such nodes generally do not have API nodes.
 */
private predicate nameFromGlobal(DataFlow::Node node, string package, string name, int badness) {
  package = "global" and
  node = AccessPath::getAnAssignmentTo(name) and
  badness = -10
}

bindingset[qualifiedName]
private int getBadnessOfClassName(string qualifiedName) {
  if qualifiedName.matches("%.constructor")
  then result = 10
  else
    if qualifiedName = ""
    then result = 5
    else result = 0
}

/** Holds if `(package, name)` is a potential name for `cls`, with the given `badness`. */
private predicate classObjectHasNameCandidate(
  DataFlow::ClassNode cls, string package, string name, int badness
) {
  // There can be multiple API nodes associated with `cls`.
  // For example:
  ///
  //    class C {}
  //    module.exports.A = C; // first sink
  //    module.exports.B = C; // second sink
  //
  exists(int baseBadness |
    sinkHasPrimaryName(getASinkNode(cls), package, name, baseBadness) and
    badness = baseBadness + getBadnessOfClassName(name)
  )
  or
  nameFromGlobal(cls, package, name, badness)
  or
  // If the class is not accessible via an access path, but instances of the
  // class can still escape via more complex access patterns, resort to a synthesized name.
  // For example:
  //
  //   class InternalClass {}
  //   function foo() {
  //     return new InternalClass();
  //   }
  //
  hasEscapingInstance(cls) and
  exists(string baseName |
    InternalModuleNaming::fallbackModuleName(cls.getTopLevel(), package, baseName, badness - 100) and
    name = join(baseName, cls.getName())
  )
}

/** Holds if an instance of `cls` can be exposed to client code. */
private predicate hasEscapingInstance(DataFlow::ClassNode cls) {
  cls.getAnInstanceReference().flowsTo(any(API::Node n).asSink())
}

private predicate sourceNodeHasNameCandidate(
  DataFlow::SourceNode node, string package, string name, int badness
) {
  sinkHasPrimaryName(getASinkNode(node), package, name, badness)
  or
  nameFromGlobal(node, package, name, badness)
  or
  classObjectHasNameCandidate(node, package, name, badness)
}

private predicate sourceNodeHasPrimaryName(
  DataFlow::SourceNode node, string package, string name, int badness
) {
  badness = min(int b | sourceNodeHasNameCandidate(node, _, _, b) | b) and
  package =
    min(string p | sourceNodeHasNameCandidate(node, p, _, badness) | p order by p.length(), p) and
  name =
    min(string n | sourceNodeHasNameCandidate(node, package, n, badness) | n order by n.length(), n)
}

/** Gets a data flow node referring to a function value. */
private DataFlow::SourceNode functionValue(DataFlow::TypeTracker t) {
  t.start() and
  (
    result instanceof DataFlow::FunctionNode
    or
    result instanceof DataFlow::ClassNode
    or
    result instanceof DataFlow::PartialInvokeNode
  )
  or
  exists(DataFlow::TypeTracker t2 | result = functionValue(t2).track(t2, t))
}

/** Gets a data flow node referring to a function value. */
private DataFlow::SourceNode functionValue() {
  result = functionValue(DataFlow::TypeTracker::end())
}

/**
 * Holds if `node` is a function or a call that returns a function.
 */
private predicate isFunctionSource(DataFlow::SourceNode node) {
  (
    exists(getASinkNode(node))
    or
    nameFromGlobal(node, _, _, _)
  ) and
  (
    node instanceof DataFlow::FunctionNode
    or
    node instanceof DataFlow::ClassNode
    or
    node = functionValue() and
    node instanceof DataFlow::InvokeNode and
    exists(node.getABoundFunctionValue(_)) and
    // `getASinkNode` steps through imports (but not other calls) so exclude calls that are imports (i.e. require calls)
    // as we want to get as close to the source as possible.
    not node instanceof DataFlow::ModuleImportNode
  )
}

/**
 * Holds if `(package, name)` is the primary name for the given `function`.
 *
 * The `function` node may be an actual function expression, or a call site from which a function is returned.
 */
predicate functionHasPrimaryName(DataFlow::SourceNode function, string package, string name) {
  sourceNodeHasPrimaryName(function, package, name, _) and
  isFunctionSource(function)
}

private predicate sinkHasSourceName(API::Node sink, string package, string name, int badness) {
  exists(DataFlow::SourceNode source |
    sink = getASinkNode(source) and
    sourceNodeHasPrimaryName(source, package, name, badness)
  )
}

private predicate sinkHasPrimarySourceName(API::Node sink, string package, string name, int badness) {
  badness = min(int b | sinkHasSourceName(sink, _, _, b) | b) and
  package = min(string p | sinkHasSourceName(sink, p, _, badness) | p order by p.length(), p) and
  name = min(string n | sinkHasSourceName(sink, package, n, badness) | n order by n.length(), n)
}

private predicate sinkHasPrimarySourceName(API::Node sink, string package, string name) {
  sinkHasPrimarySourceName(sink, package, name, _)
}

private predicate aliasCandidate(
  string package, string name, string targetPackage, string targetName, API::Node aliasDef
) {
  sinkHasPrimaryName(aliasDef, package, name) and
  sinkHasPrimarySourceName(aliasDef, targetPackage, targetName) and
  not (
    package = targetPackage and
    name = targetName
  )
}

private predicate nonAlias(string package, string name) {
  // `(package, name)` appears to be an alias for multiple things. Treat it as a primary name instead.
  strictcount(string targetPackage, string targetName |
    aliasCandidate(package, name, targetPackage, targetName, _)
  ) > 1
  or
  // Not all sinks with this name agree on the alias target
  exists(API::Node sink, string targetPackage, string targetName |
    aliasCandidate(package, name, targetPackage, targetName, _) and
    sinkHasPrimaryName(sink, package, name) and
    not sinkHasPrimarySourceName(sink, targetPackage, targetName, _)
  )
}

/**
 * Holds if `(package, name)` is an alias for `(targetPackage, targetName)`,
 * defined at `aliasDef`.
 *
 * Only the last component of an access path is reported as an alias, the prefix always
 * uses the primary name for that access path. The aliases for the prefix are reported
 * as separate tuples.
 *
 * For example, we might report that `a.b.C` is an alias for `a.b.c`, and that `a.B` is an alias for `a.b`.
 * By combining the two aliasing facts, we may conclude that `a.B.C` is an alias for `a.b.c`, but this fact is not
 * reported separately.
 */
predicate aliasDefinition(
  string package, string name, string targetPackage, string targetName, API::Node aliasDef
) {
  aliasCandidate(package, name, targetPackage, targetName, aliasDef) and
  not nonAlias(package, name)
}

/**
 * Converts a `(package, name)` pair to a string of form `(package).name`.
 */
bindingset[package, name]
string renderName(string package, string name) { result = join("(" + package + ")", name) }

/**
 * Contains predicates for naming individual modules (i.e. files) inside of a package.
 *
 * These names are not necessarily part of a package's public API, and so we only used them
 * as a fallback when a publicly-accessible access path cannot be found.
 */
private module InternalModuleNaming {
  /** Gets the path to `folder` relative to its enclosing non-private `package.json` file. */
  private string getPackageRelativePathFromFolder(Folder folder) {
    exists(PackageJson json |
      json.getFile() = folder.getFile("package.json") and
      not json.isPrivate() and
      result = json.getPackageName()
    )
    or
    not exists(folder.getFile("package.json")) and
    result =
      getPackageRelativePathFromFolder(folder.getParentContainer()) + "/" + folder.getBaseName()
  }

  private string getPackageRelativePath(Module mod) {
    exists(PackageJson json, string relativePath |
      not json.isPrivate() and
      json.getExportedModule(relativePath) = mod and
      if relativePath = "."
      then result = json.getPackageName()
      else result = json.getPackageName() + "/" + relativePath.regexpReplaceAll("^\\./", "")
    )
    or
    not mod = any(PackageJson json | not json.isPrivate()).getExportedModule(_) and
    not mod.isAmbient() and
    exists(string folderPath |
      folderPath = getPackageRelativePathFromFolder(mod.getFile().getParentContainer()) and
      if mod.getName() = "index"
      then result = folderPath
      else result = folderPath + "/" + mod.getName()
    )
  }

  /** Holds if `(package, name)` should be used to refer to code inside `mod`. */
  predicate fallbackModuleName(Module mod, string package, string name, int badness) {
    sinkHasPrimaryName(getASinkNode(mod.getDefaultOrBulkExport()), package, name, badness)
    or
    badness = 50 and
    package = getPackageRelativePath(mod) and
    name = ""
  }
}

/**
 * Contains query predicates for emitting debugging information about endpoint naming.
 */
module Debug {
  /** Holds if `node` has multiple preferred predecessors. */
  query predicate ambiguousPreferredPredecessor(API::Node node) {
    strictcount(API::Node pred, string name, int badness |
      pred = getPreferredPredecessor(node, name, badness)
    ) > 1
  }

  /** Holds if the given `node` has multiple primary names. */
  query string ambiguousSinkName(API::Node node) {
    strictcount(string package, string name | sinkHasPrimaryName(node, package, name)) > 1 and
    result =
      concat(string package, string name |
        sinkHasPrimaryName(node, package, name)
      |
        renderName(package, name), ", "
      )
  }

  /** Holds if the given `node` has multiple primary names. */
  query string ambiguousFunctionName(DataFlow::FunctionNode node) {
    strictcount(string package, string name | functionHasPrimaryName(node, package, name)) > 1 and
    result =
      concat(string package, string name |
        functionHasPrimaryName(node, package, name)
      |
        renderName(package, name), ", "
      )
  }
}
