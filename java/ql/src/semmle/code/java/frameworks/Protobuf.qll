/**
 * Provides classes and predicates for working with the Protobuf framework.
 */

import java

/**
 * The interface `com.google.protobuf.Parser`.
 */
class ProtobufParser extends Interface {
  ProtobufParser() { this.hasQualifiedName("com.google.protobuf", "Parser") }

  /**
   * Gets a method named `parseFrom` (or similar) declared on a subtype of `com.google.protobuf.Parser`.
   */
  Method getAParseFromMethod() {
    result.getDeclaringType().getASupertype*().getSourceDeclaration() = this and
    result.getName().matches("parse%From")
  }
}

/**
 * The interface `com.google.protobuf.MessageLite`.
 */
class ProtobufMessageLite extends Interface {
  ProtobufMessageLite() { this.hasQualifiedName("com.google.protobuf", "MessageLite") }

  /**
   * Gets a static method named `parseFrom` (or similar) declared on a subtype of the `MessageLite` interface.
   */
  Method getAParseFromMethod() {
    result = getASubtype+().getAMethod() and
    result.getName().matches("parse%From") and
    result.isStatic()
  }

  /**
   * Gets a getter method declared on a subtype of the `MessageLite` interface.
   */
  Method getAGetterMethod() {
    exists(RefType decl | decl = result.getDeclaringType() and decl = this.getASubtype+() |
      exists(string name, string suffix |
        suffix = "" or
        suffix = "list" or
        suffix = "map" or
        suffix = "ordefault" or
        suffix = "orthrow"
      |
        exists(Field f | f.getDeclaringType() = decl |
          f.getName().toLowerCase().replaceAll("_", "") = name
        ) and
        result.getName().toLowerCase() = "get" + name + suffix
      )
    )
  }
}
