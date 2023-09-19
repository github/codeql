/**
 * Provides models for `Numeric` and related Swift classes (such as `Int` and `Float`).
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for `Numeric` and related class members and functions that permit taint flow.
 */
private class NumericSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;numericCast(_:);;;Argument[0];ReturnValue;taint",
        ";;false;unsafeDowncast(_:to:);;;Argument[0];ReturnValue;taint",
        ";;false;unsafeBitCast(_:to:);;;Argument[0];ReturnValue;taint",
        ";Numeric;true;init(exactly:);;;Argument[0];ReturnValue.OptionalSome;value",
        ";Numeric;true;init(bitPattern:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;init(clamping:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;init(truncatingIfNeeded:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;init(_:format:lenient:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;init(_:strategy:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;formatted();;;Argument[-1];ReturnValue;taint",
        ";BinaryInteger;true;formatted(_:);;;Argument[-1];ReturnValue;taint",
        ";FixedWidthInteger;true;init(_:radix:);;;Argument[0];ReturnValue;taint",
        ";FixedWidthInteger;true;init(littleEndian:);;;Argument[0];ReturnValue;taint",
        ";FixedWidthInteger;true;init(bigEndian:);;;Argument[0];ReturnValue;taint",
        ";FloatingPoint;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";FloatingPoint;true;init(sign:exponent:significand:);;;Argument[1..2];ReturnValue;taint",
        ";FloatingPoint;true;init(signOf:magnitudeOf:);;;Argument[1];ReturnValue;taint",
      ]
  }
}

/**
 * A content implying that, if a `Numeric` is tainted, then some of its fields are
 * tainted.
 */
private class NumericFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  NumericFieldsInheritTaint() {
    this.getField().hasQualifiedName("FixedWidthInteger", ["littleEndian", "bigEndian"])
    or
    this.getField()
        .hasQualifiedName(["Double", "Float", "Float80", "FloatingPoint"],
          ["exponent", "significand"])
  }
}
