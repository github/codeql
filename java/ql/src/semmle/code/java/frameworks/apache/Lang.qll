/* Definitions related to the Apache Commons Exec library. */
import semmle.code.java.Type

class TypeApacheRandomStringUtils extends Class {
  TypeApacheRandomStringUtils() {
    hasQualifiedName("org.apache.commons.lang", "RandomStringUtils") or
    hasQualifiedName("org.apache.commons.lang3", "RandomStringUtils")
  }
}
