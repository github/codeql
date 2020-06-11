/**
 * @name Incorrect conversion between numeric types
 * @description Converting the result of strconv.Atoi (and other parsers from strconv package)
 *              to numeric types of smaller bit size can produce unexpected values.
 * @kind path-problem
 * @problem.severity warning
 * @id go/incorrect-numeric-conversion
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-681
 */

import go
import DataFlow::PathGraph

/** A function that parses integers. */
class Atoi extends Function {
  Atoi() { this.hasQualifiedName("strconv", "Atoi") }
}

/** A function that parses floating-point numbers. */
class ParseFloat extends Function {
  ParseFloat() { this.hasQualifiedName("strconv", "ParseFloat") }
}

/** A function that parses integers with a specifiable bitSize. */
class ParseInt extends Function {
  ParseInt() { this.hasQualifiedName("strconv", "ParseInt") }
}

/** A function that parses unsigned integers with a specifiable bitSize. */
class ParseUint extends Function {
  ParseUint() { this.hasQualifiedName("strconv", "ParseUint") }
}

/** Provides a class for modeling calls to number-parsing functions. */
module ParserCall {
  /**
   * A data-flow call node that parses a number.
   */
  abstract class Range extends DataFlow::CallNode {
    /** Gets the bit size of the result number. */
    abstract int getTargetBitSize();

    /** Gets the name of the parser function. */
    abstract string getParserName();
  }
}

class ParserCall extends DataFlow::CallNode {
  ParserCall::Range self;

  ParserCall() { this = self }

  int getTargetBitSize() { result = self.getTargetBitSize() }

  string getParserName() { result = self.getParserName() }
}

class AtoiCall extends DataFlow::CallNode, ParserCall::Range {
  AtoiCall() { exists(Atoi atoi | this = atoi.getACall()) }

  override int getTargetBitSize() { result = 0 }

  override string getParserName() { result = "strconv.Atoi" }
}

class ParseIntCall extends DataFlow::CallNode, ParserCall::Range {
  ParseIntCall() { exists(ParseInt parseInt | this = parseInt.getACall()) }

  override int getTargetBitSize() { result = this.getArgument(2).getIntValue() }

  override string getParserName() { result = "strconv.ParseInt" }
}

class ParseUintCall extends DataFlow::CallNode, ParserCall::Range {
  ParseUintCall() { exists(ParseUint parseUint | this = parseUint.getACall()) }

  override int getTargetBitSize() { result = this.getArgument(2).getIntValue() }

  override string getParserName() { result = "strconv.ParseUint" }
}

class ParseFloatCall extends DataFlow::CallNode, ParserCall::Range {
  ParseFloatCall() { exists(ParseFloat parseFloat | this = parseFloat.getACall()) }

  override int getTargetBitSize() { result = this.getArgument(1).getIntValue() }

  override string getParserName() { result = "strconv.ParseFloat" }
}

class NumericConversionExpr extends ConversionExpr {
  string fullTypeName;
  int bitSize;

  NumericConversionExpr() {
    exists(NumericType conv |
      conv = getTypeExpr().getType().getUnderlyingType() and
      fullTypeName = conv.getName() and
      bitSize = conv.getSize()
    )
  }

  string getFullTypeName() { result = fullTypeName }

  int getBitSize() { result = bitSize }
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
class Lt64BitFlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  Lt64BitFlowConfig() { this = "Lt64BitFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(ParserCall call | call.getTargetBitSize() = [0, 64] | source = call)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(NumericConversionExpr conv | conv.getBitSize() = [32, 16, 8] | sink.asExpr() = conv)
  }

  override predicate isSanitizerIn(DataFlow::Node node) { isSanitizedInsideAnIfBoundCheck(node) }
}

/**
 * Flow of result of parsing a 32 bit number, to conversion to lower bit numbers.
 */
class Lt32BitFlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  Lt32BitFlowConfig() { this = "Lt32BitFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    // NOTE: target bit size 0 is already addressed in Lt64BitFlowConfig.
    exists(ParserCall call | call.getTargetBitSize() = [/*0,*/ 32] | source = call)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(NumericConversionExpr conv | conv.getBitSize() = [16, 8] | sink.asExpr() = conv)
  }

  override predicate isSanitizerIn(DataFlow::Node node) { isSanitizedInsideAnIfBoundCheck(node) }
}

/**
 * Flow of result of parsing a 16 bit number, to conversion to lower bit numbers.
 */
class Lt16BitFlowConfig extends TaintTracking::Configuration, DataFlow::Configuration {
  Lt16BitFlowConfig() { this = "Lt16BitFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(ParserCall call | call.getTargetBitSize() = 16 | source = call)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(NumericConversionExpr conv | conv.getBitSize() = 8 | sink.asExpr() = conv)
  }

  override predicate isSanitizerIn(DataFlow::Node node) { isSanitizedInsideAnIfBoundCheck(node) }
}

/**
 * Check if the node is a numeric conversion inside an `if` body, where
 * the `if` condition contains an upper bound check on the conversion operand.
 */
predicate isSanitizedInsideAnIfBoundCheck(DataFlow::Node node) {
  exists(IfRelationalComparison comp, NumericConversionExpr conv |
    conv = node.asExpr().(NumericConversionExpr) and
    conv.getBitSize() = [8, 16, 32] and
    comp.getThen().getAChild*() = conv and
    (
      // If the conversion is inside an `if` block that compares the source as
      // `source > 0` or `source >= 0`, then that sanitizes conversion of int to int32;
      conv.getFullTypeName() = "int32" and
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
  string typeName, IfRelationalComparison ifExpr, NumericConversionExpr conv, int value
) {
  conv.getFullTypeName() = typeName and
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

string formatBitSize(ParserCall call) {
  call.getTargetBitSize() = 0 and result = "(arch-dependent)"
  or
  call.getTargetBitSize() > 0 and result = call.getTargetBitSize().toString()
}

from DataFlow::PathNode source, DataFlow::PathNode sink
where
  (
    exists(Lt64BitFlowConfig cfg | cfg.hasFlowPath(source, sink))
    or
    exists(Lt32BitFlowConfig cfg | cfg.hasFlowPath(source, sink))
    or
    exists(Lt16BitFlowConfig cfg | cfg.hasFlowPath(source, sink))
  ) and
  // Exclude results in test files:
  exists(File fl | fl = sink.getNode().asExpr().(NumericConversionExpr).getFile() |
    not fl instanceof TestFile
  )
select source.getNode(), source, sink,
  "Incorrect conversion of a " + formatBitSize(source.getNode().(ParserCall)) + "-bit number from " +
    source.getNode().(ParserCall).getParserName() + " result to a lower bit size type " +
    sink.getNode().asExpr().(NumericConversionExpr).getFullTypeName()
