/**
 * @name Constant password
 * @description Using constant passwords is not secure, because potential attackers can easily recover them from the source code.
 * @kind problem
 * @problem.severity error
 * @security-severity 6.8
 * @precision high
 * @id java/constant-password-new-model
 * @tags security
 *       external/cwe/cwe-259
 */

//this query is a replica of the concept in: https://github.com/github/codeql/blob/main/swift/ql/src/queries/Security/CWE-259/ConstantPassword.ql
//but uses the **NEW MODELLING**
import experimental.Quantum.Language
import semmle.code.java.dataflow.TaintTracking

/**
 * A constant password is created through either a byte array or string literals.
 */
class ConstantPasswordSource extends Expr {
  ConstantPasswordSource() {
    this instanceof CharacterLiteral or
    this instanceof StringLiteral
  }
}

module ConstantToKeyDerivationFlow implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof ConstantPasswordSource }

  predicate isSink(DataFlow::Node sink) { any(Crypto::KeyMaterialInstance i).getInput() = sink }
}

module ConstantToKeyDerivationFlowInit = TaintTracking::Global<ConstantToKeyDerivationFlow>;

from DataFlow::Node source, DataFlow::Node sink
where ConstantToKeyDerivationFlowInit::flow(source, sink)
select sink, "Constant password $@ is used.", source, source.toString()
