/**
 * Initializers for EVP PKey
 * including:
 *  https://docs.openssl.org/3.0/man3/EVP_PKEY_CTX_ctrl/
 *  https://docs.openssl.org/3.0/man3/EVP_EncryptInit/#synopsis
 */

import cpp
private import experimental.quantum.OpenSSL.CtxFlow
private import OpenSSLOperations
private import OpenSSLOperationBase

/**
 * A call to `EVP_PKEY_CTX_new` or `EVP_PKEY_CTX_new_from_pkey`.
 * These calls initialize the context from a prior key.
 * The key may be generated previously, or merely had it's
 * parameters set (e.g., `EVP_PKEY_paramgen`).
 * NOTE: for the case of `EVP_PKEY_paramgen`, these calls
 * are encoded as context passthroughs, and any operation
 * will get all associated initializers for teh paramgen
 * at the final keygen operation automatically.
 */
class EVPNewKeyCtx extends EvpKeyInitializer {
  Expr keyArg;

  EVPNewKeyCtx() {
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_new" and
    keyArg = this.(Call).getArgument(0)
    or
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_new_from_pkey" and
    keyArg = this.(Call).getArgument(1)
  }

  /**
   * Context is returned
   */
  override CtxPointerSource getContext() { result = this }

  override Expr getKeyArg() { result = keyArg }
}

/**
 * A call to "EVP_PKEY_CTX_set_ec_paramgen_curve_nid".
 * Note that this is a primary algorithm as the pattenr is to specify an "EC" context,
 * then set the specific curve later. Although the curve is set later, it is the primary
 * algorithm intended for an operation.
 */
class EvpCtxSetPrimaryAlgorithmInitializer extends EvpPrimaryAlgorithmInitializer {
  EvpCtxSetPrimaryAlgorithmInitializer() {
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_ec_paramgen_curve_nid"
  }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class EvpCtxSetHashAlgorithmInitializer extends EvpHashAlgorithmInitializer {
  EvpCtxSetHashAlgorithmInitializer() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_CTX_set_signature_md", "EVP_PKEY_CTX_set_rsa_mgf1_md_name",
        "EVP_PKEY_CTX_set_rsa_mgf1_md", "EVP_PKEY_CTX_set_rsa_oaep_md_name",
        "EVP_PKEY_CTX_set_rsa_oaep_md", "EVP_PKEY_CTX_set_dsa_paramgen_md",
        "EVP_PKEY_CTX_set_dh_kdf_md", "EVP_PKEY_CTX_set_ecdh_kdf_md"
      ]
  }

  override Expr getHashAlgorithmArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class EvpCtxSetKeySizeInitializer extends EvpKeySizeInitializer {
  Expr arg;

  EvpCtxSetKeySizeInitializer() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_CTX_set_rsa_keygen_bits", "EVP_PKEY_CTX_set_dsa_paramgen_bits",
        "EVP_CIPHER_CTX_set_key_length"
      ] and
    arg = this.(Call).getArgument(1)
    or
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_mac_key" and
    arg = this.(Call).getArgument(2)
  }

  override Expr getKeySizeArg() { result = arg }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class EvpCtxSetKeyInitializer extends EvpKeyInitializer {
  EvpCtxSetKeyInitializer() { this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_mac_key" }

  override Expr getKeyArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class EvpCtxSetPaddingInitializer extends EvpPaddingInitializer {
  EvpCtxSetPaddingInitializer() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_CTX_set_rsa_padding", "EVP_CIPHER_CTX_set_padding"
      ]
  }

  override Expr getPaddingArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}

class EvpCtxSetSaltLengthInitializer extends EvpSaltLengthInitializer {
  EvpCtxSetSaltLengthInitializer() {
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_rsa_pss_saltlen"
  }

  override Expr getSaltLengthArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContext() { result = this.(Call).getArgument(0) }
}
