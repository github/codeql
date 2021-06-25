/**
 * Provides classes for working with the Gson framework.
 */

import java

/** The class `com.google.gson.Gson`. */
class Gson extends RefType {
  Gson() { this.hasQualifiedName("com.google.gson", "Gson") }
}

/** The class `com.google.gson.GsonBuilder`. */
class GsonBuilder extends RefType {
  GsonBuilder() { this.hasQualifiedName("com.google.gson", "GsonBuilder") }
}

/** A method that registers class types in `GsonBuilder`. */
class RegisterClassTypeMethod extends Method {
  RegisterClassTypeMethod() {
    this.getDeclaringType() instanceof GsonBuilder and
    this.getName().matches("register%")
  }
}

/** The `create` method of `GsonBuilder`. */
class CreateGsonMethod extends Method {
  CreateGsonMethod() {
    this.getDeclaringType() instanceof GsonBuilder and
    this.hasName("create")
  }
}

/** The `fromJson` deserialization method. */
class GsonDeserializeMethod extends Method {
  GsonDeserializeMethod() {
    this.getDeclaringType() instanceof Gson and
    this.hasName("fromJson")
  }
}

/** The `toJson​` serialization method. */
class GsonSerializeMethod extends Method {
  GsonSerializeMethod() {
    this.getDeclaringType() instanceof Gson and
    this.hasName("toJson​")
  }
}
