import EVPHashInitializer
import EVPHashOperation
import EVPHashAlgorithmSource

class EVP_Digest_Initializer_Algorithm_Consumer extends Crypto::AlgorithmValueConsumer instanceof EVPDigestInitializerAlgorithmArgument
{
  override DataFlow::Node getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(KnownOpenSSLHashConstantAlgorithmInstance).getConsumer() = this
  }
}

class EVP_Q_Digest_Algorithm_Consumer extends Crypto::AlgorithmValueConsumer instanceof EVP_Q_Digest_Algorithm_Argument
{
  override DataFlow::Node getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(KnownOpenSSLHashConstantAlgorithmInstance).getConsumer() = this
  }
}

class EVP_Digest_Algorithm_Consumer extends Crypto::AlgorithmValueConsumer instanceof EVP_Digest_Algorithm_Argument
{
  override DataFlow::Node getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(KnownOpenSSLHashConstantAlgorithmInstance).getConsumer() = this
  }
}
