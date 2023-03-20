/**
 * Provides classes and predicates for reasoning about string length
 * conflation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * A type of Swift string encoding. This class is used as a flow state for
 * the string length conflation taint tracking configuration.
 */
class StringType extends string {
  string singular;
  string equivClass;

  StringType() {
    this = "String" and singular = "a String" and equivClass = "String"
    or
    this = "NSString" and singular = "an NSString" and equivClass = "NSString"
    or
    this = "String.utf8" and singular = "a String.utf8" and equivClass = "String.utf8"
    or
    this = "String.utf16" and singular = "a String.utf16" and equivClass = "NSString"
    or
    this = "String.unicodeScalars" and
    singular = "a String.unicodeScalars" and
    equivClass = "String.unicodeScalars"
  }

  /**
   * Gets the equivalence class for this flow state. If these are equal,
   * they should be treated as equivalent.
   */
  string getEquivClass() { result = equivClass }

  /**
   * Gets text for the singular form of this flow state.
   */
  string getSingular() { result = singular }
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

private class DefaultStringLengthConflationSink extends StringLengthConflationSink {
  StringType correctStringType;

  DefaultStringLengthConflationSink() {
    exists(AbstractFunctionDecl funcDecl, CallExpr call, string funcName, int arg |
      (
        // arguments to method calls...
        exists(string className, ClassOrStructDecl c |
          (
            // `NSRange.init`
            className = "NSRange" and
            funcName = "init(location:length:)" and
            arg = [0, 1]
            or
            // `NSString.character`
            className = ["NSString", "NSMutableString"] and
            funcName = "character(at:)" and
            arg = 0
            or
            // `NSString.character`
            className = ["NSString", "NSMutableString"] and
            funcName = "substring(from:)" and
            arg = 0
            or
            // `NSString.character`
            className = ["NSString", "NSMutableString"] and
            funcName = "substring(to:)" and
            arg = 0
            or
            // `NSMutableString.insert`
            className = "NSMutableString" and
            funcName = "insert(_:at:)" and
            arg = 1
          ) and
          c.getName() = className and
          c.getABaseTypeDecl*().(ClassOrStructDecl).getAMember() = funcDecl and
          call.getStaticTarget() = funcDecl and
          correctStringType = "NSString"
        )
        or
        // arguments to function calls...
        // `NSMakeRange`
        funcName = "NSMakeRange(_:_:)" and
        arg = [0, 1] and
        call.getStaticTarget() = funcDecl and
        correctStringType = "NSString"
        or
        // arguments to method calls...
        (
          // `String.dropFirst`, `String.dropLast`, `String.removeFirst`, `String.removeLast`
          funcName = ["dropFirst(_:)", "dropLast(_:)", "removeFirst(_:)", "removeLast(_:)"] and
          arg = 0
          or
          // `String.prefix`, `String.suffix`
          funcName = ["prefix(_:)", "suffix(_:)"] and
          arg = 0
          or
          // `String.Index.init`
          funcName = "init(encodedOffset:)" and
          arg = 0
          or
          // `String.index`
          funcName = ["index(_:offsetBy:)", "index(_:offsetBy:limitBy:)"] and
          arg = [0, 1]
          or
          // `String.formIndex`
          funcName = ["formIndex(_:offsetBy:)", "formIndex(_:offsetBy:limitBy:)"] and
          arg = [0, 1]
        ) and
        call.getStaticTarget() = funcDecl and
        correctStringType = "String"
      ) and
      // match up `funcName`, `arg`, `node`.
      funcDecl.getName() = funcName and
      call.getArgument(arg).getExpr() = this.asExpr()
    )
  }

  override StringType getCorrectStringType() { result = correctStringType }
}
