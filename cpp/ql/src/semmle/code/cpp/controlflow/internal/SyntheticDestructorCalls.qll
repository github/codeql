/**
 * Provides classes and predicates for approximating where compiler-generated
 * destructor calls should be placed. This file can be removed when the
 * extractor produces this information directly.
 */
private import cpp

private predicate isDeleteDestructorCall(DestructorCall c) {
  exists(DeleteExpr del | c = del.getDestructorCall())
  or
  exists(DeleteArrayExpr del | c = del.getDestructorCall())
}

// Things we know about these calls
// - isCompilerGenerated() always holds
// - They all have a predecessor of type VariableAccess
// - They all have successors
// - After subtracting all the jumpy dtor calls for a particular variable
//   (PrematureScopeExitNode), there's at most one call left, and that will be
//   the ordinary one.
//   - Except for ConditionDeclExpr! One chain should be directly connected to
//     the false edge out of the parent, and the other should not.
class SyntheticDestructorCall extends FunctionCall {
  SyntheticDestructorCall() {
    (
      this instanceof DestructorCall
      or
      // Workaround for CPP-320
      exists(Function target |
        target = this.(FunctionCall).getTarget() and
        not exists(target.getName())
      )
    ) and
    not synthetic_destructor_call(_, _, this) and
    not exists(this.getParent()) and
    not isDeleteDestructorCall(this) and
    not this.isUnevaluated() and
    this.isCompilerGenerated()
  }

  VariableAccess getAccess() { successors(result, this) }

  SyntheticDestructorCall getNext() { successors(this, result.getAccess()) }

  SyntheticDestructorCall getPrev() { this = result.getNext() }
}

// Things we know about these blocks
// - If they follow a JumpStmt, the VariableAccesses of their calls never
//   have multiple predecessors.
//   - But after ReturnStmt, that may happen.
/**
 * Describes a straight line of `SyntheticDestructorCall`s. Note that such
 * lines can share tails.
 */
private class SyntheticDestructorBlock extends ControlFlowNodeBase {
  SyntheticDestructorBlock() {
    this = any(SyntheticDestructorCall call |
        not exists(call.getPrev())
        or
        exists(ControlFlowNodeBase pred |
          not pred instanceof SyntheticDestructorCall and
          successors(pred, call.getAccess())
        )
      )
  }

  SyntheticDestructorCall getCall(int i) {
    i = 0 and result = this
    or
    result = this.getCall(i - 1).getNext()
  }

  ControlFlowNode getAPredecessor() {
    successors(result, this.(SyntheticDestructorCall).getAccess()) and
    not result instanceof SyntheticDestructorCall
  }

  ControlFlowNode getSuccessor() {
    successors(this.getCall(max(int i | exists(this.getCall(i)))), result)
  }
}

private class PrematureScopeExitNode extends ControlFlowNodeBase {
  PrematureScopeExitNode() {
    this instanceof JumpStmt
    or
    this instanceof Handler
    or
    this instanceof ThrowExpr
    or
    this instanceof ReturnStmt
    or
    this instanceof MicrosoftTryExceptStmt
    or
    // Detecting exception edges out of a MicrosoftTryFinallyStmt is not
    // implemented. It may not be easy to do. It'll be something like finding
    // the first synthetic destructor call that crosses out of the scope of the
    // statement and does not belong to some other `PrematureScopeExitNode`.
    // Note that the exception destructors after __try can follow right after
    // ordinary cleanup from the __finally block.
    this instanceof MicrosoftTryFinallyStmt
  }

  SyntheticDestructorBlock getSyntheticDestructorBlock() {
    result.getAPredecessor() = this
    or
    // StmtExpr not handled properly here.
    result.getAPredecessor().(Expr).getParent+() = this.(ReturnStmt)
    or
    // Only handles post-order conditions. Won't work with
    // short-circuiting operators.
    falsecond_base(this.(MicrosoftTryExceptStmt).getCondition(),
      result.(SyntheticDestructorCall).getAccess())
  }
}

private class DestructedVariable extends LocalScopeVariable {
  DestructedVariable() {
    exists(SyntheticDestructorCall call | call.getAccess().getTarget() = this)
  }

  /**
   * Gets the single destructor call that that corresponds to falling off the
   * end of the scope of this variable.
   */
  SyntheticDestructorCall getOrdinaryCall() {
    exists(SyntheticDestructorBlock block |
      block.getCall(_) = result and
      not exists(PrematureScopeExitNode exit | exit.getSyntheticDestructorBlock() = block) and
      result.getAccess().getTarget() = this
    |
      falsecond_base(getDeclaringLoop().getCondition(), block.getCall(0).getAccess())
      or
      not exists(this.getDeclaringLoop())
    )
  }

  predicate hasPositionInScope(int x, int y, Stmt scope) {
    exists(DeclStmt declStmt |
      this = declStmt.getDeclaration(y) and
      declStmt = scope.getChild(x)
    )
    or
    exists(ConditionDeclExpr decl |
      this = decl.getVariable() and
      // These coordinates are chosen to place the destruction correctly
      // relative to the destruction of other variables declared in
      // `decl.getParent()`. Only a `for` loop can have other declarations in
      // it. These show up as a `DeclStmt` with `x = 0`, so by choosing `x = 1`
      // here we get the `ConditionDeclExpr` placed after all variables
      // declared in the init statement of the `for` loop.
      x = 1 and
      y = 0 and
      scope = decl.getParent()
    )
    or
    exists(CatchBlock cb |
      this = cb.getParameter() and
      scope = cb and
      // A `CatchBlock` is a `Block`, so there might be other variables
      // declared in it. These coordinates are chosen to place the Parameter
      // before any such declarations.
      x = -1 and
      y = 0
    )
  }

  SyntheticDestructorCall getInnerScopeCall() {
    exists(SyntheticDestructorBlock block |
      block.getCall(_) = result and
      not exists(PrematureScopeExitNode exit | exit.getSyntheticDestructorBlock() = block) and
      result.getAccess().getTarget() = this
    |
      exists(Loop loop | loop = this.getDeclaringLoop() |
        not falsecond_base(loop.getCondition(), block.getCall(0).getAccess())
      )
    )
  }

  predicate hasPositionInInnerScope(int x, int y, ControlFlowNodeBase scope) {
    exists(ConditionDeclExpr decl |
      this = decl.getVariable() and
      // These coordinates are chosen to place the destruction correctly
      // relative to the destruction of other variables in `scope`. Only in the
      // `while` case can there be other variables in `scope`, and in that case
      // `scope` will be a `Block`, whose smallest `x` coordinate can be 0.
      x = -1 and
      y = 0 and
      (
        scope = decl.getParent().(ForStmt).getUpdate()
        or
        scope = decl.getParent().(WhileStmt).getStmt()
      )
    )
  }

  private Loop getDeclaringLoop() {
    exists(ConditionDeclExpr decl | this = decl.getVariable() and result = decl.getParent())
  }
}

/**
 * Gets the `index`'th synthetic destructor call that should follow `node`. The
 * exact placement of that call in the CFG depends on the type of `node` as
 * follows:
 *
 * - `Block`: after ordinary control flow falls off the end of the block
 *   without jumps or exceptions.
 * - `ReturnStmt`: After the statement itself or after its operand (if
 *   present).
 * - `ThrowExpr`: After the `throw` expression or after its operand (if
 *   present).
 * - `JumpStmt` (`BreakStmt`, `ContinueStmt`, `GotoStmt`): after the statement.
 * - A `ForStmt`, `WhileStmt`, `SwitchStmt`, or `IfStmt`: after control flow
 *   falls off the end of the statement without jumping. Destruction can occur
 *   here for `for`-loops that have an initializer (`for (C x = a; ...; ...)`)
 *   and for statements whose condition is a `ConditionDeclExpr`
 *   (`if (C x = a)`).
 * - The `getUpdate()` of a `ForStmt`: after the `getUpdate()` expression. This
 *   can happen when the condition is a `ConditionDeclExpr`
 * - `Handler`: On the edge out of the `Handler` for the case where the
 *   exception was not matched and is propagated to the next handler or
 *   function exit point.
 * - `MicrosoftTryExceptStmt`: After the false-edge out of the `e` in
 *   `__except(e)`, before propagating the exception up to the next handler or
 *   function exit point.
 * - `MicrosoftTryFinallyStmt`: On the edge following the `__finally` block for
 *   the case where an exception was thrown and needs to be propagated.
 */
SyntheticDestructorCall getDestructorCallAfterNode(ControlFlowNodeBase node, int index) {
  result = rank[index + 1](SyntheticDestructorCall call, DestructedVariable var, int x, int y |
      call = var.getOrdinaryCall() and
      var.hasPositionInScope(x, y, node)
      or
      call = var.getInnerScopeCall() and
      var.hasPositionInInnerScope(x, y, node)
    |
      call
      order by
        x desc, y desc
    )
  or
  exists(SyntheticDestructorBlock block |
    node.(PrematureScopeExitNode).getSyntheticDestructorBlock() = block and
    result = block.getCall(index)
  )
}
