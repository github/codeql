/**
 * @name Delegated SignatureValidator for JsonWebTokenHandler never throws an exception
 * @description `SignatureValidator` delegator for `JsonWebTokenHandler` always return a `SecurityToken` back without any checks.
 *   Medium precision version that does not check for subcall exception throws, so false positives are expected.
 * @kind problem
 * @tags security
 *       wilson-library
 *       manual-verification-required
 * @id cs/wilson-library/delegated-security-validations-always-permit-signature
 * @problem.severity warning
 * @precision medium
 */

import csharp
import DataFlow
import wilsonlib

module CallableReferenceFlowConfig implements DataFlow::ConfigSig{
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof Callable or
    source.asExpr() instanceof CallableAccess
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Assignment a | sink.asExpr() = a.getRValue())
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2){
    node1.asExpr() instanceof CallableAccess and
    node2.asExpr().(DelegateCreation).getArgument() = node1.asExpr()
  }
}
module CallableReferenceFlow = DataFlow::Global<CallableReferenceFlowConfig>;

from
    Assignment a,
    TokenValidationParametersPropertyWriteToValidationDelegatedSignatureValidator sv,
    Callable c,
    DataFlow::Node callableSource
where
    a.getLValue() = sv and
    not callableThrowsException(c) and
    CallableReferenceFlow::flow(callableSource, DataFlow::exprNode(a.getRValue())) and
    (callableSource = DataFlow::exprNode(c) or callableSource.asExpr().(CallableAccess).getTarget() = c)
select
    sv,
    "Delegated $@ for `JsonWebTokenHandler` is $@ that always returns a SecurityToken without any check that throws a SecurityTokenException.",
    sv, "SignatureValidator",
    c, "a callable"
 