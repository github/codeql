/**
 * Provides classes for working with the jose4j framework.
 */

import java

/** The class `org.jose4j.jws.JsonWebSignature`. */
class TypeJsonWebSignature extends RefType {
  TypeJsonWebSignature() { this.hasQualifiedName("org.jose4j.jws", "JsonWebSignature") }
}

/** The class `org.jose4j.jwt.consumer.JwtConsumer`. */
class TypeJwtConsumer extends RefType {
  TypeJwtConsumer() { this.hasQualifiedName("org.jose4j.jwt.consumer", "JwtConsumer") }
}

/** The class `org.jose4j.jwt.consumer.JwtConsumerBuilder`. */
class TypeJwtConsumerBuilder extends RefType {
  TypeJwtConsumerBuilder() {
    this.hasQualifiedName("org.jose4j.jwt.consumer", "JwtConsumerBuilder")
  }
}

/** The `setVerificationKey()` method defined in `JwtConsumerBuilder`. */
class SetJwtVerificationKey extends Method {
  SetJwtVerificationKey() {
    this.hasName("setVerificationKey") and
    this.getDeclaringType() instanceof TypeJwtConsumerBuilder
  }
}

/** The `setRelaxVerificationKeyValidation()` method defined in `JwtConsumerBuilder`. */
class SetRelaxJwtKeyValidation extends Method {
  SetRelaxJwtKeyValidation() {
    this.hasName("setRelaxVerificationKeyValidation") and
    this.getDeclaringType() instanceof TypeJwtConsumerBuilder
  }
}
