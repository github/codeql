/**
 * DEPRECATED: Now modeled using data extensions instead.
 *
 * Provides classes and predicates for working with the Castor framework.
 */
overlay[local?]
deprecated module;

import java

/**
 * DEPRECATED: Now modeled using data extensions instead.
 *
 * The class `org.exolab.castor.xml.Unmarshaller`.
 */
deprecated class CastorUnmarshaller extends RefType {
  CastorUnmarshaller() { this.hasQualifiedName("org.exolab.castor.xml", "Unmarshaller") }
}

/**
 * DEPRECATED: Now modeled using data extensions instead.
 *
 * A method with the name `unmarshal` declared in `org.exolab.castor.xml.Unmarshaller`.
 */
deprecated class CastorUnmarshalMethod extends Method {
  CastorUnmarshalMethod() {
    this.getDeclaringType() instanceof CastorUnmarshaller and
    this.getName() = "unmarshal"
  }
}
