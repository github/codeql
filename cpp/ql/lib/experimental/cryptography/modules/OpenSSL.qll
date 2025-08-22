import cpp
import experimental.cryptography.CryptoAlgorithmNames
import experimental.cryptography.CryptoArtifact
import experimental.cryptography.utils.OpenSSL.CryptoFunction
import experimental.cryptography.utils.OpenSSL.AlgorithmSink
import experimental.cryptography.utils.OpenSSL.PassthroughFunction
import experimental.cryptography.utils.OpenSSL.CryptoAlgorithm
import experimental.cryptography.CryptoArtifact
// import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.ir.dataflow.DataFlow

/**
 *  Problematic case in OpenSSL speed.c
 *    static const char *names[ALGOR_NUM] = {
 *        "md2", "mdc2", "md4", "md5", "sha1", "rmd160",
 *        "sha256", "sha512", "whirlpool", "hmac(md5)",
 *        "des-cbc", "des-ede3", "rc4", "idea-cbc", "seed-cbc",
 *        "rc2-cbc", "rc5-cbc", "blowfish", "cast-cbc",
 *        "aes-128-cbc", "aes-192-cbc", "aes-256-cbc",
 *        "camellia-128-cbc", "camellia-192-cbc", "camellia-256-cbc",
 *        "evp", "ghash", "rand", "cmac"
 *    };
 *
 *    Every entry is considered a block mode, hash, and symmetric encryption algorithm
 *    getEncryptionName for example, will return unknown
 */
predicate nodeToExpr(DataFlow::Node node, Expr e) {
  e = node.asExpr() or e = node.asIndirectArgument()
}

Expr getExprFromNode(DataFlow::Node node) { nodeToExpr(node, result) }

DataFlow::Node getNodeFromExpr(Expr e) { nodeToExpr(result, e) }

predicate isEVP_PKEY_CTX(Type t) { t.getUnderlyingType().stripType().getName() = "evp_pkey_ctx_st" }

/**
 * An expression representing an EVP_PKEY_CTX* at the location of a
 * known AlgorithmSinkArgument.
 * The EVP_PKEY_CTX* represents the location where the CTX is tied to the algorithm,
 * and can be used as a source for tracing EVP_PKEY_CTX to other operations.
 */
class Known_EVP_PKEY_CTX_Ptr_Source extends Expr {
  Known_EVP_PKEY_CTX_Ptr_Source() {
    isEVP_PKEY_CTX(this.getUnderlyingType()) and
    this.getUnderlyingType() instanceof PointerType and
    exists(AlgorithmSinkArgument arg, Call sinkCall |
      arg.getSinkCall() = sinkCall and
      sinkCall.getAnArgument() = this
      or
      this = sinkCall
    )
  }
}

// module CTXFlow implements DataFlow::ConfigSig{
//     predicate isSource(DataFlow::Node source) {
//         // ASSUMPTION: at a sink, an algorithm is converted into a CTX through a return of the call only
//         //             and is the primary source of interest for CTX tracing
//         source.asExpr() instanceof AlgorithmSinkArgument
//     }
//     predicate isSink(DataFlow::Node sink){
//         sink.asExpr() instanceof CTXSink
//     }
//     predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
//         //  cls.getName() = "asn1_object_st" flow out on any EVP_PKEY_CTX which is "evp_pkey_ctx_st"
//         exists(Call c |
//             isEVP_PKEY_CTX(c.getUnderlyingType()) and
//             node1.asExpr() = c.getAnArgument() and c = node2.asExpr())
//     }
// }
// module CTXFlowConfig = DataFlow::Global<CTXFlow>;
// TODO: currently only handles tracing from literals to sinks
module LiteralAlgorithmTracerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof Literal and
    // Optimization to reduce literal tracing on integers to only those that are known/relevant NIDs.
    (
      exists(source.asExpr().getValue().toInt())
      implies
      source.asExpr().getValue().toInt() < getNIDMax()
    ) and
    // False positives observed inside OBJ_nid2* and OBJ_sn2* functions where NULL is a possible assignment.
    // While this is a concern, it only occurs if the object being referenced is NULL to begin with
    // Perhaps a different query should be used to find these caes if they represent a threat.
    // Filter out any open ssl function source in a function namae Obj_*
    // False positives in OpenSSL also observed for CRYPTO_strndup (filtering any CRYPTO_* function)
    // due to setting a null byte in the string
    (
      isPossibleOpenSSLFunction(source.getFunction())
      implies
      (
        not source.getFunction().getName().matches("OBJ_%") and
        not source.getFunction().getName().matches("CRYPTO_%")
      )
    )
  }

  predicate isSink(DataFlow::Node sink) {
    // A sink is a call to a function that takes an algorithm as an argument
    // must include checks for asIndirectArgument since the input may be a pointer to an object
    // and the member of the object holds the algorithm on the trace.
    getExprFromNode(sink) instanceof AlgorithmSinkArgument
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    knownPassThroughStep(node1, node2)
  }

  predicate isBarrier(DataFlow::Node node) {
    // If the node is the 'next' argument of a isCallPassThrough, it is only allowed if it is an out parameter
    // i.e., a defining argument. This barrier says that if the node is an expression not an out parameter, it is filtered.
    // Out arguments will not be filtered.
    exists(Call c | knownPassthoughCall(c, _, node.asExpr()) and c.getAnArgument() = node.asExpr())
    or
    // False positive reducer, don't flow out through argv
    node.asVariable().hasName("argv")
    or
    node.asIndirectVariable().hasName("argv")
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // Assume a read on crypto identifying field for any object of type asn1_object_st (i.e., ASN1_OBJECT)
    exists(Class cls | cls.getName() = "asn1_object_st" |
      node.getType().getUnspecifiedType().stripType() = cls and
      c.(DataFlow::FieldContent).getField() = cls.getAMember() and
      c.(DataFlow::FieldContent).getField().getName() in ["nid", "sn", "ln"]
    )
  }
}

module LiteralAlgorithmTracer = DataFlow::Global<LiteralAlgorithmTracerConfig>;

/**
 * `source` is an expression that is a source of an algorithm of type `algType`.
 * `algType` may be `UNKONWN`.
 *  See CryptoAlgorithmNames for other possible values of `algType`.
 */
bindingset[sinkAlgType]
predicate hasLiteralPathToAlgSink(DataFlow::Node source, DataFlow::Node sink, string sinkAlgType) {
  LiteralAlgorithmTracer::flow(source, sink) and
  getExprFromNode(sink).(AlgorithmSinkArgument).algType() = sinkAlgType
}

private predicate knownTracedAlgorithm(Literal e, string srcSinkType) {
  knownTracedAlgorithm(e, srcSinkType, srcSinkType)
}

private predicate knownTracedAlgorithm(Literal e, string srcType, string sinkType) {
  resolveAlgorithmFromLiteral(e, _, srcType) and
  hasLiteralPathToAlgSink(DataFlow::exprNode(e), _, sinkType) and
  isKnownType(sinkType) and
  isKnownType(srcType)
}

private predicate unknownTracedLiteralAlgorithm(Literal e, string srcSinkType) {
  // Asymmetric special case:
  // Since asymmetric algorithm sinks are used for various categories of asymmetric algorithms
  // an asymmetric algorithm is only unknown if there is no trace from any asymmetric type to the given srcSinkType sink
  if getAsymmetricType() = srcSinkType
  then forall(string t | t = getAsymmetricType() | unknownTracedLiteralAlgorithm(e, t, srcSinkType))
  else unknownTracedLiteralAlgorithm(e, srcSinkType, srcSinkType)
}

private predicate unknownTracedLiteralAlgorithm(Literal e, string srcType, string sinkType) {
  // the literal resolves to an algorithm, but not to the sinktype
  // or generally doesn't resolve to any algorithm type
  // this case covers 'nonsense' cases e.g., use RSA for symmetric encryption
  not resolveAlgorithmFromLiteral(e, _, srcType) and
  isValidAlgorithmLiteral(e) and
  hasLiteralPathToAlgSink(DataFlow::exprNode(e), _, sinkType) and
  isKnownType(sinkType) and
  isKnownType(srcType)
}

private predicate unknownTracedNonLiteralAlgorithm(AlgorithmSinkArgument e, string srcSinkType) {
  // Asymmetric special case:
  // Since asymmetric algorithm sinks are used for various categories of asymmetric algorithms
  // an asymmetric algorithm is only unknown if there is no trace from any asymmetric type to the given srcSinkType sink
  if getAsymmetricType() = srcSinkType
  then
    forall(string t | t = getAsymmetricType() | unknownTracedNonLiteralAlgorithm(e, t, srcSinkType))
  else unknownTracedNonLiteralAlgorithm(e, srcSinkType, srcSinkType)
}

private predicate unknownTracedNonLiteralAlgorithm(
  AlgorithmSinkArgument e, string srcType, string sinkType
) {
  not hasLiteralPathToAlgSink(_, getNodeFromExpr(e), srcType) and
  LiteralAlgorithmTracerConfig::isSink(getNodeFromExpr(e)) and
  e.algType() = sinkType and
  isKnownType(srcType) and
  isKnownType(sinkType)
}

private predicate functionAlgorithm(Call c, string algType) {
  isOpenSSLCryptoFunctionCall(c, _, algType)
}

abstract class OpenSSLTracedAlgorithm extends CryptographicAlgorithm {
  override string getName() { resolveAlgorithmFromLiteral(this, result, this.getAlgType()) }

  override Expr configurationSink() {
    exists(DataFlow::Node sink |
      hasLiteralPathToAlgSink(DataFlow::exprNode(this), sink, this.getAlgType())
    |
      result = getExprFromNode(sink)
    )
  }
}

abstract class OpenSSLFunctionAlgorithm extends CryptographicAlgorithm {
  override string getName() { isOpenSSLCryptoFunctionCall(this, result, this.getAlgType()) }

  override Expr configurationSink() { result = this }
}

abstract class OpenSSLUnknownTracedLiteralAlgorithm extends CryptographicAlgorithm {
  override string getName() { result = unknownAlgorithm() }

  override Expr configurationSink() {
    exists(DataFlow::Node sink |
      hasLiteralPathToAlgSink(DataFlow::exprNode(this), sink, this.getAlgType())
    |
      result = getExprFromNode(sink)
    )
  }
}

abstract class OpenSSLUnknownTracedNonLiteralAlgorithm extends CryptographicAlgorithm {
  override string getName() { result = unknownAlgorithm() }

  override Expr configurationSink() { result = this }
}

module SymmetricEncryption {
  abstract class OpenSSLSymmetricEncryptionAlgorithm extends SymmetricEncryptionAlgorithm { }

  class OpenSSLSymmetricEncryptionTracedAlgorithm extends OpenSSLTracedAlgorithm,
    OpenSSLSymmetricEncryptionAlgorithm
  {
    OpenSSLSymmetricEncryptionTracedAlgorithm() {
      knownTracedAlgorithm(this, getSymmetricEncryptionType())
    }
  }

  class OpenSSLSymmetricEncryptionFunctionAlgorithm extends OpenSSLFunctionAlgorithm,
    OpenSSLSymmetricEncryptionAlgorithm
  {
    OpenSSLSymmetricEncryptionFunctionAlgorithm() {
      functionAlgorithm(this, getSymmetricEncryptionType())
    }
  }

  class OpenSSLSymmetricEncryptionTracedUnknownLiteralAlgorithm extends OpenSSLUnknownTracedLiteralAlgorithm,
    OpenSSLSymmetricEncryptionAlgorithm
  {
    OpenSSLSymmetricEncryptionTracedUnknownLiteralAlgorithm() {
      unknownTracedLiteralAlgorithm(this, getSymmetricEncryptionType())
    }
  }

  class OpenSSLSymmetricEncryptionUnknownNonLiteralTracedAlgorithm extends OpenSSLUnknownTracedNonLiteralAlgorithm,
    OpenSSLSymmetricEncryptionAlgorithm
  {
    OpenSSLSymmetricEncryptionUnknownNonLiteralTracedAlgorithm() {
      unknownTracedNonLiteralAlgorithm(this, getSymmetricEncryptionType())
    }
  }
}

module BlockModes {
  /**
   * In OpenSSL, block modes are associated directly with symmetric encryption algorithms.
   * As such, OpenSSLBLockModes are modeled as extensions of any openssl symmetric encryption algorithm
   */
  class OpenSSLBlockModeAlgorithm extends BlockModeAlgorithm, Expr instanceof SymmetricEncryption::OpenSSLSymmetricEncryptionAlgorithm
  {
    OpenSSLBlockModeAlgorithm() {
      //two cases, either the block mode is a literal or it is a function call
      resolveAlgorithmFromLiteral(this, _, "BLOCK_MODE")
      or
      isOpenSSLCryptoFunctionCall(this, _, "BLOCK_MODE")
    }

    override string getName() {
      resolveAlgorithmFromLiteral(this, result, "BLOCK_MODE")
      or
      isOpenSSLCryptoFunctionCall(this, result, "BLOCK_MODE")
    }

    override Expr configurationSink() {
      result = this.(SymmetricEncryption::OpenSSLSymmetricEncryptionAlgorithm).configurationSink()
    }

    override Expr getIVorNonce() {
      // TODO
      none()
    }
  }

  class UnknownOpenSSLBlockModeAlgorithm extends BlockModeAlgorithm, Expr instanceof SymmetricEncryption::OpenSSLSymmetricEncryptionAlgorithm
  {
    UnknownOpenSSLBlockModeAlgorithm() {
      //two cases, either the block mode is a literal or it is a function call
      not resolveAlgorithmFromLiteral(this, _, "BLOCK_MODE") and
      not isOpenSSLCryptoFunctionCall(this, _, "BLOCK_MODE")
    }

    override string getName() { result = unknownAlgorithm() }

    override Expr configurationSink() {
      result = this.(SymmetricEncryption::OpenSSLSymmetricEncryptionAlgorithm).configurationSink()
    }

    override Expr getIVorNonce() { none() }
  }
}

module Hashes {
  abstract class OpenSSLHashAlgorithm extends HashAlgorithm { }

  class OpenSSLHashTracedAlgorithm extends OpenSSLTracedAlgorithm, OpenSSLHashAlgorithm {
    OpenSSLHashTracedAlgorithm() { knownTracedAlgorithm(this, getHashType()) }
  }

  class OpenSSLHashFunctionAlgorithm extends OpenSSLFunctionAlgorithm, OpenSSLHashAlgorithm {
    OpenSSLHashFunctionAlgorithm() { functionAlgorithm(this, getHashType()) }
  }

  class OpenSSLHashTracedUnknownLiteralAlgorithm extends OpenSSLUnknownTracedLiteralAlgorithm,
    OpenSSLHashAlgorithm
  {
    OpenSSLHashTracedUnknownLiteralAlgorithm() {
      unknownTracedLiteralAlgorithm(this, getHashType())
    }
  }

  class OpenSSLHashUnknownNonLiteralTracedAlgorithm extends OpenSSLUnknownTracedNonLiteralAlgorithm,
    OpenSSLHashAlgorithm
  {
    OpenSSLHashUnknownNonLiteralTracedAlgorithm() {
      unknownTracedNonLiteralAlgorithm(this, getHashType())
    }
  }

  class OpenSSLNullHash extends HashAlgorithm {
    OpenSSLNullHash() {
      exists(Call c |
        this = c and
        isPossibleOpenSSLFunction(c.getTarget()) and
        c.getTarget().getName() in ["EVP_md_null"]
      )
    }

    override string getName() { result = unknownAlgorithm() }

    override Expr configurationSink() { result = this }
  }
}

module EllipticCurves {
  // TODO: need to address EVP_PKEY_Q_keygen where the type is "EC" but the curve is UNKNOWN?
  class OpenSSLEllipticCurveTracedAlgorithm extends OpenSSLTracedAlgorithm, EllipticCurveAlgorithm {
    OpenSSLEllipticCurveTracedAlgorithm() { knownTracedAlgorithm(this, getEllipticCurveType()) }
  }

  class OpenSSLEllipticCurveFunctionAlgorithm extends OpenSSLFunctionAlgorithm,
    EllipticCurveAlgorithm
  {
    OpenSSLEllipticCurveFunctionAlgorithm() { functionAlgorithm(this, getEllipticCurveType()) }
  }

  class OpenSSLEllipticCurveTracedUnknownLiteralAlgorithm extends OpenSSLUnknownTracedLiteralAlgorithm,
    EllipticCurveAlgorithm
  {
    OpenSSLEllipticCurveTracedUnknownLiteralAlgorithm() {
      unknownTracedLiteralAlgorithm(this, getEllipticCurveType())
    }
  }

  class OpenSSLEllipticCurvehUnknownNonLiteralTracedAlgorithm extends OpenSSLUnknownTracedNonLiteralAlgorithm,
    EllipticCurveAlgorithm
  {
    OpenSSLEllipticCurvehUnknownNonLiteralTracedAlgorithm() {
      unknownTracedNonLiteralAlgorithm(this, getEllipticCurveType())
    }
  }

  // https://www.openssl.org/docs/manmaster/man3/EC_KEY_new_ex.html
  class OpenSSLNullEllipticCurve extends EllipticCurveAlgorithm {
    OpenSSLNullEllipticCurve() {
      exists(Call c |
        this = c and
        isPossibleOpenSSLFunction(c.getTarget()) and
        c.getTarget().getName() in ["EC_KEY_new", "EC_KEY_new_ex"]
      )
    }

    override string getName() { result = unknownAlgorithm() }

    override Expr configurationSink() { result = this }
  }
}

module AsymmetricEncryption {
  class OpenSSLAsymmetricEncryptionTracedAlgorithm extends OpenSSLTracedAlgorithm,
    AsymmetricEncryptionAlgorithm
  {
    OpenSSLAsymmetricEncryptionTracedAlgorithm() {
      knownTracedAlgorithm(this, getAsymmetricEncryptionType())
    }
  }

  class OpenSSLAsymmetricEncryptionFunctionAlgorithm extends OpenSSLFunctionAlgorithm,
    AsymmetricEncryptionAlgorithm
  {
    OpenSSLAsymmetricEncryptionFunctionAlgorithm() {
      functionAlgorithm(this, getAsymmetricEncryptionType())
    }
  }

  class OpenSSLAsymmetricEncryptionTracedUnknownLiteralAlgorithm extends OpenSSLUnknownTracedLiteralAlgorithm,
    AsymmetricEncryptionAlgorithm
  {
    OpenSSLAsymmetricEncryptionTracedUnknownLiteralAlgorithm() {
      unknownTracedLiteralAlgorithm(this, getAsymmetricEncryptionType())
    }
  }

  class OpenSSLAsymmetricEncryptionUnknownNonLiteralTracedAlgorithm extends OpenSSLUnknownTracedNonLiteralAlgorithm,
    AsymmetricEncryptionAlgorithm
  {
    OpenSSLAsymmetricEncryptionUnknownNonLiteralTracedAlgorithm() {
      unknownTracedNonLiteralAlgorithm(this, getAsymmetricEncryptionType())
    }
  }
}

module SigningAlgorithms {
  class OpenSSLSignatureTracedAlgorithm extends OpenSSLTracedAlgorithm, SigningAlgorithm {
    OpenSSLSignatureTracedAlgorithm() { knownTracedAlgorithm(this, getSignatureType()) }
  }

  class OpenSSLSignatureFunctionAlgorithm extends OpenSSLFunctionAlgorithm, SigningAlgorithm {
    OpenSSLSignatureFunctionAlgorithm() { functionAlgorithm(this, getSignatureType()) }
  }

  class OpenSSLSignatureTracedUnknownLiteralAlgorithm extends OpenSSLUnknownTracedLiteralAlgorithm,
    SigningAlgorithm
  {
    OpenSSLSignatureTracedUnknownLiteralAlgorithm() {
      unknownTracedLiteralAlgorithm(this, getSignatureType())
    }
  }

  class OpenSSLSignatureUnknownNonLiteralTracedAlgorithm extends OpenSSLUnknownTracedNonLiteralAlgorithm,
    SigningAlgorithm
  {
    OpenSSLSignatureUnknownNonLiteralTracedAlgorithm() {
      unknownTracedNonLiteralAlgorithm(this, getSignatureType())
    }
  }
}

module KeyExchange {
  class OpenSSLKeyExchangeTracedAlgorithm extends OpenSSLTracedAlgorithm, KeyExchangeAlgorithm {
    OpenSSLKeyExchangeTracedAlgorithm() { knownTracedAlgorithm(this, getKeyExchangeType()) }
  }

  class OpenSSLKeyExchangeFunctionAlgorithm extends OpenSSLFunctionAlgorithm, KeyExchangeAlgorithm {
    OpenSSLKeyExchangeFunctionAlgorithm() { functionAlgorithm(this, getKeyExchangeType()) }
  }

  class OpenSSLKeyExchangeTracedUnknownLiteralAlgorithm extends OpenSSLUnknownTracedLiteralAlgorithm,
    KeyExchangeAlgorithm
  {
    OpenSSLKeyExchangeTracedUnknownLiteralAlgorithm() {
      unknownTracedLiteralAlgorithm(this, getKeyExchangeType())
    }
  }

  class OpenSSLKeyExchangeUnknownNonLiteralTracedAlgorithm extends OpenSSLUnknownTracedNonLiteralAlgorithm,
    KeyExchangeAlgorithm
  {
    OpenSSLKeyExchangeUnknownNonLiteralTracedAlgorithm() {
      unknownTracedNonLiteralAlgorithm(this, getKeyExchangeType())
    }
  }
}

module KeyGeneration {
  /**
   * Functions that explicitly set key generation parameters.
   * `sizeInd` is the parameter specifying the size of the key.
   * `outInd` is the parameter or return value that the key is written to.
   * `outInd` is -1 if the key is written to the return value.
   */
  predicate isAsymmetricKeyGenExplicitAlgorithm(Function func, int sizeInd, int outInd) {
    isPossibleOpenSSLFunction(func) and
    exists(string name | func.hasGlobalName(name) |
      name in [
          "EVP_PKEY_CTX_set_dsa_paramgen_bits", "DSA_generate_parameters_ex",
          "EVP_PKEY_CTX_set_rsa_keygen_bits", "RSA_generate_key_ex", "RSA_generate_key_fips",
          "EVP_PKEY_CTX_set_dh_paramgen_prime_len", "DH_generate_parameters_ex"
        ] and
      sizeInd = 1 and
      outInd = 0
      or
      name in ["DSA_generate_parameters", "RSA_generate_key", "DH_generate_parameters"] and
      sizeInd = 0 and
      outInd = -1
    ) and
    exists(Type t |
      (
        if sizeInd = -1
        then t = func.getType().getUnderlyingType()
        else t = func.getParameter(sizeInd).getUnderlyingType()
      ) and
      t instanceof IntegralType and
      not t instanceof CharType
    )
  }

  module AsymExplicitAlgKeyLengthFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node node) {
      // Optimizations to avoid tracing all integers
      node.asExpr().(Literal).getValue().toInt() > 0 and // exclude sentinel values
      node.asExpr().(Literal).getValue().toInt() < 8500
    }

    predicate isSink(DataFlow::Node node) {
      exists(FunctionCall c, int sizeInd |
        isAsymmetricKeyGenExplicitAlgorithm(c.getTarget(), sizeInd, _) and
        c.getArgument(sizeInd) = node.asExpr()
      )
    }
  }

  module AsymExplicitAlgKeyLengthFlow = DataFlow::Global<AsymExplicitAlgKeyLengthFlowConfig>;

  class OpenSSLAsymmetricKeyGenTiedToAlgorithm extends AsymmetricKeyGeneration {
    OpenSSLAsymmetricKeyGenTiedToAlgorithm() {
      exists(Call c |
        this = c and
        isPossibleOpenSSLFunction(c.getTarget()) and
        isAsymmetricKeyGenExplicitAlgorithm(c.getTarget(), _, _)
      )
    }

    override CryptographicAlgorithm getAlgorithm() { result = this }

    override Expr getKeyConfigurationSource(CryptographicAlgorithm alg) {
      alg = this and
      exists(int sizeInd |
        isAsymmetricKeyGenExplicitAlgorithm(this.getTarget(), sizeInd, _) and
        AsymExplicitAlgKeyLengthFlow::flow(DataFlow::exprNode(result),
          DataFlow::exprNode(this.getArgument(sizeInd)))
      )
    }
  }

  module Length_to_RSA_EVP_PKEY_Q_keygen_Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node node) {
      // Optimizations to avoid tracing all integers
      node.asExpr().(Literal).getValue().toInt() > 0 and // exclude sentinel values
      node.asExpr().(Literal).getValue().toInt() < 5000
    }

    predicate isSink(DataFlow::Node node) {
      exists(FunctionCall c |
        c.getTarget().getName() = "EVP_PKEY_Q_keygen" and
        isPossibleOpenSSLFunction(c.getTarget()) and
        c.getArgument(3) = node.asExpr()
      )
    }
  }

  module Length_to_RSA_EVP_PKEY_Q_keygen_Flow =
    DataFlow::Global<Length_to_RSA_EVP_PKEY_Q_keygen_Config>;

  class OpenSSL_RSA_EVP_PKEY_Q_keygen extends AsymmetricKeyGeneration {
    OpenSSL_RSA_EVP_PKEY_Q_keygen() {
      exists(Call c |
        this = c and
        isPossibleOpenSSLFunction(c.getTarget()) and
        this.getTarget().getName() = "EVP_PKEY_Q_keygen" and
        this.getArgument(3).getUnderlyingType() instanceof IntegralType
      )
    }

    override CryptographicAlgorithm getAlgorithm() {
      result.configurationSink().(AlgorithmSinkArgument).getSinkCall() = this
    }

    override Expr getKeyConfigurationSource(CryptographicAlgorithm alg) {
      alg = this.getAlgorithm() and
      Length_to_RSA_EVP_PKEY_Q_keygen_Flow::flow(DataFlow::exprNode(result),
        DataFlow::exprNode(this.getArgument(3)))
    }
  }

  predicate isKeyGenOperationWithNoSize(Function func) {
    isPossibleOpenSSLFunction(func) and
    exists(string name | func.hasGlobalName(name) |
      name in ["EVP_PKEY_keygen", "DSA_generate_key", "DH_generate_key", "EVP_PKEY_generate"]
    )
  }

  module KeyGenKeySizeInitToKeyGenConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node node) {
      exists(Call c, Function func, int outInd |
        isAsymmetricKeyGenExplicitAlgorithm(func, _, outInd) and
        c.getTarget() = func
      |
        if outInd = -1 then node.asExpr() = c else node.asExpr() = c.getArgument(outInd)
      )
    }

    predicate isSink(DataFlow::Node node) {
      exists(Call c |
        isKeyGenOperationWithNoSize(c.getTarget()) and c.getAnArgument() = node.asExpr()
      )
    }
  }

  module KeyGenKeySizeInitToKeyGenFlow = DataFlow::Global<KeyGenKeySizeInitToKeyGenConfig>;

  predicate isEVP_PKEY_CTX_Source(DataFlow::Node node, CryptographicAlgorithm alg) {
    exists(Call c |
      alg.configurationSink().(AlgorithmSinkArgument).getSinkCall() = c and
      (
        node.asExpr() = c
        or
        node.asExpr() = c.getAnArgument()
        or
        node.asDefiningArgument() = c.getAnArgument()
      )
    ) and
    (
      node.asExpr() instanceof Known_EVP_PKEY_CTX_Ptr_Source
      or
      node.asDefiningArgument() instanceof Known_EVP_PKEY_CTX_Ptr_Source
    )
  }

  predicate isKeyGen_EVP_PKEY_CTX_Sink(DataFlow::Node node, Call c) {
    isKeyGenOperationWithNoSize(c.getTarget()) and nodeToExpr(node, c.getAnArgument())
  }

  /**
   * Trace from EVP_PKEY_CTX* at algorithm sink to keygen,
   * users can then extrapolatae the matching algorithm from the alg sink to the keygen
   */
  module EVP_PKEY_CTX_Ptr_Source_to_KeyGenOperationWithNoSize implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { isEVP_PKEY_CTX_Source(source, _) }

    predicate isSink(DataFlow::Node sink) { isKeyGen_EVP_PKEY_CTX_Sink(sink, _) }
  }

  module EVP_PKEY_CTX_Ptr_Source_to_KeyGenOperationWithNoSize_Flow =
    DataFlow::Global<EVP_PKEY_CTX_Ptr_Source_to_KeyGenOperationWithNoSize>;

  /**
   * UNKNOWN key sizes to general purpose key generation functions (i.e., that take in no key size and assume
   * is it set on context prior to the call). No path from a key configuration to these operations
   * means the key size is UNKNOWN, or more precisely the key size is DEFAULT but
   * the defaults can change with each version of OpenSSL, we simply assume the size is generally UNKNOWN.
   * ASSUMPTION/TODO: we currently model all known locations where a key size is set explicitly.
   *                 When a key is set implicitly, this usually means a key generation operation
   *                 is called where the operation takes in no key size, and no flow to this operation
   *                 initializes the context with a key size.
   *                 Currently, without a definitive source (set of sources) to start tracing from, we cannot determine
   *                 determine if a single path exists that initializes the context with a key size and another that doesn't.
   *                 Rather than attempt to model all possible sources, we assume that if no path
   *                 from a key config location reaches a generic key generation operation, then the key size is not set.
   *                 NOTE: while this is true, it is possible a key size is set in one path, but not in another
   *                 meaning this approach (and other similar approaches used in this model for UNKNOWN)
   *                 can produce false negatives.
   */
  class OpenSSLDefaultKeyGeneration extends AsymmetricKeyGeneration {
    OpenSSLDefaultKeyGeneration() {
      // this is a call to a function matching isKeyGenOperationWithNoSize
      // and there is no flow from a key configuration source to this call
      exists(Call c |
        this = c and
        isKeyGenOperationWithNoSize(this.getTarget()) and
        not exists(DataFlow::Node src, DataFlow::Node sink |
          KeyGenKeySizeInitToKeyGenFlow::flow(src, sink) and
          nodeToExpr(sink, this.getAnArgument())
        )
      )
    }

    override CryptographicAlgorithm getAlgorithm() {
      if this.getTarget().getName() in ["DSA_generate_key", "DH_generate_key"]
      then result = this
      else
        // NOTE/ASSUMPTION: EVP_PKEY_keygen, EVP_PKEY_generate assume only other possibilities,
        //        each take in a CTX as the first arg, need to trace from an alg sink from this CTX param
        // get every alg sink, get the corresponding call, trace out on any CTX type variable
        // to the key gen
        // NOTE: looking for any cryptographic algorithm tracing to the keygen to handle
        //  any odd cases we aren't awaare of where keygen can be used for other algorithm types
        exists(DataFlow::Node src, DataFlow::Node sink |
          EVP_PKEY_CTX_Ptr_Source_to_KeyGenOperationWithNoSize_Flow::flow(src, sink) and
          isEVP_PKEY_CTX_Source(src, result) and
          isKeyGen_EVP_PKEY_CTX_Sink(sink, this)
          // TODO: what if there is no CTX source? then the keygen becomes an UNKNOWN sink
        )
    }

    /**
     * For this class, there is no known configuration source for any algorithm
     */
    override Expr getKeyConfigurationSource(CryptographicAlgorithm alg) { none() }
  }
}
