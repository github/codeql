/**
 * @name Incorrect Conversion between Numeric Types
 * @description Converting the result of strconv.Atoi (which is of type `int`) to
 *                numeric types of lower bit size can produce unexpected values.
 * @kind path-problem
 * @id go/incorrect-numeric-conversion
 * @tags security
 *       external/cwe/cwe-681
 */

import go
import DataFlow::PathGraph

class IntParser extends Function {
  IntParser() { this.hasQualifiedName("strconv", "Atoi") }
}

class NumericConversionExpr extends ConversionExpr {
  string conversionTypeName;

  NumericConversionExpr() {
    exists(ConversionExpr conv |
      conversionTypeName = conv.getTypeExpr().getType().getUnderlyingType*().getName() and
      (
        // anything lower than int64:
        conversionTypeName = "int8" or
        conversionTypeName = "int16" or
        conversionTypeName = "int32" or
        // anything lower than uint64:
        conversionTypeName = "uint8" or
        conversionTypeName = "uint16" or
        conversionTypeName = "uint32" or
        // anything lower than float64:
        conversionTypeName = "float32"
      )
    |
      this = conv
    )
  }

  string getTypeName() { result = conversionTypeName }
}

class IfRelationalComparison extends IfStmt {
  IfRelationalComparison() {
    this.getCond() instanceof RelationalComparisonExpr or this.getCond() instanceof LandExpr
  }

  RelationalComparisonExpr getComparison() { result = this.getCond().(RelationalComparisonExpr) }

  LandExpr getLandExpr() { result = this.getCond().(LandExpr) }
}

class FlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  FlowConfig() { this = "FlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(IntParser atoi | source = atoi.getACall().getResult(0))
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(NumericConversionExpr conv | sink.asExpr() = conv)
  }

  override predicate isSanitizerIn(DataFlow::Node node) {
    exists(IfRelationalComparison san, NumericConversionExpr conv |
      conv = node.asExpr().(NumericConversionExpr) and
      san.getThen().getAChild*() = conv and
      (
        // If the conversion is inside an `if` block that compares the source as
        // `source > 0` or `source >= 0`, then that sanitizes conversion of int to int32;
        conv.getTypeName() = "int32" and
        san.getComparison().getLesserOperand().getNumericValue() = 0 and
        san.getComparison().getGreaterOperand().getGlobalValueNumber() =
          conv.getOperand().getGlobalValueNumber()
        or
        comparisonGreaterOperandValueIsEqualOrLess("int8", san, conv, getMaxInt8())
        or
        comparisonGreaterOperandValueIsEqualOrLess("int16", san, conv, getMaxInt16())
        or
        comparisonGreaterOperandValueIsEqualOrLess("int32", san, conv, getMaxInt32())
        or
        comparisonGreaterOperandValueIsEqualOrLess("uint8", san, conv, getMaxUint8())
        or
        comparisonGreaterOperandValueIsEqualOrLess("uint16", san, conv, getMaxUint16())
      )
    )
  }
}

int getMaxInt8() {
  result = 2.pow(7) - 1
  //   = 1<<7 - 1
}

int getMaxInt16() {
  result = 2.pow(15) - 1
  //  = 1<<15 - 1
}

int getMaxInt32() {
  result = 2.pow(31) - 1
  //  = 1<<31 - 1
}

int getMaxUint8() {
  result = 2.pow(8) - 1
  //  = 1<<8 - 1
}

int getMaxUint16() {
  result = 2.pow(16) - 1
  // = 1<<16 - 1
}

predicate comparisonGreaterOperandValueIsEqualOrLess(
  string typeName, IfRelationalComparison ifExpr, NumericConversionExpr conv, int value
) {
  conv.getTypeName() = typeName and
  (
    // exclude cases like: if parsed < math.MaxInt8 {return int8(parsed)}
    exists(RelationalComparisonExpr comp | comp = ifExpr.getComparison() |
      // greater operand is equal to value:
      comp.getGreaterOperand().getNumericValue() = value and
      // and lesser is the conversion operand:
      comp.getLesserOperand().getGlobalValueNumber() = conv.getOperand().getGlobalValueNumber()
    )
    or
    // exclude cases like: if err == nil && parsed < math.MaxInt8 {return int8(parsed)}
    exists(RelationalComparisonExpr andExpr |
      andExpr = ifExpr.getLandExpr().getAnOperand().(RelationalComparisonExpr)
    |
      // greater operand is equal to value:
      andExpr.getGreaterOperand().getNumericValue() = value and
      // and lesser is the conversion operand:
      andExpr.getLesserOperand().getGlobalValueNumber() = conv.getOperand().getGlobalValueNumber()
    )
  )
}

from FlowConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select source, source, sink,
  "Incorrect type conversion of int from strconv.Atoi result to another numeric type"
