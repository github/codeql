/**
 * Provides classes and predicates for working with Java Serialization in the context of
 * the `com.fasterxml.jackson` JSON processing framework.
 */

import java
import semmle.code.java.Serializability
import semmle.code.java.Reflection
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSteps

/**
 * A `@com.fasterxml.jackson.annotation.JsonIgnore` annoation.
 */
class JacksonJsonIgnoreAnnotation extends NonReflectiveAnnotation {
  JacksonJsonIgnoreAnnotation() {
    exists(AnnotationType anntp | anntp = this.getType() |
      anntp.hasQualifiedName("com.fasterxml.jackson.annotation", "JsonIgnore")
    )
  }
}

/** A type whose values may be serialized using the Jackson JSON framework. */
abstract class JacksonSerializableType extends Type { }

/**
 * A method used for serializing objects using Jackson. The final parameter is the object to be
 * serialized.
 */
private class JacksonWriteValueMethod extends Method, TaintPreservingCallable {
  JacksonWriteValueMethod() {
    (
      this.getDeclaringType().hasQualifiedName("com.fasterxml.jackson.databind", "ObjectWriter") or
      this.getDeclaringType().hasQualifiedName("com.fasterxml.jackson.databind", "ObjectMapper")
    ) and
    this.getName().matches("writeValue%") and
    this.getParameter(this.getNumberOfParameters() - 1).getType() instanceof TypeObject
  }

  override predicate returnsTaintFrom(int arg) {
    this.getNumberOfParameters() = 1 and
    arg = 0
  }

  override predicate transfersTaint(int src, int sink) {
    this.getNumberOfParameters() > 1 and
    src = this.getNumberOfParameters() - 1 and
    sink = 0
  }
}

/**
 * A method used for deserializing objects using Jackson. The first parameter is the object to be
 * deserialized.
 */
private class JacksonReadValueMethod extends Method, TaintPreservingCallable {
  JacksonReadValueMethod() {
    (
      this.getDeclaringType().hasQualifiedName("com.fasterxml.jackson.databind", "ObjectReader") or
      this.getDeclaringType().hasQualifiedName("com.fasterxml.jackson.databind", "ObjectMapper")
    ) and
    this.hasName(["readValue", "readValues"])
  }

  override predicate returnsTaintFrom(int arg) { arg = 0 }
}

/** A type whose values are explicitly serialized in a call to a Jackson method. */
private class ExplicitlyWrittenJacksonSerializableType extends JacksonSerializableType {
  ExplicitlyWrittenJacksonSerializableType() {
    exists(MethodCall ma |
      // A call to a Jackson write method...
      ma.getMethod() instanceof JacksonWriteValueMethod and
      // ...where `this` is used in the final argument, indicating that this type will be serialized.
      usesType(ma.getArgument(ma.getNumArgument() - 1).getType(), this)
    )
  }
}

/** A type used in a `JacksonSerializableField` declaration. */
private class FieldReferencedJacksonSerializableType extends JacksonSerializableType {
  FieldReferencedJacksonSerializableType() {
    exists(JacksonSerializableField f | usesType(f.getType(), this))
  }
}

/** A type whose values may be deserialized by the Jackson JSON framework. */
abstract class JacksonDeserializableType extends Type { }

private module TypeLiteralToJacksonDatabindFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof TypeLiteral }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma, Method m, int i |
      ma.getArgument(i) = sink.asExpr() and
      m = ma.getMethod() and
      m.getParameterType(i) instanceof TypeClass and
      exists(RefType decl | decl = m.getDeclaringType() |
        decl.hasQualifiedName("com.fasterxml.jackson.databind", "ObjectReader") or
        decl.hasQualifiedName("com.fasterxml.jackson.databind", "ObjectMapper") or
        decl.hasQualifiedName("com.fasterxml.jackson.databind.type", "TypeFactory")
      )
    )
  }
}

private module TypeLiteralToJacksonDatabindFlow =
  DataFlow::Global<TypeLiteralToJacksonDatabindFlowConfig>;

private TypeLiteral getSourceWithFlowToJacksonDatabind() {
  TypeLiteralToJacksonDatabindFlow::flow(DataFlow::exprNode(result), _)
}

/** A type whose values are explicitly deserialized in a call to a Jackson method. */
private class ExplicitlyReadJacksonDeserializableType extends JacksonDeserializableType {
  ExplicitlyReadJacksonDeserializableType() {
    usesType(getSourceWithFlowToJacksonDatabind().getReferencedType(), this)
    or
    exists(MethodCall ma |
      // A call to a Jackson read method...
      ma.getMethod() instanceof JacksonReadValueMethod and
      // ...where `this` is used in the final argument, indicating that this type will be deserialized.
      usesType(ma.getArgument(ma.getNumArgument() - 1).getType(), this)
    )
  }
}

/** A type used in a `JacksonDeserializableField` declaration. */
private class FieldReferencedJacksonDeserializableType extends JacksonDeserializableType {
  FieldReferencedJacksonDeserializableType() {
    exists(JacksonDeserializableField f | usesType(f.getType(), this))
  }
}

/** A field that may be serialized using the Jackson JSON framework. */
class JacksonSerializableField extends SerializableField {
  JacksonSerializableField() {
    exists(JacksonSerializableType superType |
      superType = this.getDeclaringType().getAnAncestor() and
      not superType instanceof TypeObject and
      superType.fromSource()
    ) and
    not this.getAnAnnotation() instanceof JacksonJsonIgnoreAnnotation
  }
}

/** A field that may be deserialized using the Jackson JSON framework. */
class JacksonDeserializableField extends DeserializableField {
  JacksonDeserializableField() {
    exists(JacksonDeserializableType superType |
      superType = this.getDeclaringType().getAnAncestor() and
      not superType instanceof TypeObject and
      superType.fromSource()
    ) and
    not this.getAnAnnotation() instanceof JacksonJsonIgnoreAnnotation
  }
}

/** A call to a field that may be deserialized using the Jackson JSON framework. */
private class JacksonDeserializableFieldAccess extends FieldAccess {
  JacksonDeserializableFieldAccess() { this.getField() instanceof JacksonDeserializableField }
}

/**
 * When an object is deserialized by the Jackson JSON framework using a tainted input source,
 * the fields that the framework deserialized are themselves tainted input data.
 */
private class JacksonDeserializedTaintStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    DataFlow::getFieldQualifier(node2.asExpr().(JacksonDeserializableFieldAccess)) = node1
  }
}

/**
 * A call to the `addMixInAnnotations` or `addMixIn` Jackson method.
 *
 * This informs Jackson to treat the annotations on the second class argument as if they were on
 * the first class argument. This allows adding annotations to library classes, for example.
 */
class JacksonAddMixinCall extends MethodCall {
  JacksonAddMixinCall() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType().hasQualifiedName("com.fasterxml.jackson.databind", "ObjectMapper")
    |
      m.hasName("addMixIn") or
      m.hasName("addMixInAnnotations")
    )
  }

  /**
   * Gets a possible type for the target of the mixing, if any can be deduced.
   */
  RefType getATarget() { result = inferClassParameterType(this.getArgument(0)) }

  /**
   * Gets a possible type that will be mixed in, if any can be deduced.
   */
  RefType getAMixedInType() { result = inferClassParameterType(this.getArgument(1)) }
}

/**
 * A Jackson annotation.
 */
class JacksonAnnotation extends Annotation {
  JacksonAnnotation() { this.getType().getPackage().hasName("com.fasterxml.jackson.annotation") }
}

/**
 * A type used as a Jackson mixin type.
 */
class JacksonMixinType extends ClassOrInterface {
  JacksonMixinType() { exists(JacksonAddMixinCall mixinCall | this = mixinCall.getAMixedInType()) }

  /**
   * Gets a type that this type is mixed into.
   */
  RefType getATargetType() {
    exists(JacksonAddMixinCall mixinCall | this = mixinCall.getAMixedInType() |
      result = mixinCall.getATarget()
    )
  }

  /**
   * Gets a callable from this type that is mixed in by Jackson.
   */
  Callable getAMixedInCallable() {
    result = this.getACallable() and
    (
      result.(Constructor).isDefaultConstructor() or
      result.getAnAnnotation() instanceof JacksonAnnotation or
      result.getAParameter().getAnAnnotation() instanceof JacksonAnnotation
    )
  }

  /**
   * Gets a field that is mixed in by Jackson.
   */
  Field getAMixedInField() {
    result = this.getAField() and
    result.getAnAnnotation() instanceof JacksonAnnotation
  }
}

/** A callable used as a Jackson mixin callable. */
class JacksonMixedInCallable extends Callable {
  JacksonMixedInCallable() {
    exists(JacksonMixinType mixinType | this = mixinType.getAMixedInCallable())
  }

  /**
   * Gets a candidate target type that this callable can be mixed into.
   */
  RefType getATargetType() {
    exists(JacksonMixinType mixinType | this = mixinType.getAMixedInCallable() |
      result = mixinType.getATargetType()
    )
  }

  /**
   * Gets a callable on a possible target that this is mixed into.
   */
  Callable getATargetCallable() {
    exists(RefType targetType | targetType = this.getATargetType() |
      result = this.getATargetType().getACallable() and
      if this instanceof Constructor
      then
        // The mixed in type will have a different name to the target type, so just compare the
        // parameters.
        result.getSignature().suffix(targetType.getName().length()) =
          this.getSignature().suffix(this.getDeclaringType().getName().length())
      else
        // Signatures should match
        result.getSignature() = this.getSignature()
    )
  }
}
