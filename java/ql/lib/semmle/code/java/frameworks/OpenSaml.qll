/**
 * Provides classes and predicates for working with the OpenSAML libraries.
 */

import java
private import semmle.code.java.security.InsecureRandomnessQuery

/** The interface  `org.opensaml.saml.saml2.core.RequestAbstractType`. */
class SamlRequestAbstractType extends Interface {
  SamlRequestAbstractType() {
    this.hasQualifiedName("org.opensaml.saml.saml2.core", "RequestAbstractType")
  }
}

/** The method `setID` of  the interface `RequestAbstractType`. */
class SamlRequestSetIdMethod extends Method {
  SamlRequestSetIdMethod() {
    this.getDeclaringType() instanceof SamlRequestAbstractType and
    this.hasName("setID")
  }
}

private class SamlRequestSetIdSink extends InsecureRandomnessSink {
  SamlRequestSetIdSink() {
    exists(MethodCall c | c.getMethod() instanceof SamlRequestSetIdMethod |
      c.getArgument(0) = this.asExpr()
    )
  }
}
