import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstances
private import experimental.quantum.OpenSSL.Operations.OpenSSLOperations
private import Crypto::KeyOpAlg as KeyOpAlg
private import AlgToAVCFlow

class KnownOpenSslMacConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::KeyOperationAlgorithmInstance instanceof KnownOpenSslMacAlgorithmExpr
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

  override string getRawAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override Crypto::KeyOpAlg::AlgorithmType getAlgorithmType() {
    if this instanceof KnownOpenSslHMacAlgorithmExpr
    then result = KeyOpAlg::TMac(KeyOpAlg::HMAC())
    else
      if this instanceof KnownOpenSslCMacAlgorithmExpr
      then result = KeyOpAlg::TMac(KeyOpAlg::CMAC())
      else result = KeyOpAlg::TMac(KeyOpAlg::OtherMacAlgorithmType())
  }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    // TODO: trace to any key size initializer?
    none()
  }

  override int getKeySizeFixed() {
    // TODO: are there known fixed key sizes to consider?
    none()
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }
}

class KnownOpenSslHMacConstantAlgorithmInstance extends Crypto::HmacAlgorithmInstance,
  KnownOpenSslMacConstantAlgorithmInstance
{
  override Crypto::AlgorithmValueConsumer getHashAlgorithmValueConsumer() {
    if exists(this.(KnownOpenSslHMacAlgorithmExpr).getExplicitHashAlgorithm())
    then
      // ASSUMPTION: if there is an explicit hash algorithm, it is already modeled
      // and we can simply grab that model's AVC
      this.(OpenSslAlgorithmInstance).getAvc() = result
    else
      // ASSUMPTION: If no explicit algorithm is given, then find
      // where the current AVC traces to a HashAlgorithmIO consuming operation step.
      // TODO: need to consider getting reset values, tracing down to the first set for now
      exists(OperationStep s, AvcContextCreationStep avc |
        avc = super.getAvc() and
        avc.flowsToOperationStep(s) and
        s.getAlgorithmValueConsumerForInput(HashAlgorithmIO()) = result
      )
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }
}
