/**
 * @name Count AST inconsistencies
 * @description Counts the various AST inconsistencies that may occur.
 *              This query is for internal use only and may change without notice.
 * @kind table
 * @id cpp/count-ast-inconsistencies
 */

import cpp

predicate hasDuplicateFunctionEntryPointLocation(Function func) {
  count(func.getEntryPoint().getLocation()) > 1
}

predicate hasDuplicateFunctionEntryPoint(Function func) { count(func.getEntryPoint()) > 1 }

select count(Function f | hasDuplicateFunctionEntryPoint(f) | f) as duplicateFunctionEntryPoint,
  count(Function f | hasDuplicateFunctionEntryPointLocation(f) | f) as duplicateFunctionEntryPointLocation
