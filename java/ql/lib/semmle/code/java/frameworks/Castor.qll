/**
 * Provides classes and predicates for working with the Castor framework.
 */

import java

/**
 * The class `org.exolab.castor.xml.Unmarshaller`.
 */
class CastorUnmarshaller extends RefType {
  CastorUnmarshaller() { this.hasQualifiedName("org.exolab.castor.xml", "Unmarshaller") }
}

/** A method with the name `unmarshal` declared in `org.exolab.castor.xml.Unmarshaller`. */
class CastorUnmarshalMethod extends Method {
  CastorUnmarshalMethod() {
    this.getDeclaringType() instanceof CastorUnmarshaller and
    this.getName() = "unmarshal"
  }
}
