/**
 * @name Incomplete URL scheme check
 * @description Checking for the "javascript:" URL scheme without also checking for "vbscript:"
 *              and "data:" suggests a logic error or even a security vulnerability.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/incomplete-url-scheme-check
 * @tags security
 *       correctness
 *       external/cwe/cwe-020
 */

import javascript
import semmle.javascript.dataflow.internal.AccessPaths

/** A URL scheme that can be used to represent executable code. */
class DangerousScheme extends string {
  DangerousScheme() { this = "data:" or this = "javascript:" or this = "vbscript:" }
}

/** Gets a data-flow node that checks `nd` against the given `scheme`. */
DataFlow::Node schemeCheck(
  DataFlow::Node nd, DangerousScheme scheme
) {
  // check of the form `nd.startsWith(scheme)`
  exists(StringOps::StartsWith sw | sw = result |
    sw.getBaseString() = nd and
    sw.getSubstring().mayHaveStringValue(scheme)
  )
  or
  // propagate through trimming, case conversion, and regexp replace
  exists(DataFlow::MethodCallNode stringop |
    stringop.getMethodName().matches("trim%") or
    stringop.getMethodName().matches("to%Case") or
    stringop.getMethodName() = "replace"
  |
    result = schemeCheck(stringop, scheme) and
    nd = stringop.getReceiver()
  )
  or
  // propagate througb local data flow
  result = schemeCheck(nd.getASuccessor(), scheme)
}

/** Gets a data-flow node that checks an instance of `ap` against the given `scheme`. */
DataFlow::Node schemeCheckOn(AccessPath ap, DangerousScheme scheme) {
  result = schemeCheck(ap.getAnInstance().flow(), scheme)
}

from AccessPath ap, int n
where
  n = strictcount(DangerousScheme s) and
  strictcount(DangerousScheme s | exists(schemeCheckOn(ap, s))) < n
select schemeCheckOn(ap, "javascript:"),
  "This check does not consider " +
    strictconcat(DangerousScheme s | not exists(schemeCheckOn(ap, s)) | s, " and ") + "."
