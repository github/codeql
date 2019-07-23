/**
 * Provides predicates for associating qualified names with data flow nodes.
 */
import javascript

module GlobalAccessPath {
  /**
   * A local variable with exactly one definition, not counting implicit initialization.
   */
  private class EffectivelyConstantVariable extends LocalVariable {
    EffectivelyConstantVariable() {
      strictcount(SsaExplicitDefinition ssa | ssa.getSourceVariable() = this) = 1
    }

    /** Gets the SSA definition of this variable. */
    SsaExplicitDefinition getSsaDefinition() {
      result.getSourceVariable() = this
    }

    /** Gets the data flow node representing the value of this variable, if one exists. */
    DataFlow::Node getValue() {
      result = getSsaDefinition().getRhsNode()
    }
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
  string fromReference(DataFlow::Node node) {
    result = fromReference(node.getImmediatePredecessor())
    or
    exists(EffectivelyConstantVariable var |
      var.isCaptured() and
      node.asExpr() = var.getAnAccess() and
      result = fromReference(var.getValue())
    )
    or
    node.accessesGlobal(result) and
    result != "undefined"
    or
    not node.accessesGlobal(_) and
    exists(DataFlow::PropRead prop | node = prop |
      result = fromReference(prop.getBase()) + "." + prop.getPropertyName()
    )
    or
    exists(Closure::ClosureNamespaceAccess acc | node = acc |
      result = acc.getClosureNamespace()
    )
    or
    exists(DataFlow::PropertyProjection proj | node = proj |
      proj.isSingletonProjection() and
      result = fromReference(proj.getObject()) + "." + proj.getASelector()
    )
    or
    // Treat 'e || {}' as having the same name as 'e'
    exists(LogOrExpr e | node.asExpr() = e |
      e.getRightOperand().(ObjectExpr).getNumProperty() = 0 and
      result = fromReference(e.getLeftOperand().flow())
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
      result = fromReference(rhs.flow())
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
    fromRhs(rhs) = fromReference(rhs)
  }

  /**
   * Holds if there is an assignment to `accessPath` in `file`, not counting
   * self-assignments.
   */
  private predicate isAssignedInFile(string accessPath, File file) {
    exists(DataFlow::Node rhs |
      fromRhs(rhs) = accessPath and
      not isSelfAssignment(rhs) and
      // Note: Avoid unneeded materialization of DataFlow::Node.getFile()
      rhs.getAstNode().getFile() = file
    )
  }

  /**
   * Holds if `accessPath` is only assigned to from one file, not counting
   * self-assignments.
   */
  predicate isAssignedInUniqueFile(string accessPath) {
    strictcount(File f | isAssignedInFile(accessPath, f)) = 1
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
  string fromRhs(DataFlow::Node node) {
    exists(DataFlow::SourceNode base, string baseName, string name |
      node = base.getAPropertyWrite(name).getRhs() and
      result = baseName + "." + name
    |
      baseName = fromReference(base)
      or
      baseName = fromRhs(base)
    )
    or
    exists(AssignExpr assign |
      node = assign.getRhs().flow() and
      result = assign.getLhs().(GlobalVarAccess).getName()
    )
    or
    exists(FunctionDeclStmt fun |
      node = DataFlow::valueNode(fun) and
      result = fun.getId().(GlobalVarDecl).getName()
    )
    or
    exists(ClassDeclStmt cls |
      node = DataFlow::valueNode(cls) and
      result = cls.getIdentifier().(GlobalVarDecl).getName()
    )
  }

  /**
   * Gets the global access path referenced by or assigned to `node`.
   */
  string getAccessPath(DataFlow::Node node) {
    result = fromReference(node)
    or
    not exists(fromReference(node)) and
    result = fromRhs(node)
  }
}
