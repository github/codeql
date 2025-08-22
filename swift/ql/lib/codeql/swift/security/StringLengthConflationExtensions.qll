/**
 * Provides classes and predicates for reasoning about string length
 * conflation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

private newtype TStringType =
  TString() or
  TNsString() or
  TStringUtf8() or
  TStringUtf16() or
  TStringUnicodeScalars()

/**
 * A type of Swift string encoding. This class is used as a flow state for
 * the string length conflation taint tracking configuration.
 */
class StringType extends TStringType {
  string name;
  string singular;
  TStringType equivClass;
  string csvLabel;

  StringType() {
    this = TString() and
    name = "String" and
    singular = "a String" and
    equivClass = this and
    csvLabel = "string-length"
    or
    this = TNsString() and
    name = "NSString" and
    singular = "an NSString" and
    equivClass = this and
    csvLabel = "nsstring-length"
    or
    this = TStringUtf8() and
    name = "String.UTF8View" and
    singular = "a String.UTF8View" and
    equivClass = this and
    csvLabel = "string-utf8-length"
    or
    this = TStringUtf16() and
    name = "String.UTF16View" and
    singular = "a String.UTF16View" and
    equivClass = TNsString() and
    csvLabel = "string-utf16-length"
    or
    this = TStringUnicodeScalars() and
    name = "String.UnicodeScalarView" and
    singular = "a String.UnicodeScalarView" and
    equivClass = this and
    csvLabel = "string-unicodescalars-length"
  }

  /**
   * Gets a textual representation of this string type.
   */
  string toString() { result = name }

  /**
   * Gets the name of this string type.
   */
  string getName() { result = name }

  /**
   * Gets the equivalence class for this string type. If these are equal,
   * they should be treated as equivalent.
   */
  StringType getEquivClass() { result = equivClass }

  /**
   * Gets text for the singular form of this string type.
   */
  string getSingular() { result = singular }

  /**
   * Gets the label for this string type in CSV models.
   */
  string getCsvLabel() { result = csvLabel }
}

/**
 * A dataflow source for string length conflation vulnerabilities. That is,
 * a `DataFlow::Node` where a string length is generated.
 */
abstract class StringLengthConflationSource extends DataFlow::Node {
  /**
   * Gets the `StringType` for this source.
   */
  abstract StringType getStringType();
}

/**
 * A dataflow sink for string length conflation vulnerabilities. That is,
 * a `DataFlow::Node` where a string length is used.
 */
abstract class StringLengthConflationSink extends DataFlow::Node {
  /**
   * Gets the correct `StringType` for this sink.
   */
  abstract StringType getCorrectStringType();
}

/**
 * A barrier for string length conflation vulnerabilities.
 */
abstract class StringLengthConflationBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class StringLengthConflationAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to string length conflation vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A source defined in a CSV model.
 */
private class DefaultStringLengthConflationSource extends StringLengthConflationSource {
  StringType stringType;

  DefaultStringLengthConflationSource() { sourceNode(this, stringType.getCsvLabel()) }

  override StringType getStringType() { result = stringType }
}

private class StringLengthConflationSources extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";String;true;count;;;;string-length", ";NSString;true;length;;;;nsstring-length",
        ";NSMutableString;true;length;;;;nsstring-length",
      ]
  }
}

/**
 * An extra source that don't currently fit into the CSV scheme.
 */
private class ExtraStringLengthConflationSource extends StringLengthConflationSource {
  StringType stringType;

  ExtraStringLengthConflationSource() {
    // source is the result of a call to `[stringType].count`.
    exists(MemberRefExpr memberRef |
      (
        stringType = TStringUtf8()
        or
        stringType = TStringUtf16()
        or
        stringType = TStringUnicodeScalars()
      ) and
      memberRef.getBase().getType().(NominalType).getFullName() = stringType.getName() and
      memberRef.getMember().(VarDecl).getName() = "count" and
      this.asExpr() = memberRef
    )
  }

  override StringType getStringType() { result = stringType }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultStringLengthConflationSink extends StringLengthConflationSink {
  StringType stringType;

  DefaultStringLengthConflationSink() { sinkNode(this, stringType.getCsvLabel()) }

  override StringType getCorrectStringType() { result = stringType }
}

private class StringLengthConflationSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";String;true;index(_:offsetBy:);;;Argument[0..1];string-length",
        ";String;true;index(_:offsetBy:limitBy:);;;Argument[0..1];string-length",
        ";String.Index;true;init(encodedOffset:);;;Argument[0];string-length",
        ";NSRange;true;init(location:length:);;;Argument[0..1];nsstring-length",
        ";NSString;true;character(at:);;;Argument[0];nsstring-length",
        ";NSString;true;substring(from:);;;Argument[0];nsstring-length",
        ";NSString;true;substring(to:);;;Argument[0];nsstring-length",
        ";NSMutableString;true;character(at:);;;Argument[0];nsstring-length",
        ";NSMutableString;true;substring(from:);;;Argument[0];nsstring-length",
        ";NSMutableString;true;substring(to:);;;Argument[0];nsstring-length",
        ";NSMutableString;true;insert(_:at:);;;Argument[1];nsstring-length",
        ";;false;NSMakeRange(_:_:);;;Argument[0..1];nsstring-length",
      ]
  }
}

/**
 * An extra sink that don't fit into the CSV scheme (because we care about the actual
 * type the method is being called on, not just the type it's declared on).
 */
private class ExtraStringLengthConflationSink extends StringLengthConflationSink {
  StringType stringType;

  ExtraStringLengthConflationSink() {
    // sink is a length or offset argument of a call to `[stringType].[method]`.
    exists(CallExpr call |
      (
        stringType = TString()
        or
        stringType = TStringUtf8()
        or
        stringType = TStringUtf16()
        or
        stringType = TStringUnicodeScalars()
      ) and
      (
        call.getQualifier().getType().(NominalType).getFullName() = stringType.getName() or
        call.getQualifier().getType().(InOutType).getObjectType().(NominalType).getFullName() =
          stringType.getName()
      ) and
      (
        call.getStaticTarget().getName() =
          [
            "dropFirst(_:)", "dropLast(_:)", "prefix(_:)", "suffix(_:)", "removeFirst(_:)",
            "removeLast(_:)"
          ] and
        this.asExpr() = call.getArgument(0).getExpr()
        or
        call.getStaticTarget().getName() =
          ["formIndex(_:offsetBy:)", "formIndex(_:offsetBy:limitBy:)"] and
        this.asExpr() = call.getArgument([0, 1]).getExpr()
      )
    )
  }

  override StringType getCorrectStringType() { result = stringType }
}
