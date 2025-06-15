import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import experimental.quantum.OpenSSL.Operations.OpenSSLOperations
private import AlgToAVCFlow

class KnownOpenSSLMACConstantAlgorithmInstance extends OpenSSLAlgorithmInstance,
  Crypto::MACAlgorithmInstance instanceof KnownOpenSSLMACAlgorithmExpr
{
  OpenSSLAlgorithmValueConsumer getterCall;

  KnownOpenSSLMACConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSSLAlgorithm is call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof OpenSSLAlgorithmLiteral and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.(OpenSSLAlgorithmValueConsumer).getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSSLAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink)
    )
    or
    // Possibility 2:
    this instanceof OpenSSLAlgorithmCall and
    getterCall = this
  }

  override OpenSSLAlgorithmValueConsumer getAVC() { result = getterCall }

  override string getRawMACAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override Crypto::TMACType getMACType() {
    this instanceof KnownOpenSSLHMACAlgorithmExpr and result instanceof Crypto::THMAC
    or
    this instanceof KnownOpenSSLCMACAlgorithmExpr and result instanceof Crypto::TCMAC
  }
}

class KnownOpenSSLHMACConstantAlgorithmInstance extends Crypto::HMACAlgorithmInstance,
  KnownOpenSSLMACConstantAlgorithmInstance
{
  override Crypto::AlgorithmValueConsumer getHashAlgorithmValueConsumer() {
    if exists(this.(KnownOpenSSLHMACAlgorithmExpr).getExplicitHashAlgorithm())
    then
      // ASSUMPTION: if there is an explicit hash algorithm, it is already modeled
      // and we can simply grab that model's AVC
      exists(OpenSSLAlgorithmInstance inst | inst.getAVC() = result and inst = this)
    else
      // ASSUMPTION: If no explicit algorithm is given, then it is assumed to be configured by
      // a signature operation
      exists(Crypto::SignatureOperationInstance s |
        s.getHashAlgorithmValueConsumer() = result and
        s.getAnAlgorithmValueConsumer() = this.getAVC()
      )
  }
}
