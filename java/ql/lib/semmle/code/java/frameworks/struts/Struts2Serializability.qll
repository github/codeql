/**
 * Provides classes and predicates for working with objects bound from Http requests in the context of
 * the Struts2 web framework.
 */

import java
private import semmle.code.java.Serializability
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.frameworks.struts.StrutsActions

/** A type whose values may be unmarshalled from an Http request by the Struts2 framework. */
abstract class Struts2DeserializableType extends Type { }

/** A type whose values are explicitly unmarshalled by from an Http request by the Struts2 framework. */
private class ExplicitlyReadStruts2DeserializableType extends Struts2DeserializableType {
  ExplicitlyReadStruts2DeserializableType() {
    exists(Struts2ActionSupportClass c |
      usesType(c.getASetterMethod().getField().getType(), this) and
      not this instanceof TypeClass and
      not this instanceof TypeObject
    )
  }
}

/** A type used in a `Struts2ActionField` declaration. */
private class FieldReferencedStruts2DeserializableType extends Struts2DeserializableType {
  FieldReferencedStruts2DeserializableType() {
    exists(Struts2ActionField f | usesType(f.getType(), this))
  }
}

/** A field that may be unmarshalled from an Http request using the Struts2 framework. */
private class Struts2ActionField extends DeserializableField {
  Struts2ActionField() {
    exists(Struts2DeserializableType superType |
      superType = this.getDeclaringType().getAnAncestor() and
      not superType instanceof TypeObject and
      superType.fromSource() and
      (
        this.isPublic()
        or
        exists(SetterMethod setter | setter.getField() = this and setter.isPublic())
      )
    )
  }
}

/** A field that should convey the taint from its qualifier to itself. */
private class Struts2ActionFieldInheritTaint extends DataFlow::FieldContent, TaintInheritingContent {
  Struts2ActionFieldInheritTaint() { this.getField() instanceof Struts2ActionField }
}
