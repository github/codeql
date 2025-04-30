/**
 * @name Invalid string formatting
 * @description Calling 'string.Format()' with either an invalid format string or incorrect
 *              number of arguments may result in dropped arguments or a 'System.FormatException'.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/invalid-string-formatting
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.system.Text
import semmle.code.csharp.frameworks.Format
import FormatFlow::PathGraph

module FormatFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() instanceof StringLiteral }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Add flow via `System.Text.CompositeFormat.Parse`.
    exists(FormatCall call |
      call.getTarget() instanceof CompositeFormatParseMethod and
      pred.asExpr() = call.getFormatExpr() and
      succ.asExpr() = call
    )
  }

  predicate isSink(DataFlow::Node n) { exists(FormatCall c | n.asExpr() = c.getFormatExpr()) }
}

module FormatFlow = DataFlow::Global<FormatFlowConfig>;

private predicate invalidFormatString(
  InvalidFormatString src, FormatFlow::PathNode source, FormatFlow::PathNode sink, string msg,
  FormatCall call, string callString
) {
  source.getNode().asExpr() = src and
  sink.getNode().asExpr() = call.getFormatExpr() and
  FormatFlow::flowPath(source, sink) and
  msg = "Invalid format string used in $@ formatting call." and
  callString = "this"
}

private predicate unusedArgument(
  FormatCall call, FormatFlow::PathNode source, FormatFlow::PathNode sink, string msg,
  ValidFormatString src, string srcString, Expr unusedExpr, string unusedString
) {
  exists(int unused |
    source.getNode().asExpr() = src and
    sink.getNode().asExpr() = call.getFormatExpr() and
    not call.getTarget() instanceof CompositeFormatParseMethod and
    FormatFlow::flowPath(source, sink) and
    unused = call.getASuppliedArgument() and
    not unused = src.getAnInsert() and
    not src.getValue() = "" and
    msg = "The $@ ignores $@." and
    srcString = "format string" and
    unusedExpr = call.getSuppliedExpr(unused) and
    unusedString = "this supplied value"
  )
}

private predicate missingArgument(
  FormatCall call, FormatFlow::PathNode source, FormatFlow::PathNode sink, string msg,
  ValidFormatString src, string srcString
) {
  exists(int used, int supplied |
    source.getNode().asExpr() = src and
    sink.getNode().asExpr() = call.getFormatExpr() and
    not call.getTarget() instanceof CompositeFormatParseMethod and
    FormatFlow::flowPath(source, sink) and
    used = src.getAnInsert() and
    supplied = call.getSuppliedArguments() and
    used >= supplied and
    msg = "Argument '{" + used + "}' has not been supplied to $@ format string." and
    srcString = "this"
  )
}

from
  Element alert, FormatFlow::PathNode source, FormatFlow::PathNode sink, string msg, Element extra1,
  string extra1String, Element extra2, string extra2String
where
  invalidFormatString(alert, source, sink, msg, extra1, extra1String) and
  extra2 = extra1 and
  extra2String = extra1String
  or
  unusedArgument(alert, source, sink, msg, extra1, extra1String, extra2, extra2String)
  or
  missingArgument(alert, source, sink, msg, extra1, extra1String) and
  extra2 = extra1 and
  extra2String = extra1String
select alert, source, sink, msg, extra1, extra1String, extra2, extra2String
