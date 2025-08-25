/**
 * @name Query test without inline test expectations
 * @description Using inline test expectations is a best practice for writing query tests.
 * @kind problem
 * @problem.severity warning
 * @id ql/qlref-inline-expectations
 * @precision high
 */

import ql
import codeql_ql.ast.Yaml

from QlRefDocument f, TopLevel t, QueryDoc doc
where
  not f.usesInlineExpectations() and
  t.getFile() = f.getQueryFile() and
  doc = t.getQLDoc() and
  doc.getQueryKind() in ["problem", "path-problem"]
select f, "Query test does not use inline test expectations."
