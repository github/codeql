/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id powershell/weak-symmetric-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.security.cryptography.Concepts


// class WeaksSymmetricAlgorithmCreateCall extends DataFlow::CallNode {
//     WeaksSymmetricAlgorithmCreateCall() {
//         this = API::getTopLevelMember("system").getMember("security").getMember("cryptography").getMember("rc2").getMember("create").asCall() or
//         this = API::getTopLevelMember("system").getMember("security").getMember("cryptography").getMember("des").getMember("create").asCall() or
//         this = API::getTopLevelMember("system").getMember("security").getMember("cryptography").getMember("tripledes").getMember("create").asCall() or 
//         (
//             this = API::getTopLevelMember("system").getMember("security").getMember("cryptography").getMember("symmetricalgorithm").getMember("create").asCall() and 
//             this.getAnArgument().asExpr().getValue().asString() = ["RC2", "DES", "TripleDES", "Rijndael"] or 
//             this.getAnArgument().asExpr().getValue().asString() = ["System.Security.Cryptography.RC2", "System.Security.Cryptography.DES", "System.Security.Cryptography.TripleDES", "System.Security.Cryptography.Rijndael"]
//         )
//   }
// }

// class WeakSymmetricAlgorithmObjectCreation extends DataFlow::ObjectCreationNode {
//   WeakSymmetricAlgorithmObjectCreation() {
//     this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.DES" or 
//     this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.DESCryptoServiceProvider" or 
//     this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.TripleDES" or 
//     this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.TripleDESCryptoServiceProvider" or
//     this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.RC2" or 
//     this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.RC2CryptoServiceProvider" or
//     this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.Rijndael" or 
//     this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Security.Cryptography.Rijndael"
//   }
// }

// class CreateFromNameSink extends DataFlow::CallNode {
//   CreateFromNameSink(){
//       this = API::getTopLevelMember("system").getMember("security").getMember("cryptography").getMember("cryptoconfig").getMember("createfromname").asCall() and 
//       (
//         this.getAnArgument().asExpr().getValue().asString() = ["System.Security.Cryptography.DES", "System.Security.Cryptography.TripleDES", "System.Security.Cryptography.RC2", "System.Security.Cryptography.Rijndael"] or
//         this.getAnArgument().asExpr().getValue().asString() = ["DES", "TripleDES", "RC2", "Rijndael"] 
//       )
//   }
// }

// from DataFlow::Node weakSymmetricAlg
// where weakSymmetricAlg instanceof WeaksSymmetricAlgorithmCreateCall or
//       weakSymmetricAlg instanceof WeakSymmetricAlgorithmObjectCreation or 
//         weakSymmetricAlg instanceof CreateFromNameSink
// select weakSymmetricAlg,
//     "Use of weak symmetric cryptographic algorithm. Consider using AES instead."

from SymmetricAlgorithm symmetricAlg
where
  not symmetricAlg.getSymmetricAlgorithmName() =  ["aes","aes128", "aes192", "aes256"]
  select symmetricAlg,
    "Use of weak symmetric cryptographic algorithm: " + symmetricAlg.getSymmetricAlgorithmName() + ". Consider using AES instead."