/**
 * @name String length conflation
 * @description Using a length value from an `NSString` in a `String`, or a count from a `String` in an `NSString`, may cause unexpected behavior.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id swift/string-length-conflation
 * @tags security
 *       external/cwe/cwe-135
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * A flow state for this query, which is a type of Swift string encoding.
 */
class StringLengthConflationFlowState extends string {
  string equivClass;
  string singular;

  StringLengthConflationFlowState() {
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
 * A configuration for tracking string lengths originating from source that is
 * a `String` or an `NSString` object, to a sink of a different kind that
 * expects an incompatible measure of length.
 */
class StringLengthConflationConfiguration extends TaintTracking::Configuration {
  StringLengthConflationConfiguration() { this = "StringLengthConflationConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    exists(MemberRefExpr memberRef, string className, string varName |
      memberRef.getBase().getType().(NominalType).getABaseType*().getName() = className and
      memberRef.getMember().(VarDecl).getName() = varName and
      node.asExpr() = memberRef and
      (
        // result of a call to `String.count`
        className = "String" and
        varName = "count" and
        flowstate = "String"
        or
        // result of a call to `NSString.length`
        className = ["NSString", "NSMutableString"] and
        varName = "length" and
        flowstate = "NSString"
        or
        // result of a call to `String.utf8.count`
        className = "String.UTF8View" and
        varName = "count" and
        flowstate = "String.utf8"
        or
        // result of a call to `String.utf16.count`
        className = "String.UTF16View" and
        varName = "count" and
        flowstate = "String.utf16"
        or
        // result of a call to `String.unicodeScalars.count`
        className = "String.UnicodeScalarView" and
        varName = "count" and
        flowstate = "String.unicodeScalars"
      )
    )
  }

  /**
   * Holds if `node` is a sink and `flowstate` is the *correct* flow state for
   * that sink. We actually want to report incorrect flow states.
   */
  predicate isSinkImpl(DataFlow::Node node, string flowstate) {
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
          flowstate = "NSString"
        )
        or
        // arguments to function calls...
        // `NSMakeRange`
        funcName = "NSMakeRange(_:_:)" and
        arg = [0, 1] and
        call.getStaticTarget() = funcDecl and
        flowstate = "NSString"
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
        flowstate = "String"
      ) and
      // match up `funcName`, `arg`, `node`.
      funcDecl.getName() = funcName and
      call.getArgument(arg).getExpr() = node.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node node, string flowstate) {
    // Permit any *incorrect* flowstate, as those are the results the query
    // should report.
    exists(string correctFlowState |
      isSinkImpl(node, correctFlowState) and
      flowstate.(StringLengthConflationFlowState).getEquivClass() !=
        correctFlowState.(StringLengthConflationFlowState).getEquivClass()
    )
  }
}

from
  StringLengthConflationConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  StringLengthConflationFlowState sourceFlowState, StringLengthConflationFlowState sinkFlowstate,
  string message
where
  config.hasFlowPath(source, sink) and
  config.isSource(source.getNode(), sourceFlowState) and
  config.isSinkImpl(sink.getNode(), sinkFlowstate) and
  message =
    "This " + sourceFlowState + " length is used in " + sinkFlowstate.getSingular() +
      ", but it may not be equivalent."
select sink.getNode(), source, sink, message
