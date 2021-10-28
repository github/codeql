/**
 * @name Missing SAMLv2 signature check
 * @description Failing to verify the SAMLv2 signature allows an attacker to forge SAML assertion and launch Signature Exclusion Attack.
 * @kind path-problem
 * @problem.severity error
 * @id java/missing-samlv2-signature-check
 * @tags security
 *       external/cwe/cwe-347
 */

import java
import SAML
import DOM
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/** Configuration of handling SAML assertion in XML file. */
class SamlAssertionConf extends TaintTracking::Configuration {
  SamlAssertionConf() { this = "SamlAssertionConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof SamlAssertionSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SamlAssertionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    exists(Method validator |
      isValidationMethod(validator, sanitizer.asExpr()) and
      not skipsValidationOnEmptySignature(validator)
    )
  }
}

/** Holds if the method `validator` validates `validated`. */
predicate isValidationMethod(Method validator, Expr validated) {
  validator instanceof ValidateSignatureMethod and
  validated = validator.getAReference().getQualifier()
  or
  exists(MethodAccess call, Expr recursiveValidated |
    call.getMethod() = validator and
    exists(int i |
      validated = call.getArgument(i) and
      TaintTracking::localTaint(DataFlow::parameterNode(validator.getParameter(i)),
        DataFlow::exprNode(recursiveValidated))
    ) and
    isValidationMethod(validator.getACallee(), recursiveValidated)
  )
}

/** Holds if `m` skips signature validation when the signature length is 0. */
predicate skipsValidationOnEmptySignature(Method m) {
  exists(ConditionBlock cb, EqualityTest et, IntegerLiteral zero, MethodAccess ma, ReturnStmt stmt |
    // if (signatureNodeList.getLength() == 0) { return; }
    cb.getCondition() = et and
    zero.getIntValue() = 0 and
    ma.getMethod().getDeclaringType().getASupertype*() instanceof TypeDomNodeList and
    ma.getMethod().hasName("getLength") and
    et.hasOperands(ma, zero) and
    cb.controls(stmt.getBasicBlock(), et.polarity()) and
    ma.getEnclosingCallable() = m
  )
}

from DataFlow::PathNode source, DataFlow::PathNode sink, SamlAssertionConf conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "SAMLv2 assertion is used $@, but the signature is not verified.", source.getNode(), "here"
