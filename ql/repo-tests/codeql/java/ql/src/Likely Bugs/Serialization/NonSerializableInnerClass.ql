/**
 * @name Serializable inner class of non-serializable class
 * @description A class that is serializable with an enclosing class that is not serializable
 *              causes serialization to fail.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/non-serializable-inner-class
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java
import semmle.code.java.JDKAnnotations

predicate isSerializable(RefType t) { exists(TypeSerializable ts | ts = t.getASupertype*()) }

predicate withinStaticContext(NestedClass c) {
  c.isStatic() or
  c.(AnonymousClass).getClassInstanceExpr().getEnclosingCallable().isStatic() // JLS 15.9.2
}

RefType enclosingInstanceType(Class inner) {
  not withinStaticContext(inner) and
  result = inner.(NestedClass).getEnclosingType()
}

predicate castTo(ClassInstanceExpr cie, RefType to) {
  exists(LocalVariableDeclExpr lvd | lvd.getInit() = cie | to = lvd.getType())
  or
  exists(Assignment a | a.getSource() = cie | to = a.getType())
  or
  exists(Call call, int n | call.getArgument(n) = cie | to = call.getCallee().getParameterType(n))
  or
  exists(ReturnStmt ret | ret.getResult() = cie | to = ret.getEnclosingCallable().getReturnType())
  or
  exists(ArrayCreationExpr ace | ace.getInit().getAnInit() = cie |
    to = ace.getType().(Array).getComponentType()
  )
}

predicate exceptions(NestedClass inner) {
  inner instanceof AnonymousClass
  or
  // Serializable objects with custom `readObject` or `writeObject` methods may write out
  // the "non-serializable" fields in a different way.
  inner.declaresMethod("readObject")
  or
  inner.declaresMethod("writeObject")
  or
  // Exclude cases where serialization warnings are deliberately suppressed.
  inner.suppressesWarningsAbout("serial")
  or
  // The class `inner` is a local class or non-public member class and
  // all its instance expressions are cast to non-serializable types.
  (inner instanceof LocalClass or not inner.isPublic()) and
  forall(ClassInstanceExpr cie, RefType target |
    cie.getConstructedType() = inner and castTo(cie, target)
  |
    not isSerializable(target)
  ) and
  // Exception 1: the expression is used as an argument to `writeObject()`.
  not exists(Call writeCall, ClassInstanceExpr cie | cie.getConstructedType() = inner |
    writeCall.getCallee().hasName("writeObject") and
    writeCall.getAnArgument() = cie
  ) and
  // Exception 2: the expression is thrown as an exception (exceptions should be serializable
  // due to use cases such as remote procedure calls, logging, etc.)
  not exists(ThrowStmt ts, ClassInstanceExpr cie |
    cie.getConstructedType() = inner and
    ts.getExpr() = cie
  ) and
  // Exception 3: if the programmer added a `serialVersionUID`, we interpret that
  // as an intent to make the class serializable.
  not exists(Field f | f.getDeclaringType() = inner | f.hasName("serialVersionUID"))
}

from NestedClass inner, Class outer, string advice
where
  inner.fromSource() and
  isSerializable(inner) and
  outer = enclosingInstanceType+(inner) and
  not isSerializable(outer) and
  not exceptions(inner) and
  (
    if inner instanceof LocalClass
    then advice = "Consider implementing readObject() and writeObject()."
    else advice = "Consider making the class static or implementing readObject() and writeObject()."
  )
select inner, "Serializable inner class of non-serializable class $@. " + advice, outer,
  outer.getName()
