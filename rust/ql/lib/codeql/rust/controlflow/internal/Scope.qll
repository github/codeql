private import rust
private import Completion
private import codeql.rust.generated.ParentChild

abstract class CfgScope extends AstNode { }

class FunctionScope extends CfgScope, Function { }

/**
 * Gets the immediate parent of a non-`AstNode` element `e`.
 *
 * We restrict `e` to be a non-`AstNode` to skip past non-`AstNode` in
 * the transitive closure computation in `getParentOfAst`. This is
 * necessary because the parent of an `AstNode` is not necessarily an `AstNode`.
 */
private Element getParentOfAstStep(Element e) {
  not e instanceof AstNode and
  result = getImmediateParent(e)
}

/** Gets the nearest enclosing parent of `ast` that is an `AstNode`. */
private AstNode getParentOfAst(AstNode ast) {
  result = getParentOfAstStep*(getImmediateParent(ast))
}

/** Gets the enclosing scope of a node */
cached
AstNode scopeOfAst(AstNode n) {
  exists(AstNode p | p = getParentOfAst(n) |
    if p instanceof CfgScope then p = result else result = scopeOfAst(p)
  )
}
