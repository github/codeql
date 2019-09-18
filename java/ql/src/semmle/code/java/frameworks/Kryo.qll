/**
 * Provides classes and predicates for working with the Kryo serialization framework.
 */

import java

/**
 * The type `com.esotericsoftware.kryo.Kryo`.
 */
class Kryo extends RefType {
  Kryo() { this.hasQualifiedName("com.esotericsoftware.kryo", "Kryo") }
}

/**
 * A Kryo input stream.
 */
class KryoInput extends RefType {
  KryoInput() { this.hasQualifiedName("com.esotericsoftware.kryo.io", "Input") }
}

/**
 * A Kryo method that deserializes an object.
 */
class KryoReadObjectMethod extends Method {
  KryoReadObjectMethod() {
    this.getDeclaringType() instanceof Kryo and
    (
      this.hasName("readClassAndObject") or
      this.hasName("readObject") or
      this.hasName("readObjectOrNull")
    )
  }
}

/**
 * A call to `Kryo.setRegistrationRequired` that enables white-listing.
 */
class KryoEnableWhiteListing extends MethodAccess {
  KryoEnableWhiteListing() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof Kryo and
      m.hasName("setRegistrationRequired") and
      this.getAnArgument().(BooleanLiteral).getBooleanValue() = true
    )
  }
}
