/**
 * @name Functions2
 * @kind table
 */

import cpp

bindingset[c, f]
string describe(Class c, MemberFunction f) {
  f = c.getAConstructor() and
  result = "getAConstructor()"
  or
  f = c.getDestructor() and
  result = "getDestructor()"
  or
  f instanceof Constructor and
  result = "Constructor"
  or
  f instanceof Destructor and
  result = "Destructor"
  or
  f instanceof CopyConstructor and
  result = "CopyConstructor"
  or
  f instanceof MoveConstructor and
  result = "MoveConstructor"
  or
  f instanceof NoArgConstructor and
  result = "NoArgConstructor"
  or
  f instanceof ConversionOperator and
  result = "ConversionOperator"
}

from Class c, string ctype, MemberFunction f
where
  f.getDeclaringType() = c and
  if c instanceof Struct then ctype = "Struct" else ctype = "Class"
select c, ctype, f, concat(describe(c, f), ", ")
