/**
 * @name Incomplete URL scheme check
 * @description Checking for the "javascript:" URL scheme without also checking for "vbscript:"
 *              and "data:" suggests a logic error or even a security vulnerability.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id js/incomplete-url-scheme-check
 * @tags security
 *       correctness
 *       external/cwe/cwe-020
 *       external/cwe/cwe-184
 */

import javascript
import semmle.javascript.security.IncompleteBlacklistSanitizer as IncompleteBlacklistSanitizer

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

/**
 * A chain of replace calls that replaces one or more dangerous schemes.
 */
class SchemeReplacementChain extends IncompleteBlacklistSanitizer::StringReplaceCallSequence {
  SchemeReplacementChain() { this.getAMember().getAReplacedString() instanceof DangerousScheme }

  /**
   * Gets the source node that the replacement happens on.
   * The result is the receiver of the first call in the chain.
   */
  DataFlow::Node getReplacementSource() {
    result = this.getReceiver+() and not result instanceof DataFlow::MethodCallNode
  }
}

/** Gets a data-flow node that checks `nd` against the given `scheme`. */
DataFlow::Node schemeCheck(DataFlow::Node nd, DangerousScheme scheme) {
  // check of the form `nd.startsWith(scheme)`
  exists(StringOps::StartsWith sw | sw = result |
    sw.getBaseString() = nd and
    sw.getSubstring().mayHaveStringValue(scheme)
  )
  or
  exists(MembershipCandidate candidate |
    result = candidate.getTest()
    or
    // fall back to the candidate if the test itself is implicit
    not exists(candidate.getTest()) and result = candidate
  |
    candidate.getAMemberString() = scheme.getWithOrWithoutColon() and
    schemeOf(nd).flowsTo(candidate)
  )
  or
  exists(SchemeReplacementChain chain | result = chain |
    scheme = chain.getAMember().getAReplacedString() and
    nd = chain.getReplacementSource()
  )
  or
  // propagate through trimming, case conversion, and regexp replace
  exists(DataFlow::MethodCallNode stringop |
    stringop.getMethodName().matches("trim%") or
    stringop.getMethodName().matches("to%Case") or
    stringop.getMethodName() = ["replace", "replaceAll"]
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
