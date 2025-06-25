import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import experimental.quantum.OpenSSL.Operations.OpenSSLOperations
private import AlgToAVCFlow

class KnownOpenSslMacConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::MacAlgorithmInstance instanceof KnownOpenSslMacAlgorithmExpr
{
  OpenSslAlgorithmValueConsumer getterCall;

  KnownOpenSslMacConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSslAlgorithm is call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof OpenSslAlgorithmLiteral and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSslAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink)
    )
    or
    // Possibility 2:
    this instanceof OpenSslAlgorithmCall and
    getterCall = this
  }

  override OpenSslAlgorithmValueConsumer getAvc() { result = getterCall }

  override string getRawMacAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override Crypto::MacType getMacType() {
    this instanceof KnownOpenSslHMacAlgorithmExpr and result = Crypto::HMAC()
    or
    this instanceof KnownOpenSslCMacAlgorithmExpr and result = Crypto::CMAC()
  }
}

class KnownOpenSslHMacConstantAlgorithmInstance extends Crypto::HmacAlgorithmInstance,
  KnownOpenSslMacConstantAlgorithmInstance
{
  override Crypto::AlgorithmValueConsumer getHashAlgorithmValueConsumer() {
    if exists(this.(KnownOpenSslHMacAlgorithmExpr).getExplicitHashAlgorithm())
    then
      // ASSUMPTION: if there is an explicit hash algorithm, it is already modeled
      // and we can simply grab that model's AVC
      exists(OpenSslAlgorithmInstance inst | inst.getAvc() = result and inst = this)
    else
      // ASSUMPTION: If no explicit algorithm is given, then it is assumed to be configured by
      // a signature operation
      exists(Crypto::SignatureOperationInstance s |
        s.getHashAlgorithmValueConsumer() = result and
        s.getAnAlgorithmValueConsumer() = this.getAvc()
      )
  }
}
