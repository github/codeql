/** Definitions related to the Apache Commons Lang library. */

import java

/*--- Types ---*/
/** The class `org.apache.commons.lang.RandomStringUtils` or `org.apache.commons.lang3.RandomStringUtils`. */
class TypeApacheRandomStringUtils extends Class {
  TypeApacheRandomStringUtils() {
    hasQualifiedName("org.apache.commons.lang", "RandomStringUtils") or
    hasQualifiedName("org.apache.commons.lang3", "RandomStringUtils")
  }
}

/*--- Methods ---*/
/**
 * The method `deserialize` in either `org.apache.commons.lang.SerializationUtils`
 * or `org.apache.commons.lang3.SerializationUtils`.
 */
class MethodApacheSerializationUtilsDeserialize extends Method {
  MethodApacheSerializationUtilsDeserialize() {
    (
      this.getDeclaringType().hasQualifiedName("org.apache.commons.lang", "SerializationUtils") or
      this.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "SerializationUtils")
    ) and
    this.hasName("deserialize")
  }
}
