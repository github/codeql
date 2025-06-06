private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase

abstract class OpenSSLAlgorithmInstance extends Crypto::AlgorithmInstance {
  abstract OpenSSLAlgorithmValueConsumer getAVC();
}
