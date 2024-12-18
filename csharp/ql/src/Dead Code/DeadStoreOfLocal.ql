/**
 * @name Useless assignment to local variable
 * @description An assignment to a local variable that is not used later on, or whose value is always
 *              overwritten, has no effect.
 * @kind problem
 * @problem.severity warning
 * @id cs/useless-assignment-to-local
 * @tags maintainability
 *       external/cwe/cwe-563
 * @precision very-high
 */

import csharp

/**
 * Gets a callable that either directly captures local variable `v`, or which
 * is enclosed by the callable that declares `v` and encloses a callable that
 * captures `v`.
 */
Callable getACapturingCallableAncestor(LocalVariable v) {
  result = v.getACapturingCallable()
  or
  exists(Callable mid | mid = getACapturingCallableAncestor(v) |
    result = mid.getEnclosingCallable() and
    not v.getEnclosingCallable() = result
  )
}

Expr getADelegateExpr(Callable c) {
  c = result.(CallableAccess).getTarget()
  or
  result = c.(AnonymousFunctionExpr)
}

/**
 * Holds if `c` is a call where any delegate argument is evaluated immediately.
 */
predicate nonEscapingCall(Call c) {
  exists(string name | c.getTarget().hasName(name) |
    name =
      [
        "ForEach", "Count", "Any", "All", "Average", "Aggregate", "First", "Last", "FirstOrDefault",
        "LastOrDefault", "LongCount", "Max", "Single", "SingleOrDefault", "Sum"
      ]
  )
}

/**
 * Holds if `v` is a captured local variable, and one of the callables capturing
 * `v` may escape the local scope.
 */
predicate mayEscape(LocalVariable v) {
  exists(Callable c, Expr e, Expr succ | c = getACapturingCallableAncestor(v) |
    e = getADelegateExpr(c) and
    DataFlow::localExprFlow(e, succ) and
    not succ = any(DelegateCall dc).getExpr() and
    not succ = any(Cast cast).getExpr() and
    not succ = any(Call call | nonEscapingCall(call)).getAnArgument() and
    not succ = any(AssignableDefinition ad | ad.getTarget() instanceof LocalVariable).getSource()
  )
}

class RelevantDefinition extends AssignableDefinition {
  RelevantDefinition() {
    this.(AssignableDefinitions::AssignmentDefinition).getAssignment() =
      any(Assignment a | not a = any(UsingDeclStmt uds).getAVariableDeclExpr())
    or
    this instanceof AssignableDefinitions::MutationDefinition
    or
    this instanceof AssignableDefinitions::TupleAssignmentDefinition
    or
    // Discards in out assignments are only possible from C# 7 (2017), so we disable this case
    // for now
    //or
    //this.(AssignableDefinitions::OutRefDefinition).getTargetAccess().isOutArgument()
    this.(AssignableDefinitions::LocalVariableDefinition).getDeclaration() =
      any(LocalVariableDeclExpr lvde |
        lvde = any(SpecificCatchClause scc).getVariableDeclExpr()
        or
        lvde = any(ForeachStmt fs).getVariableDeclExpr() and
        not lvde.getName() = "_"
      )
    or
    this instanceof AssignableDefinitions::PatternDefinition
  }

  /** Holds if this assignment may be live. */
  private predicate isMaybeLive() {
    exists(LocalVariable v | v = this.getTarget() |
      // SSA definitions are only created for live variables
      this = any(Ssa::ExplicitDefinition ssaDef).getADefinition()
      or
      mayEscape(v)
      or
      v.isCaptured()
    )
  }

  /** Holds if this definition is a variable initializer, for example `string s = null`. */
  private predicate isInitializer() {
    this.getSource() = this.getTarget().(LocalVariable).getInitializer()
  }

  /**
   * Holds if this definition is a default-like variable initializer, for example
   * `string s = null` or `int i = 0`, but not `string s = "Hello"`.
   */
  private predicate isDefaultLikeInitializer() {
    this.isInitializer() and
    exists(Expr e | e = this.getSource().stripCasts() |
      e.getValue() = ["0", "-1", "", "false"]
      or
      e instanceof NullLiteral
      or
      e =
        any(Field f |
          f.isStatic() and
          (f.isReadOnly() or f.isConst())
        ).getAnAccess()
      or
      e instanceof DefaultValueExpr
      or
      e instanceof AnonymousObjectCreation
    )
  }

  /** Holds if this definition is dead and we want to report it. */
  predicate isDead() {
    // Ensure that the definition is not in dead code
    exists(this.getExpr().getAControlFlowNode()) and
    not this.isMaybeLive() and
    // Allow dead initializer assignments, such as `string s = string.Empty`, but only
    // if the initializer expression assigns a default-like value, and there exists another
    // definition of the same variable
    if this.isDefaultLikeInitializer()
    then this = unique(AssignableDefinition def | def.getTarget() = this.getTarget())
    else any()
  }
}

from RelevantDefinition def, LocalVariable v
where
  v = def.getTarget() and
  def.isDead()
select def, "This assignment to $@ is useless, since its value is never read.", v, v.getName()
