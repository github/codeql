import EVPHashInitializer
import EVPHashOperation
import EVPHashAlgorithmSource

class EVP_Digest_Initializer_Algorithm_Consumer extends Crypto::AlgorithmConsumer instanceof EVPDigestInitializerAlgorithmArgument{ 
    override DataFlow::Node getInputNode() { result.asExpr() = this }

    override Crypto::AlgorithmElement getAKnownAlgorithmSource() {
        result.(KnownOpenSSLHashConstantAlgorithmInstance).getConsumer() = this
      }
}

class EVP_Q_Digest_Algorithm_Consumer extends Crypto::AlgorithmConsumer instanceof EVP_Q_Digest_Algorithm_Argument{ 
    override DataFlow::Node getInputNode() { result.asExpr() = this }

    override Crypto::AlgorithmElement getAKnownAlgorithmSource() {
        result.(KnownOpenSSLHashConstantAlgorithmInstance).getConsumer() = this
      }
}

class EVP_Digest_Algorithm_Consumer extends Crypto::AlgorithmConsumer instanceof EVP_Digest_Algorithm_Argument{ 
    override DataFlow::Node getInputNode() { result.asExpr() = this }

    override Crypto::AlgorithmElement getAKnownAlgorithmSource() {
        result.(KnownOpenSSLHashConstantAlgorithmInstance).getConsumer() = this
      }
}