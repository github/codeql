/**
 * @name Summary statistics
 * @description A table of summary statistics about a database.
 * @kind table
 * @id swift/summary/summary-statistics
 * @tags summary
 */

import swift
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.SensitiveExprs

predicate statistic(string what, int value) {
  what = "Files" and value = count(File f)
  or
  what = "Expressions" and value = count(Expr e | not e.getFile() instanceof UnknownFile)
  or
  what = "Local flow sources" and value = count(LocalFlowSource s)
  or
  what = "Remote flow sources" and value = count(RemoteFlowSource s)
  or
  what = "Sensitive expressions" and value = count(SensitiveExpr e)
}

from string what, int value
where statistic(what, value)
select what, value
