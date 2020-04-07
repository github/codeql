/**
 * @name Incorrect Conversion between Numeric Types
 * @description Converting the result of strconv.Atoi (and other parsers from strconv package)
 *              to numeric types of lower bit size can produce unexpected values.
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

/**
 * A type conversion expression towards a numeric type that has
 * a bit size equal to or lower than 32 bits.
 */
class Lte32BitNumericConversionExpr extends ConversionExpr {
  string conversionTypeName;

  Lte32BitNumericConversionExpr() {
    exists(ConversionExpr conv |
      conversionTypeName = conv.getTypeExpr().getType().getUnderlyingType*().getName() and
      (
        // anything lower than int64:
        conversionTypeName = ["int8", "int16", "int32"]
        or
        // anything lower than uint64:
        conversionTypeName = ["uint8", "uint16", "uint32"]
        or
        // anything lower than float64:
        conversionTypeName = "float32"
      )
    |
      this = conv
    )
  }

  string getTypeName() { result = conversionTypeName }
}

/**
 * A type conversion expression towards a numeric type that has
 * a bit size equal to or lower than 16 bits.
 */
class Lte16BitNumericConversionExpr extends Lte32BitNumericConversionExpr {
  Lte16BitNumericConversionExpr() {
    conversionTypeName = this.getTypeName() and
    (
      // anything lower than int32:
      conversionTypeName = ["int8", "int16"]
      or
      // anything lower than uint32:
      conversionTypeName = ["uint8", "uint16"]
    )
  }
}

/**
 * A type conversion expression towards a numeric type that has
 * a bit size equal to 8 bits.
 */
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

/**
 * An `if` statement with the condition being either a relational comparison,
 * or one or more `&&`.
 */
class IfRelationalComparison extends IfStmt {
  IfRelationalComparison() {
    this.getCond() instanceof RelationalComparisonExpr or this.getCond() instanceof LandExpr
  }

  RelationalComparisonExpr getComparison() { result = this.getCond().(RelationalComparisonExpr) }

  LandExpr getLandExpr() { result = this.getCond().(LandExpr) }
}

/**
 * Flow of result of parsing a 64 bit number, to conversion to lower bit numbers.
 */
class Lte64FlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  Lte64FlowConfig() { this = "Lte64FlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(Atoi atoi | source = atoi.getACall().getResult(0))
    or
    exists(ParseFloat parseFloat, DataFlow::CallNode call |
      call = parseFloat.getACall() and call.getArgument(1).getIntValue() = 64
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

/**
 * Flow of result of parsing a 32 bit number, to conversion to lower bit numbers.
 */
class Lte32FlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  Lte32FlowConfig() { this = "Lte32FlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(ParseFloat parseFloat, DataFlow::CallNode call |
      call = parseFloat.getACall() and call.getArgument(1).getIntValue() = 32
    |
      source = call.getResult(0)
    )
    or
    exists(ParseInt parseInt, DataFlow::CallNode call |
      call = parseInt.getACall() and call.getArgument(2).getIntValue() = 32
    |
      source = call.getResult(0)
    )
    or
    exists(ParseUint parseUint, DataFlow::CallNode call |
      call = parseUint.getACall() and call.getArgument(2).getIntValue() = 32
    |
      source = call.getResult(0)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Lte16BitNumericConversionExpr conv | sink.asExpr() = conv)
  }

  override predicate isSanitizerIn(DataFlow::Node node) { isSanitizedInsideAnIfBoundCheck(node) }
}

/**
 * Flow of result of parsing a 16 bit number, to conversion to lower bit numbers.
 */
class Lte16FlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  Lte16FlowConfig() { this = "Lte16FlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(ParseInt parseInt, DataFlow::CallNode call |
      call = parseInt.getACall() and call.getArgument(2).getIntValue() = 16
    |
      source = call.getResult(0)
    )
    or
    exists(ParseUint parseUint, DataFlow::CallNode call |
      call = parseUint.getACall() and call.getArgument(2).getIntValue() = 16
    |
      source = call.getResult(0)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Lte8BitNumericConversionExpr conv | sink.asExpr() = conv)
  }

  override predicate isSanitizerIn(DataFlow::Node node) { isSanitizedInsideAnIfBoundCheck(node) }
}

/**
 * Check if the node is a numeric conversion inside an `if` body, where
 * the `if` condition contains an upper bound check on the conversion operand.
 */
predicate isSanitizedInsideAnIfBoundCheck(DataFlow::Node node) {
  exists(IfRelationalComparison comp, Lte32BitNumericConversionExpr conv |
    // NOTE: using Lte32BitNumericConversionExpr because it also catches
    // any lower bit conversions.
    conv = node.asExpr().(Lte32BitNumericConversionExpr) and
    comp.getThen().getAChild*() = conv and
    (
      // If the conversion is inside an `if` block that compares the source as
      // `source > 0` or `source >= 0`, then that sanitizes conversion of int to int32;
      conv.getTypeName() = "int32" and
      comp.getComparison().getLesserOperand().getNumericValue() = 0 and
      comp.getComparison().getGreaterOperand().getGlobalValueNumber() =
        conv.getOperand().getGlobalValueNumber()
      or
      comparisonGreaterOperandValueIsEqual("int8", comp, conv, getMaxInt8())
      or
      comparisonGreaterOperandValueIsEqual("int16", comp, conv, getMaxInt16())
      or
      comparisonGreaterOperandValueIsEqual("int32", comp, conv, getMaxInt32())
      or
      comparisonGreaterOperandValueIsEqual("uint8", comp, conv, getMaxUint8())
      or
      comparisonGreaterOperandValueIsEqual("uint16", comp, conv, getMaxUint16())
    )
  )
}

int getMaxInt8() { result = 2.pow(7) - 1 }

int getMaxInt16() { result = 2.pow(15) - 1 }

int getMaxInt32() { result = 2.pow(31) - 1 }

int getMaxUint8() { result = 2.pow(8) - 1 }

int getMaxUint16() { result = 2.pow(16) - 1 }

/**
 * The `if` relational comparison (which can also be inside a `LandExpr`) stating that
 * the greater operand is equal to `value`, and the lesses operand is the conversion operand.
 */
predicate comparisonGreaterOperandValueIsEqual(
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

string getParserQualifiedNameFromResultType(string resultTypeName) {
  resultTypeName = "int" and result = "strconv.Atoi"
  or
  resultTypeName = "int64" and result = "strconv.ParseInt"
  or
  resultTypeName = "uint64" and result = "strconv.ParseUint"
  or
  resultTypeName = "float64" and result = "strconv.ParseFloat"
}

from DataFlow::PathNode source, DataFlow::PathNode sink
where
  exists(Lte64FlowConfig cfg | cfg.hasFlowPath(source, sink)) or
  exists(Lte32FlowConfig cfg | cfg.hasFlowPath(source, sink)) or
  exists(Lte16FlowConfig cfg | cfg.hasFlowPath(source, sink))
select source, source, sink,
  "Incorrect type conversion of " + source.getNode().getType() + " from " +
    getParserQualifiedNameFromResultType(source.getNode().getType().toString()) + " result to a lower bit size type " +
    sink.getNode().asExpr().(Lte32BitNumericConversionExpr).getTypeName()
