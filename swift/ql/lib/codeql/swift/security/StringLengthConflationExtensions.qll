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
    name = "String.utf8" and
    singular = "a String.utf8" and
    equivClass = this and
    csvLabel = "string-utf8-length"
    or
    this = TStringUtf16() and
    name = "String.utf16" and
    singular = "a String.utf16" and
    equivClass = TNsString() and
    csvLabel = "string-utf16-length"
    or
    this = TStringUnicodeScalars() and
    name = "String.unicodeScalars" and
    singular = "a String.unicodeScalars" and
    equivClass = this and
    csvLabel = "string-unicodescalars-length"
  }

  /** Gets a textual representation of this string type. */
  string toString() { result = name }

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
 * A sanitizer for string length conflation vulnerabilities.
 */
abstract class StringLengthConflationSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class StringLengthConflationAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
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
    exists(MemberRefExpr memberRef, string typeName |
      (
        // result of a call to `String.utf8.count`
        typeName = "String.UTF8View" and
        stringType = TStringUtf8()
        or
        // result of a call to `String.utf16.count`
        typeName = "String.UTF16View" and
        stringType = TStringUtf16()
        or
        // result of a call to `String.unicodeScalars.count`
        typeName = "String.UnicodeScalarView" and
        stringType = TStringUnicodeScalars()
      ) and
      memberRef.getBase().getType().(NominalType).getName() = typeName and
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
        ";Sequence;true;dropFirst(_:);;;Argument[0];string-length",
        ";Sequence;true;dropLast(_:);;;Argument[0];string-length",
        ";Sequence;true;prefix(_:);;;Argument[0];string-length",
        ";Sequence;true;suffix(_:);;;Argument[0];string-length",
        ";Collection;true;formIndex(_:offsetBy:);;;Argument[0..1];string-length",
        ";Collection;true;formIndex(_:offsetBy:limitBy:);;;Argument[0..1];string-length",
        ";Collection;true;removeFirst(_:);;;Argument[0];string-length",
        ";RangeReplaceableCollection;true;removeLast(_:);;;Argument[0];string-length",
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
