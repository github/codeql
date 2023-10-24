/**
 * Provides classes and predicates for working with the XStream XML serialization framework.
 */

import java

/**
 * The type `com.thoughtworks.xstream.XStream`.
 */
class XStream extends RefType {
  XStream() { this.hasQualifiedName("com.thoughtworks.xstream", "XStream") }
}

/**
 * An XStream method that deserializes an object.
 */
class XStreamReadObjectMethod extends Method {
  XStreamReadObjectMethod() {
    this.getDeclaringType() instanceof XStream and
    (
      this.hasName("fromXML") or
      this.hasName("unmarshal")
    )
  }
}

/**
 * A call to `XStream.addPermission(NoTypePermission.NONE)`, which enables white-listing.
 */
class XStreamEnableWhiteListing extends MethodCall {
  XStreamEnableWhiteListing() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof XStream and
      m.hasName("addPermission") and
      exists(Field f |
        this.getAnArgument() = f.getAnAccess() and
        f.hasName("NONE") and
        f.getDeclaringType()
            .hasQualifiedName("com.thoughtworks.xstream.security", "NoTypePermission")
      )
    )
  }
}
