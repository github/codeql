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
 * A configuration for tracking string lengths originating from source that is
 * a `String` or an `NSString` object, to a sink of a different kind that
 * expects an incompatible measure of length.
 */
class StringLengthConflationConfiguration extends DataFlow::Configuration {
  StringLengthConflationConfiguration() { this = "StringLengthConflationConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    // result of a call to `String.count`
    exists(MemberRefExpr member |
      member.getBaseExpr().getType().getName() = "String" and
      member.getMember().(VarDecl).getName() = "count" and
      node.asExpr() = member and
      flowstate = "String"
    )
    or
    // result of a call to `NSString.length`
    exists(MemberRefExpr member |
      member.getBaseExpr().getType().getName() = ["NSString", "NSMutableString"] and
      member.getMember().(VarDecl).getName() = "length" and
      node.asExpr() = member and
      flowstate = "NSString"
    )
  }

  override predicate isSink(DataFlow::Node node, string flowstate) {
    exists(CallExpr call, string paramName, int arg |
      // arguments to method calls...
      exists(string className, string methodName, ClassDecl c, AbstractFunctionDecl f |
        (
          // `NSRange.init`
          className = "NSRange" and
          methodName = "init(location:length:)" and
          paramName = ["location", "length"]
          or
          // `NSString.character`
          className = ["NSString", "NSMutableString"] and
          methodName = "character(at:)" and
          paramName = "at"
          or
          // `NSString.character`
          className = ["NSString", "NSMutableString"] and
          methodName = "substring(from:)" and
          paramName = "from"
          or
          // `NSString.character`
          className = ["NSString", "NSMutableString"] and
          methodName = "substring(to:)" and
          paramName = "to"
          or
          // `NSMutableString.insert`
          className = "NSMutableString" and
          methodName = "insert(_:at:)" and
          paramName = "at"
        ) and
        c.getName() = className and
        c.getAMember() = f and // TODO: will this even work if its defined in a parent class?
        call.getFunction().(ApplyExpr).getStaticTarget() = f and
        f.getName() = methodName and
        f.getParam(pragma[only_bind_into](arg)).getName() = paramName and
        call.getArgument(pragma[only_bind_into](arg)).getExpr() = node.asExpr() and
        flowstate = "String" // `String` length flowing into `NSString`
      )
      or
      // arguments to function calls...
      exists(string funcName |
        // `NSMakeRange`
        funcName = "NSMakeRange(_:_:)" and
        paramName = ["loc", "len"] and
        call.getStaticTarget().getName() = funcName and
        call.getStaticTarget().getParam(pragma[only_bind_into](arg)).getName() = paramName and
        call.getArgument(pragma[only_bind_into](arg)).getExpr() = node.asExpr() and
        flowstate = "String" // `String` length flowing into `NSString`
      )
      or
      // arguments to function calls...
      exists(string funcName |
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
        call.getFunction().(ApplyExpr).getStaticTarget().getName() = funcName and
        call.getFunction()
            .(ApplyExpr)
            .getStaticTarget()
            .getParam(pragma[only_bind_into](arg))
            .getName() = paramName and
        call.getArgument(pragma[only_bind_into](arg)).getExpr() = node.asExpr() and
        flowstate = "NSString" // `NSString` length flowing into `String`
      )
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // allow flow through `+`, `-`, `*` etc.
    node2.asExpr().(ArithmeticOperation).getAnOperand() = node1.asExpr()
  }
}

from
  StringLengthConflationConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  string flowstate, string message
where
  config.hasFlowPath(source, sink) and
  config.isSink(sink.getNode(), flowstate) and
  (
    flowstate = "String" and
    message = "This String length is used in an NSString, but it may not be equivalent."
    or
    flowstate = "NSString" and
    message = "This NSString length is used in a String, but it may not be equivalent."
  )
select sink.getNode(), source, sink, message
