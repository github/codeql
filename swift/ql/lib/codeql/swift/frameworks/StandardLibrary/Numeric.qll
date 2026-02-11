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
        ";;false;min(_:_:);;;Argument[0..1];ReturnValue;taint",
        ";;false;min(_:_:_:_:);;;Argument[0..2];ReturnValue;taint",
        ";;false;min(_:_:_:_:);;;Argument[3].CollectionElement;ReturnValue;taint",
        ";;false;max(_:_:);;;Argument[0..1];ReturnValue;taint",
        ";;false;max(_:_:_:_:);;;Argument[0..2];ReturnValue;taint",
        ";;false;max(_:_:_:_:);;;Argument[3].CollectionElement;ReturnValue;taint",
        ";;false;abs(_:);;;Argument[0];ReturnValue;taint",
        ";Numeric;true;init(exactly:);;;Argument[0];ReturnValue.OptionalSome;value",
        ";Numeric;true;init(bitPattern:);;;Argument[0];ReturnValue;taint", // actually implemented in Int, UInt, Double etc.
        ";Numeric;true;init(truncating:);;;Argument[0];ReturnValue;taint", // actually implemented in Int, UInt, Double etc.
        ";BinaryInteger;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;init(clamping:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;init(truncatingIfNeeded:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;init(_:format:lenient:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;init(_:strategy:);;;Argument[0];ReturnValue;taint",
        ";BinaryInteger;true;formatted();;;Argument[-1];ReturnValue;taint",
        ";BinaryInteger;true;formatted(_:);;;Argument[-1];ReturnValue;taint",
        ";BinaryInteger;true;quotientAndRemainder(dividingBy:);;;Argument[-1..0];ReturnValue.TupleElement[0,1];taint",
        ";BinaryInteger;true;advanced(by:);;;Argument[-1..0];ReturnValue;taint",
        ";BinaryInteger;true;distance(to:);;;Argument[-1..0];ReturnValue;taint",
        ";SignedInteger;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";SignedInteger;true;init(exactly:);;;Argument[0];ReturnValue.OptionalSome;value",
        ";UnsignedInteger;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";UnsignedInteger;true;init(exactly:);;;Argument[0];ReturnValue.OptionalSome;value",
        ";FixedWidthInteger;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";FixedWidthInteger;true;init(clamping:);;;Argument[0];ReturnValue;taint",
        ";FixedWidthInteger;true;init(truncatingIfNeeded:);;;Argument[0];ReturnValue;taint",
        ";FixedWidthInteger;true;init(bitPattern:);;;Argument[0];ReturnValue;taint", // actually implemented in Int, UInt, Double etc.
        ";FixedWidthInteger;true;init(truncating:);;;Argument[0];ReturnValue;taint", // actually implemented in Int, UInt, Double etc.
        ";FixedWidthInteger;true;init(_:radix:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";FixedWidthInteger;true;init(littleEndian:);;;Argument[0];ReturnValue;taint",
        ";FixedWidthInteger;true;init(bigEndian:);;;Argument[0];ReturnValue;taint",
        ";FixedWidthInteger;true;addingReportingOverflow(_:);;;Argument[-1..0];ReturnValue.TupleElement[0];taint",
        ";FixedWidthInteger;true;subtractingReportingOverflow(_:);;;Argument[-1..0];ReturnValue.TupleElement[0];taint",
        ";FixedWidthInteger;true;multipliedReportingOverflow(by:);;;Argument[-1..0];ReturnValue.TupleElement[0];taint",
        ";FixedWidthInteger;true;dividedReportingOverflow(by:);;;Argument[-1..0];ReturnValue.TupleElement[0];taint",
        ";FixedWidthInteger;true;remainderReportingOverflow(dividingBy:);;;Argument[-1..0];ReturnValue.TupleElement[0];taint",
        ";FixedWidthInteger;true;dividingFullWidth(_:);;;Argument[-1];ReturnValue.TupleElement[0,1];taint",
        ";FixedWidthInteger;true;dividingFullWidth(_:);;;Argument[1].TupleElement[0,1];ReturnValue.TupleElement[0,1];taint",
        ";FixedWidthInteger;true;multipliedFullWidth(by:);;;Argument[-1..0];ReturnValue.TupleElement[0,1];taint",
        ";FloatingPoint;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";FloatingPoint;true;init(sign:exponent:significand:);;;Argument[1..2];ReturnValue;taint",
        ";FloatingPoint;true;init(signOf:magnitudeOf:);;;Argument[1];ReturnValue;taint",
        ";FloatingPoint;true;addProduct(_:_:);;;Argument[-1..1];Argument[-1];taint",
        ";FloatingPoint;true;addingProduct(_:_:);;;Argument[-1..1];ReturnValue;taint",
        ";FloatingPoint;true;formRemainder(dividingBy:);;;Argument[-1..0];Argument[-1];taint",
        ";FloatingPoint;true;remainder(dividingBy:);;;Argument[-1..0];ReturnValue;taint",
        ";FloatingPoint;true;formTruncatingRemainder(dividingBy:);;;Argument[-1..0];Argument[-1];taint",
        ";FloatingPoint;true;truncatingRemainder(dividingBy:);;;Argument[-1..0];ReturnValue;taint",
        ";FloatingPoint;true;rounded();;;Argument[-1];ReturnValue;taint",
        ";FloatingPoint;true;rounded(_:);;;Argument[-1];ReturnValue;taint",
        ";FloatingPoint;true;squareRoot();;;Argument[-1];ReturnValue;taint",
        ";FloatingPoint;true;maximum(_:_:);;;Argument[0..1];ReturnValue;taint",
        ";FloatingPoint;true;maximumMagnitude(_:_:);;;Argument[0..1];ReturnValue;taint",
        ";FloatingPoint;true;minimum(_:_:);;;Argument[0..1];ReturnValue;taint",
        ";FloatingPoint;true;minimumMagnitude(_:_:);;;Argument[0..1];ReturnValue;taint",
        ";BinaryFloatingPoint;true;init(sign:exponentBitPattern:significandBitPattern:);;;Argument[0..2];ReturnValue;taint",
        ";BinaryFloatingPoint;true;init(_:format:lenient:);;;Argument[0];ReturnValue;taint",
        ";BinaryFloatingPoint;true;init(_:strategy:);;;Argument[0];ReturnValue;taint",
        ";BinaryFloatingPoint;true;formatted();;;Argument[-1];ReturnValue;taint",
        ";BinaryFloatingPoint;true;formatted(_:);;;Argument[-1];ReturnValue;taint",
        ";Strideable;true;advanced(by:);;;Argument[-1..0];ReturnValue;taint",
        ";Strideable;true;distance(to:);;;Argument[-1..0];ReturnValue;taint",
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
    exists(string className, string fieldName |
      (
        className = "FixedWidthInteger" and
        fieldName = ["littleEndian", "bigEndian"]
        or
        className = "FloatingPoint" and
        fieldName = ["exponent", "significand"]
        or
        className = "BinaryInteger" and
        fieldName = "words"
        or
        className = ["Numeric", "SignedInteger", "UnsignedInteger"] and
        fieldName = ["magnitude", "byteSwapped"]
        or
        className = "BinaryFloatingPoint" and
        fieldName = ["binade", "exponentBitPattern", "significandBitPattern"]
      ) and
      exists(FieldDecl fieldDecl, Decl declaringDecl, TypeDecl namedTypeDecl |
        namedTypeDecl.getFullName() = className and
        fieldDecl.getName() = fieldName and
        declaringDecl.getAMember() = fieldDecl and
        declaringDecl.asNominalTypeDecl() = namedTypeDecl.getADerivedTypeDecl*() and
        this.getField() = fieldDecl
      )
    )
  }
}
