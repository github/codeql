import java
import semmle.code.java.deadcode.DeadCode
import semmle.code.java.frameworks.javaee.Persistence
import semmle.code.java.frameworks.JAXB
import semmle.code.java.frameworks.jackson.JacksonSerializability

/**
 * A field that is from a source file.
 *
 * This defines the set of fields for which we will determine liveness.
 */
library class SourceField extends Field {
  SourceField() { fromSource() }
}

/**
 * A field is dead if it is never read by a live callable and it is neither reflectively accessed,
 * nor whitelisted.
 */
class DeadField extends SourceField {
  DeadField() { not this instanceof LiveField }

  /**
   * Holds if this dead field is already within the scope of a dead class, or reported by a dead
   * enum constant.
   */
  predicate isInDeadScope() {
    // `EnumConstant`s, and fields in dead classes, are reported in other queries.
    getDeclaringType() instanceof DeadClass or
    this instanceof EnumConstant
  }
}

/**
 * A field is live if it is read by a live callable, accessed by an annotation on a live element,
 * reflectively read, or whitelisted as read.
 */
class LiveField extends SourceField {
  LiveField() {
    exists(FieldRead access | access = getAnAccess() |
      isLive(access.getEnclosingCallable())
      or
      exists(Annotation a |
        // This is an access used in an annotation, either directly, or within the expression.
        a.getValue(_) = access.getParent*()
      |
        // The annotated element is a live callable.
        isLive(a.getAnnotatedElement())
        or
        // The annotated element is in a live callable.
        isLive(a.getAnnotatedElement().(LocalVariableDecl).getEnclosingCallable())
        or
        // The annotated element is a live field.
        a.getAnnotatedElement() instanceof LiveField
        or
        // The annotated element is a live source class or interface.
        // Note: We ignore annotation values on library classes, because they should only refer to
        // fields in library classes, not `fromSource()` fields.
        a.getAnnotatedElement() instanceof LiveClass
      )
    )
    or
    this instanceof ReflectivelyReadField
    or
    this instanceof WhitelistedLiveField
  }
}

/**
 * A field that may be read reflectively.
 */
abstract class ReflectivelyReadField extends Field { }

/**
 * A field which is dead, but should be considered as live.
 *
 * This should be used for cases where the field is dead, but should not be removed - for example,
 * because it may be useful in the future. If the field is live, but is not marked as a such, then
 * either a new `EntryPoint` should be added, or, if the field is accessed reflectively, this should
 * be identified by extending `ReflectivelyReadField` instead.
 *
 * Whitelisting a field will automatically cause the containing class to be considered as live.
 */
abstract class WhitelistedLiveField extends Field { }

/**
 * A static, final, long field named `serialVersionUID` in a class that extends `Serializable` acts as
 * a version number for the serialization framework.
 */
class SerialVersionUIDField extends ReflectivelyReadField {
  SerialVersionUIDField() {
    hasName("serialVersionUID") and
    isStatic() and
    isFinal() and
    getType().hasName("long") and
    getDeclaringType().getASupertype*() instanceof TypeSerializable
  }
}

/**
 * A field is read by the JAXB during serialization if it is a JAXB bound field, and if the
 * containing class is considered "live".
 */
class LiveJaxbBoundField extends ReflectivelyReadField, JaxbBoundField {
  LiveJaxbBoundField() {
    // If the class is considered live, it must have at least one live constructor.
    exists(Constructor c | c = getDeclaringType().getAConstructor() | isLive(c))
  }
}

/**
 * A field with an annotation which implies that it will be read by `JUnit` when running tests
 * within this class.
 */
class JUnitAnnotatedField extends ReflectivelyReadField {
  JUnitAnnotatedField() {
    hasAnnotation("org.junit.experimental.theories", "DataPoint") or
    hasAnnotation("org.junit.experimental.theories", "DataPoints") or
    hasAnnotation("org.junit.runners", "Parameterized$Parameter") or
    hasAnnotation("org.junit", "Rule") or
    hasAnnotation("org.junit", "ClassRule")
  }
}

/**
 * A field that is reflectively read via a call to `Class.getField(...)`.
 */
class ClassReflectivelyReadField extends ReflectivelyReadField {
  ClassReflectivelyReadField() {
    exists(ReflectiveFieldAccess fieldAccess | this = fieldAccess.inferAccessedField())
  }
}

/**
 * Consider all `JacksonSerializableField`s as reflectively read.
 */
class JacksonSerializableReflectivelyReadField extends ReflectivelyReadField,
  JacksonSerializableField { }

/**
 * A field that is used when applying Jackson mixins.
 */
class JacksonMixinReflextivelyReadField extends ReflectivelyReadField {
  JacksonMixinReflextivelyReadField() {
    exists(JacksonMixinType mixinType, JacksonAddMixinCall mixinCall |
      this = mixinType.getAMixedInField() and
      mixinType = mixinCall.getAMixedInType()
    |
      isLive(mixinCall.getEnclosingCallable())
    )
  }
}

/**
 * A field which is read by a JPA compatible Java persistence framework.
 */
class JPAReadField extends ReflectivelyReadField {
  JPAReadField() {
    exists(PersistentEntity entity |
      this = entity.getAField() and
      (
        entity.getAccessType() = "field" or
        this.hasAnnotation("javax.persistence", "Access")
      )
    |
      not this.hasAnnotation("javax.persistence", "Transient") and
      not isStatic() and
      not isFinal()
    )
  }
}
