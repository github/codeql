/**
 * Provides classes and predicates for working with the Kryo serialization framework.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/**
 * The type `com.esotericsoftware.kryo.Kryo`.
 */
class Kryo extends RefType {
  Kryo() {
    this.hasQualifiedName("com.esotericsoftware.kryo", "Kryo") or
    this.hasQualifiedName("com.esotericsoftware.kryo5", "Kryo")
  }
}

/**
 * A Kryo input stream.
 */
class KryoInput extends RefType {
  KryoInput() {
    this.hasQualifiedName("com.esotericsoftware.kryo.io", "Input") or
    this.hasQualifiedName("com.esotericsoftware.kryo5.io", "Input")
  }
}

/**
 * A Kryo pool.
 */
class KryoPool extends RefType {
  KryoPool() {
    this.hasQualifiedName("com.esotericsoftware.kryo.pool", "KryoPool") or
    this.hasQualifiedName("com.esotericsoftware.kryo5.pool", "KryoPool")
  }
}

/**
 * A Kryo pool builder.
 */
class KryoPoolBuilder extends RefType {
  KryoPoolBuilder() {
    this.hasQualifiedName("com.esotericsoftware.kryo.pool", "KryoPool$Builder") or
    this.hasQualifiedName("com.esotericsoftware.kryo5.pool", "KryoPool$Builder")
  }
}

/**
 * A Kryo pool builder method used in a fluent API call chain.
 */
class KryoPoolBuilderMethod extends Method {
  KryoPoolBuilderMethod() {
    this.getDeclaringType() instanceof KryoPoolBuilder and
    (
      this.getReturnType() instanceof KryoPoolBuilder or
      this.getReturnType() instanceof KryoPool
    )
  }
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

/**
 * A KryoPool method that uses a Kryo instance.
 */
class KryoPoolRunMethod extends Method {
  KryoPoolRunMethod() {
    this.getDeclaringType() instanceof KryoPool and
    this.hasName("run")
  }
}
