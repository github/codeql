/**
 * Provides classes and predicates for working with Java Serialization in the context of
 * the `com.google.gson` JSON processing framework.
 */

import java
private import semmle.code.java.Serializability
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/**
 * A method used for deserializing objects using Gson. The first parameter is the object to be
 * deserialized.
 */
private class GsonReadValueMethod extends Method {
  GsonReadValueMethod() { this.hasQualifiedName("com.google.gson", "Gson", "fromJson") }
}

/** A type whose values may be deserialized by the Gson JSON framework. */
abstract class GsonDeserializableType extends Type { }

/** A type whose values are explicitly deserialized in a call to a Gson method. */
private class ExplicitlyReadGsonDeserializableType extends GsonDeserializableType {
  ExplicitlyReadGsonDeserializableType() {
    exists(MethodCall ma |
      // A call to a Gson read method...
      ma.getMethod() instanceof GsonReadValueMethod and
      // ...where `this` is used in the final argument, indicating that this type will be deserialized.
      // TODO: find a way to get the type represented by java.lang.reflect.Type and com.google.gson.reflect.TypeToken
      // fromJson(String json, TypeToken<T> typeOfT)
      // fromJson(String json, Type typeOfT)
      usesType(ma.getArgument(1).getType(), this) and
      not this instanceof TypeClass and
      not this instanceof TypeObject
    )
  }
}

/** A type used in a `GsonDeserializableField` declaration. */
private class FieldReferencedGsonDeserializableType extends GsonDeserializableType {
  FieldReferencedGsonDeserializableType() {
    exists(GsonDeserializableField f | usesType(f.getType(), this))
  }
}

/** A field that may be deserialized using the Gson JSON framework. */
private class GsonDeserializableField extends DeserializableField {
  GsonDeserializableField() {
    exists(GsonDeserializableType superType |
      superType = this.getDeclaringType().getAnAncestor() and
      not superType instanceof TypeObject and
      superType.fromSource()
    )
  }
}

private class GsonInheritTaint extends DataFlow::FieldContent, TaintInheritingContent {
  GsonInheritTaint() { this.getField() instanceof GsonDeserializableField }
}
