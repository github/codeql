/**
 * @name Predicates starting with "get" should return a value
 * @description Checks if predicates that start with "get" actually return a value.
 * @kind problem
 * @problem.severity warning
 * @id ql/predicates-get-should-return-value
 * @tags correctness
 *       maintainability
 * @precision high
 */

import ql
import codeql_ql.ast.Ast

/**
 * Identifies predicates whose names start with "get" followed by an uppercase letter.
 * This ensures that only predicates like "getValue" are matched, excluding names like "getter".
 */
predicate isGetPredicate(Predicate pred) { pred.getName().regexpMatch("get[A-Z].*") }

/**
 * Checks if a predicate has a return type.
 */
predicate hasReturnType(Predicate pred) { exists(pred.getReturnType()) }

/**
 * Checks if a predicate is an alias using getAlias().
 */
predicate isAlias(Predicate pred) {
  pred instanceof ClasslessPredicate and exists(pred.(ClasslessPredicate).getAlias())
}

from Predicate pred
where
  isGetPredicate(pred) and
  not hasReturnType(pred) and
  not isAlias(pred)
select pred, "This predicate starts with 'get' but does not return a value."
