/**
 * Provides classes and predicates for working with the Castor framework.
 */

import java

/**
 * The class `org.exolab.castor.xml.Unmarshaller`.
 */
class Unmarshaller extends RefType {
  Unmarshaller() { this.hasQualifiedName("org.exolab.castor.xml", "Unmarshaller") }
}

/** A method with the name `unmarshal` declared in `org.exolab.castor.xml.Unmarshaller`. */
class UnmarshalMethod extends Method {
  UnmarshalMethod() {
    this.getDeclaringType() instanceof Unmarshaller and
    this.getName() = "unmarshal"
  }
}
