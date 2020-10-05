/** Definitions related to the Apache Commons Lang library. */
import semmle.code.java.Type

/*--- Types ---*/
/** The class `org.apache.commons.lang.RandomStringUtils` or `org.apache.commons.lang3.RandomStringUtils`. */
class TypeApacheRandomStringUtils extends Class {
  TypeApacheRandomStringUtils() {
    hasQualifiedName("org.apache.commons.lang", "RandomStringUtils") or
    hasQualifiedName("org.apache.commons.lang3", "RandomStringUtils")
  }
}
