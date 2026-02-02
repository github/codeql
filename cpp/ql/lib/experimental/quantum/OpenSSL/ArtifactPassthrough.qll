private import experimental.quantum.Language

/**
 * A call to `BN_bn2bin`.
 * Commonly used to extract partial bytes from a signature,
 * e.g., a signature from DSA_do_sign, passed to DSA_do_verify
 * - int BN_bn2bin(const BIGNUM *a, unsigned char *to);
 */
class BnBn2BinCalStep extends AdditionalFlowInputStep {
  Call call;

  BnBn2BinCalStep() {
    call.getTarget().getName() = "BN_bn2bin" and
    call.getArgument(0) = this.asIndirectExpr()
  }

  override DataFlow::Node getOutput() { result.asDefiningArgument() = call.getArgument(1) }
}

/**
 * A call to `BN_bin2bn`.
 * Commonly used to convert to a signature for DSA_do_verify
 * - BIGNUM *BN_bin2bn(const unsigned char *s, int len, BIGNUM *ret);
 */
class BnBin2BnCallStep extends AdditionalFlowInputStep {
  Call call;

  BnBin2BnCallStep() {
    call.getTarget().getName() = "BN_bin2bn" and
    call.getArgument(0) = this.asIndirectExpr()
  }

  override DataFlow::Node getOutput() { result.asDefiningArgument() = call.getArgument(2) }
}

/**
 * A call to `RSA_set0_key` or `DSA_SIG_set0`.
 * Often used in combination with BN_bin2bn, to construct a signature.
 */
class RsaSet0KeyCallStep extends AdditionalFlowInputStep {
  Call call;

  RsaSet0KeyCallStep() {
    (call.getTarget().getName() = "RSA_set0_key" or call.getTarget().getName() = "DSA_SIG_set0") and
    this.asIndirectExpr() in [call.getArgument(1), call.getArgument(2), call.getArgument(3)]
  }

  override DataFlow::Node getOutput() { result.asDefiningArgument() = call.getArgument(0) }
}

/**
 * A call to `d2i_DSA_SIG`. This is a pass through of a signature of one form to another.
 * - DSA_SIG *d2i_DSA_SIG(DSA_SIG **sig, const unsigned char **pp, long length);
 */
class D2iDsaSigCallStep extends AdditionalFlowInputStep {
  Call call;

  D2iDsaSigCallStep() {
    call.getTarget().getName() = "d2i_DSA_SIG" and
    this.asIndirectExpr() = call.getArgument(1)
  }

  override DataFlow::Node getOutput() {
    // If arg 0 specified, the same pointer is returned, if not specified
    // a new allocation is returned.
    result.asDefiningArgument() = call.getArgument(0) or
    result.asIndirectExpr() = call
  }
}

/**
 * A call to `DSA_SIG_get0`.
 * Converts a DSA_Sig into its components, which are commonly used with BN_bn2Bin to
 * construct a char* signature.
 * - void DSA_SIG_get0(const DSA_SIG *sig, const BIGNUM **pr, const BIGNUM **ps);
 */
class DsaSigGet0CallStep extends AdditionalFlowInputStep {
  Call call;

  DsaSigGet0CallStep() {
    call.getTarget().getName() = "DSA_SIG_get0" and
    this.asIndirectExpr() = call.getArgument(0)
  }

  override DataFlow::Node getOutput() {
    result.asDefiningArgument() = call.getArgument(1)
    or
    result.asDefiningArgument() = call.getArgument(2)
  }
}

/**
 * A call to `EVP_PKEY_get1_RSA` or `EVP_PKEY_get1_DSA`
 *  - RSA *EVP_PKEY_get1_RSA(EVP_PKEY *pkey);
 *  - DSA *EVP_PKEY_get1_DSA(EVP_PKEY *pkey);
 * A key input is converted into a key output, a key is not generated.
 */
class EvpPkeyGet1RsaOrDsa extends AdditionalFlowInputStep {
  Call c;

  EvpPkeyGet1RsaOrDsa() {
    c.getTarget().getName() = ["EVP_PKEY_get1_RSA", "EVP_PKEY_get1_DSA"] and
    this.asIndirectExpr() = c.getArgument(0)
  }

  override DataFlow::Node getOutput() { result.asIndirectExpr() = c }
}
