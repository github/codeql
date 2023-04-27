/**
 * @name Predicate built from user-controlled sources
 * @description Building an NSPredicate from user-controlled sources may lead to attackers
 *              changing the predicate's intended logic.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id swift/predicate-injection
 * @tags security
 *       external/cwe/cwe-943
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.PredicateInjectionQuery
import PredicateInjectionFlow::PathGraph

from PredicateInjectionFlow::PathNode source, PredicateInjectionFlow::PathNode sink
where PredicateInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This predicate depends on a $@.", source.getNode(),
  "user-provided value"
