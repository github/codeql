/**
 * Provides QL classes for indicating data flow through a function parameter, return value,
 * or receiver.
 */

import go
private import semmle.go.dataflow.internal.DataFlowPrivate

/**
 * An abstract representation of an input to a function, which is either a parameter
 * or the receiver parameter.
 */
private newtype TFunctionInput =
  TInParameter(int i) { exists(SignatureType s | exists(s.getParameterType(i))) } or
  TInReceiver() or
  TInResult(int index) {
    // the one and only result
    index = -1
    or
    // one among several results
    exists(SignatureType s | exists(s.getResultType(index)))
  }

/**
 * An abstract representation of an input to a function, which is either a parameter
 * or the receiver parameter.
 */
class FunctionInput extends TFunctionInput {
  /** Holds if this represents the `i`th parameter of a function. */
  predicate isParameter(int i) { none() }

  /** Holds if this represents the receiver of a function. */
  predicate isReceiver() { none() }

  /** Holds if this represents the result of a function. */
  predicate isResult() { none() }

  /** Holds if this represents the `i`th result of a function. */
  predicate isResult(int i) { none() }

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

  ParameterInput() { this = TInParameter(index) }

  override predicate isParameter(int i) { i = index }

  override DataFlow::Node getEntryNode(DataFlow::CallNode c) { result = c.getArgument(index) }

  override DataFlow::Node getExitNode(FuncDef f) {
    result = DataFlow::parameterNode(f.getParameter(index))
  }

  override string toString() { result = "parameter " + index }
}

/** The receiver of a function, viewed as a source of input. */
private class ReceiverInput extends FunctionInput, TInReceiver {
  override predicate isReceiver() { any() }

  override DataFlow::Node getEntryNode(DataFlow::CallNode c) {
    result = c.(DataFlow::MethodCallNode).getReceiver()
  }

  override DataFlow::Node getExitNode(FuncDef f) {
    result = DataFlow::receiverNode(f.(MethodDecl).getReceiver())
  }

  override string toString() { result = "receiver" }
}

/**
 * A result position of a function, viewed as an input.
 *
 * Results are usually outputs rather than inputs, but for taint tracking it can be useful to
 * think of taint propagating backwards from a result of a function to its arguments. For instance,
 * the function `bufio.NewWriter` returns a writer `bw` that buffers write operations to an
 * underlying writer `w`. If tainted data is written to `bw`, then it makes sense to propagate
 * that taint back to the underlying writer `w`, which can be modeled by saying that
 * `bufio.NewWriter` propagates taint from its result to its first argument.
 */
private class ResultInput extends FunctionInput, TInResult {
  int index;

  ResultInput() { this = TInResult(index) }

  override predicate isResult() { index = -1 }

  override predicate isResult(int i) {
    i = 0 and isResult()
    or
    i = index and i >= 0
  }

  override DataFlow::Node getEntryNode(DataFlow::CallNode c) {
    exists(DataFlow::PostUpdateNode pun, DataFlow::Node init |
      pun = result and
      init = pun.(DataFlow::SsaNode).getInit()
    |
      index = -1 and
      init = c.getResult()
      or
      index >= 0 and
      init = c.getResult(index)
    )
  }

  override DataFlow::Node getExitNode(FuncDef f) { none() }

  override string toString() {
    index = -1 and result = "result"
    or
    index >= 0 and result = "result " + index
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
  } or
  TOutReceiver() or
  TOutParameter(int index) { exists(SignatureType s | exists(s.getParameterType(index))) }

/**
 * An abstract representation of an output of a function, which is one of its results
 * or a parameter with mutable type.
 */
class FunctionOutput extends TFunctionOutput {
  /** Holds if this represents the (single) result of a function. */
  predicate isResult() { none() }

  /** Holds if this represents the `i`th result of a function. */
  predicate isResult(int i) { none() }

  /** Holds if this represents the receiver of a function. */
  predicate isReceiver() { none() }

  /** Holds if this represents the `i`th parameter of a function. */
  predicate isParameter(int i) { none() }

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

  OutResult() { this = TOutResult(index) }

  override predicate isResult() { index = -1 }

  override predicate isResult(int i) {
    i = 0 and isResult()
    or
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

/** The receiver of a function, viewed as an output. */
private class OutReceiver extends FunctionOutput, TOutReceiver {
  override predicate isReceiver() { any() }

  override DataFlow::Node getEntryNode(FuncDef f) {
    // there is no generic way of assigning to a receiver; operations that taint a receiver
    // have to be handled on a case-by-case basis
    none()
  }

  override DataFlow::Node getExitNode(DataFlow::CallNode c) {
    exists(DataFlow::Node arg |
      arg = getArgument(c, -1) and
      result.(DataFlow::PostUpdateNode).getPreUpdateNode() = arg
    )
  }

  override string toString() { result = "receiver" }
}

/**
 * A parameter of a function, viewed as an output.
 *
 * Note that slices passed to varargs parameters using `...` are not included, since in this
 * case it is ambiguous whether the output should be the slice itself or one of its elements.
 */
private class OutParameter extends FunctionOutput, TOutParameter {
  int index;

  OutParameter() { this = TOutParameter(index) }

  override predicate isParameter(int i) { i = index }

  override DataFlow::Node getEntryNode(FuncDef f) {
    // there is no generic way of assigning to a parameter; operations that taint a parameter
    // have to be handled on a case-by-case basis
    none()
  }

  override DataFlow::Node getExitNode(DataFlow::CallNode c) {
    exists(DataFlow::Node arg |
      arg = getArgument(c, index) and
      // exclude slices passed to varargs parameters using `...` calls
      not (c.hasEllipsis() and index = c.getNumArgument() - 1)
    |
      result.(DataFlow::PostUpdateNode).getPreUpdateNode() = arg
    )
  }

  override string toString() { result = "parameter " + index }
}
