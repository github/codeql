private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase

abstract class OpenSslAlgorithmInstance extends Crypto::AlgorithmInstance {
  abstract OpenSslAlgorithmValueConsumer getAvc();
}
