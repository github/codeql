/**
 * @name Use of weak cryptographic hash
 * @description Using weak cryptographic hash algorithms like MD5 or SHA1 can compromise data integrity and security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id powershell/weak-hash
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow

class WeakHashAlgorithmObjectCreation extends DataFlow::ObjectCreationNode {
  WeakHashAlgorithmObjectCreation() {
    this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.MD5" or 
    this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.MD5CryptoServiceProvider" or 
    this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.SHA1" or
    this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.SHA1CryptoServiceProvider" or
    this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.SHA1Managed"
  }
}

class WeakHashAlgorithmObjectCreate extends DataFlow::CallNode {
    WeakHashAlgorithmObjectCreate() {
        // System.Security.Cryptography.MD5
        this = API::getTopLevelMember("system")
        .getMember("security")
        .getMember("cryptography")
        .getMember("md5")
        .getMember("create")
        .asCall() 
    }
}

class ComputeHashSink extends DataFlow::Node {
    ComputeHashSink() {
      exists(DataFlow::ObjectCreationNode ocn, DataFlow::CallNode cn | 
        (
            ocn.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.SHA1Managed" or 
            ocn.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.SHA1CryptoServiceProvider"
        ) and
        cn.getQualifier().getALocalSource() = ocn and 
        cn.getLowerCaseName() = "computehash" and
        cn.getAnArgument() = this
    )
    }
}

from DataFlow::Node sink 
where sink instanceof ComputeHashSink or 
sink instanceof WeakHashAlgorithmObjectCreation or 
sink instanceof WeakHashAlgorithmObjectCreate
select sink, "Use of weak cryptographic hash algorithm."
