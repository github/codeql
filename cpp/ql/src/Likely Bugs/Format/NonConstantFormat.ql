/**
 * @name Non-constant format string
 * @description Passing a non-constant 'format' string to a printf-like function can lead
 *              to a mismatch between the number of arguments defined by the 'format' and the number
 *              of arguments actually passed to the function. If the format string ultimately stems
 *              from an untrusted source, this can be used for exploits.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/non-constant-format
 * @tags maintainability
 *       correctness
 *       security
 *       external/cwe/cwe-134
 */

import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.commons.Printf

predicate whitelistFunction(Function f, int arg) {
  // basic variations of gettext
  f.getName() = "_" and arg = 0
  or
  f.getName() = "gettext" and arg = 0
  or
  f.getName() = "dgettext" and arg = 1
  or
  f.getName() = "dcgettext" and arg = 1
  or
  // plural variations of gettext that take one format string for singular and another for plural form
  f.getName() = "ngettext" and
  (arg = 0 or arg = 1)
  or
  f.getName() = "dngettext" and
  (arg = 1 or arg = 2)
  or
  f.getName() = "dcngettext" and
  (arg = 1 or arg = 2)
}

predicate whitelisted(Expr e) {
  exists(FunctionCall fc, int arg | fc = e.(FunctionCall) |
    whitelistFunction(fc.getTarget(), arg) and
    isConst(fc.getArgument(arg))
  )
}

predicate isConst(Expr e) {
  e instanceof StringLiteral
  or
  whitelisted(e)
}

class ConstFlow extends DataFlow::Configuration {
  ConstFlow() { this = "ConstFlow" }

  override predicate isSource(DataFlow::Node source) { 
    isConst(source.asExpr())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FormattingFunctionCall fc |
      sink.asExpr() = fc.getArgument(fc.getFormatParameterIndex())
    )
  }
}

from FormattingFunctionCall call, Expr formatString
where call.getArgument(call.getFormatParameterIndex()) = formatString
  and not exists(ConstFlow cf, DataFlow::Node source, DataFlow::Node sink |
    cf.hasFlow(source, sink) and
    sink.asExpr() = formatString
  )
select call, "The format string argument to " + call.getTarget().getQualifiedName() + " should be constant to prevent security issues and other potential errors."