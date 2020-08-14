import python

module MagicMethod {
  abstract class Potential extends ControlFlowNode {
    abstract string getMagicMethodName();
    abstract ControlFlowNode getArg(int n);
    ControlFlowNode getSelf() { result = this.getArg(0) }
  }

  class Actual extends ControlFlowNode {
    Value resolvedMagicMethod;

    Actual() {
      exists(Potential pot |
        this.(Potential) = pot and
        pot.getSelf().pointsTo().getClass().lookup(pot.getMagicMethodName()) = resolvedMagicMethod
      )
    }

    Value getResolvedMagicMethod() { result = resolvedMagicMethod }
  }
}

class MagicBinOp extends MagicMethod::Potential, BinaryExprNode {
  Operator operator;

  MagicBinOp() { this.getOp() = operator}

  override string getMagicMethodName() {
    result = operator.getSpecialMethodName()
  }

  override ControlFlowNode getArg(int n) {
    n = 0 and result = this.getLeft()
    or
    n = 1 and result = this.getRight()
  }
}
