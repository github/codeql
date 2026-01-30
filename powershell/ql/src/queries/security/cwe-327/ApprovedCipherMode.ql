/**
 * @name Insecure Symmetric cipher mode
 * @description Use of insecure cipher mode
 * @problem.severity error
 * @kind path-problem
 * @security-severity 8.8
 * @precision high
 * @id powershell/microsoft/public/weak-cipher-mode
 * @tags correctness
 *       security
 *       external/cwe/cwe-327
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.dataflow.TaintTracking
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.security.cryptography.Concepts
import WeakEncryptionFlow::PathGraph

class AesModeProperty extends MemberExpr {
  AesModeProperty() {
    exists(DataFlow::ObjectCreationNode aesObjectCreation, DataFlow::Node aesObjectAccess |
      (
        aesObjectCreation
            .asExpr()
            .getExpr()
            .(ObjectCreation)
            .getAnArgument()
            .getValue()
            .stringMatches("System.Security.Cryptography.AesManaged") or
        aesObjectCreation =
          API::getTopLevelMember("system")
              .getMember("security")
              .getMember("cryptography")
              .getMember("aes")
              .getMember("create")
              .asCall()
      ) and
      aesObjectAccess.getALocalSource() = aesObjectCreation and
      aesObjectAccess.asExpr().getExpr() = this.getQualifier() and
      this.getLowerCaseMemberName() = "mode"
    )
  }
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(BlockMode blockMode |
      source = blockMode and
      not blockMode.getBlockModeName() = ["cbc", "cts", "xts"]
    )
  }

  predicate isSink(DataFlow::Node sink) {
    sink.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr().getExpr() =
      any(AesModeProperty mode).getQualifier()
  }

  predicate allowImplicitRead(DataFlow::Node n, DataFlow::ContentSet cs) {
    isSink(n) and
    exists(DataFlow::Content::FieldContent fc |
      cs.isSingleton(fc) and
      fc.getLowerCaseName() = "mode"
    )
  }
}

module WeakEncryptionFlow = TaintTracking::Global<Config>;

from WeakEncryptionFlow::PathNode source, WeakEncryptionFlow::PathNode sink
where WeakEncryptionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, ""
