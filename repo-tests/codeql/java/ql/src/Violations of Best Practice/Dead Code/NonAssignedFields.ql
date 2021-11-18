/**
 * @name Field is never assigned a non-null value
 * @description A field that is never assigned a value (except possibly 'null') just returns the
 *              default value when it is read.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/unassigned-field
 * @tags reliability
 *       maintainability
 *       useless-code
 *       external/cwe/cwe-457
 */

import java
import semmle.code.java.Reflection

/**
 * Holds if `c` is of the form `Class<T>`, where `t` represents `T`.
 */
predicate isClassOf(ParameterizedClass c, RefType t) {
  c.getGenericType() instanceof TypeClass and
  c.getATypeArgument().getSourceDeclaration() = t.getSourceDeclaration()
}

/**
 * Holds if field `f` is potentially accessed by an `AtomicReferenceFieldUpdater`.
 */
predicate subjectToAtomicReferenceFieldUpdater(Field f) {
  exists(Class arfu, Method newUpdater, MethodAccess c |
    arfu.hasQualifiedName("java.util.concurrent.atomic", "AtomicReferenceFieldUpdater") and
    newUpdater = arfu.getAMethod() and
    newUpdater.hasName("newUpdater") and
    c.getMethod().getSourceDeclaration() = newUpdater and
    isClassOf(c.getArgument(0).getType(), f.getDeclaringType()) and
    isClassOf(c.getArgument(1).getType(), f.getType()) and
    c.getArgument(2).(StringLiteral).getValue() = f.getName()
  )
}

/**
 * Holds if `f` is ever looked up reflectively.
 */
predicate lookedUpReflectively(Field f) {
  exists(MethodAccess getDeclaredField |
    isClassOf(getDeclaredField.getQualifier().getType(), f.getDeclaringType()) and
    getDeclaredField.getMethod().hasName("getDeclaredField") and
    getDeclaredField.getArgument(0).(StringLiteral).getValue() = f.getName()
  )
}

/**
 * Holds if `rt` registers a VM observer in its static initialiser.
 */
predicate isVMObserver(RefType rt) {
  exists(Method register |
    register.getDeclaringType().hasQualifiedName("sun.jvm.hotspot.runtime", "VM") and
    register.hasName("registerVMInitializedObserver") and
    register.getAReference().getEnclosingCallable().(StaticInitializer).getDeclaringType() = rt
  )
}

from Field f, FieldRead fr
where
  f.fromSource() and
  fr.getField().getSourceDeclaration() = f and
  not f.getDeclaringType() instanceof EnumType and
  forall(Assignment ae, Field g | ae.getDest() = g.getAnAccess() and g.getSourceDeclaration() = f |
    ae.getSource() instanceof NullLiteral
  ) and
  not exists(UnaryAssignExpr ua, Field g |
    ua.getExpr() = g.getAnAccess() and
    g.getSourceDeclaration() = f
  ) and
  not f.isFinal() and
  // Exclude fields that may be accessed reflectively.
  not reflectivelyWritten(f) and
  not lookedUpReflectively(f) and
  not subjectToAtomicReferenceFieldUpdater(f) and
  // If an object containing `f` is, or may be, passed to a native method,
  // assume it initializes the field.
  not exists(Callable c | c.isNative() |
    c.getAParameter().getType() = f.getDeclaringType() or
    c.getAReference().getAnArgument().getType() = f.getDeclaringType() or
    c.getDeclaringType() = f.getDeclaringType()
  ) and
  // Exclude special VM classes.
  not isVMObserver(f.getDeclaringType())
select f, "Field " + f.getName() + " never assigned non-null value, yet it is read at $@.", fr,
  fr.getFile().getStem() + ".java:" + fr.getLocation().getStartLine()
