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

/**
 * Holds if `name` (lowercase) is the short name of a .NET symmetric algorithm type
 * that has a `Mode` property.
 */
private predicate isSymmetricAlgorithmTypeName(string name) {
  name =
    [
      "aes", "aesmanaged", "aescryptoserviceprovider", "aescng",
      "rijndael", "rijndaelmanaged",
      "des", "descryptoserviceprovider",
      "tripledes", "tripledescryptoserviceprovider",
      "rc2", "rc2cryptoserviceprovider",
      "symmetricalgorithm"
    ]
}

/**
 * Holds if `creation` is a data flow node that creates a symmetric algorithm object.
 */
private predicate isSymmetricAlgorithmCreation(DataFlow::Node creation) {
  // New-Object "System.Security.Cryptography.Xxx" or [Xxx]::new()
  exists(DataFlow::ObjectCreationNode objCreation, string typeName, string shortName |
    creation = objCreation and
    typeName = objCreation.getLowerCaseConstructedTypeName() and
    isSymmetricAlgorithmTypeName(shortName) and
    (
      typeName = shortName or
      typeName.matches("%." + shortName)
    )
  )
  or
  // [System.Security.Cryptography.Xxx]::Create()
  exists(string typeName |
    isSymmetricAlgorithmTypeName(typeName) and
    creation =
      API::getTopLevelMember("system")
          .getMember("security")
          .getMember("cryptography")
          .getMember(typeName)
          .getMember("create")
          .asCall()
  )
}

/**
 * A member expression that writes to the `Mode` property of a symmetric algorithm object.
 */
class SymmetricAlgorithmModeProperty extends MemberExpr {
  SymmetricAlgorithmModeProperty() {
    exists(DataFlow::Node symAlgCreation, DataFlow::Node qualAccess |
      isSymmetricAlgorithmCreation(symAlgCreation) and
      qualAccess.getALocalSource() = symAlgCreation and
      qualAccess.asExpr().getExpr() = this.getQualifier() and
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
      any(SymmetricAlgorithmModeProperty mode).getQualifier()
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
