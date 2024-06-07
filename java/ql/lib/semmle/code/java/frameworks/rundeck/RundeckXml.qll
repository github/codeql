/** Provides definitions related to XML parsing in Rundeck. */

import java
private import semmle.code.java.security.XmlParsers

/** A call to `ParserHelper.loadDocument`. */
private class ParserHelperLoadDocument extends XmlParserCall {
  ParserHelperLoadDocument() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType().hasQualifiedName("org.rundeck.api.parser", "ParserHelper") and
      m.hasName("loadDocument")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}
