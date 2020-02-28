/**
 * @name Constant return type on member
 * @description A 'const' modifier on a member function return type is useless. It is usually a typo or misunderstanding, since the syntax for a 'const' function is 'int foo() const', not 'const int foo()'.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/member-const-no-effect
 * @tags maintainability
 *       readability
 *       language-features
 */

import ReturnConstTypeCommon

from MemberFunction f, string message
where
  hasSuperfluousConstReturn(f) and
  if f.hasSpecifier("const") or f.isStatic()
  then
    message =
      "The 'const' modifier has no effect on return types. The 'const' modifying the return type can be removed."
  else
    message =
      "The 'const' modifier has no effect on return types. For a const function, the 'const' should go after the parameter list."
select f, message
