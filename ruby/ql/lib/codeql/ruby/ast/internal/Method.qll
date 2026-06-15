overlay[local]
module;

private import codeql.ruby.AST
private import AST
private import TreeSitter

class BraceBlockReal extends BraceBlock, TBraceBlockReal {
  private Ruby::Block g;

  BraceBlockReal() { this = TBraceBlockReal(g) }

  final override LocalVariableWriteAccess getLocalVariable(int n) {
    toGenerated(result) = g.getParameters().getLocals(n)
  }

  final override Parameter getParameter(int n) {
    toGenerated(result) = g.getParameters().getChild(n)
  }

  final override BodyStmt getBody() { toGenerated(result) = g.getBody() }
}

/**
 * A synthesized block, such as the block synthesized from the body of
 * a `for` loop.
 */
class BraceBlockSynth extends BraceBlock, TBraceBlockSynth {
  final override Parameter getParameter(int n) { synthChild(this, n, result) }

  final override BodyStmt getBody() { synthChild(this, _, result) }
}
