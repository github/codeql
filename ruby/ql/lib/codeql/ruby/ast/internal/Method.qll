private import codeql.ruby.AST
private import AST
private import TreeSitter

/**
 * A synthesized block, such as the block synthesized from the body of
 * a `for` loop.
 */
class SynthBlock extends Block, TBlockSynth {
  SynthBlock() { this = TBlockSynth(_, _) }

  final override Parameter getParameter(int n) { synthChild(this, n, result) }

  final override Stmt getStmt(int i) {
    i >= 0 and
    synthChild(this, i + this.getNumberOfParameters(), result)
  }

  final override string toString() { result = "{ ... }" }
}
