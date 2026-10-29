/**
 * @name Rule of three
 * @description Classes that have an explicit destructor, copy constructor, or
 *              copy assignment operator may behave inconsistently if they do
 *              not have all three.
 * @kind problem
 * @id cpp/rule-of-three
 * @problem.severity warning
 * @tags reliability
 */

import cpp

class BigThree extends MemberFunction {
  BigThree() {
    this instanceof Destructor or
    this instanceof CopyConstructor or
    this instanceof CopyAssignmentOperator
  }
}

from Class c, BigThree b
where
  b.getDeclaringType() = c and
  not (
    c.hasDestructor() and
    c.getAMemberFunction() instanceof CopyConstructor and
    c.getAMemberFunction() instanceof CopyAssignmentOperator
  )
select c,
  "Class defines a destructor, copy constructor, or copy assignment operator, but not all three."
