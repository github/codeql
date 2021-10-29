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
import DOM
import JavaXml
import SAML
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/** Configuration of handling SAML assertion in XML file. */
class SamlAssertionConf extends TaintTracking::Configuration {
  SamlAssertionConf() { this = "SamlAssertionConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof SamlAssertionSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SamlAssertionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof GetElementValueMethod and // jaxbElement.getValue()
      prev.asExpr() = ma.getQualifier() and
      succ.asExpr() = ma
      or
      ma.getMethod() instanceof UnmarshalElementMethod and // unmarshaller.unmarshal(document, type)
      prev.asExpr() = ma.getArgument(0) and
      succ.asExpr() = ma
    )
  }
}

/** Configuration of validating signature in XML file. */
class SamlAssertionSignatureCheckConf extends TaintTracking::Configuration {
  SamlAssertionSignatureCheckConf() { this = "SamlAssertionSignatureCheckConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof SamlAssertionSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof ValidateSignatureMethod and
      sink.asExpr() = ma.getQualifier()
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(
      ConditionBlock cb, EQExpr ee, CompileTimeConstantExpr zero, MethodAccess ma, ReturnStmt stmt
    |
      // if (signatureNodeList.getLength() == 0) { return; }
      cb.getCondition() = ee and
      zero.(IntegerLiteral).getIntValue() = 0 and
      ma.getMethod().getDeclaringType().getASupertype*() instanceof TypeDomNodeList and
      ma.getMethod().hasName("getLength") and
      ee.hasOperands(ma, zero) and
      node.asExpr() = ma.getQualifier() and
      cb.controls(stmt.getBasicBlock(), true)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, SamlAssertionConf conf
where
  conf.hasFlowPath(source, sink) and
  not exists(SamlAssertionSignatureCheckConf conf2, DataFlow::PathNode sink2 |
    conf2.hasFlow(source.getNode(), sink2.getNode())
  )
select sink.getNode(), source, sink,
  "SAMLv2 assertion is used $@, but the signature is not verified.", source.getNode(), "here"
