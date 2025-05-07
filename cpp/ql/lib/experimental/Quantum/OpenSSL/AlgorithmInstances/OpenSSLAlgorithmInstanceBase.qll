import experimental.Quantum.Language
import experimental.Quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase

abstract class OpenSSLAlgorithmInstance extends Crypto::AlgorithmInstance {
  abstract OpenSSLAlgorithmValueConsumer getAVC();
}
