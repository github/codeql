/**
 * @name AV Rule 68
 * @description Unneeded implicitly generated member functions shall be explicitly disallowed.
 * @kind problem
 * @id cpp/jsf/av-rule-68
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * Implicitly generated member functions are:
 *   - default constructor, created if there is no explicit constructor and
 *     the class is instantiated (using new or by declaring a variable of that type)
 *   - copy constructor, created if there is no explicit copy constructor and
 *     the class is copied
 *   - copy assignment operator if there is no explicit copy assignment operator
 *     and the class is assigned from
 *   - destructor if no destructor is defined and the object is destroyed (goes out
 *     of scope as an automatic variable or delete is called
 */

/*
 * Now for disallowing generated member functions. There are two ways to do this:
 * define them as private, or inherit from a class that defines them as private.
 * It's okay if the class actually defines those members as public; so long as they
 * are not implicitly generated
 */

predicate definesDefaultConstructor(Class c) {
  exists(Constructor constr | constr.getDeclaringType() = c and constr.isDefault())
  or
  definesDefaultConstructor(c.getABaseClass())
}

predicate definesCopyConstructor(Class c) {
  exists(CopyConstructor constr | constr.getDeclaringType() = c) or
  definesCopyConstructor(c.getABaseClass())
}

predicate definesCopyAssignmentOperator(Class c) {
  exists(CopyAssignmentOperator op | op.getDeclaringType() = c) or
  definesCopyAssignmentOperator(c.getABaseClass())
}

predicate definesDestructor(Class c) {
  exists(Destructor op | op.getDeclaringType() = c) or
  definesDestructor(c.getABaseClass())
}

class ProperClass extends Class {
  ProperClass() { not this instanceof Struct }
}

/*
 * The query now checks for each case whether: (a) it is not needed, (b) it is not already defined,
 * and (c) it will be generated (ie for default constructors, if there is any constructor at all then default
 * constructors will not be generated)
 */

from ProperClass c, string msg
where
  not definesDefaultConstructor(c) and
  not c.hasConstructor() and
  msg =
    "AV Rule 68: class " + c.getName() +
      " does not need a default constructor and should explicitly disallow it."
  or
  not definesCopyConstructor(c) and
  msg =
    "AV Rule 68: class " + c.getName() +
      " does not need a copy constructor and should explicitly disallow it."
  or
  not definesCopyAssignmentOperator(c) and
  msg =
    "AV Rule 68: class " + c.getName() +
      " does not need a copy assignment operator and should explicitly disallow it."
  or
  not definesDestructor(c) and
  msg =
    "AV Rule 68: class " + c.getName() +
      " does not need a destructor and should explicitly disallow it."
select c, msg
