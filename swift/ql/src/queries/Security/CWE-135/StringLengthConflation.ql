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
class StringLengthConflationConfiguration extends DataFlow::Configuration {
  StringLengthConflationConfiguration() { this = "StringLengthConflationConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    // result of a call to `String.count`
    exists(MemberRefExpr member |
      member.getBase().getType().getName() = "String" and
      member.getMember().(VarDecl).getName() = "count" and
      node.asExpr() = member and
      flowstate = "String"
    )
    or
    // result of a call to `NSString.length`
    exists(MemberRefExpr member |
      member.getBase().getType().getName() = ["NSString", "NSMutableString"] and
      member.getMember().(VarDecl).getName() = "length" and
      node.asExpr() = member and
      flowstate = "NSString"
    )
    or
    // result of a call to `String.utf8.count`
    exists(MemberRefExpr member |
      member.getBase().getType().getName() = "String.UTF8View" and
      member.getMember().(VarDecl).getName() = "count" and
      node.asExpr() = member and
      flowstate = "String.utf8"
    )
    or
    // result of a call to `String.utf16.count`
    exists(MemberRefExpr member |
      member.getBase().getType().getName() = "String.UTF16View" and
      member.getMember().(VarDecl).getName() = "count" and
      node.asExpr() = member and
      flowstate = "String.utf16"
    )
    or
    // result of a call to `String.unicodeScalars.count`
    exists(MemberRefExpr member |
      member.getBase().getType().getName() = "String.UnicodeScalarView" and
      member.getMember().(VarDecl).getName() = "count" and
      node.asExpr() = member and
      flowstate = "String.unicodeScalars"
    )
  }

  /**
   * Holds if `node` is a sink and `flowstate` is the *correct* flow state for
   * that sink. We actually want to report incorrect flow states.
   */
  predicate isSinkImpl(DataFlow::Node node, string flowstate) {
    exists(
      AbstractFunctionDecl funcDecl, CallExpr call, string funcName, string paramName, int arg
    |
      (
        // arguments to method calls...
        exists(string className, ClassDecl c |
          (
            // `NSRange.init`
            className = "NSRange" and
            funcName = "init(location:length:)" and
            paramName = ["location", "length"]
            or
            // `NSString.character`
            className = ["NSString", "NSMutableString"] and
            funcName = "character(at:)" and
            paramName = "at"
            or
            // `NSString.character`
            className = ["NSString", "NSMutableString"] and
            funcName = "substring(from:)" and
            paramName = "from"
            or
            // `NSString.character`
            className = ["NSString", "NSMutableString"] and
            funcName = "substring(to:)" and
            paramName = "to"
            or
            // `NSMutableString.insert`
            className = "NSMutableString" and
            funcName = "insert(_:at:)" and
            paramName = "at"
          ) and
          c.getName() = className and
          c.getAMember() = funcDecl and
          call.getStaticTarget() = funcDecl and
          flowstate = "NSString"
        )
        or
        // arguments to function calls...
        // `NSMakeRange`
        funcName = "NSMakeRange(_:_:)" and
        paramName = ["loc", "len"] and
        call.getStaticTarget() = funcDecl and
        flowstate = "NSString"
        or
        // arguments to method calls...
        (
          // `String.dropFirst`, `String.dropLast`, `String.removeFirst`, `String.removeLast`
          funcName = ["dropFirst(_:)", "dropLast(_:)", "removeFirst(_:)", "removeLast(_:)"] and
          paramName = "k"
          or
          // `String.prefix`, `String.suffix`
          funcName = ["prefix(_:)", "suffix(_:)"] and
          paramName = "maxLength"
          or
          // `String.Index.init`
          funcName = "init(encodedOffset:)" and
          paramName = "offset"
          or
          // `String.index`
          funcName = ["index(_:offsetBy:)", "index(_:offsetBy:limitBy:)"] and
          paramName = "n"
          or
          // `String.formIndex`
          funcName = ["formIndex(_:offsetBy:)", "formIndex(_:offsetBy:limitBy:)"] and
          paramName = "distance"
        ) and
        call.getStaticTarget() = funcDecl and
        flowstate = "String"
      ) and
      // match up `funcName`, `paramName`, `arg`, `node`.
      funcDecl.getName() = funcName and
      funcDecl.getParam(pragma[only_bind_into](arg)).getName() = paramName and
      call.getArgument(pragma[only_bind_into](arg)).getExpr() = node.asExpr()
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

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // allow flow through `+`, `-`, `*` etc.
    node2.asExpr().(ArithmeticOperation).getAnOperand() = node1.asExpr()
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
