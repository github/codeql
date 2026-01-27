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
import WeakEncryptionFlow::PathGraph

class AesCreation extends ObjectCreation {
  AesCreation() {
    this.getAnArgument().getValue().stringMatches("System.Security.Cryptography.AesManaged")
  }
}

class AesModeProperty extends MemberExpr {
  AesModeProperty() {
    exists(DataFlow::ObjectCreationNode aesObjectCreation, DataFlow::Node aesObjectAccess |
      (
        aesObjectCreation.asExpr().getExpr().(ObjectCreation).getAnArgument().getValue().stringMatches("System.Security.Cryptography.AesManaged") or 
        aesObjectCreation.(DataFlow::CallNode)= API::getTopLevelMember("system").getMember("security").getMember("cryptography").getMember("aes").getMember("create").asCall() 
      )
      and
      aesObjectAccess.getALocalSource() = aesObjectCreation and
      aesObjectAccess.asExpr().getExpr() = this.getQualifier() and
      this.getLowerCaseMemberName() = "mode"
    )
  }
}

class WeakAesMode extends DataFlow::Node {
  WeakAesMode() {
    exists(API::Node node, string modeValue |
      node =
        API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember("ciphermode")
            .getMember(modeValue) and
      modeValue = ["ecb", "ofb", "cfb", "ctr", "obc"] and
      this = node.asSource()
    ) or 
    exists(StringConstExpr s | 
      s.getValueString().toLowerCase() = ["ecb", "ofb", "cfb", "ctr", "obc"] and 
      this.asExpr().getExpr() = s
    )
  }
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof WeakAesMode }

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