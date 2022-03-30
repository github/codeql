/**
 * Provides support for special methods.
 * This is done in two steps:
 *   - A subset of `ControlFlowNode`s are labelled as potentially corresponding to
 *     a special method call (by being an instance of `SpecialMethod::Potential`).
 *   - A subset of the potential special method calls are labelled as being actual
 *     special method calls (`SpecialMethodCallNode`) if the appropriate method is defined.
 * Extend `SpecialMethod::Potential` to capture more cases.
 */

import python

/** A control flow node which might correspond to a special method call. */
class PotentialSpecialMethodCallNode extends ControlFlowNode {
  PotentialSpecialMethodCallNode() { this instanceof SpecialMethod::Potential }
}

/**
 * Machinery for detecting special method calls.
 * Extend `SpecialMethod::Potential` to capture more cases.
 */
module SpecialMethod {
  /** A control flow node which might correspond to a special method call. */
  abstract class Potential extends ControlFlowNode {
    /** Gets the name of the method that would be called. */
    abstract string getSpecialMethodName();

    /** Gets the control flow node that would be passed as the specified argument. */
    abstract ControlFlowNode getArg(int n);

    /**
     * Gets the control flow node corresponding to the instance
     * that would define the special method.
     */
    ControlFlowNode getSelf() { result = this.getArg(0) }
  }

  /** A binary expression node that might correspond to a special method call. */
  class SpecialBinOp extends Potential, BinaryExprNode {
    Operator operator;

    SpecialBinOp() { this.getOp() = operator }

    override string getSpecialMethodName() { result = operator.getSpecialMethodName() }

    override ControlFlowNode getArg(int n) {
      n = 0 and result = this.getLeft()
      or
      n = 1 and result = this.getRight()
    }
  }

  /** A subscript expression node that might correspond to a special method call. */
  abstract class SpecialSubscript extends Potential, SubscriptNode {
    override ControlFlowNode getArg(int n) {
      n = 0 and result = this.getObject()
      or
      n = 1 and result = this.getIndex()
    }
  }

  /** A subscript expression node that might correspond to a call to __getitem__. */
  class SpecialGetItem extends SpecialSubscript {
    SpecialGetItem() { this.isLoad() }

    override string getSpecialMethodName() { result = "__getitem__" }
  }

  /** A subscript expression node that might correspond to a call to __setitem__. */
  class SpecialSetItem extends SpecialSubscript {
    SpecialSetItem() { this.isStore() }

    override string getSpecialMethodName() { result = "__setitem__" }

    override ControlFlowNode getArg(int n) {
      n = 0 and result = this.getObject()
      or
      n = 1 and result = this.getIndex()
      or
      n = 2 and result = this.getValueNode()
    }

    private ControlFlowNode getValueNode() {
      exists(AssignStmt a |
        a.getATarget() = this.getNode() and
        result.getNode() = a.getValue()
      )
      or
      exists(AugAssign a |
        a.getTarget() = this.getNode() and
        result.getNode() = a.getValue()
      )
    }
  }

  /** A subscript expression node that might correspond to a call to __delitem__. */
  class SpecialDelItem extends SpecialSubscript {
    SpecialDelItem() { this.isDelete() }

    override string getSpecialMethodName() { result = "__delitem__" }
  }
}

/** A control flow node corresponding to a special method call. */
class SpecialMethodCallNode extends PotentialSpecialMethodCallNode {
  Value resolvedSpecialMethod;

  SpecialMethodCallNode() {
    exists(SpecialMethod::Potential pot |
      this = pot and
      pot.getSelf().pointsTo().getClass().lookup(pot.getSpecialMethodName()) = resolvedSpecialMethod
    )
  }

  /** Gets the method that is called. */
  Value getResolvedSpecialMethod() { result = resolvedSpecialMethod }
}
