import EVPCipherInitializer
import EVPCipherOperation
import EVPCipherAlgorithmSource

class EVP_Cipher_Initializer_Algorithm_Consumer extends Crypto::AlgorithmConsumer instanceof EVPCipherInitializerAlgorithmArgument
{
  override DataFlow::Node getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmElement getAKnownAlgorithmSource() {
    result.(KnownOpenSSLCipherConstantAlgorithmInstance).getConsumer() = this
  }
}

// //TODO: need a key consumer
// class EVP_Initializer_Key_Consumer extends Crypto::KeyConsumer instanceof EVP_Cipher_Inititalizer isntanceof InitializerKeyArgument{
// }
class EVP_Cipher_Initializer_IV_Consumer extends Crypto::NonceArtifactConsumer instanceof EVPCipherInitializerIVArgument
{
  override DataFlow::Node getInputNode() { result.asExpr() = this }
}

class EVP_Cipher_Input_Consumer extends Crypto::CipherInputConsumer instanceof EVPCipherInputArgument
{
  override DataFlow::Node getInputNode() { result.asExpr() = this }
}
