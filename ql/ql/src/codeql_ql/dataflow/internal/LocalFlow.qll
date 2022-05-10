/**
 * Models local flow edges. Each equivalence class in the local flow relation becomes a super node.
 */

private import codeql_ql.dataflow.DataFlow
private import codeql_ql.ast.Ast
private import codeql_ql.ast.internal.AstNodeNumbering
private import NodesInternal
private import VarScoping
private import DataFlowNumbering

private module Cached {
  /**
   * Holds if `x` and `y` are bound by an equality (intra-predicate only).
   *
   * This edge has no orientation, and is used to construct the equivalence relation.
   * Each equivalence class becomes a `SuperNode`.
   */
  private predicate localEdge(Node x, Node y) {
    exists(AstNode a, AstNode b |
      x = astNode(a) and
      y = astNode(b)
    |
      // x ~ any(x)
      a = b.(Any).getExpr(0)
      or
      // v ~ any(T v)
      a = b.(Any).getArgument(0)
      or
      // x ~ x as VAR
      a = b.(AsExpr).getInnerExpr()
      or
      // x ~ x.(Type)
      a = b.(InlineCast).getBase()
      or
      // x = y ==> x ~ y
      exists(ComparisonFormula compare |
        compare.getOperator() = "=" and
        a = compare.getLeftOperand() and
        b = compare.getRightOperand()
      )
    )
    or
    // VarAccess -> ScopedVariable
    exists(VarDef var, VarAccess access, VarAccessOrDisjunct scope |
      isRefinement(var, access, scope) and
      x = astNode(access) and
      y = scopedVariable(var, scope)
    )
    or
    // VarAccess -> VarDef  (if no refinement exists)
    exists(VarDef var, VarAccess access |
      isRefinement(var, access, getVarDefScope(var)) and
      x = astNode(access) and
      y = astNode(var)
    )
    or
    // result ~ enclosing 'result' node
    x = resultNode(y.(AstNodeNode).getAstNode().(ResultAccess).getEnclosingPredicate())
    or
    // this ~ enclosing 'this' node
    x = thisNode(y.(AstNodeNode).getAstNode().(ThisAccess).getEnclosingPredicate())
    or
    // f ~ enclosing field node for 'f'
    exists(FieldAccess access |
      x = astNode(access) and
      y = fieldNode(access.getEnclosingPredicate(), access.getDeclaration())
    )
    or
    // field declaration ~ field node in the charpred
    exists(FieldDecl field, Class cls |
      cls.getAField() = field and
      x = astNode(field.getVarDecl()) and
      y = fieldNode(cls.getCharPred(), field)
    )
  }

  /** Like `localEdge` but the parameters are mapped to their internal ID. */
  private predicate rawLocalEdge(int x, int y) {
    exists(Node a, Node b |
      localEdge(a, b) and
      x = getInternalId(a) and
      y = getInternalId(b)
    )
    or
    // Ensure a representative is generated for singleton components
    x = getInternalId(_) and
    y = x
  }

  /** Gets the representative for the equivalence class containing the node with ID `x`. */
  private int getRawRepr(int x) = equivalenceRelation(rawLocalEdge/2)(x, result)

  /** Gets the ID for the equivalence class containing `node`. */
  cached
  int getRepr(Node node) { result = getRawRepr(getInternalId(node)) }

  cached
  newtype TSuperNode = MkSuperNode(int repr) { repr = getRepr(_) }
}

import Cached
