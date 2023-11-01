/**
 * @name Summary Statistics
 * @description A table of summary statistics about a database.
 * @kind table
 * @id swift/summary/summary-statistics
 * @tags summary
 */

import swift
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.SensitiveExprs
import codeql.swift.regex.Regex

predicate statistic(string what, string value) {
  what = "Files" and value = count(File f).toString()
  or
  what = "Lines of code" and value = sum(File f | | f.getNumberOfLinesOfCode()).toString()
  or
  what = "Compiler errors" and value = count(CompilerError d).toString()
  or
  what = "Compiler warnings" and value = count(CompilerWarning d).toString()
  or
  what = "Expressions" and value = count(Expr e | not e.getFile() instanceof UnknownFile).toString()
  or
  what = "Local flow sources" and value = count(LocalFlowSource s).toString()
  or
  what = "Remote flow sources" and value = count(RemoteFlowSource s).toString()
  or
  what = "Sensitive expressions" and value = count(SensitiveExpr e).toString()
  or
  what = "Regular expression evals" and value = count(RegexEval e).toString()
  or
  what = "Regular expressions evaluated" and
  value = count(RegexEval e | | e.getARegex()).toString()
}

from string what, string value
where statistic(what, value)
select what, value
