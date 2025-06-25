import cpp
private import experimental.quantum.Language
private import OpenSSLAlgorithmInstanceBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.DirectAlgorithmValueConsumer
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import AlgToAVCFlow
private import codeql.quantum.experimental.Standardization::Types::KeyOpAlg as KeyOpAlg

/**
 * Given a `KnownOpenSslBlockModeAlgorithmExpr`, converts this to a block family type.
 * Does not bind if there is no mapping (no mapping to 'unknown' or 'other').
 */
predicate knownOpenSslConstantToBlockModeFamilyType(
  KnownOpenSslBlockModeAlgorithmExpr e, KeyOpAlg::ModeOfOperationType type
) {
  exists(string name |
    name = e.(KnownOpenSslAlgorithmExpr).getNormalizedName() and
    (
      name = "CBC" and type instanceof KeyOpAlg::CBC
      or
      name = "CFB%" and type instanceof KeyOpAlg::CFB
      or
      name = "CTR" and type instanceof KeyOpAlg::CTR
      or
      name = "GCM" and type instanceof KeyOpAlg::GCM
      or
      name = "OFB" and type instanceof KeyOpAlg::OFB
      or
      name = "XTS" and type instanceof KeyOpAlg::XTS
      or
      name = "CCM" and type instanceof KeyOpAlg::CCM
      or
      name = "GCM" and type instanceof KeyOpAlg::GCM
      or
      name = "CCM" and type instanceof KeyOpAlg::CCM
      or
      name = "ECB" and type instanceof KeyOpAlg::ECB
    )
  )
}

class KnownOpenSslBlockModeConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::ModeOfOperationAlgorithmInstance instanceof KnownOpenSslBlockModeAlgorithmExpr
{
  OpenSslAlgorithmValueConsumer getterCall;

  KnownOpenSslBlockModeConstantAlgorithmInstance() {
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

  override KeyOpAlg::ModeOfOperationType getModeType() {
    knownOpenSslConstantToBlockModeFamilyType(this, result)
    or
    not knownOpenSslConstantToBlockModeFamilyType(this, _) and result = KeyOpAlg::OtherMode()
  }

  // NOTE: I'm not going to attempt to parse out the mode specific part, so returning
  // the same as the raw name for now.
  override string getRawModeAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override OpenSslAlgorithmValueConsumer getAvc() { result = getterCall }
}
