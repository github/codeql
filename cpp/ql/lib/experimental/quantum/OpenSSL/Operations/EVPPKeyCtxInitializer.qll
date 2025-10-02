/**
 * Initializers for EVP PKey
 * These are used to create a Pkey context or set properties on a Pkey context
 * e.g., key size, hash algorithms, curves, padding schemes, etc.
 * Meant to capture more general purpose initializers that aren't necessarily
 * tied to a specific operation. If tied to an operation (i.e., in the docs)
 * we recommend defining defining all together in the same operation definition qll.
 * including:
 *  https://docs.openssl.org/3.0/man3/EVP_PKEY_CTX_ctrl/
 *  https://docs.openssl.org/3.0/man3/EVP_EncryptInit/#synopsis
 */

import cpp
private import OpenSSLOperations

/**
 * A call to `EVP_PKEY_CTX_new` or `EVP_PKEY_CTX_new_from_pkey`.
 * These calls initialize the context from a prior key.
 * The key may be generated previously, or merely had it's
 * parameters set (e.g., `EVP_PKEY_paramgen`).
 */
class EvpNewKeyCtx extends OperationStep instanceof Call {
  Expr keyArg;

  EvpNewKeyCtx() {
    this.getTarget().getName() = "EVP_PKEY_CTX_new" and
    keyArg = this.getArgument(0)
    or
    this.getTarget().getName() = "EVP_PKEY_CTX_new_from_pkey" and
    keyArg = this.getArgument(1)
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = keyArg and type = KeyIO()
    or
    this.getTarget().getName() = "EVP_PKEY_CTX_new_from_pkey" and
    result.asIndirectExpr() = this.getArgument(0) and
    type = OsslLibContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asIndirectExpr() = this and type = ContextIO()
  }

  override OperationStepType getStepType() { result = ContextCreationStep() }
}

/**
 * A call to "EVP_PKEY_CTX_set_ec_paramgen_curve_nid".
 */
class EvpCtxSetEcParamgenCurveNidInitializer extends OperationStep {
  EvpCtxSetEcParamgenCurveNidInitializer() {
    this.getTarget().getName() = "EVP_PKEY_CTX_set_ec_paramgen_curve_nid"
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and type = PrimaryAlgorithmIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to the following:
 * - `EVP_PKEY_CTX_set_signature_md`
 * - `EVP_PKEY_CTX_set_rsa_mgf1_md_name`
 * - `EVP_PKEY_CTX_set_rsa_mgf1_md`
 * - `EVP_PKEY_CTX_set_rsa_oaep_md_name`
 * - `EVP_PKEY_CTX_set_rsa_oaep_md`
 * - `EVP_PKEY_CTX_set_dsa_paramgen_md`
 * - `EVP_PKEY_CTX_set_dh_kdf_md`
 * - `EVP_PKEY_CTX_set_ecdh_kdf_md`
 */
class EvpCtxSetHashInitializer extends OperationStep {
  boolean isOaep;
  boolean isMgf1;

  EvpCtxSetHashInitializer() {
    this.getTarget().getName() in [
        "EVP_PKEY_CTX_set_signature_md", "EVP_PKEY_CTX_set_dsa_paramgen_md",
        "EVP_PKEY_CTX_set_dh_kdf_md", "EVP_PKEY_CTX_set_ecdh_kdf_md"
      ] and
    isOaep = false and
    isMgf1 = false
    or
    this.getTarget().getName() in [
        "EVP_PKEY_CTX_set_rsa_mgf1_md_name", "EVP_PKEY_CTX_set_rsa_mgf1_md"
      ] and
    isOaep = false and
    isMgf1 = true
    or
    this.getTarget().getName() in [
        "EVP_PKEY_CTX_set_rsa_oaep_md_name",
        "EVP_PKEY_CTX_set_rsa_oaep_md"
      ] and
    isOaep = true and
    isMgf1 = false
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asIndirectExpr() = this.getArgument(1) and
    type = HashAlgorithmIO() and
    isOaep = false and
    isMgf1 = false
    or
    result.asIndirectExpr() = this.getArgument(1) and type = HashAlgorithmOaepIO() and isOaep = true
    or
    result.asIndirectExpr() = this.getArgument(1) and type = HashAlgorithmMgf1IO() and isMgf1 = true
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to `EVP_PKEY_CTX_set_rsa_keygen_bits`, `EVP_PKEY_CTX_set_dsa_paramgen_bits`,
 * or `EVP_CIPHER_CTX_set_key_length`.
 */
class EvpCtxSetKeySizeInitializer extends OperationStep {
  EvpCtxSetKeySizeInitializer() {
    this.getTarget().getName() in [
        "EVP_PKEY_CTX_set_rsa_keygen_bits", "EVP_PKEY_CTX_set_dsa_paramgen_bits",
        "EVP_CIPHER_CTX_set_key_length"
      ]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = KeySizeIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

class EvpCtxSetMacKeyInitializer extends OperationStep {
  EvpCtxSetMacKeyInitializer() { this.getTarget().getName() = "EVP_PKEY_CTX_set_mac_key" }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(2) and type = KeySizeIO()
    or
    // the raw key that is configured into the output key
    result.asIndirectExpr() = this.getArgument(1) and type = KeyIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

class EvpCtxSetPaddingInitializer extends OperationStep {
  EvpCtxSetPaddingInitializer() {
    this.getTarget().getName() in ["EVP_PKEY_CTX_set_rsa_padding", "EVP_CIPHER_CTX_set_padding"]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    // The algorithm is an int: use asExpr
    result.asExpr() = this.getArgument(1) and type = PaddingAlgorithmIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

class EvpCtxSetSaltLengthInitializer extends OperationStep {
  EvpCtxSetSaltLengthInitializer() {
    this.getTarget().getName() = "EVP_PKEY_CTX_set_rsa_pss_saltlen"
  }

  override DataFlow::Node getInput(IOType type) {
    result.asIndirectExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = SaltLengthIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(0) and type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}
