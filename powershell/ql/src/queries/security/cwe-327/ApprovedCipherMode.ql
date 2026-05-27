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
predicate isSymmetricAlgorithmTypeName(string name) {
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
 * A data flow node that creates a symmetric algorithm object.
 */
abstract class SymmetricAlgorithmCreation extends DataFlow::Node { }

/**
 * A symmetric algorithm creation via `New-Object "System.Security.Cryptography.Xxx"` or `[Xxx]::new()`.
 */
class SymmetricAlgorithmNewObject extends SymmetricAlgorithmCreation {
  SymmetricAlgorithmNewObject() {
    exists(DataFlow::ObjectCreationNode objCreation, string typeName, string shortName |
      this = objCreation and
      typeName = objCreation.getLowerCaseConstructedTypeName() and
      isSymmetricAlgorithmTypeName(shortName) and
      (
        typeName = shortName or
        typeName.matches("%." + shortName)
      )
    )
  }
}

/**
 * A symmetric algorithm creation via `[System.Security.Cryptography.Xxx]::Create()`.
 */
class SymmetricAlgorithmFactoryCreate extends SymmetricAlgorithmCreation {
  SymmetricAlgorithmFactoryCreate() {
    exists(string typeName |
      isSymmetricAlgorithmTypeName(typeName) and
      this =
        API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember(typeName)
            .getMember("create")
            .asCall()
    )
  }
}

/**
 * A member expression that writes to the `Mode` property of a symmetric algorithm object.
 */
class SymmetricAlgorithmModeProperty extends MemberExpr {
  SymmetricAlgorithmModeProperty() {
    exists(SymmetricAlgorithmCreation symAlgCreation, DataFlow::Node qualAccess |
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
