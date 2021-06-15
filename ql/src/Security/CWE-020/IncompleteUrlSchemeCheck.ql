/**
 * @name Incomplete URL scheme check
 * @description Checking for the "javascript:" URL scheme without also checking for "vbscript:"
 *              and "data:" suggests a logic error or even a security vulnerability.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id go/incomplete-url-scheme-check
 * @tags security
 *       correctness
 *       external/cwe/cwe-020
 */

import go

/** A URL scheme that can be used to represent executable code. */
class DangerousScheme extends string {
  DangerousScheme() { this = "data" or this = "javascript" or this = "vbscript" }
}

/** Gets a data-flow node that checks an instance of `g` against the given `scheme`. */
DataFlow::Node schemeCheck(GVN g, DangerousScheme scheme) {
  // check of the form `nd.Scheme == scheme`
  exists(NamedType url, DataFlow::FieldReadNode fr, DataFlow::Node s |
    url.hasQualifiedName("net/url", "URL") and
    fr.readsField(g.getANode(), url.getField("Scheme")) and
    s.getStringValue() = scheme and
    result.(DataFlow::EqualityTestNode).eq(_, fr, s)
  )
  or
  // check of the form `strings.HasPrefix(nd, "scheme:")`
  exists(StringOps::HasPrefix hasPrefix | result = hasPrefix |
    hasPrefix.getBaseString() = g.getANode() and
    hasPrefix.getSubstring().getStringValue() = scheme + ":"
  )
  or
  // propagate through various string transformations
  exists(string stringop, DataFlow::CallNode c |
    stringop = "Map" or
    stringop.matches("Replace%") or
    stringop.matches("To%") or
    stringop.matches("Trim%")
  |
    c.getTarget().hasQualifiedName("strings", stringop) and
    c.getAnArgument() = g.getANode() and
    result = schemeCheck(globalValueNumber(c), scheme)
  )
}

/**
 * Gets a scheme that `g`, which is checked against at least one scheme, is not checked against.
 */
DangerousScheme getAMissingScheme(GVN g) {
  exists(schemeCheck(g, _)) and
  not exists(schemeCheck(g, result))
}

from GVN g
select schemeCheck(g, "javascript"),
  "This check does not consider " + strictconcat(getAMissingScheme(g), " and ") + "."
