/**
 * @name Incorrect conversion between integer types
 * @description Converting the result of `strconv.Atoi`, `strconv.ParseInt`,
 *              and `strconv.ParseUint` to integer types of smaller bit size
 *              can produce unexpected values.
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
  bitSize in [8, 16, 32] and
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
  sourceBitSize in [16, 32, 64] and
  sinkBitSize in [8, 16, 32] and
  sourceBitSize > sinkBitSize
  or
  sourceBitSize = 0 and
  sinkBitSize in [8, 16, 32]
  or
  sourceBitSize = 64 and
  sinkBitSize = 0
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
    this = "ConversionWithoutBoundsCheckConfig" + sourceBitSize + sourceIsSigned + sinkBitSize
  }

  /** Gets the bit size of the source. */
  int getSourceBitSize() { result = sourceBitSize }

  override predicate isSource(DataFlow::Node source) {
    exists(DataFlow::CallNode c, IntegerParser::Range ip, int bitSize |
      c.getTarget() = ip and source = c.getResult(0)
    |
      (
        if ip.getResultType(0) instanceof SignedIntegerType
        then sourceIsSigned = true
        else sourceIsSigned = false
      ) and
      (
        bitSize = ip.getTargetBitSize()
        or
        if
          exists(StrConv::IntSize intSize |
            ip.getTargetBitSizeInput().getNode(c).(DataFlow::ReadNode).reads(intSize)
          )
        then bitSize = 0
        else bitSize = ip.getTargetBitSizeInput().getNode(c).getIntValue()
      ) and
      // `bitSize` could be any value between 0 and 64, but we can round
      // it up to the nearest size of an integer type without changing
      // behaviour.
      sourceBitSize = min(int b | b in [0, 8, 16, 32, 64] and b >= bitSize)
    )
  }

  /**
   * Holds if `sink` is a typecast to an integer type with size `bitSize` (where
   * 0 represents architecture-dependent) and the expression being typecast is
   * not also in a right-shift expression. We allow this case because it is
   * a common pattern to serialise `byte(v)`, `byte(v >> 8)`, and so on.
   */
  predicate isSink(DataFlow::TypeCastNode sink, int bitSize) {
    exists(IntegerType integerType | sink.getType().getUnderlyingType() = integerType |
      bitSize = integerType.getSize()
      or
      not exists(integerType.getSize()) and
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
      result = expr.getAnOperand().getExactValue().toFloat() - strictnessOffset
    )
  }

  override predicate checks(Expr e, boolean branch) {
    this.leq(branch, DataFlow::exprNode(e), _, _) and
    not exists(e.getIntValue())
  }
}

/** Gets a string describing the size of the integer parsed. */
string describeBitSize(int bitSize) {
  if bitSize != 0
  then bitSize in [8, 16, 32, 64] and result = "a " + bitSize + "-bit integer"
  else result = "an integer with architecture-dependent bit size"
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, ConversionWithoutBoundsCheckConfig cfg,
  DataFlow::CallNode call
where cfg.hasFlowPath(source, sink) and call.getResult(0) = source.getNode()
select source.getNode(), source, sink,
  "Incorrect conversion of " + describeBitSize(cfg.getSourceBitSize()) + " from " +
    call.getTarget().getQualifiedName() + " to a lower bit size type " +
    sink.getNode().getType().getUnderlyingType().getName() + " without an upper bound check."
