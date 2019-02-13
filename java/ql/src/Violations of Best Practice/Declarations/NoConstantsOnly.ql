/**
 * @name Constant interface anti-pattern
 * @description Implementing an interface (or extending an abstract class)
 *              only to put a number of constant definitions into scope is considered bad practice.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/constants-only-interface
 * @tags maintainability
 *       modularity
 */

import semmle.code.java.Member

class ConstantField extends Field {
  ConstantField() { this.isStatic() and this.isFinal() }
}

pragma[noinline]
predicate typeWithConstantField(RefType t) { exists(ConstantField f | f.getDeclaringType() = t) }

class ConstantRefType extends RefType {
  ConstantRefType() {
    fromSource() and
    (
      this instanceof Interface
      or
      this instanceof Class and this.isAbstract()
    ) and
    typeWithConstantField(this) and
    forall(Member m | m.getDeclaringType() = this |
      m.(Constructor).isDefaultConstructor() or
      m instanceof StaticInitializer or
      m instanceof ConstantField
    )
  }

  string getKind() {
    result = "interface" and this instanceof Interface
    or
    result = "class" and this instanceof Class
  }
}

from ConstantRefType t, RefType sub
where
  sub.fromSource() and
  sub.getASupertype() = t and
  not sub instanceof ConstantRefType and
  sub = sub.getSourceDeclaration()
select sub, "Type " + sub.getName() + " implements constant " + t.getKind() + " $@.", t, t.getName()
