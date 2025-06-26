import cpp
private import experimental.quantum.Language
private import OpenSSLAlgorithmInstanceBase
private import experimental.quantum.OpenSSL.Operations.OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import AlgToAVCFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.DirectAlgorithmValueConsumer
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase

/**
 * A class to define padding specific integer values.
 * from rsa.h in openssl:
 *     # define RSA_PKCS1_PADDING          1
 *     # define RSA_NO_PADDING             3
 *     # define RSA_PKCS1_OAEP_PADDING     4
 *     # define RSA_X931_PADDING           5
 *     # define RSA_PKCS1_PSS_PADDING      6
 *     # define RSA_PKCS1_WITH_TLS_PADDING 7
 *     # define RSA_PKCS1_NO_IMPLICIT_REJECT_PADDING 8
 */
class OpenSslSpecialPaddingLiteral extends Literal {
  // TODO: we can be more specific about where the literal is in a larger expression
  // to avoid literals that are clealy not representing an algorithm, e.g., array indices.
  OpenSslSpecialPaddingLiteral() { this.getValue().toInt() in [0, 1, 3, 4, 5, 6, 7, 8] }
}

/**
 * Holds if `e` has the given `type`.
 * Given a `KnownOpenSslPaddingAlgorithmExpr`, converts this to a padding family type.
 * Does not bind if there is no mapping (no mapping to 'unknown' or 'other').
 */
predicate knownOpenSslConstantToPaddingFamilyType(
  KnownOpenSslPaddingAlgorithmExpr e, Crypto::TPaddingType type
) {
  exists(string name |
    name = e.(KnownOpenSslAlgorithmExpr).getNormalizedName() and
    (
      name.matches("OAEP") and type = Crypto::OAEP()
      or
      name.matches("PSS") and type = Crypto::PSS()
      or
      name.matches("PKCS7") and type = Crypto::PKCS7()
      or
      name.matches("PKCS1V15") and type = Crypto::PKCS1_v1_5()
    )
  )
}

class KnownOpenSslPaddingConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::PaddingAlgorithmInstance instanceof Expr
{
  OpenSslAlgorithmValueConsumer getterCall;
  boolean isPaddingSpecificConsumer;

  KnownOpenSslPaddingConstantAlgorithmInstance() {
    // three possibilities:
    // 1) The source is a 'typical' literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSslAlgorithm is call, and we know we have an instance immediately from that
    // 3) the source is a padding-specific literal flowing to a padding-specific consumer
    // Possibility 1:
    this instanceof OpenSslAlgorithmLiteral and
    this instanceof KnownOpenSslPaddingAlgorithmExpr and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSslAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink) and
      isPaddingSpecificConsumer = false
    )
    or
    // Possibility 2:
    this instanceof OpenSslAlgorithmCall and
    getterCall = this and
    this instanceof KnownOpenSslPaddingAlgorithmExpr and
    isPaddingSpecificConsumer = false
    or
    // Possibility 3: padding-specific literal
    this instanceof OpenSslSpecialPaddingLiteral and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a padding-specific consumer
      RSAPaddingAlgorithmToPaddingAlgorithmValueConsumerFlow::flow(src, sink)
    ) and
    isPaddingSpecificConsumer = true
  }

  override string getRawPaddingAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override OpenSslAlgorithmValueConsumer getAvc() { result = getterCall }

  Crypto::TPaddingType getKnownPaddingType() {
    this.(Literal).getValue().toInt() in [1, 7, 8] and result = Crypto::PKCS1_v1_5()
    or
    this.(Literal).getValue().toInt() = 3 and result = Crypto::NoPadding()
    or
    this.(Literal).getValue().toInt() = 4 and result = Crypto::OAEP()
    or
    this.(Literal).getValue().toInt() = 5 and result = Crypto::ANSI_X9_23()
    or
    this.(Literal).getValue().toInt() = 6 and result = Crypto::PSS()
  }

  override Crypto::TPaddingType getPaddingType() {
    isPaddingSpecificConsumer = true and
    (
      result = this.getKnownPaddingType()
      or
      not exists(this.getKnownPaddingType()) and result = Crypto::OtherPadding()
    )
    or
    isPaddingSpecificConsumer = false and
    knownOpenSslConstantToPaddingFamilyType(this, result)
  }
}

class OAEPPaddingAlgorithmInstance extends Crypto::OAEPPaddingAlgorithmInstance,
  KnownOpenSslPaddingConstantAlgorithmInstance
{
  OAEPPaddingAlgorithmInstance() {
    this.(Crypto::PaddingAlgorithmInstance).getPaddingType() = Crypto::OAEP()
  }

  override Crypto::HashAlgorithmInstance getOAEPEncodingHashAlgorithm() {
    exists(OperationStep s |
      this.getAvc().(AvcContextCreationStep).flowsToOperationStep(s) and
      s.getAlgorithmValueConsumerForInput(HashAlgorithmOaepIO()) =
        result.(OpenSslAlgorithmInstance).getAvc()
    )
  }

  override Crypto::HashAlgorithmInstance getMGF1HashAlgorithm() {
    exists(OperationStep s |
      this.getAvc().(AvcContextCreationStep).flowsToOperationStep(s) and
      s.getAlgorithmValueConsumerForInput(HashAlgorithmMgf1IO()) =
        result.(OpenSslAlgorithmInstance).getAvc()
    )
  }
}
