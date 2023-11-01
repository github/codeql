/**
 * @name Bad redirect check
 * @description A redirect check that checks for a leading slash but not two
 *              leading slashes or a leading slash followed by a backslash is
 *              incomplete.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @id go/bad-redirect-check
 * @tags security
 *       external/cwe/cwe-601
 * @precision high
 */

import go
import semmle.go.security.OpenUrlRedirectCustomizations

StringOps::HasPrefix checkForLeadingSlash(SsaWithFields v) {
  exists(DataFlow::Node substr |
    result.getBaseString() = v.getAUse() and result.getSubstring() = substr
  |
    substr.getStringValue() = "/"
  )
}

predicate isCheckedForSecondSlash(SsaWithFields v) {
  exists(StringOps::HasPrefix hp | hp.getBaseString() = v.getAUse() |
    hp.getSubstring().getStringValue() = "//"
  )
  or
  exists(DataFlow::EqualityTestNode eq, DataFlow::Node slash, DataFlow::ElementReadNode er |
    slash.getStringValue() = "/" and
    er.getBase() = v.getAUse() and
    er.getIndex().getIntValue() = 1 and
    eq.eq(_, er, slash)
  )
  or
  // a call to path.Clean will strip away multiple leading slashes
  isCleaned(v.getAUse())
}

/**
 * Holds if `nd` is the result of a call to `path.Clean`, or flows into the first argument
 * of such a call, possibly inter-procedurally.
 */
predicate isCleaned(DataFlow::Node nd) {
  exists(Function clean | clean.hasQualifiedName("path", "Clean") |
    nd = clean.getACall()
    or
    nd = clean.getACall().getArgument(0)
  )
  or
  isCleaned(nd.getAPredecessor())
  or
  exists(FuncDef f, FunctionInput inp | nd = inp.getExitNode(f) |
    forex(DataFlow::CallNode call | call.getACallee() = f | isCleaned(inp.getEntryNode(call)))
  )
}

predicate isCheckedForSecondBackslash(SsaWithFields v) {
  exists(StringOps::HasPrefix hp | hp.getBaseString() = v.getAUse() |
    hp.getSubstring().getStringValue() = "/\\"
  )
  or
  exists(DataFlow::EqualityTestNode eq, DataFlow::Node slash, DataFlow::ElementReadNode er |
    slash.getStringValue() = "\\" and
    er.getBase() = v.getAUse() and
    er.getIndex().getIntValue() = 1 and
    eq.eq(_, er, slash)
  )
  or
  // if this variable comes from or is a net/url.URL.Path, backslashes are most likely sanitized,
  // as the parse functions turn them into "%5C"
  urlPath(v.getAUse())
}

/**
 * Holds if `nd` derives its value from the field `url.URL.Path`, possibly inter-procedurally.
 */
predicate urlPath(DataFlow::Node nd) {
  exists(Field f |
    f.hasQualifiedName("net/url", "URL", "Path") and
    nd = f.getARead()
  )
  or
  urlPath(nd.getAPredecessor())
  or
  exists(FuncDef f, FunctionInput inp | nd = inp.getExitNode(f) |
    forex(DataFlow::CallNode call | call.getACallee() = f | urlPath(inp.getEntryNode(call)))
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isCheckedSource(source, _) }

  /**
   * Holds if `source` is the first node that flows into a use of a variable that is checked by a
   * bad redirect check `check`..
   */
  additional predicate isCheckedSource(DataFlow::Node source, DataFlow::Node check) {
    exists(SsaWithFields v |
      DataFlow::localFlow(source, v.getAUse()) and
      not exists(source.getAPredecessor()) and
      isBadRedirectCheckOrWrapper(check, v)
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // this is very over-approximate, because most filtering is done by the isSource predicate
    exists(Write w | w.writesField(node2, _, node1))
  }

  predicate isBarrierOut(DataFlow::Node node) {
    // assume this value is safe if something is prepended to it.
    exists(StringOps::Concatenation conc, int i, int j | i < j |
      node = conc.getOperand(j) and
      exists(conc.getOperand(i))
    )
    or
    exists(DataFlow::CallNode call, int i | call.getTarget().hasQualifiedName("path", "Join") |
      i > 0 and node = call.getSyntacticArgument(i)
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof OpenUrlRedirect::Sink }
}

module Flow = TaintTracking::Global<Config>;

/**
 * Holds there is a check `check` that is a bad redirect check, and `v` is either
 * checked directly by `check` or checked by a function that contains `check`.
 */
predicate isBadRedirectCheckOrWrapper(DataFlow::Node check, SsaWithFields v) {
  isBadRedirectCheck(check, v)
  or
  exists(DataFlow::CallNode call, FuncDef f, FunctionInput input |
    call = f.getACall() and
    input.getEntryNode(call) = v.getAUse() and
    isBadRedirectCheckWrapper(check, f, input)
  )
}

/**
 * Holds if `check` checks that `v` has a leading slash, but not whether it has another slash or a
 * backslash in its second position.
 */
predicate isBadRedirectCheck(DataFlow::Node check, SsaWithFields v) {
  // a check for a leading slash
  check = checkForLeadingSlash(v) and
  // where there does not exist a check for both a second slash and a second backslash
  // (we allow those checks to be on variables that are most likely equivalent to `v`
  // to rule out false positives due to minor variations in data flow)
  not (
    isCheckedForSecondSlash(v.similar()) and
    isCheckedForSecondBackslash(v.similar())
  )
}

/**
 * Holds if `f` contains a bad redirect check `check`, that checks the parameter `input`.
 */
predicate isBadRedirectCheckWrapper(DataFlow::Node check, FuncDef f, FunctionInput input) {
  exists(SsaWithFields v |
    v.getAUse().getAPredecessor*() = input.getExitNode(f) and
    isBadRedirectCheck(check, v)
  )
}

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, DataFlow::Node check
where
  Config::isCheckedSource(source.getNode(), check) and
  Flow::flowPath(source, sink)
select check, source, sink,
  "This is a check that $@, which flows into a $@, has a leading slash, but not that it does not have '/' or '\\' in its second position.",
  source.getNode(), "this value", sink.getNode(), "redirect"
