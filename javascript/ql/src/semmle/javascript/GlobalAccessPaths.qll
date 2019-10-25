/**
 * Provides predicates for associating qualified names with data flow nodes.
 */

import javascript

module GlobalAccessPath {
  /**
   * A source node that can be the root of an access path.
   */
  private class Root extends DataFlow::SourceNode {
    Root() {
      not this.accessesGlobal(_) and
      not this instanceof DataFlow::PropRead and
      not this instanceof PropertyProjection and
      not this instanceof Closure::ClosureNamespaceAccess and
      not this = DataFlow::parameterNode(any(ImmediatelyInvokedFunctionExpr iife).getAParameter())
    }

    /** Holds if this represents the root of the global access path. */
    predicate isGlobal() {
      this = DataFlow::globalAccessPathRootPseudoNode()
    }
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
   * Gets the access path relative to `root` referred to by `node`.
   *
   * This holds for direct references as well as for aliases
   * established through local data flow.
   *
   * Examples:
   * ```
   * function f(x) {
   *   let a = x.f.g; // access path relative to 'x' is '.f.g'
   *   let b = a.h;   // access path relative to 'x' is '.f.g.h'
   * }
   * ```
   */
  cached
  string fromReference(DataFlow::Node node, Root root) {
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
      result = fromReference(prop.getBase(), root) + "." + prop.getPropertyName()
    )
    or
    exists(Closure::ClosureNamespaceAccess acc | node = acc |
      result = acc.getClosureNamespace() and
      root.isGlobal()
    )
    or
    exists(PropertyProjection proj | node = proj |
      proj.isSingletonProjection() and
      result = fromReference(proj.getObject(), root) + "." + proj.getASelector()
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
   * Gets the global access path referred to by `node`.
   *
   * This holds for direct references as well as for aliases
   * established through local data flow.
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
  cached
  string fromReference(DataFlow::Node node) {
    result = fromReference(node, DataFlow::globalAccessPathRootPseudoNode())
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
    fromRhs(rhs, DataFlow::globalAccessPathRootPseudoNode()) = fromReference(rhs, DataFlow::globalAccessPathRootPseudoNode())
  }

  /**
   * Holds if there is an assignment to `accessPath` in `file`, not counting
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
   * For example, the class nodes below all map to `.foo.bar` relative to `x`:
   * ```
   * function f(x) {
   *   x.foo.bar = class {};
   *   x.foo = { bar: class() };
   *   let alias = x;
   *   alias.foo.bar = class {};
   * }
   * ```
   */
  cached
  string fromRhs(DataFlow::Node node, Root root) {
    exists(DataFlow::SourceNode base, string baseName, string name |
      node = base.getAPropertyWrite(name).getRhs() and
      result = baseName + "." + name
    |
      baseName = fromReference(base, root)
      or
      baseName = fromRhs(base, root)
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
      result = fun.getId().(GlobalVarDecl).getName() and
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
      result = decl.getId().(GlobalVarDecl).getName() and
      root.isGlobal()
    )
  }

  /**
   * Gets the global access path `node` is being assigned to, if any.
   *
   * Only holds for the immediate right-hand side of an assignment or property, not
   * for nodes that transitively flow there.
   *
   * For example, the class nodes below all map to `foo.bar`:
   * ```
   * foo.bar = class {};
   *
   * foo = { bar: class {} };
   *
   * (function(f) {
   *   f.bar = class {}
   *  })(foo = foo || {});
   * ```
   */
  cached
  string fromRhs(DataFlow::Node node) {
    result = fromRhs(node, DataFlow::globalAccessPathRootPseudoNode())
  }

  /**
   * Gets the access path relative to `root` referenced by or assigned to `node`.
   */
  string getAccessPath(DataFlow::Node node, Root root) {
    result = fromReference(node, root)
    or
    not exists(fromReference(node, root)) and
    result = fromRhs(node, root)
  }

  /**
   * Gets the global access path referenced by or assigned to `node`.
   */
  string getAccessPath(DataFlow::Node node) {
    result = getAccessPath(node, DataFlow::globalAccessPathRootPseudoNode())
  }

  /**
   * Holds if there is a step from `pred` to `succ` through an assignment to an access path.
   */
  pragma[inline]
  predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(string name, Root root |
      name = fromRhs(pred, root) and
      name = fromReference(succ, root) and
      not root.isGlobal()
    )
    or
    exists(string name |
      name = fromRhs(pred) and
      name = fromReference(succ) and
      isAssignedInUniqueFile(name)
    )
  }
}
