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

class Atoi extends Function {
  Atoi() { this.hasQualifiedName("strconv", "Atoi") }
}

class ParseFloat extends Function {
  ParseFloat() { this.hasQualifiedName("strconv", "ParseFloat") }
}

class ParseInt extends Function {
  ParseInt() { this.hasQualifiedName("strconv", "ParseInt") }
}

class ParseUint extends Function {
  ParseUint() { this.hasQualifiedName("strconv", "ParseUint") }
}

class Lte32BitNumericConversionExpr extends ConversionExpr {
  string conversionTypeName;

  Lte32BitNumericConversionExpr() {
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

class Lte16BitNumericConversionExpr extends Lte32BitNumericConversionExpr {
  Lte16BitNumericConversionExpr() {
    conversionTypeName = this.getTypeName() and
    (
      // anything lower than int32:
      conversionTypeName = "int8" or
      conversionTypeName = "int16" or
      // anything lower than uint32:
      conversionTypeName = "uint8" or
      conversionTypeName = "uint16"
    )
  }
}

class Lte8BitNumericConversionExpr extends Lte16BitNumericConversionExpr {
  Lte8BitNumericConversionExpr() {
    conversionTypeName = this.getTypeName() and
    (
      // anything lower than int16:
      conversionTypeName = "int8"
      or
      // anything lower than uint16:
      conversionTypeName = "uint8"
    )
  }
}

class IfRelationalComparison extends IfStmt {
  IfRelationalComparison() {
    this.getCond() instanceof RelationalComparisonExpr or this.getCond() instanceof LandExpr
  }

  RelationalComparisonExpr getComparison() { result = this.getCond().(RelationalComparisonExpr) }

  LandExpr getLandExpr() { result = this.getCond().(LandExpr) }
}

class Lte64FlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  Lte64FlowConfig() { this = "Lte64FlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(Atoi atoi | source = atoi.getACall().getResult(0))
    or
    exists(ParseFloat parseFloat, DataFlow::CallNode call |
      call = parseFloat.getACall() and call.getArgument(1).getIntValue() = [64]
    |
      source = call.getResult(0)
    )
    or
    exists(ParseInt parseInt, DataFlow::CallNode call |
      call = parseInt.getACall() and call.getArgument(2).getIntValue() = [0, 64]
    |
      source = call.getResult(0)
    )
    or
    exists(ParseUint parseUint, DataFlow::CallNode call |
      call = parseUint.getACall() and call.getArgument(2).getIntValue() = [0, 64]
    |
      source = call.getResult(0)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Lte32BitNumericConversionExpr conv | sink.asExpr() = conv)
  }

  override predicate isSanitizerIn(DataFlow::Node node) { isSanitizedInsideAnIfBoundCheck(node) }
}

class Lte32FlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  Lte32FlowConfig() { this = "Lte32FlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(ParseFloat parseFloat, DataFlow::CallNode call |
      call = parseFloat.getACall() and call.getArgument(1).getIntValue() = [32]
    |
      source = call.getResult(0)
    )
    or
    exists(ParseInt parseInt, DataFlow::CallNode call |
      call = parseInt.getACall() and call.getArgument(2).getIntValue() = [32]
    |
      source = call.getResult(0)
    )
    or
    exists(ParseUint parseUint, DataFlow::CallNode call |
      call = parseUint.getACall() and call.getArgument(2).getIntValue() = [32]
    |
      source = call.getResult(0)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Lte16BitNumericConversionExpr conv | sink.asExpr() = conv)
  }

  override predicate isSanitizerIn(DataFlow::Node node) { isSanitizedInsideAnIfBoundCheck(node) }
}

class Lte16FlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  Lte16FlowConfig() { this = "Lte16FlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(ParseInt parseInt, DataFlow::CallNode call |
      call = parseInt.getACall() and call.getArgument(2).getIntValue() = [16]
    |
      source = call.getResult(0)
    )
    or
    exists(ParseUint parseUint, DataFlow::CallNode call |
      call = parseUint.getACall() and call.getArgument(2).getIntValue() = [16]
    |
      source = call.getResult(0)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Lte8BitNumericConversionExpr conv | sink.asExpr() = conv)
  }

  override predicate isSanitizerIn(DataFlow::Node node) { isSanitizedInsideAnIfBoundCheck(node) }
}

predicate isSanitizedInsideAnIfBoundCheck(DataFlow::Node node) {
  exists(IfRelationalComparison san, Lte32BitNumericConversionExpr conv |
    conv = node.asExpr().(Lte32BitNumericConversionExpr) and
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
  string typeName, IfRelationalComparison ifExpr, Lte32BitNumericConversionExpr conv, int value
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

from DataFlow::PathNode source, DataFlow::PathNode sink
where
  exists(Lte64FlowConfig cfg | cfg.hasFlowPath(source, sink)) or
  exists(Lte32FlowConfig cfg | cfg.hasFlowPath(source, sink)) or
  exists(Lte16FlowConfig cfg | cfg.hasFlowPath(source, sink))
select source, source, sink,
  "Incorrect type conversion of int from strconv.Atoi result to another numeric type"
