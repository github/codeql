/**
 * Provides functionality for performing structural comparison of
 * expressions and statements.
 */

import csharp

private newtype TGvnKind =
  TGvnKindExpr(int kind) { expressions(_, kind, _) } or
  TGvnKindStmt(int kind) { statements(_, kind) } or
  TGvnKindDeclaration(GvnKindExpr kind, boolean thisTarget, Declaration d) {
    exists(Expr e |
      d = referenceAttribute(e) and thisTarget = isTargetThis(e) and kind = getKind(e)
    )
  }

abstract private class GvnKind extends TGvnKind {
  abstract string toString();
}

private class GvnKindExpr extends GvnKind, TGvnKindExpr {
  private int kind;

  GvnKindExpr() { this = TGvnKindExpr(kind) }

  override string toString() { result = "Expr(" + kind.toString() + ")" }
}

private class GvnKindStmt extends GvnKind, TGvnKindStmt {
  private int kind;

  GvnKindStmt() { this = TGvnKindStmt(kind) }

  override string toString() { result = "Stmt(" + kind.toString() + ")" }
}

private class GvnKindDeclaration extends GvnKind, TGvnKindDeclaration {
  private GvnKindExpr kind;
  private boolean isTargetThis;
  private Declaration d;

  GvnKindDeclaration() { this = TGvnKindDeclaration(kind, isTargetThis, d) }

  override string toString() { result = kind.toString() + "," + isTargetThis + "," + d.toString() }
}

/** Gets the declaration referenced by the expression `e`, if any. */
private Declaration referenceAttribute(Expr e) {
  result = e.(MethodCall).getTarget()
  or
  result = e.(ObjectCreation).getTarget()
  or
  result = e.(Access).getTarget()
}

/** Returns true iff the target of the expression `e` is `this`. */
private boolean isTargetThis(Expr e) {
  result = true and e.(MemberAccess).targetIsThisInstance()
  or
  result = false and not e.(MemberAccess).targetIsThisInstance()
}

/** Gets the AST node kind of element `cfe` wrapped in the GvnKind type. */
private GvnKind getKind(ControlFlowElement cfe) {
  exists(int kind |
    expressions(cfe, kind, _) and
    result = TGvnKindExpr(kind)
    or
    statements(cfe, kind) and
    result = TGvnKindStmt(kind)
  )
}

/**
 * Type for containing the global value number of a control flow element.
 * A global value number, can either be a constant or a list of global value numbers,
 * where the list also carries a `kind`, which is used to distinguish between general expressions,
 * declarations and statements.
 */
private newtype TGvn =
  TConstantGvn(string s) { s = any(Expr e).getValue() } or
  TListGvn(GvnList l)

/** The global value number of a control flow element. */
abstract class Gvn extends TGvn {
  /** Gets the string representation of this global value number. */
  abstract string toString();
}

private class ConstantGvn extends Gvn, TConstantGvn {
  override string toString() { this = TConstantGvn(result) }
}

private class ListGvn extends Gvn, TListGvn {
  private GvnList l;

  ListGvn() { this = TListGvn(l) }

  override string toString() { result = "[" + l.toString() + "]" }
}

/**
 * Type for containing a list of global value numbers with a kind.
 * The empty list carries the kind of the controlflowelement.
 */
private newtype TGvnList =
  TGvnNil(GvnKind gkind) or
  TGvnCons(Gvn head, GvnList tail) { gvnConstructedCons(_, _, _, head, tail) }

abstract private class GvnList extends TGvnList {
  abstract string toString();
}

private class GvnNil extends GvnList, TGvnNil {
  private GvnKind kind;

  GvnNil() { this = TGvnNil(kind) }

  override string toString() { result = "(kind:" + kind + ")" }
}

private class GvnCons extends GvnList, TGvnCons {
  private Gvn head;
  private GvnList tail;

  GvnCons() { this = TGvnCons(head, tail) }

  override string toString() { result = head.toString() + " :: " + tail.toString() }
}

private predicate gvnConstructedCons(
  ControlFlowElement e, GvnKind kind, int index, Gvn head, GvnList tail
) {
  none()
}
