import cpp
import experimental.Quantum.Language
import OpenSSLAlgorithmInstanceBase
import experimental.Quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
import AlgToAVCFlow
import experimental.Quantum.OpenSSL.AlgorithmValueConsumers.DirectAlgorithmValueConsumer

/**
 * Given a `KnownOpenSSLPaddingAlgorithmConstant`, converts this to a padding family type.
 * Does not bind if there is know mapping (no mapping to 'unknown' or 'other').
 */
predicate knownOpenSSLConstantToPaddingFamilyType(
  KnownOpenSSLPaddingAlgorithmConstant e, Crypto::TPaddingType type
) {
  exists(string name |
    name = e.getNormalizedName() and
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

//abstract class OpenSSLPaddingAlgorithmInstance extends OpenSSLAlgorithmInstance, Crypto::PaddingAlgorithmInstance{}
// TODO: need to alter this to include known padding constants which don't have the
// same mechanics as those with known nids
class KnownOpenSSLPaddingConstantAlgorithmInstance extends OpenSSLAlgorithmInstance,
  Crypto::PaddingAlgorithmInstance instanceof Expr
{
  OpenSSLAlgorithmValueConsumer getterCall;
  boolean isPaddingSpecificConsumer;

  KnownOpenSSLPaddingConstantAlgorithmInstance() {
    // three possibilities:
    // 1) The source is a 'typical' literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSSLAlgorithm is call, and we know we have an instance immediately from that
    // 3) the source is a padding-specific literal flowing to a padding-specific consumer
    // Possibility 1:
    this instanceof Literal and
    this instanceof KnownOpenSSLPaddingAlgorithmConstant and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.(OpenSSLAlgorithmValueConsumer).getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSSLAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink) and
      isPaddingSpecificConsumer = false
    )
    or
    // Possibility 2:
    this instanceof DirectAlgorithmValueConsumer and
    getterCall = this and
    this instanceof KnownOpenSSLPaddingAlgorithmConstant and
    isPaddingSpecificConsumer = false
    or
    // Possibility 3:
    // from rsa.h in openssl:
    // # define RSA_PKCS1_PADDING          1
    // # define RSA_NO_PADDING             3
    // # define RSA_PKCS1_OAEP_PADDING     4
    // # define RSA_X931_PADDING           5
    // /* EVP_PKEY_ only */
    // # define RSA_PKCS1_PSS_PADDING      6
    // # define RSA_PKCS1_WITH_TLS_PADDING 7
    // /* internal RSA_ only */
    // # define RSA_PKCS1_NO_IMPLICIT_REJECT_PADDING 8
    this instanceof Literal and
    this.getValue().toInt() in [0, 1, 3, 4, 5, 6, 7, 8] and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.(OpenSSLAlgorithmValueConsumer).getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a padding-specific consumer
      RSAPaddingAlgorithmToPaddingAlgorithmValueConsumerFlow::flow(src, sink)
    ) and
    isPaddingSpecificConsumer = true
  }

  override string getRawPaddingAlgorithmName() { result = this.(Literal).getValue().toString() }

  override OpenSSLAlgorithmValueConsumer getAVC() { result = getterCall }

  override Crypto::TPaddingType getPaddingType() {
    isPaddingSpecificConsumer = true and
    (
      if this.(Literal).getValue().toInt() in [1, 7, 8]
      then result = Crypto::PKCS1_v1_5()
      else
        if this.(Literal).getValue().toInt() = 3
        then result = Crypto::NoPadding()
        else
          if this.(Literal).getValue().toInt() = 4
          then result = Crypto::OAEP()
          else
            if this.(Literal).getValue().toInt() = 5
            then result = Crypto::ANSI_X9_23()
            else
              if this.(Literal).getValue().toInt() = 6
              then result = Crypto::PSS()
              else result = Crypto::OtherPadding()
    )
    or
    isPaddingSpecificConsumer = false and
    knownOpenSSLConstantToPaddingFamilyType(this, result)
  }
}

// // Values used for EVP_PKEY_CTX_set_rsa_padding, these are
// // not the same as 'typical' constants found in the set of known algorithm constants
// // they do not have an NID
// // TODO: what about setting the padding directly?
// class KnownRSAPaddingConstant extends OpenSSLPaddingAlgorithmInstance, Crypto::PaddingAlgorithmInstance instanceof Literal
// {
//   KnownRSAPaddingConstant() {
//     // from rsa.h in openssl:
//     // # define RSA_PKCS1_PADDING          1
//     // # define RSA_NO_PADDING             3
//     // # define RSA_PKCS1_OAEP_PADDING     4
//     // # define RSA_X931_PADDING           5
//     // /* EVP_PKEY_ only */
//     // # define RSA_PKCS1_PSS_PADDING      6
//     // # define RSA_PKCS1_WITH_TLS_PADDING 7
//     // /* internal RSA_ only */
//     // # define RSA_PKCS1_NO_IMPLICIT_REJECT_PADDING 8
//     this instanceof Literal and
//     this.getValue().toInt() in [0, 1, 3, 4, 5, 6, 7, 8]
//     // TODO: trace to padding-specific consumers
//     RSAPaddingAlgorithmToPaddingAlgorithmValueConsumerFlow
//   }
//   override string getRawPaddingAlgorithmName() { result = this.(Literal).getValue().toString() }
//   override Crypto::TPaddingType getPaddingType() {
//     if this.(Literal).getValue().toInt() in [1, 6, 7, 8]
//     then result = Crypto::PKCS1_v1_5()
//     else
//       if this.(Literal).getValue().toInt() = 3
//       then result = Crypto::NoPadding()
//       else
//         if this.(Literal).getValue().toInt() = 4
//         then result = Crypto::OAEP()
//         else
//           if this.(Literal).getValue().toInt() = 5
//           then result = Crypto::ANSI_X9_23()
//           else result = Crypto::OtherPadding()
//   }
// }
class OAEPPaddingAlgorithmInstance extends Crypto::OAEPPaddingAlgorithmInstance,
  KnownOpenSSLPaddingConstantAlgorithmInstance
{
  OAEPPaddingAlgorithmInstance() {
    this.(Crypto::PaddingAlgorithmInstance).getPaddingType() = Crypto::OAEP()
  }

  override Crypto::HashAlgorithmInstance getOAEPEncodingHashAlgorithm() {
    none() //TODO
  }

  override Crypto::HashAlgorithmInstance getMGF1HashAlgorithm() {
    none() //TODO
  }
}
