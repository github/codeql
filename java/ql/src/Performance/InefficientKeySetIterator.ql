/**
 * @name Inefficient use of key set iterator
 * @description Iterating through the values of a map using the key set is inefficient.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/inefficient-key-set-iterator
 * @tags efficiency
 *       maintainability
 */

import java

/** A local variable that is initialized using a key-set iterator. */
class KeySetIterator extends LocalVariableDecl {
  KeySetIterator() {
    exists(LocalVariableDeclExpr lvde, MethodCall init |
      lvde.getVariable() = this and
      lvde.getInit() = init and
      init.getMethod().hasName("iterator") and
      init.getQualifier().(MethodCall).getMethod().hasName("keySet")
    )
  }

  LocalVariableDecl getBase() {
    exists(LocalVariableDeclExpr lvde, MethodCall init |
      lvde.getVariable() = this and
      lvde.getInit() = init and
      init.getQualifier().(MethodCall).getQualifier().(VarAccess).getVariable() = result
    )
  }
}

predicate isKeyNext(Expr e, KeySetIterator it) {
  exists(MethodCall ma | ma = e |
    ma.getMethod().hasName("next") and
    ma.getQualifier().(VarAccess).getVariable() = it
  )
  or
  isKeyNext(e.(CastingExpr).getExpr(), it)
}

class Key extends LocalVariableDecl {
  Key() {
    exists(LocalVariableDeclExpr lvde |
      lvde.getVariable() = this and
      isKeyNext(lvde.getInit(), _)
    )
  }

  KeySetIterator getBase() {
    exists(LocalVariableDeclExpr lvde |
      lvde.getVariable() = this and
      isKeyNext(lvde.getInit(), result)
    )
  }
}

from MethodCall ma, Method get
where
  ma.getMethod() = get and
  get.hasName("get") and
  ma.getAnArgument().(VarAccess).getVariable().(Key).getBase().getBase() =
    ma.getQualifier().(VarAccess).getVariable()
select ma, "Inefficient use of key set iterator instead of entry set iterator."
