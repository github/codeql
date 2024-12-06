/**
 * Provides classes and predicates for working with the `kotlinx.serialization` plugin.
 */
overlay[local?]
module;

import java

/**
 * A constructor with a `SerializationConstructorMarker` parameter.
 */
class SerializationConstructor extends Constructor {
  SerializationConstructor() {
    this.getParameterType(this.getNumberOfParameters() - 1)
        .(RefType)
        .hasQualifiedName("kotlinx.serialization.internal", "SerializationConstructorMarker")
  }
}
