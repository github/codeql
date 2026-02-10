import powershell
import CryptoAlgorithmNames
import semmle.code.powershell.dataflow.DataFlow

/*
 * A cryptographic artifact is a DataFlow::Node associated with some
 * operation, algorithm, or any other aspect of cryptography.
 */

abstract class CryptographicArtifact extends DataFlow::Node { }

abstract class CryptographicAlgorithm extends CryptographicArtifact {
  abstract string getName();
}

abstract class HashAlgorithm extends CryptographicAlgorithm {
  final string getHashName() {
    if exists(string n | n = this.getName() and isHashingAlgorithm(n))
    then result = this.getName()
    else result = unknownAlgorithm()
  }
}

abstract class SymmetricAlgorithm extends CryptographicAlgorithm {
  final string getSymmetricAlgorithmName() {
    if exists(string n | n = this.getName() and isSymmetricAlgorithm(n))
    then result = this.getName()
    else result = unknownAlgorithm()
  }
}

abstract class BlockMode extends CryptographicAlgorithm {
  final string getBlockModeName() {
    if exists(string n | n = this.getName() and isCipherBlockModeAlgorithm(n))
    then result = this.getName()
    else result = unknownAlgorithm()
  }
}
