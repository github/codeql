private import codeql.ruby.AST
private import AST
private import TreeSitter
private import Variable

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

abstract class SimpleParameterImpl extends AstNode, TSimpleParameter {
  abstract LocalVariable getVariableImpl();

  abstract string getNameImpl();
}

class SimpleParameterRealImpl extends SimpleParameterImpl, TSimpleParameterReal {
  private Ruby::Identifier g;

  SimpleParameterRealImpl() { this = TSimpleParameterReal(g) }

  override LocalVariable getVariableImpl() { result = TLocalVariableReal(_, _, g) }

  override string getNameImpl() { result = g.getValue() }
}

class SimpleParameterSynthImpl extends SimpleParameterImpl, TSimpleParameterSynth {
  SimpleParameterSynthImpl() { this = TSimpleParameterSynth(_, _) }

  LocalVariableAccessSynth getDefininingAccess() { synthChild(this, 0, result) }

  override LocalVariable getVariableImpl() { result = TLocalVariableSynth(this, _) }

  override string getNameImpl() { result = this.getVariableImpl().getName() }
}

class DestructuredParameterImpl extends Ruby::DestructuredParameter {
  Ruby::AstNode getChildNode(int i) { result = this.getChild(i) }
}
