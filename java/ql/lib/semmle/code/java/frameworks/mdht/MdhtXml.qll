/** Provides definitions related to XML parsing in Model-Driven Health Tools. */

import java
private import semmle.code.java.security.XmlParsers

/** A call to `CDAUtil.load` or `CDAUtil.loadAs`. */
private class CdaUtilLoad extends XmlParserCall {
  CdaUtilLoad() {
    this.getMethod()
        .hasQualifiedName("org.openhealthtools.mdht.uml.cda.util", "CDAUtil", ["load", "loadAs"])
  }

  override Expr getSink() {
    result = this.getAnArgument() and
    exists(RefType t | result.getType().(RefType).getASourceSupertype*() = t |
      t instanceof TypeInputStream or
      t instanceof InputSource
    )
  }

  override predicate isSafe() { none() }
}
