/** Provides predicates and classes for reasoning about arithmetic with extreme values. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.security.ArithmeticCommon

/**
 * A field representing an extreme value.
 *
 * For example, `Integer.MAX_VALUE` or `Long.MIN_VALUE`.
 */
abstract class ExtremeValueField extends Field {
  ExtremeValueField() { this.getType() instanceof IntegralType }
}

/** A field representing the minimum value of a primitive type. */
private class MinValueField extends ExtremeValueField {
  MinValueField() { this.getName() = "MIN_VALUE" }
}

/** A field representing the maximum value of a primitive type. */
private class MaxValueField extends ExtremeValueField {
  MaxValueField() { this.getName() = "MAX_VALUE" }
}

/** A variable access that refers to an extreme value. */
class ExtremeSource extends VarAccess {
  ExtremeSource() { this.getVariable() instanceof ExtremeValueField }
}

/** A dataflow configuration which tracks flow from maximum values to an overflow. */
module MaxValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(ExtremeSource).getVariable() instanceof MaxValueField
  }

  predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  predicate isBarrierIn(DataFlow::Node n) { isSource(n) }

  predicate isBarrier(DataFlow::Node n) { overflowBarrier(n) }
}

/** Dataflow from maximum values to an underflow. */
module MaxValueFlow = DataFlow::Global<MaxValueFlowConfig>;

/** A dataflow configuration which tracks flow from minimum values to an underflow. */
module MinValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(ExtremeSource).getVariable() instanceof MinValueField
  }

  predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  predicate isBarrierIn(DataFlow::Node n) { isSource(n) }

  predicate isBarrier(DataFlow::Node n) { underflowBarrier(n) }
}

/** Dataflow from minimum values to an underflow. */
module MinValueFlow = DataFlow::Global<MinValueFlowConfig>;
