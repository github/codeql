/**
 * @name Function pointer call
 * @description Function pointers are not permitted -- they make it impossible for a tool to prove the absence of recursion.
 * @kind problem
 * @id cpp/power-of-10/function-pointer
 * @problem.severity recommendation
 * @tags maintainability
 *       testability
 *       external/powerof10
 */

import cpp

from ExprCall e
select e, "Calls through function pointers are not permitted."
