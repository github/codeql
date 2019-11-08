/**
 * Provides QL classes for indicating data flow through a function parameter, return value,
 * or receiver.
 */

import go

/**
 * An abstract representation of an input to a function, which is either a parameter
 * or the receiver parameter.
 */
private newtype TFunctionInput =
  TInParameter(int i) { exists(SignatureType s | exists(s.getParameterType(i))) }
  or
  TInReceiver()

/**
 * An abstract representation of an input to a function, which is either a parameter
 * or the receiver parameter.
 */
class FunctionInput extends TFunctionInput {
  /** Holds if this represents the `i`th parameter of a function. */
  predicate isParameter(int i) {
    none()
  }

  /** Holds if this represents the receiver of a function. */
  predicate isReceiver() {
    none()
  }

  /** Gets the data-flow node corresponding to this input for the call `c`. */
  final DataFlow::Node getNode(DataFlow::CallNode c) { result = getEntryNode(c) }

  /** Gets the data-flow node through which data is passed into this input for the call `c`. */
  abstract DataFlow::Node getEntryNode(DataFlow::CallNode c);

  /** Gets the data-flow node through which data from this input enters function `f`. */
  abstract DataFlow::Node getExitNode(FuncDef f);

  /** Gets a textual representation of this element. */
  abstract string toString();
}

/** A parameter position of a function, viewed as a source of input. */
private class ParameterInput extends FunctionInput, TInParameter {
  int index;

  ParameterInput() {
    this = TInParameter(index)
  }

  override predicate isParameter(int i) {
    i = index
  }

  override DataFlow::Node getEntryNode(DataFlow::CallNode c) {
    result = c.getArgument(index)
  }

  override DataFlow::Node getExitNode(FuncDef f) {
    result = DataFlow::parameterNode(f.getParameter(index))
  }

  override string toString() {
    result = "parameter " + index
  }
}

/** The receiver of a function, viewed as a source of input. */
private class ReceiverInput extends FunctionInput, TInReceiver {
  override predicate isReceiver() {
    any()
  }

  override DataFlow::Node getEntryNode(DataFlow::CallNode c) {
    result = c.(DataFlow::MethodCallNode).getReceiver()
  }

  override DataFlow::Node getExitNode(FuncDef f) {
    result = DataFlow::receiverNode(f.(MethodDecl).getReceiver())
  }

  override string toString() {
    result = "receiver"
  }
}

/**
 * An abstract representation of an output of a function, which is one of its results.
 */
private newtype TFunctionOutput =
  TOutResult(int index) {
    // the one and only result
    index = -1
    or
    // one among several results
    exists(SignatureType s | exists(s.getResultType(index)))
  }

/**
 * An abstract representation of an output of a function, which is one of its results.
 */
class FunctionOutput extends TFunctionOutput {
  /** Holds if this represents the (single) result of a function. */
  predicate isResult() {
    none()
  }

  /** Holds if this represents the `i`th result of a function. */
  predicate isResult(int i) {
    none()
  }

  /** Gets the data-flow node corresponding to this output for the call `c`. */
  final DataFlow::Node getNode(DataFlow::CallNode c) { result = getExitNode(c) }

  /** Gets the data-flow node through which data is passed into this output for the function `f`. */
  abstract DataFlow::Node getEntryNode(FuncDef f);

  /** Gets the data-flow node through which data is returned from this output for the call `c`. */
  abstract DataFlow::Node getExitNode(DataFlow::CallNode c);

  /** Gets a textual representation of this element. */
  abstract string toString();
}

/** A result position of a function, viewed as an output. */
private class OutResult extends FunctionOutput, TOutResult {
  int index;

  OutResult() {
    this = TOutResult(index)
  }

  override predicate isResult() {
    index = -1
  }

  override predicate isResult(int i) {
    i = index and i >= 0
  }

  override DataFlow::Node getEntryNode(FuncDef f) {
    // return expressions
    exists(IR::ReturnInstruction ret | f = ret.getRoot() |
      index = -1 and
      result = DataFlow::instructionNode(ret.getResult())
      or
      index >= 0 and
      ret.returnsMultipleResults() and
      result = DataFlow::instructionNode(ret.getResult(index))
    )
    or
    // expressions assigned to result variables
    exists(Write w, int nr | nr = f.getType().getNumResult() |
      index = -1 and
      nr = 1 and
      w.writes(f.getResultVar(0), result)
      or
      index >= 0 and
      nr > 1 and
      w.writes(f.getResultVar(index), result)
    )
  }

  override DataFlow::Node getExitNode(DataFlow::CallNode c) {
    index = -1 and result = c.getResult()
    or
    result = c.getResult(index)
  }

  override string toString() {
    index = -1 and result = "result"
    or
    index >= 0 and result = "result " + index
  }
}
