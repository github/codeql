/**
 * @name Use of JWT Methods that only decode user provided Token
 * @description Using JWT methods without verification can cause to authorization or authentication bypass
 * @kind path-problem
 * @problem.severity error
 * @id go/parse-jwt-without-verification
 * @tags security
 *       experimental
 *       external/cwe/cwe-347
 */

import go
import experimental.frameworks.JWT

module WithValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink = any(JwtParse jwtParse).getTokenArg() or
    sink = any(JwtParseWithKeyFunction jwtParseWithKeyFunction).getTokenArg()
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    golangJwtIsAdditionalFlowStep(nodeFrom, nodeTo)
    or
    goJoseIsAdditionalFlowStep(nodeFrom, nodeTo)
  }
}

module NoValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof UntrustedFlowSource and
    not WithValidation::flow(source, _)
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(JwtUnverifiedParse parseUnverified).getTokenArg()
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    golangJwtIsAdditionalFlowStep(nodeFrom, nodeTo)
    or
    goJoseIsAdditionalFlowStep(nodeFrom, nodeTo)
  }
}

module WithValidation = TaintTracking::Global<WithValidationConfig>;

module NoValidation = TaintTracking::Global<NoValidationConfig>;

import NoValidation::PathGraph

from NoValidation::PathNode source, NoValidation::PathNode sink
where NoValidation::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This JWT is parsed without verification and received from $@.", source.getNode(),
  "this user-controlled source"
