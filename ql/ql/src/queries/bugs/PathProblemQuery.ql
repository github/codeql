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
import codeql_ql.ast.internal.Module

FileOrModule hasEdgesRelation(ClasslessPredicate pred) {
  pred.getName() = "edges" and
  pred.hasAnnotation("query") and
  (
    result.asModule().getAMember() = pred
    or
    any(TopLevel top | top.getLocation().getFile() = result.asFile()).getAMember() = pred
  )
}

FileOrModule importsEdges(ClasslessPredicate pred) {
  result = hasEdgesRelation(pred)
  or
  exists(Import i |
    not (i.hasAnnotation("private") and i.getLocation().getFile().getExtension() = "qll") and
    importsEdges(pred) = i.getResolvedModule()
  |
    i = result.asModule().getAMember()
    or
    i = any(TopLevel top | top.getLocation().getFile() = result.asFile()).getAMember()
  )
}

class Query extends File {
  Query() { this.getExtension() = "ql" }

  predicate isPathProblem() {
    exists(QLDoc doc | doc.getLocation().getFile() = this |
      doc.getContents().matches("%@kind path-problem%")
    )
  }

  predicate isProblem() {
    exists(QLDoc doc | doc.getLocation().getFile() = this |
      doc.getContents().matches("%@kind problem%")
    )
  }

  predicate hasEdgesRelation(ClasslessPredicate pred) { importsEdges(pred).asFile() = this }
}

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
