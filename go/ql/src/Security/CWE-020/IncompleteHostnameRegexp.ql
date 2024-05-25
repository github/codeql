/**
 * @name Incomplete regular expression for hostnames
 * @description Matching a URL or hostname against a regular expression that contains an unescaped
 *              dot as part of the hostname might match more hostnames than expected.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id go/incomplete-hostname-regexp
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import go

/**
 * Holds if `pattern` is a regular expression pattern for URLs with a host matched by `hostPart`,
 * and `pattern` contains a subtle mistake that allows it to match unexpected hosts.
 */
bindingset[pattern]
predicate isIncompleteHostNameRegexpPattern(string pattern, string hostPart) {
  hostPart =
    pattern
        .regexpCapture("(?i).*?" +
            // an unescaped single `.`
            "(?<!\\\\)[.]" +
            // immediately followed by a sequence of subdomains, perhaps with some regex characters mixed in,
            // followed by a known TLD
            "(([():|?a-z0-9-]+(\\\\)?[.])?" + commonTld() + ")" + ".*", 1)
}

/** Holds if `b` sets the HTTP status code (represented by a pseudo-header named  `status`) */
predicate writesHttpError(ReachableBasicBlock b) {
  forex(Http::HeaderWrite hw |
    hw.getHeaderName() = "status" and hw.asInstruction().getBasicBlock() = b
  |
    exists(string code | code.matches("4__") or code.matches("5__") |
      hw.definesHeader("status", code)
    )
  )
}

/** Holds if starting from `block` a status code representing an error is certainly set. */
predicate onlyErrors(BasicBlock block) {
  writesHttpError(block)
  or
  forex(ReachableBasicBlock pred | pred = block.getAPredecessor() | onlyErrors(pred))
}

/** Gets a node that refers to a handler that is considered to return an HTTP error. */
DataFlow::Node getASafeHandler() {
  exists(Variable v |
    v.hasQualifiedName(ElazarlGoproxy::packagePath(), ["AlwaysReject", "RejectConnect"])
  |
    result = v.getARead()
  )
  or
  exists(Function f |
    onlyErrors(f.getFuncDecl().(ControlFlow::Root).getExitNode().getBasicBlock())
  |
    result = f.getARead()
  )
}

/** Holds if `regexp` is used in a check before `handler` is called. */
predicate regexpGuardsHandler(RegexpPattern regexp, Http::RequestHandler handler) {
  handler.guardedBy(DataFlow::exprNode(regexp.getAUse().asExpr().getParent*()))
}

/** Holds if `regexp` guards an HTTP error write. */
predicate regexpGuardsError(RegexpPattern regexp) {
  exists(ControlFlow::ConditionGuardNode cond, RegexpMatchFunction match, DataFlow::CallNode call |
    call.getTarget() = match and
    match.getRegexp(call) = regexp
  |
    cond.ensures(match.getResult().getNode(call).getASuccessor*(), true) and
    cond.dominates(any(ReachableBasicBlock b | writesHttpError(b)))
  )
}

module IncompleteHostNameRegexpConfig implements DataFlow::ConfigSig {
  additional predicate isSourceString(DataFlow::Node source, string hostPart) {
    exists(Expr e | e = source.asExpr() |
      isIncompleteHostNameRegexpPattern(e.getStringValue(), hostPart) and
      // Exclude constant names to avoid duplicate results, because the string
      // literals which they are initialised with are also considered as
      // sources.
      not e instanceof ConstantName
    )
  }

  predicate isSource(DataFlow::Node source) { isSourceString(source, _) }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof RegexpPattern and
    forall(Http::RequestHandler handler | regexpGuardsHandler(sink, handler) |
      not handler = getASafeHandler()
    ) and
    not regexpGuardsError(sink)
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    StringOps::Concatenation::taintStep(node1, node2)
  }
}

module Flow = DataFlow::Global<IncompleteHostNameRegexpConfig>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, string hostPart
where
  Flow::flowPath(source, sink) and
  IncompleteHostNameRegexpConfig::isSourceString(source.getNode(), hostPart)
select source, source, sink,
  "This regular expression has an unescaped dot before '" + hostPart + "', " +
    "so it might match more hosts than expected when $@.", sink, "the regular expression is used"
