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

/** A URL scheme that can be used to represent executable code. */
class DangerousScheme extends string {
  DangerousScheme() { this = "data:" or this = "javascript:" or this = "vbscript:" }

  /** Gets the name of this scheme without the `:`. */
  string getWithoutColon() { this = result + ":" }

  /** Gets the name of this scheme, with or without the `:`. */
  string getWithOrWithoutColon() { result = this or result = getWithoutColon() }
}

/** Returns a node that refers to the scheme of `url`. */
DataFlow::SourceNode schemeOf(DataFlow::Node url) {
  // url.split(":")[0]
  exists(StringSplitCall split |
    split.getSeparator() = ":" and
    result = split.getASubstringRead(0) and
    url = split.getBaseString()
  )
  or
  // url.getScheme(), url.getProtocol(), getScheme(url), getProtocol(url)
  exists(DataFlow::CallNode call |
    result = call and
    (call.getCalleeName() = "getScheme" or call.getCalleeName() = "getProtocol")
  |
    call.getNumArgument() = 1 and
    url = call.getArgument(0)
    or
    call.getNumArgument() = 0 and
    url = call.getReceiver()
  )
  or
  // url.scheme, url.protocol
  exists(DataFlow::PropRead prop |
    result = prop and
    (prop.getPropertyName() = "scheme" or prop.getPropertyName() = "protocol") and
    url = prop.getBase()
  )
}

/** Gets a data-flow node that checks `nd` against the given `scheme`. */
DataFlow::Node schemeCheck(DataFlow::Node nd, DangerousScheme scheme) {
  // check of the form `nd.startsWith(scheme)`
  exists(StringOps::StartsWith sw | sw = result |
    sw.getBaseString() = nd and
    sw.getSubstring().mayHaveStringValue(scheme)
  )
  or
  // check of the form `array.includes(getScheme(nd))`
  exists(InclusionTest test, DataFlow::ArrayCreationNode array | test = result |
    schemeOf(nd).flowsTo(test.getContainedNode()) and
    array.flowsTo(test.getContainerNode()) and
    array.getAnElement().mayHaveStringValue(scheme.getWithOrWithoutColon())
  )
  or
  // check of the form `getScheme(nd) === scheme`
  exists(EqualityTest test, Expr op1, Expr op2 | test.flow() = result |
    test.hasOperands(op1, op2) and
    schemeOf(nd).flowsToExpr(op1) and
    op2.mayHaveStringValue(scheme.getWithOrWithoutColon())
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
  // propagate through local data flow
  result = schemeCheck(nd.getASuccessor(), scheme)
}

/** Gets a data-flow node that checks an instance of `ap` against the given `scheme`. */
DataFlow::Node schemeCheckOn(DataFlow::SourceNode root, string path, DangerousScheme scheme) {
  result = schemeCheck(AccessPath::getAReferenceTo(root, path), scheme)
}

from DataFlow::SourceNode root, string path, int n
where
  n = strictcount(DangerousScheme s) and
  strictcount(DangerousScheme s | exists(schemeCheckOn(root, path, s))) < n
select schemeCheckOn(root, path, "javascript:"),
  "This check does not consider " +
    strictconcat(DangerousScheme s | not exists(schemeCheckOn(root, path, s)) | s, " and ") + "."
