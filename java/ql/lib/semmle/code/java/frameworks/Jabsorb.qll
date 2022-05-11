/**
 * Provides classes for working with the Jabsorb JSON-RPC ORB framework.
 */

import java

/** The class `org.jabsorb.JSONSerializer`. */
class JabsorbSerializer extends RefType {
  JabsorbSerializer() { this.hasQualifiedName("org.jabsorb", "JSONSerializer") }
}

/** The deserialization method `unmarshall`. */
class JabsorbUnmarshallMethod extends Method {
  JabsorbUnmarshallMethod() {
    this.getDeclaringType().getAnAncestor() instanceof JabsorbSerializer and
    this.getName() = "unmarshall"
  }
}

/** The deserialization method `fromJSON`. */
class JabsorbFromJsonMethod extends Method {
  JabsorbFromJsonMethod() {
    this.getDeclaringType().getAnAncestor() instanceof JabsorbSerializer and
    this.getName() = "fromJSON"
  }
}
