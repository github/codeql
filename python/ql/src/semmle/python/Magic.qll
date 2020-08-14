import python

module MagicMethod {
  abstract class Potential extends ControlFlowNode {
    abstract string getMagicMethodName();
    abstract ControlFlowNode getArg(int n);
    ControlFlowNode getSelf() { result = this.getArg(1) }
  }

  class Actual extends ControlFlowNode {
    Object resolvedMagicMethod;

    Actual() {
      exists(Potential pot |
        this.(Potential) = pot and
        pot.getSelf().(ClassObject).lookupAttribute(pot.getMagicMethodName()) = resolvedMagicMethod
      )
    }
  }
}

class MagicBinOp extends MagicMethod::Potential, BinaryExprNode {
  Operator operator;

  MagicBinOp() { this.getOp() = operator}

  override string getMagicMethodName() {
    result = operator.getSpecialMethodName()
  }

  override ControlFlowNode getArg(int n) {
    n = 1 and result = this.getLeft()
    or
    n = 2 and result = this.getRight()
  }
}
