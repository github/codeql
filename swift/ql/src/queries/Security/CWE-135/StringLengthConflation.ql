/**
 * @name String length conflation
 * @description TODO
 * @kind problem
 * @problem.severity TODO
 * @security-severity TODO
 * @precision TODO
 * @id swift/string-length-conflation
 * @tags security
 *       external/cwe/cwe-135
 */

import swift
import codeql.swift.dataflow.DataFlow
import DataFlow::PathGraph

class StringLengthConflationConfiguration extends DataFlow::Configuration {
  StringLengthConflationConfiguration() { this = "StringLengthConflationConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    // result of a call to to `String.count`
    exists(MemberRefExpr member |
      member.getBaseExpr().getType().getName() = "String" and
      member.getMember().(VarDecl).getName() = "count" and
      node.asExpr() = member and
      flowstate = "String"
    )
  }

  override predicate isSink(DataFlow::Node node, string flowstate) {
    // arguments to method calls...
    exists(
      string className, string methodName, string paramName, ClassDecl c, AbstractFunctionDecl f,
      CallExpr call, int arg
    |
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
      f.getParam(arg).getName() = paramName and
      call.getArgument(arg).getExpr() = node.asExpr() and
      flowstate = "String" // `String` length flowing into `NSString`
    )
    or
    // arguments to function calls...
    exists(string funcName, string paramName, CallExpr call, int arg |
      // `NSMakeRange`
      funcName = "NSMakeRange(_:_:)" and
      paramName = ["loc", "len"] and
      call.getStaticTarget().getName() = funcName and
      call.getStaticTarget().getParam(arg).getName() = paramName and
      call.getArgument(arg).getExpr() = node.asExpr() and
      flowstate = "String" // `String` length flowing into `NSString`
    )
  }
}

from StringLengthConflationConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "RESULT"
