/**
 * @name Predicates starting with "get" or "as" should return a value
 * @description Checks if predicates that start with "get" or "as" actually return a value.
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
 * Identifies predicates whose names start with "get", "as" followed by an uppercase letter.
 * This ensures that only predicates like "getValue" are matched, excluding names like "getter".
 */
predicate isGetPredicate(Predicate pred, string prefix) {
  prefix = pred.getName().regexpCapture("(get|as)[A-Z].*", 1)
}

/**
 * Checks if a predicate has a return type.
 */
predicate hasReturnType(Predicate pred) { exists(pred.getReturnTypeExpr()) }

/**
 * Checks if a predicate is an alias using getAlias().
 */
predicate isAlias(Predicate pred) { exists(pred.(ClasslessPredicate).getAlias()) }

from Predicate pred, string prefix
where
  isGetPredicate(pred, prefix) and
  not hasReturnType(pred) and
  not isAlias(pred)
select pred, "This predicate starts with '" + prefix + "' but does not return a value."
