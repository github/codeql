/**
 * @name Incorrect conversion between integer types
 * @description Converting the result of strconv.Atoi, strconv.ParseInt and strconv.ParseUint
 *              to integer types of smaller bit size can produce unexpected values.
 * @kind path-problem
 * @problem.severity warning
 * @id go/incorrect-integer-conversion
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-681
 * @precision very-high
 */

import go
import DataFlow::PathGraph

/**
 * Gets the maximum value of an integer (signed if `isSigned`
 * is true, unsigned otherwise) with `bitSize` bits.
 */
float getMaxIntValue(int bitSize, boolean isSigned) {
  bitSize in [8, 16, 32, 64] and
  (
    isSigned = true and result = 2.pow(bitSize - 1) - 1
    or
    isSigned = false and result = 2.pow(bitSize) - 1
  )
}

/**
 * Holds if converting from an integer types with size `sourceBitSize` to
 * one with size `sinkBitSize` can produce unexpected values, where 0 means
 * architecture-dependent.
 */
private predicate isIncorrectIntegerConversion(int sourceBitSize, int sinkBitSize) {
  sourceBitSize in [0, 16, 32, 64] and
  sinkBitSize in [0, 8, 16, 32] and
  not (sourceBitSize = 0 and sinkBitSize = 0) and
  exists(int source, int sink |
    (if sourceBitSize = 0 then source = 64 else source = sourceBitSize) and
    if sinkBitSize = 0 then sink = 32 else sink = sinkBitSize
  |
    source > sink
  )
}

/**
 * A taint-tracking configuration for reasoning about when an integer
 * obtained from parsing a string flows to a type conversion to a smaller
 * integer types, which could cause unexpected values.
 */
class ConversionWithoutBoundsCheckConfig extends TaintTracking::Configuration {
  boolean sourceIsSigned;
  int sourceBitSize;
  int sinkBitSize;

  ConversionWithoutBoundsCheckConfig() {
    sourceIsSigned in [true, false] and
    isIncorrectIntegerConversion(sourceBitSize, sinkBitSize) and
    this =
      sourceBitSize.toString() + sourceIsSigned.toString() + sinkBitSize.toString() +
        "ConversionWithoutBoundsCheckConfig"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(ParserCall pc, int bitSize | source = pc.getResult(0) |
      (if pc.targetIsSigned() then sourceIsSigned = true else sourceIsSigned = false) and
      (if pc.getTargetBitSize() = 0 then bitSize = 0 else bitSize = pc.getTargetBitSize()) and
      // `bitSize` could be any value between 0 and 64, but we can round
      // it up to the nearest size of an integer type without changing
      // behaviour.
      sourceBitSize = min(int b | b in [0, 8, 16, 32, 64] and b >= bitSize)
    )
  }

  /**
   * Holds if `sink` is a typecast to an integer type with size `bitSize` (where
   * 0 represents architecture-dependent) and the expression being typecast is
   * not also in a right-shift expression.
   */
  predicate isSink(DataFlow::TypeCastNode sink, int bitSize) {
    exists(IntegerType integerType | sink.getType().getUnderlyingType() = integerType |
      bitSize = integerType.getSize()
      or
      (
        integerType instanceof IntType or
        integerType instanceof UintType
      ) and
      bitSize = 0
    ) and
    not exists(ShrExpr shrExpr |
      shrExpr.getLeftOperand().getGlobalValueNumber() =
        sink.getOperand().asExpr().getGlobalValueNumber()
    )
  }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, sinkBitSize) }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    exists(int bitSize | if sinkBitSize != 0 then bitSize = sinkBitSize else bitSize = 32 |
      guard.(UpperBoundCheckGuard).getBound() <= getMaxIntValue(bitSize, sourceIsSigned)
    )
  }

  override predicate isSanitizerOut(DataFlow::Node node) {
    exists(int bitSize | isIncorrectIntegerConversion(sourceBitSize, bitSize) |
      isSink(node, bitSize)
    )
  }
}

/** An upper bound check that compares a variable to a constant value. */
class UpperBoundCheckGuard extends DataFlow::BarrierGuard, DataFlow::RelationalComparisonNode {
  UpperBoundCheckGuard() { count(expr.getAnOperand().getIntValue()) = 1 }

  /**
   * Gets the constant value which this upper bound check ensures the
   * other value is less than or equal to.
   */
  float getBound() {
    exists(int strictnessOffset |
      if expr.isStrict() then strictnessOffset = 1 else strictnessOffset = 0
    |
      result = expr.getAnOperand().getIntValue() - strictnessOffset
    )
  }

  override predicate checks(Expr e, boolean branch) {
    this.leq(branch, DataFlow::exprNode(e), _, _) and
    not exists(e.getIntValue())
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, ConversionWithoutBoundsCheckConfig cfg,
  ParserCall pc
where cfg.hasFlowPath(source, sink) and pc.getResult(0) = source.getNode()
select source.getNode(), source, sink,
  "Incorrect conversion of " + pc.getBitSizeString() + " from " + pc.getParserName() +
    " to a lower bit size type " +
    sink.getNode().(DataFlow::TypeCastNode).getType().getUnderlyingType().getName() +
    " without an upper bound check."
