private import codeql_ruby.AST
private import AST
private import TreeSitter

module Parameter {
  class Range extends Generated::AstNode {
    private int pos;

    Range() {
      this = any(Generated::BlockParameters bp).getChild(pos)
      or
      this = any(Generated::MethodParameters mp).getChild(pos)
      or
      this = any(Generated::LambdaParameters lp).getChild(pos)
    }

    int getPosition() { result = pos }
  }
}
