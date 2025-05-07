import experimental.quantum.Language
import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase

abstract class OpenSSLAlgorithmInstance extends Crypto::AlgorithmInstance {
  abstract OpenSSLAlgorithmValueConsumer getAVC();
}
