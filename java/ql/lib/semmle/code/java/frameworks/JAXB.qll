/** Definitions related to JAXB. */

import semmle.code.java.Type

library class JAXBElement extends Class {
  JAXBElement() {
    this.getAnAncestor().getQualifiedName() = "javax.xml.bind.JAXBElement" or
    this.getAnAnnotation().getType().getName() = "XmlRootElement"
  }
}

library class JAXBMarshalMethod extends Method {
  JAXBMarshalMethod() {
    this.getDeclaringType().getQualifiedName() = "javax.xml.bind.Marshaller" and
    this.getName() = "marshal"
  }
}

class JaxbAnnotationType extends AnnotationType {
  JaxbAnnotationType() { this.getPackage().getName() = "javax.xml.bind.annotation" }
}

class JaxbAnnotated extends Annotatable {
  JaxbAnnotated() { this.getAnAnnotation().getType() instanceof JaxbAnnotationType }

  predicate hasJaxbAnnotation(string name) { hasJaxbAnnotation(this, name) }
}

private predicate hasJaxbAnnotation(Annotatable annotatable, string name) {
  annotatable.getAnAnnotation().getType().(JaxbAnnotationType).hasName(name)
}

/**
 * A class that is mapped to an XML schema.
 */
class JaxbType extends Class {
  JaxbType() {
    // Explicitly an `XmlType`.
    hasJaxbAnnotation(this, "XmlType")
    or
    hasJaxbAnnotation(this, "XmlRootElement")
    or
    // There is at least one Jaxb annotation on a member of this class. The `@XmlType` is implied
    // on any class, but we limit our identification to those that have some reference to JAXB.
    exists(AnnotationType at |
      at = this.getAMember().getAnAnnotation().getType() and
      at instanceof JaxbMemberAnnotation
    )
  }

  private XmlAccessType getDeclaredAccessType() {
    // This ignores cases where the `XmlAccessorType` is defined on a supertype.
    exists(Annotation a |
      this.getAnAnnotation() = a and
      a.getType().(JaxbAnnotationType).hasName("XmlAccessorType")
    |
      result.getAnAccess() = a.getValue("value")
    )
  }

  /**
   * Gets the `XmlAccessType` associated with this class.
   */
  XmlAccessType getXmlAccessType() {
    if exists(this.getDeclaredAccessType())
    then result = this.getDeclaredAccessType()
    else
      // Default access type, if not specified.
      result.isPublicMember()
  }
}

/**
 * An `XmlAccessType` is applied to a `JaxbType` to indicate which members will be automatically bound.
 */
class XmlAccessType extends EnumConstant {
  XmlAccessType() {
    exists(EnumType type | type.getName() = "XmlAccessType" and type.getAnEnumConstant() = this)
  }

  /**
   * All public getter/setter pairs and public fields will be bound.
   */
  predicate isPublicMember() { this.getName() = "PUBLIC_MEMBER" }

  /**
   * All non-static, non-transient fields will be bound.
   */
  predicate isField() { this.getName() = "FIELD" }

  /**
   * All getter/setter pairs will be bound.
   */
  predicate isProperty() { this.getName() = "PROPERTY" }

  /**
   * Nothing will be bound automatically.
   */
  predicate isNone() { this.getName() = "NONE" }
}

/**
 * An annotation on a class member indicating that this member corresponds to an XML element or
 * attribute in the XML schema represented by this class.
 */
class JaxbMemberAnnotation extends JaxbAnnotationType {
  JaxbMemberAnnotation() {
    this.hasName("XmlElement") or
    this.hasName("XmlAttribute") or
    this.hasName("XmlElementRefs") or
    this.hasName("XmlElements")
  }
}

private predicate isTransient(Member m) { hasJaxbAnnotation(m, "XmlTransient") }

/**
 * A field is "bound" to an XML element or attribute if it is either annotated as such, or it is
 * bound due to the `XmlAccessType` of the declaring class.
 */
class JaxbBoundField extends Field {
  JaxbBoundField() {
    // Fields cannot be static, because JAXB creates instances.
    not this.isStatic() and
    // Fields cannot be final, because JAXB instantiates the object, then sets the properties.
    not this.isFinal() and
    // No transient fields are ever bound.
    not isTransient(this) and
    (
      // Explicitly annotated to be bound.
      exists(this.getAnAnnotation().getType().(JaxbMemberAnnotation))
      or
      // Within a JAXB type which has an `XmlAcessType` that binds this field.
      exists(JaxbType type | this.getDeclaringType() = type |
        // All fields are automatically bound in this access type.
        type.getXmlAccessType().isField()
        or
        // Only public fields are automatically bound in this access type.
        type.getXmlAccessType().isPublicMember() and this.isPublic()
      )
    )
  }
}

/**
 * A getter or setter method, as defined by whether the method name starts with "set" or "get".
 */
library class GetterOrSetterMethod extends Method {
  GetterOrSetterMethod() { this.getName().matches("get%") or this.getName().matches("set%") }

  Field getField() {
    result.getDeclaringType() = this.getDeclaringType() and
    result.getName().toLowerCase() = this.getName().suffix(3).toLowerCase()
  }

  /**
   * Holds if this method has a "pair"ed method, e.g. whether there is an equivalent getter if this
   * is a setter, and vice versa.
   */
  predicate isProperty() { exists(this.getPair()) }

  /**
   * Gets the "pair" method, if one exists; that is, the getter if this is a setter, and vice versa.
   */
  GetterOrSetterMethod getPair() { result.getField() = this.getField() and not result = this }

  /**
   * Gets either this method or its pair.
   */
  GetterOrSetterMethod getThisOrPair() { result.getField() = this.getField() }
}

/**
 * A getter or setter that is "bound" to an XML element or attribute.
 */
class JaxbBoundGetterSetter extends GetterOrSetterMethod {
  JaxbBoundGetterSetter() {
    // Neither setter nor getter should be marked transient.
    not isTransient(this) and
    not isTransient(this.getPair()) and
    (
      // An annotated field which indicates that this is a getter or setter.
      this.getField() instanceof JaxbBoundField
      or
      // An annotation on this method or the pair that indicate that it is a valid setter/getter.
      this.getThisOrPair().getAnAnnotation().getType() instanceof JaxbMemberAnnotation
      or
      // Within a JAXB type which has an `XmlAcessType` that binds this method.
      exists(JaxbType c | this.getDeclaringType() = c |
        // If this is a "property" - both a setter and getter present for the XML element or attribute
        // - the `XmlAccessType` of the declaring type may cause this property to be bound.
        this.isProperty() and
        (
          // In the `PUBLIC_MEMBER` case all public properties are considered bound.
          c.getXmlAccessType().isPublicMember() and this.isPublic()
          or
          // In "property" all properties are considered bound.
          c.getXmlAccessType().isProperty()
        )
      )
    )
  }
}
