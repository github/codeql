/**
 * Provides classes and predicates for working with Java Serialization.
 */

import java
private import frameworks.jackson.JacksonSerializability
private import frameworks.google.GsonSerializability
private import frameworks.google.GoogleHttpClientApi
private import frameworks.struts.Struts2Serializability

/**
 * A serializable field may be read without code referencing it,
 * due to the use of serialization.
 */
abstract class SerializableField extends Field { }

/**
 * A deserializable field may be written without code referencing it,
 * due to the use of serialization.
 */
abstract class DeserializableField extends Field { }

/**
 * A non-`transient` field in a type that (directly or indirectly) implements the `Serializable` interface
 * and may be read or written via serialization.
 */
class StandardSerializableField extends SerializableField, DeserializableField {
  StandardSerializableField() {
    this.getDeclaringType().getAnAncestor() instanceof TypeSerializable and
    not this.isTransient()
  }
}
