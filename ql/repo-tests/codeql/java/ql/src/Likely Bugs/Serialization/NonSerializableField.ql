/**
 * @name Non-serializable field
 * @description A non-transient field in a serializable class must also be serializable
 *              otherwise it causes the class to fail to serialize with a 'NotSerializableException'.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/non-serializable-field
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java
import semmle.code.java.JDKAnnotations
import semmle.code.java.Collections
import semmle.code.java.Maps
import semmle.code.java.frameworks.javaee.ejb.EJB

predicate externalizable(Interface interface) {
  interface.hasQualifiedName("java.io", "Externalizable")
}

predicate serializableOrExternalizable(Interface interface) {
  externalizable(interface) or
  interface instanceof TypeSerializable
}

predicate collectionOrMapType(RefType t) { t instanceof CollectionType or t instanceof MapType }

predicate serializableType(RefType t) {
  exists(RefType sup | sup = t.getASupertype*() | serializableOrExternalizable(sup))
  or
  // Collection interfaces are not serializable, but their implementations are
  // likely to be.
  collectionOrMapType(t) and
  not t instanceof RawType and
  forall(RefType param | param = t.(ParameterizedType).getATypeArgument() | serializableType(param))
  or
  exists(BoundedType bt | bt = t | serializableType(bt.getUpperBoundType()))
}

RefType reasonForNonSerializableCollection(ParameterizedType par) {
  collectionOrMapType(par) and
  result = par.getATypeArgument() and
  not serializableType(result)
}

string nonSerialReason(RefType t) {
  not serializableType(t) and
  if exists(reasonForNonSerializableCollection(t))
  then result = reasonForNonSerializableCollection(t).getName() + " is not serializable"
  else result = t.getName() + " is not serializable"
}

predicate exceptions(Class c, Field f) {
  f.getDeclaringType() = c and
  (
    // `Serializable` objects with custom `readObject` or `writeObject` methods
    // may write out the "non-serializable" fields in a different way.
    c.declaresMethod("readObject")
    or
    c.declaresMethod("writeObject")
    or
    // Exclude classes with suppressed warnings.
    c.suppressesWarningsAbout("serial")
    or
    // Exclude anonymous classes whose `ClassInstanceExpr` is assigned to
    // a variable on which serialization warnings are suppressed.
    exists(Variable v |
      v.getAnAssignedValue() = c.(AnonymousClass).getClassInstanceExpr() and
      v.suppressesWarningsAbout("serial")
    )
    or
    f.isTransient()
    or
    f.isStatic()
    or
    // Classes that implement `Externalizable` completely take over control during serialization.
    externalizable(c.getASupertype+())
    or
    // Stateless session beans are not normally serialized during their usual life-cycle
    // but are forced by their expected supertype to be serializable.
    // Arguably, warnings for their non-serializable fields can therefore be suppressed in practice.
    c instanceof StatelessSessionEJB
    or
    // Enum types are serialized by name, so it doesn't matter if they have non-serializable fields.
    c instanceof EnumType
  )
}

from Class c, Field f, string reason
where
  c.fromSource() and
  c.getASupertype+() instanceof TypeSerializable and
  f.getDeclaringType() = c and
  not exceptions(c, f) and
  reason = nonSerialReason(f.getType())
select f,
  "This field is in a serializable class, " + " but is not serializable itself because " + reason +
    "."
