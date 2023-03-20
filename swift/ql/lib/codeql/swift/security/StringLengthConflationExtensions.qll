/**
 * Provides classes and predicates for reasoning about string length
 * conflation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A type of Swift string encoding. This class is used as a flow state for
 * the string length conflation taint tracking configuration.
 */
class StringType extends string {
  string singular;
  string equivClass;
  string csvLabel;

  StringType() {
    this = "String" and
    singular = "a String" and
    equivClass = "String" and
    csvLabel = "string-length"
    or
    this = "NSString" and
    singular = "an NSString" and
    equivClass = "NSString" and
    csvLabel = "nsstring-length"
    or
    this = "String.utf8" and
    singular = "a String.utf8" and
    equivClass = "String.utf8" and
    csvLabel = "string-utf8-length"
    or
    this = "String.utf16" and
    singular = "a String.utf16" and
    equivClass = "NSString" and
    csvLabel = "string-utf16-length"
    or
    this = "String.unicodeScalars" and
    singular = "a String.unicodeScalars" and
    equivClass = "String.unicodeScalars" and
    csvLabel = "string-unicodescalars-length"
  }

  /**
   * Gets the equivalence class for this string type. If these are equal,
   * they should be treated as equivalent.
   */
  string getEquivClass() { result = equivClass }

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

private class DefaultStringLengthConflationSource extends StringLengthConflationSource {
  StringType stringType;

  DefaultStringLengthConflationSource() {
    exists(MemberRefExpr memberRef, string className, string varName |
      memberRef.getBase().getType().(NominalType).getABaseType*().getName() = className and
      memberRef.getMember().(VarDecl).getName() = varName and
      this.asExpr() = memberRef and
      (
        // result of a call to `String.count`
        className = "String" and
        varName = "count" and
        stringType = "String"
        or
        // result of a call to `NSString.length`
        className = ["NSString", "NSMutableString"] and
        varName = "length" and
        stringType = "NSString"
        or
        // result of a call to `String.utf8.count`
        className = "String.UTF8View" and
        varName = "count" and
        stringType = "String.utf8"
        or
        // result of a call to `String.utf16.count`
        className = "String.UTF16View" and
        varName = "count" and
        stringType = "String.utf16"
        or
        // result of a call to `String.unicodeScalars.count`
        className = "String.UnicodeScalarView" and
        varName = "count" and
        stringType = "String.unicodeScalars"
      )
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
