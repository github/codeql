private import rust

/**
 * A control flow graph (CFG) scope.
 */
final class CfgScope extends AstNode {
  CfgScope() {
    this instanceof AsyncBlockExpr
    or
    this.(Callable).hasBody() and
    this.fromSource()
    or
    this instanceof SourceFile
  }
}
