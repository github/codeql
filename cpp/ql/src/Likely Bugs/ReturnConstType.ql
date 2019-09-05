/**
 * @name Constant return type
 * @description A 'const' modifier on a function return type is useless and should be removed for clarity.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/non-member-const-no-effect
 * @tags maintainability
 *       readability
 *       language-features
 */

import ReturnConstTypeCommon

from Function f
where
  hasSuperfluousConstReturn(f) and
  not f instanceof MemberFunction
select f, "The 'const' modifier has no effect on a return type and can be removed."
