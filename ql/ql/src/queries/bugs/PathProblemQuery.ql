/**
 * @name Missing edges query predicate in path-problem
 * @description A path-problem query should have a edges relation, and a problem query should not.
 * @kind problem
 * @problem.severity warning
 * @id ql/path-problem-query
 * @tags correctness
 *       maintainability
 * @precision medium
 */

import ql
import codeql_ql.bugs.PathProblemQueryQuery

from Query query, string msg, AstNode pred
where
  query.isPathProblem() and
  not query.hasEdgesRelation(_) and
  pred = any(TopLevel top | top.getLocation().getFile() = query) and // <- dummy value
  msg = "A path-problem query should have a edges relation."
  or
  query.isProblem() and
  query.hasEdgesRelation(pred) and
  msg = "A problem query should not have a $@."
select query, msg, pred, "edges relation"
