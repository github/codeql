/**
 * @name Abstract class only declares common constants
 * @description Constants should be placed in a class where they belong logically, rather than in an
 *              abstract class containing just constants.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/constants-only-interface
 * @tags maintainability
 *       modularity
 */

import csharp

class ConstantField extends Field {
  ConstantField() {
    this.isStatic() and this.isReadOnly()
    or
    this.isConst()
  }
}

from Class c
where
  c.isSourceDeclaration() and
  c.isAbstract() and
  c.getAMember() instanceof ConstantField and
  forex(Member m | m = c.getAMember() |
    m instanceof ConstantField or
    m instanceof Constructor
  )
select c, "Class '" + c.getName() + "' only declares common constants."
