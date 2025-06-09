/**
 * Initializers from https://docs.openssl.org/3.0/man3/EVP_PKEY_CTX_ctrl/
 */

import cpp
private import experimental.quantum.OpenSSL.CtxFlow
private import OpenSSLOperationBase

class EvpCtxSetAlgorithmInitializer extends EvpAlgorithmInitializer {
  EvpCtxSetAlgorithmInitializer() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_CTX_set_signature_md", "EVP_PKEY_CTX_set_rsa_mgf1_md_name",
        "EVP_PKEY_CTX_set_rsa_mgf1_md", "EVP_PKEY_CTX_set_rsa_oaep_md_name",
        "EVP_PKEY_CTX_set_rsa_oaep_md", "EVP_PKEY_CTX_set_dsa_paramgen_md",
        "EVP_PKEY_CTX_set_dsa_paramgen_md_props", "EVP_PKEY_CTX_set_dh_kdf_md",
        "EVP_PKEY_CTX_set_ec_paramgen_curve_nid", "EVP_PKEY_CTX_set_ecdh_kdf_md"
      ]
  }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContextArg() { result = this.(Call).getArgument(0) }
}

class EvpCtxSetKeySizeInitializer extends EvpKeySizeInitializer {
  Expr arg;

  EvpCtxSetKeySizeInitializer() {
    this.(Call).getTarget().getName() in [
        "EVP_PKEY_CTX_set_rsa_keygen_bits", "EVP_PKEY_CTX_set_dsa_paramgen_bits"
      ] and
    arg = this.(Call).getArgument(1)
    or
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_mac_key" and
    arg = this.(Call).getArgument(2)
  }

  override Expr getKeySizeArg() { result = arg }

  override CtxPointerSource getContextArg() { result = this.(Call).getArgument(0) }
}

class EvpCtxSetKeyInitializer extends EvpKeyInitializer {
  EvpCtxSetKeyInitializer() { this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_mac_key" }

  override Expr getKeyArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContextArg() { result = this.(Call).getArgument(0) }
}

class EvpCtxSetPaddingInitializer extends EvpPaddingInitializer {
  EvpCtxSetPaddingInitializer() {
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_rsa_padding"
  }

  override Expr getPaddingArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContextArg() { result = this.(Call).getArgument(0) }
}

class EvpCtxSetSaltLengthInitializer extends EvpSaltLengthInitializer {
  EvpCtxSetSaltLengthInitializer() {
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_rsa_pss_saltlen"
  }

  override Expr getSaltLengthArg() { result = this.(Call).getArgument(1) }

  override CtxPointerSource getContextArg() { result = this.(Call).getArgument(0) }
}
