import powershell
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs
import CryptoArtifact

abstract class CryptoAlgorithmObjectCreation extends DataFlow::ObjectCreationNode {
  string objectName;

  CryptoAlgorithmObjectCreation() {
    objectName =
      this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString().toLowerCase()
  }

}

abstract class CryptoAlgorithmCreateCall extends DataFlow::CallNode {
  string objectName;

  CryptoAlgorithmCreateCall() {
    this =
      API::getTopLevelMember("system")
          .getMember("security")
          .getMember("cryptography")
          .getMember(objectName)
          .getMember("create")
          .asCall()
  }

  string getObjectName() { result = objectName }
}

abstract class CryptoAlgorithmCreateArgCall extends DataFlow::CallNode {
  string objectName;

  CryptoAlgorithmCreateArgCall() {
    (
      this =
        API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember(_)
            .getMember("create")
            .asCall() or
      this =
        API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember("create")
            .asCall()
    ) and
    objectName = this.getAnArgument().asExpr().getValue().asString().toLowerCase()
  }

  string getObjectName() { result = objectName }
}

class CryptoAlgorithmCreateFromNameCall extends DataFlow::CallNode {
  string objectName;

  CryptoAlgorithmCreateFromNameCall() {
    this =
      API::getTopLevelMember("system")
          .getMember("security")
          .getMember("cryptography")
          .getMember("cryptoconfig")
          .getMember("createfromname")
          .asCall() and
    objectName = this.getAnArgument().asExpr().getValue().asString().toLowerCase()
  }

  string getObjectName() { result = objectName }
}

class HashAlgorithmObjectCreation extends HashAlgorithm, CryptoAlgorithmObjectCreation {
  string algName;

  HashAlgorithmObjectCreation() {
    this.getObjectName() = "system.security.cryptography." + algName + ["", "cryptoserviceprovider"] and
    isHashingAlgorithm(algName)
  }

  override string getName() { result = algName }
}

class HashAlgorithmCreateCall extends HashAlgorithm, CryptoAlgorithmCreateCall {
  string algName;

  HashAlgorithmCreateCall() {
    isHashingAlgorithm(algName) and
    this.getObjectName() = ["", "system.security.cryptography."] + algName
  }

  override string getName() { result = algName }
}

class HashAlgorithmCreateFromNameCall extends HashAlgorithm, CryptoAlgorithmCreateFromNameCall {
  string algName;

  HashAlgorithmCreateFromNameCall() {
    this.getObjectName() = ["", "system.security.cryptography."] + algName and
    isHashingAlgorithm(algName)
  }

  override string getName() { result = algName }
}

class SymmetricAlgorithmObjectCreation extends SymmetricAlgorithm, CryptoAlgorithmObjectCreation {
  string algName;

  SymmetricAlgorithmObjectCreation() {
    (
      objectName = "system.security.cryptography." + algName or
      objectName = "system.security.cryptography." + algName + "cryptoserviceprovider" or
      objectName = "system.security.cryptography.symmetricalgorithm." + algName
    ) and
    isSymmetricAlgorithm(algName)
  }

  override string getName() { result = algName }
}

class SymmetricAlgorithmCreateCall extends SymmetricAlgorithm, CryptoAlgorithmCreateCall {
  string algName;

  SymmetricAlgorithmCreateCall() {
    isSymmetricAlgorithm(algName) and
    this.getObjectName() = ["", "system.security.cryptography.", "system.security.cryptography.symmetricalgorithm."] + algName
  }

  override string getName() { result = algName }
}

class SymmetricAlgorithmCreateArgCall extends SymmetricAlgorithm, CryptoAlgorithmCreateArgCall {
  string algName;

  SymmetricAlgorithmCreateArgCall() {
    algName = ["", "system.security.cryptography."] + this.getObjectName() and
    isSymmetricAlgorithm(algName)
  }

  override string getName() { result = algName }
}

class SymmetricAlgorithmCreateFromNameCall extends SymmetricAlgorithm,
  CryptoAlgorithmCreateFromNameCall
{
  string algName;

  SymmetricAlgorithmCreateFromNameCall() {
    this.getObjectName() = ["", "system.security.cryptography.", "system.security.cryptography.symmetricalgorithm."] + algName and
    isSymmetricAlgorithm(algName)
  }

  override string getName() { result = algName }
}

class CipherBlockStringConstExpr extends BlockMode {
  string modeName;

  CipherBlockStringConstExpr() {
    exists(StringConstExpr s |
      s = this.asExpr().getExpr() and
      modeName = s.getValueString().toLowerCase() and
      isCipherBlockModeAlgorithm(modeName)
    )
  }

  override string getName() { result = modeName }
}

class CipherBlockModeEnum extends BlockMode {
  string modeName;

  CipherBlockModeEnum() {
    exists(API::Node node |
      node =
        API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember("ciphermode")
            .getMember(modeName) and
      this = node.asSource() and
      isCipherBlockModeAlgorithm(modeName)
    )
  }

  override string getName() { result = modeName }
}
