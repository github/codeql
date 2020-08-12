/**
 * Provides predicates for associating qualified names with data flow nodes.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps

deprecated module GlobalAccessPath {
  /**
   * DEPRECATED. Instead use `AccessPath::getAReferenceTo` with the result and parameter reversed.
   */
  pragma[inline]
  string fromReference(DataFlow::Node node) { node = AccessPath::getAReferenceTo(result) }

  /**
   * DEPRECATED. Instead use `AccessPath::getAnAssignmentTo` with the result and parameter reversed.
   */
  pragma[inline]
  string fromRhs(DataFlow::Node node) { node = AccessPath::getAnAssignmentTo(result) }

  /**
   * DEPRECATED. Use `AccessPath::getAReferenceOrAssignmentTo`.
   */
  pragma[inline]
  string getAccessPath(DataFlow::Node node) {
    result = fromReference(node)
    or
    not exists(fromReference(node)) and
    result = fromRhs(node)
  }
}

/**
 * Provides predicates for associating access paths with data flow nodes.
 *
 * For example, `AccessPath::getAReferenceTo(x)` can be used to obtain the global access path
 * that `x` refers to, as in the following sample:
 * ```
 * function f() {
 *   let v = foo.bar; // reference to 'foo.bar'
 *   v.baz;           // reference to 'foo.bar.baz'
 * }
 *
 * (function(ns) {
 *   ns.x;            // reference to 'NS.x'
 * })(NS = NS || {});
 * ```
 *
 * A pseudo-property named `[number]` is sometimes used to represent array indices within an access path.
 */
module AccessPath {
  /**
   * A source node that can be the root of an access path.
   */
  class Root extends DataFlow::SourceNode {
    Root() {
      not this.accessesGlobal(_) and
      not this instanceof DataFlow::PropRead and
      not this instanceof PropertyProjection and
      not this instanceof Closure::ClosureNamespaceAccess and
      not this = DataFlow::parameterNode(any(ImmediatelyInvokedFunctionExpr iife).getAParameter()) and
      not FlowSteps::identityFunctionStep(_, this)
    }

    /** Holds if this represents the root of the global access path. */
    predicate isGlobal() { this = DataFlow::globalAccessPathRootPseudoNode() }
  }

  /**
   * A local variable with exactly one definition, not counting implicit initialization.
   */
  private class EffectivelyConstantVariable extends LocalVariable {
    EffectivelyConstantVariable() {
      strictcount(SsaExplicitDefinition ssa | ssa.getSourceVariable() = this) = 1
    }

    /** Gets the SSA definition of this variable. */
    SsaExplicitDefinition getSsaDefinition() { result.getSourceVariable() = this }

    /** Gets the data flow node representing the value of this variable, if one exists. */
    DataFlow::Node getValue() { result = getSsaDefinition().getRhsNode() }
  }

  /**
   * Appends a single property name onto the access path `base`, where
   * the empty string represents the empty access path.
   */
  bindingset[base, prop]
  private string join(string base, string prop) {
    base = "" and result = prop
    or
    base != "" and
    result = base + "." + prop
  }

  /**
   * Holds if `variable` is compared to the `length` property of something, indicating
   * that, if used as a dynamic property name, it represents an array index.
   */
  private predicate isLikelyArrayIndex(SsaVariable variable) {
    exists(RelationalComparison cmp, DataFlow::PropRead length, Expr lengthUse |
      length.getPropertyName() = "length" and
      length.flowsToExpr(lengthUse) and
      cmp.hasOperands(variable.getAUse(), lengthUse)
    )
    or
    isLikelyArrayIndex(variable.getDefinition().(SsaRefinementNode).getAnInput())
  }

  /**
   * Holds if `prop` likely accesses a non-constant array element.
   */
  private predicate isLikelyDynamicArrayAccess(DataFlow::PropRead prop) {
    // The implicit PropRead in a for-of loop is represented by its lvalue node
    prop = DataFlow::lvalueNode(any(ForOfStmt stmt).getLValue())
    or
    // Match an index access x[i] where `i` is likely an array index variable.
    not exists(prop.getPropertyName()) and
    exists(SsaVariable indexVar |
      isLikelyArrayIndex(indexVar) and
      prop.getPropertyNameExpr() = indexVar.getAUse()
    )
  }

  /**
   * Gets the access path relative to `root` referred to by `node`.
   *
   * This holds for direct references as well as for aliases
   * established through local data flow.
   *
   * Examples:
   * ```
   * function f(x) {
   *   let a = x.f.g; // access path relative to 'x' is 'f.g'
   *   let b = a.h;   // access path relative to 'x' is 'f.g.h'
   * }
   * ```
   */
  cached
  private string fromReference(DataFlow::Node node, Root root) {
    root = node and
    not root.isGlobal() and
    result = ""
    or
    result = fromReference(node.getImmediatePredecessor(), root)
    or
    exists(EffectivelyConstantVariable var |
      var.isCaptured() and
      node.asExpr() = var.getAnAccess() and
      result = fromReference(var.getValue(), root)
    )
    or
    node.accessesGlobal(result) and
    result != "undefined" and
    root.isGlobal()
    or
    not node.accessesGlobal(_) and
    exists(DataFlow::PropRead prop | node = prop |
      result = join(fromReference(prop.getBase(), root), prop.getPropertyName())
      or
      isLikelyDynamicArrayAccess(prop) and
      result = join(fromReference(prop.getBase(), root), "[number]")
    )
    or
    exists(Closure::ClosureNamespaceAccess acc | node = acc |
      result = acc.getClosureNamespace() and
      root.isGlobal()
    )
    or
    exists(PropertyProjection proj | node = proj |
      proj.isSingletonProjection() and
      result = join(fromReference(proj.getObject(), root), proj.getASelector().getStringValue())
    )
    or
    // Treat 'e || {}' as having the same name as 'e'
    exists(LogOrExpr e | node.asExpr() = e |
      e.getRightOperand().(ObjectExpr).getNumProperty() = 0 and
      result = fromReference(e.getLeftOperand().flow(), root)
    )
    or
    // Treat 'e && e.f' as having the same name as 'e.f'
    exists(LogAndExpr e, Expr lhs, PropAccess rhs | node.asExpr() = e |
      lhs = e.getLeftOperand() and
      rhs = e.getRightOperand() and
      (
        exists(Variable v |
          lhs = v.getAnAccess() and
          rhs.getBase() = v.getAnAccess()
        )
        or
        exists(string name |
          lhs.(PropAccess).getQualifiedName() = name and
          rhs.getBase().(PropAccess).getQualifiedName() = name
        )
      ) and
      result = fromReference(rhs.flow(), root)
    )
  }

  /**
   * Holds if `rhs` is the right-hand side of a self-assignment.
   *
   * This usually happens in defensive initialization, for example:
   * ```
   * foo = foo || {};
   * ```
   */
  private predicate isSelfAssignment(DataFlow::Node rhs) {
    fromRhs(rhs, DataFlow::globalAccessPathRootPseudoNode()) =
      fromReference(rhs, DataFlow::globalAccessPathRootPseudoNode())
  }

  /**
   * Holds if there is an assignment to the global `accessPath` in `file`, not counting
   * self-assignments.
   */
  private predicate isAssignedInFile(string accessPath, File file) {
    exists(DataFlow::Node rhs |
      fromRhs(rhs, DataFlow::globalAccessPathRootPseudoNode()) = accessPath and
      not isSelfAssignment(rhs) and
      // Note: Avoid unneeded materialization of DataFlow::Node.getFile()
      rhs.getAstNode().getFile() = file
    )
  }

  /**
   * Holds if the global `accessPath` is only assigned to from one file, not counting
   * self-assignments.
   */
  predicate isAssignedInUniqueFile(string accessPath) {
    strictcount(File f | isAssignedInFile(accessPath, f)) = 1
  }

  /**
   * Gets the access path relative to `root`, which `node` is being assigned to, if any.
   *
   * Only holds for the immediate right-hand side of an assignment or property, not
   * for nodes that transitively flow there.
   *
   * For example, the class nodes below all map to `foo.bar` relative to `x`:
   * ```
   * function f(x) {
   *   x.foo.bar = class {};
   *   x.foo = { bar: class {} };
   *   let alias = x;
   *   alias.foo.bar = class {};
   * }
   * ```
   */
  cached
  private string fromRhs(DataFlow::Node node, Root root) {
    exists(DataFlow::PropWrite write, string baseName |
      node = write.getRhs() and
      result = join(baseName, write.getPropertyName())
    |
      baseName = fromReference(write.getBase(), root)
      or
      baseName = fromRhs(write.getBase(), root)
    )
    or
    exists(GlobalVariable var |
      node = var.getAnAssignedExpr().flow() and
      result = var.getName() and
      root.isGlobal()
    )
    or
    exists(FunctionDeclStmt fun |
      node = DataFlow::valueNode(fun) and
      result = fun.getIdentifier().(GlobalVarDecl).getName() and
      root.isGlobal()
    )
    or
    exists(ClassDeclStmt cls |
      node = DataFlow::valueNode(cls) and
      result = cls.getIdentifier().(GlobalVarDecl).getName() and
      root.isGlobal()
    )
    or
    exists(EnumDeclaration decl |
      node = DataFlow::valueNode(decl) and
      result = decl.getIdentifier().(GlobalVarDecl).getName() and
      root.isGlobal()
    )
    or
    exists(NamespaceDeclaration decl |
      node = DataFlow::valueNode(decl) and
      result = decl.getIdentifier().(GlobalVarDecl).getName() and
      root.isGlobal()
    )
  }

  /**
   * Gets a node that refers to the given access path relative to the given `root` node,
   * or `root` itself if the access path is empty.
   *
   * This works for direct references as well as for aliases established through local data flow.
   *
   * For example:
   * ```
   * function f(x) {
   *   let a = x.f.g; // reference to (x, "f.g")
   *   let b = a.h;   // reference to (x, "f.g.h")
   * }
   * ```
   */
  DataFlow::Node getAReferenceTo(Root root, string path) {
    path = fromReference(result, root) and
    not root.isGlobal()
  }

  /**
   * Gets a node that refers to the given global access path.
   *
   * This works for direct references as well as for aliases established through local data flow.
   *
   * Examples:
   * ```
   * function f() {
   *   let v = foo.bar; // reference to 'foo.bar'
   *   v.baz;           // reference to 'foo.bar.baz'
   * }
   *
   * (function(ns) {
   *   ns.x;            // reference to 'NS.x'
   * })(NS = NS || {});
   * ```
   */
  DataFlow::Node getAReferenceTo(string path) {
    path = fromReference(result, DataFlow::globalAccessPathRootPseudoNode())
  }

  /**
   * Gets a node that is assigned to the given access path relative to the given `root` node.
   *
   * Only gets the immediate right-hand side of an assignment or property, not
   * nodes that transitively flow there.
   *
   * For example, the class nodes below are all assignments to `(x, "foo.bar")`.
   * ```
   * function f(x) {
   *   x.foo.bar = class {};
   *   x.foo = { bar: class {} };
   *   let alias = x;
   *   alias.foo.bar = class {};
   * }
   * ```
   */
  DataFlow::Node getAnAssignmentTo(Root root, string path) {
    path = fromRhs(result, root) and
    not root.isGlobal()
  }

  /**
   * Gets a node that is assigned to the given global access path.
   *
   * Only gets the immediate right-hand side of an assignment or property or a global declaration,
   * not nodes that transitively flow there.
   *
   * For example, the class nodes below are all assignments to `foo.bar`:
   * ```
   * foo.bar = class {};
   * foo = { bar: class {} };
   * (function(f) {
   *   f.bar = class {}
   *  })(foo = foo || {});
   * ```
   */
  DataFlow::Node getAnAssignmentTo(string path) {
    path = fromRhs(result, DataFlow::globalAccessPathRootPseudoNode())
  }

  /**
   * Gets a node that refers to or is assigned to the given global access path.
   *
   * See `getAReferenceTo` and `getAnAssignmentTo` for more details.
   */
  DataFlow::Node getAReferenceOrAssignmentTo(string path) {
    result = getAReferenceTo(path)
    or
    result = getAnAssignmentTo(path)
  }

  /**
   * Gets a node that refers to or is assigned to the given access path.
   *
   * See `getAReferenceTo` and `getAnAssignmentTo` for more details.
   */
  DataFlow::Node getAReferenceOrAssignmentTo(Root root, string path) {
    result = getAReferenceTo(root, path)
    or
    result = getAnAssignmentTo(root, path)
  }

  /**
   * Holds if there is a step from `pred` to `succ` through an assignment to an access path.
   */
  pragma[inline]
  predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(string name, Root root |
      pred = getAnAssignmentTo(root, name) and
      succ = getAReferenceTo(root, name)
    )
    or
    exists(string name |
      pred = getAnAssignmentTo(name) and
      succ = getAReferenceTo(name) and
      isAssignedInUniqueFile(name)
    )
  }

  /**
   * Gets a `SourceNode` that refers to the same value or access path as the given node.
   */
  pragma[inline]
  DataFlow::SourceNode getAnAliasedSourceNode(DataFlow::Node node) {
    exists(DataFlow::SourceNode root, string accessPath |
      node = AccessPath::getAReferenceTo(root, accessPath) and
      result = AccessPath::getAReferenceTo(root, accessPath)
    )
    or
    result = node.getALocalSource()
  }

  /**
   * A module for reasoning dominating reads and writes to access-paths.
   */
  module DominatingPaths {
    /**
     * A classification of acccess paths into reads and writes.
     */
    cached
    private newtype AccessPathKind =
      AccessPathRead() or
      AccessPathWrite()

    /**
     * Gets the `ranking`th access-path with `root` and `path` within `bb`.
     * And the access-path has type `type`.
     *
     * Only has a result if there exists both a read and write of the access-path within `bb`.
     */
    private ControlFlowNode rankedAccessPath(
      ReachableBasicBlock bb, Root root, string path, int ranking, AccessPathKind type
    ) {
      result =
        rank[ranking](ControlFlowNode ref |
          ref = getAccessTo(root, path, _) and
          ref.getBasicBlock() = bb and
          // Prunes the accesses where there does not exists a read and write within the same basicblock.
          // This could be more precise, but doing it like this avoids massive joins.
          hasRead(bb) and
          hasWrite(bb)
        |
          ref order by any(int i | ref = bb.getNode(i))
        ) and
      result = getAccessTo(root, path, type)
    }

    /**
     * Holds if there exists an access-path read inside the basic-block `bb`.
     *
     * INTERNAL: This predicate is only meant to be used inside `rankedAccessPath`.
     */
    pragma[noinline]
    private predicate hasRead(ReachableBasicBlock bb) {
      bb = getAccessTo(_, _, AccessPathRead()).getBasicBlock()
    }

    /**
     * Holds if there exists an access-path write inside the basic-block `bb`.
     *
     * INTERNAL: This predicate is only meant to be used inside `rankedAccessPath`.
     */
    pragma[noinline]
    private predicate hasWrite(ReachableBasicBlock bb) {
      bb = getAccessTo(_, _, AccessPathRead()).getBasicBlock()
    }

    /**
     * Gets a `ControlFlowNode` for an access to `path` from `root` with type `type`.
     *
     * This predicate uses both the AccessPath API, and the SourceNode API.
     * This ensures that we have basic support for access-paths with ambiguous roots.
     *
     * There is only a result if both a read and a write of the access-path exists.
     */
    pragma[nomagic]
    private ControlFlowNode getAccessTo(Root root, string path, AccessPathKind type) {
      exists(getAReadNode(root, path)) and
      exists(getAWriteNode(root, path)) and
      (
        type = AccessPathRead() and
        result = getAReadNode(root, path)
        or
        type = AccessPathWrite() and
        result = getAWriteNode(root, path)
      )
    }

    /**
     * Gets a `ControlFlowNode` for a read to `path` from `root`.
     *
     * Only used within `getAccessTo`.
     */
    private ControlFlowNode getAReadNode(Root root, string path) {
      exists(DataFlow::PropRead read | read.asExpr() = result |
        path = fromReference(read, root) or
        read = root.getAPropertyRead(path)
      )
    }

    /**
     * Gets a `ControlFlowNode` for a write to `path` from `root`.
     *
     * Only used within `getAccessTo`.
     */
    private ControlFlowNode getAWriteNode(Root root, string path) {
      result = root.getAPropertyWrite(path).getWriteNode()
      or
      exists(DataFlow::PropWrite write | path = fromRhs(write.getRhs(), root) |
        result = write.getWriteNode()
      )
    }

    /**
     * Gets a basic-block where the access path defined by `root` and `path` is written to.
     * And a read to the same access path exists.
     */
    private ReachableBasicBlock getAWriteBlock(Root root, string path) {
      result = getAccessTo(root, path, AccessPathWrite()).getBasicBlock() and
      exists(getAccessTo(root, path, AccessPathRead())) // helps performance
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * Holds for `read` if there exists a previous write to the same access-path that dominates this read.
     */
    cached
    predicate hasDominatingWrite(DataFlow::PropRead read) {
      // within the same basic block.
      exists(ReachableBasicBlock bb, Root root, string path, int ranking |
        read.asExpr() = rankedAccessPath(bb, root, path, ranking, AccessPathRead()) and
        exists(rankedAccessPath(bb, root, path, any(int prev | prev < ranking), AccessPathWrite()))
      )
      or
      // across basic blocks.
      exists(Root root, string path |
        read.asExpr() = getAccessTo(root, path, AccessPathRead()) and
        getAWriteBlock(root, path).strictlyDominates(read.getBasicBlock())
      )
    }
  }
}
