/**
 * Provides support for magic methods.
 * This is done in two steps:
 *   - A subset of `ControlFlowNode`s are labelled as potentially corresponding to
 *     a magic method call (by being an instance of `MagicMethod::Potential`).
 *   - A subset of the potential magic method calls are labelled as being actual
 *     magic method calls (`MagicMethod::Actual`) if the appropriate method is defined.
 */

import python

/**
 * Machinery for detecting magic method calls.
 * Extend `MagicMethod::Potential` to capture more cases.
 */
module MagicMethod {
  /** A control flow node which might correpsond to a magic method call. */
  abstract class Potential extends ControlFlowNode {
    /** Gets the name of the method that would be called */
    abstract string getMagicMethodName();

    /** Gets the controlflow node that would be passed as the specified argument. */
    abstract ControlFlowNode getArg(int n);

    /** Gets the control flow node corresponding to the instance
     * that would define the magic method. */
    ControlFlowNode getSelf() { result = this.getArg(0) }
  }

  /** A control flow node corresponding to a magic method call. */
  class Actual extends ControlFlowNode {
    Value resolvedMagicMethod;

    Actual() {
      exists(Potential pot |
        this.(Potential) = pot and
        pot.getSelf().pointsTo().getClass().lookup(pot.getMagicMethodName()) = resolvedMagicMethod
      )
    }

    /** The method that is called. */
    Value getResolvedMagicMethod() { result = resolvedMagicMethod }
  }
}

/** A binary expression node that might correspond to a magic method call. */
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
