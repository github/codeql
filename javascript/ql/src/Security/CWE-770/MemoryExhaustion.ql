/**
 * @name Memory exhaustion
 * @description Allocating objects with user-controlled sizes
 *              can cause memory exhaustion.
 * @kind path-problem
 * @problem.severity warning
 * @id js/memory-exhaustion
 * @precision high
 * @tags security
 *       external/cwe/cwe-770
 */

import javascript
import DataFlow::PathGraph
private import semmle.javascript.dataflow.InferredTypes
import semmle.javascript.security.dataflow.LoopBoundInjectionCustomizations

/**
 * A data flow source for memory exhaustion vulnerabilities.
 */
abstract class Source extends DataFlow::Node {
  /** Gets a flow label denoting the type of value for which this is a source. */
  DataFlow::FlowLabel getAFlowLabel() { result.isTaint() }
}

/**
 * A data flow sink for memory exhaustion vulnerabilities.
 */
abstract class Sink extends DataFlow::Node {
  /** Gets a flow label denoting the type of value for which this is a sink. */
  DataFlow::FlowLabel getAFlowLabel() { result instanceof Label::Number }
}

/**
 * A data flow sanitizer for memory exhaustion vulnerabilities.
 */
abstract class Sanitizer extends DataFlow::Node { }

/**
 * Provides data flow labels for memory exhaustion vulnerabilities.
 */
module Label {
  /**
   * A number data flow label.
   */
  class Number extends DataFlow::FlowLabel {
    Number() { this = "number" }
  }
}

/**
 * A data flow configuration for memory exhaustion vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "MemoryExhaustion" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getAFlowLabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getAFlowLabel() = label
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    dstlabel instanceof Label::Number and
    isNumericFlowStep(src, dst)
    or
    // reuse taint steps
    super.isAdditionalFlowStep(src, dst) and
    not dst.asExpr() instanceof AddExpr and
    if dst.(DataFlow::MethodCallNode).calls(src, "toString")
    then dstlabel.isTaint()
    else srclabel = dstlabel
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof LoopBoundInjection::LengthCheckSanitizerGuard or
    guard instanceof UpperBoundsCheckSanitizerGuard or
    guard instanceof TypeTestGuard
  }
}

predicate isNumericFlowStep(DataFlow::Node src, DataFlow::Node dst) {
  // steps that introduce or preserve a number
  dst.(DataFlow::PropRead).accesses(src, ["length", "size"])
  or
  exists(DataFlow::CallNode c |
    c = dst and
    src = c.getAnArgument()
  |
    c = DataFlow::globalVarRef("Math").getAMemberCall(_) or
    c = DataFlow::globalVarRef(["Number", "parseInt", "parseFloat"]).getACall()
  )
  or
  exists(Expr dstExpr, Expr srcExpr |
    dstExpr = dst.asExpr() and
    srcExpr = src.asExpr()
  |
    dstExpr.(BinaryExpr).getAnOperand() = srcExpr and
    not dstExpr instanceof AddExpr
    or
    dstExpr.(PlusExpr).getOperand() = srcExpr
  )
}

/**
 * A sanitizer that blocks taint flow if the size of a number is limited.
 */
class UpperBoundsCheckSanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode,
  DataFlow::ValueNode {
  override RelationalComparison astNode;

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    label instanceof Label::Number and
    (
      true = outcome and
      e = astNode.getLesserOperand()
      or
      false = outcome and
      e = astNode.getGreaterOperand()
    )
  }
}

/**
 * A test of form `typeof x === "something"`, preventing `x` from being a number in some cases.
 */
private class TypeTestGuard extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::ValueNode {
  override EqualityTest astNode;
  TypeofExpr typeof;
  boolean polarity;

  TypeTestGuard() {
    astNode.getAnOperand() = typeof and
    (
      // typeof x === "number" sanitizes `x` when it evaluates to false
      astNode.getAnOperand().getStringValue() = "number" and
      polarity = astNode.getPolarity().booleanNot()
      or
      // typeof x === "string" sanitizes `x` when it evaluates to true
      astNode.getAnOperand().getStringValue() != "number" and
      polarity = astNode.getPolarity()
    )
  }

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    polarity = outcome and
    e = typeof.getOperand() and
    label instanceof Label::Number
  }
}

/** A source of remote user input, considered as a data flow source for memory exhaustion vulnerabilities. */
class RemoteFlowSourceAsSource extends Source {
  RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
}

/**
 * A node that determines the size of a buffer, considered as a data flow sink for memory exhaustion vulnerabilities.
 */
class BufferSizeSink extends Sink {
  BufferSizeSink() {
    exists(DataFlow::SourceNode clazz, DataFlow::InvokeNode invk, int index |
      clazz = DataFlow::globalVarRef("Buffer") and this = invk.getArgument(index)
    |
      exists(string name |
        invk = clazz.getAMemberCall(name) and
        (
          name = "from" and index = 2
          or
          name = ["alloc", "allocUnsafe", "allocUnsafeSlow"] and index = 0
        )
      )
      or
      invk = clazz.getAnInvocation() and
      (
        invk.getNumArgument() = 1 and
        index = 0
        or
        invk.getNumArgument() = 3 and index = 2
      )
    )
    or
    this = DataFlow::globalVarRef("SlowBuffer").getAnInstantiation().getArgument(0)
  }
}

/**
 * A node that determines the size of an array, considered as a data flow sink for memory exhaustion vulnerabilities.
 */
class DenseArraySizeSink extends Sink {
  DenseArraySizeSink() {
    // Arrays are sparse by default, so we must also look at how the array is used
    exists(DataFlow::ArrayConstructorInvokeNode instance |
      this = instance.getArgument(0) and
      instance.getNumArgument() = 1
    |
      exists(instance.getAMethodCall(["map", "fill", "join", "toString"])) or
      instance.flowsToExpr(any(AddExpr p).getAnOperand())
    )
  }
}

/**
 * A node that determines the repetitions of a string, considered as a data flow sink for memory exhaustion vulnerabilities.
 */
class StringRepetitionSink extends Sink {
  StringRepetitionSink() {
    exists(DataFlow::MethodCallNode repeat |
      repeat.getMethodName() = "repeat" and
      this = repeat.getArgument(0)
    )
  }

  override DataFlow::FlowLabel getAFlowLabel() { any() }
}

from Configuration dataflow, DataFlow::PathNode source, DataFlow::PathNode sink
where dataflow.hasFlowPath(source, sink)
select sink, source, sink, "This allocates an object with a user-controlled size from $@.", source,
  "here"
