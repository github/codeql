private import codeql.ruby.AST
private import AST
private import TreeSitter

module Parameter {
  class Range extends Ruby::AstNode {
    private int pos;

    Range() {
      this = any(Ruby::BlockParameters bp).getChild(pos)
      or
      this = any(Ruby::MethodParameters mp).getChild(pos)
      or
      this = any(Ruby::LambdaParameters lp).getChild(pos)
    }

    int getPosition() { result = pos }
  }
}
