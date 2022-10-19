/**
 * @name Summary statistics
 * @description A table of summary statistics about a database. Includes
 *              values that measure its size, and the numbers of certain
 *              features interesting to analysis that have been found.
 * @kind table
 * @id swift/summary/summary-statistics
 */

import swift
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.SensitiveExprs

predicate statistic(string what, int value) {
  what = "Files" and value = count(File f)
  or
  what = "Expressions" and value = count(Expr e)
  or
  what = "Remote flow sources" and value = count(RemoteFlowSource s)
  or
  what = "Sensitive expressions" and value = count(SensitiveExpr e)
}

from string what, int value
where statistic(what, value)
select what, value
