/**
 * @name Database query built from user-controlled sources
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id js/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 *       external/cwe/cwe-090
 *       external/cwe/cwe-943
 */

import javascript
import semmle.javascript.security.dataflow.SqlInjectionQuery as Sql
import semmle.javascript.security.dataflow.NosqlInjectionQuery as Nosql

module Merged =
  DataFlow::MergePathGraph<Sql::SqlInjectionFlow::PathNode, Nosql::NosqlInjectionFlow::PathNode,
    Sql::SqlInjectionFlow::PathGraph, Nosql::NosqlInjectionFlow::PathGraph>;

import DataFlow::DeduplicatePathGraph<Merged::PathNode, Merged::PathGraph>

from PathNode source, PathNode sink, string type
where
  Sql::SqlInjectionFlow::flowPath(source.getAnOriginalPathNode().asPathNode1(),
    sink.getAnOriginalPathNode().asPathNode1()) and
  type = "string"
  or
  Nosql::NosqlInjectionFlow::flowPath(source.getAnOriginalPathNode().asPathNode2(),
    sink.getAnOriginalPathNode().asPathNode2()) and
  type = "object"
select sink.getNode(), source, sink, "This query " + type + " depends on a $@.", source.getNode(),
  "user-provided value"
