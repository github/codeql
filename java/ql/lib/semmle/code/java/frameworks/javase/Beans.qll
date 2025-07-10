/** Provides definitions related to the `java.beans` package. */

import java
private import semmle.code.java.security.XmlParsers

/** The class `java.beans.XMLDecoder`. */
private class XmlDecoder extends RefType {
  XmlDecoder() { this.hasQualifiedName("java.beans", "XMLDecoder") }
}

/** A call to `XMLDecoder.readObject`. */
private class XmlDecoderReadObject extends XmlParserCall {
  XmlDecoderReadObject() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof XmlDecoder and
      m.hasName("readObject")
    )
  }

  override Expr getSink() { result = this.getQualifier() }

  override predicate isSafe() { none() }
}
