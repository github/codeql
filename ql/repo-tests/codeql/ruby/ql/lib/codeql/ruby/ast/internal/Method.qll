private import codeql.ruby.AST
private import AST
private import TreeSitter

class BraceBlockReal extends BraceBlock, TBraceBlockReal {
  private Ruby::Block g;

  BraceBlockReal() { this = TBraceBlockReal(g) }

  final override Parameter getParameter(int n) {
    toGenerated(result) = g.getParameters().getChild(n)
  }

  final override Stmt getStmt(int i) { toGenerated(result) = g.getChild(i) }
}

/**
 * A synthesized block, such as the block synthesized from the body of
 * a `for` loop.
 */
class BraceBlockSynth extends BraceBlock, TBraceBlockSynth {
  final override Parameter getParameter(int n) { synthChild(this, n, result) }

  final override Stmt getStmt(int i) {
    i >= 0 and
    synthChild(this, i + this.getNumberOfParameters(), result)
  }
}
