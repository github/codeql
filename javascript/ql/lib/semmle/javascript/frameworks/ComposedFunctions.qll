/**
 * Provides classes for reasoning about composed functions.
 */

import javascript

/**
 * A call to a function that constructs a function composition `f(g(h(...)))` from a
 * series of functions `f, g, h, ...`.
 */
class FunctionCompositionCall extends DataFlow::CallNode instanceof FunctionCompositionCall::Range {
  /**
   * Gets the `i`th function in the composition `f(g(h(...)))`, counting from left to right.
   *
   * Note that this is the opposite of the order in which the function are invoked,
   * that is, `g` occurs later than `f` in `f(g(...))` but is invoked before `f`.
   */
  DataFlow::Node getOperandNode(int i) { result = super.getOperandNode(i) }

  /** Gets a node holding one of the functions to be composed. */
  final DataFlow::Node getAnOperandNode() { result = this.getOperandNode(_) }

  /**
   * Gets the function flowing into the `i`th function in the composition `f(g(h(...)))`.
   *
   * Note that this is the opposite of the order in which the function are invoked,
   * that is, `g` occurs later than `f` in `f(g(...))` but is invoked before `f`.
   */
  final DataFlow::FunctionNode getOperandFunction(int i) {
    result = this.getOperandNode(i).getALocalSource()
  }

  /** Gets any of the functions being composed. */
  final DataFlow::FunctionNode getAnOperandFunction() { result = this.getOperandFunction(_) }

  /** Gets the number of functions being composed. */
  int getNumOperand() { result = super.getNumOperand() }
}

/**
 * Companion module to the `FunctionCompositionCall` class.
 */
module FunctionCompositionCall {
  /**
   * Class that determines the set of values in `FunctionCompositionCall`.
   *
   * May be subclassed to classify more calls as function compositions.
   */
  abstract class Range extends DataFlow::CallNode {
    /**
     * Gets the function flowing into the `i`th function in the composition `f(g(h(...)))`.
     */
    abstract DataFlow::Node getOperandNode(int i);

    /** Gets the number of functions being composed. */
    abstract int getNumOperand();
  }

  /**
   * A function composition call that accepts its operands in an array or
   * via the arguments list.
   *
   * For simplicity, we model every composition function as if it supported this.
   */
  abstract private class WithArrayOverloading extends Range {
    /** Gets the `i`th argument to the call or the `i`th array element passed into the call. */
    DataFlow::Node getEffectiveArgument(int i) {
      result = this.getArgument(0).(DataFlow::ArrayCreationNode).getElement(i)
      or
      not this.getArgument(0) instanceof DataFlow::ArrayCreationNode and
      result = this.getArgument(i)
    }

    override int getNumOperand() {
      result = this.getArgument(0).(DataFlow::ArrayCreationNode).getSize()
      or
      not this.getArgument(0) instanceof DataFlow::ArrayCreationNode and
      result = this.getNumArgument()
    }
  }

  /** A call whose arguments are functions `f,g,h` which are composed into `f(g(h(...))` */
  private class RightToLeft extends WithArrayOverloading {
    RightToLeft() {
      this = DataFlow::moduleImport("compose-function").getACall()
      or
      this =
        DataFlow::moduleMember(["redux", "ramda", "@reduxjs/toolkit", "recompose"], "compose")
            .getACall()
      or
      this = LodashUnderscore::member("flowRight").getACall()
    }

    override DataFlow::Node getOperandNode(int i) { result = this.getEffectiveArgument(i) }
  }

  /** A call whose arguments are functions `f,g,h` which are composed into `h(g(f(...))` */
  private class LeftToRight extends WithArrayOverloading {
    LeftToRight() {
      this = DataFlow::moduleImport("just-compose").getACall()
      or
      this = LodashUnderscore::member("flow").getACall()
    }

    override DataFlow::Node getOperandNode(int i) {
      result = this.getEffectiveArgument(this.getNumOperand() - i - 1)
    }
  }
}

private class ComposedFunctionTaintStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      int fnIndex, DataFlow::FunctionNode fn, FunctionCompositionCall composed,
      DataFlow::CallNode call
    |
      fn = composed.getOperandFunction(fnIndex) and
      call = composed.getACall()
    |
      // flow into the first function
      fnIndex = composed.getNumOperand() - 1 and
      exists(int callArgIndex |
        pred = call.getArgument(callArgIndex) and
        succ = fn.getParameter(callArgIndex)
      )
      or
      // flow through the composed functions
      exists(DataFlow::FunctionNode predFn | predFn = composed.getOperandFunction(fnIndex + 1) |
        pred = predFn.getReturnNode() and
        succ = fn.getParameter(0)
      )
      or
      // flow out of the composed call
      fnIndex = 0 and
      pred = fn.getReturnNode() and
      succ = call
    )
  }
}
