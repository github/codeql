/**
 * @name Virtual call in constructor or destructor
 * @description Calling a virtual function from a constructor or destructor
 *              rarely has the intended effect. It is likely to either cause a
 *              bug or confuse readers.
 * @kind problem
 * @id cpp/virtual-call-in-structor
 * @problem.severity warning
 * @tags reliability
 */

import cpp

class Structor extends MemberFunction {
  Structor() {
    this instanceof Constructor or
    this instanceof Destructor
  }
}

from Structor s, FunctionCall c, VirtualFunction vf
where
  c.getEnclosingFunction() = s and
  vf = c.getTarget() and
  exists(VirtualFunction vff |
    vff.overrides(vf) and
    vff.getDeclaringType().getABaseClass+() = s.getDeclaringType()
  )
select c, "Virtual call in constructor or destructor."
