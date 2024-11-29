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
predicate isGetPredicate(Predicate pred) { pred.getName().regexpMatch("(get|as)[A-Z].*") }

/**
 * Checks if a predicate has a return type.
 */
predicate hasReturnType(Predicate pred) { exists(pred.getReturnType()) }

/**
 * Checks if a predicate is an alias using getAlias().
 */
predicate isAlias(Predicate pred) { exists(pred.(ClasslessPredicate).getAlias()) }

/**
 * Returns "get" if the predicate name starts with "get", otherwise "as".
 */
string getPrefix(Predicate pred) {
  if pred.getName().matches("get%")
  then result = "get"
  else
    if pred.getName().matches("as%")
    then result = "as"
    else result = ""
}

from Predicate pred
where
  isGetPredicate(pred) and
  not hasReturnType(pred) and
  not isAlias(pred)
select pred, "This predicate starts with '" + getPrefix(pred) + "' but does not return a value."
