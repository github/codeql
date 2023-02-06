/**
 * @name Buffer access with incorrect length value
 * @description Incorrect use of the length argument in some functions will result in out-of-memory accesses.
 * @kind problem
 * @id cpp/buffer-access-with-incorrect-length-value
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       experimental
 *       external/cwe/cwe-805
 */

import cpp

/** Holds for a function `f`, which has an argument at index `bpos` that points to a buffer and an argument at index `spos` that points to a size. */
predicate numberArgument(Function f, int bpos, int spos) {
  f.hasGlobalOrStdName([
      "X509_NAME_oneline", "SSL_CIPHER_description", "SSL_get_shared_ciphers",
      "SSL_export_keying_material_early", "SSL_export_keying_material", "SSL_set_alpn_protos",
      "SSL_CTX_set_alpn_protos", "SSL_read", "SSL_read_ex", "SSL_read_early_data",
      "SSL_bytes_to_cipher_list", "SSL_write", "SSL_SESSION_set1_master_key",
      "SSL_CTX_set_session_id_context", "BIO_gets", "BIO_read", "BIO_read_ex", "BIO_write",
      "BIO_write_ex", "BIO_ctrl", "BN_bn2binpad", "BN_signed_bn2bin", "BN_signed_bn2lebin",
      "EVP_PKEY_get_default_digest_name", "EVP_DigestUpdate", "EVP_PKEY_CTX_set1_tls1_prf_secret",
      "EVP_KDF_derive", "EVP_CIPHER_CTX_get_updated_iv", "EVP_PKEY_get_group_name", "EVP_MAC_init",
      "write", "read", "send", "sendto", "recv", "recvfrom", "strerror_r"
    ]) and
  bpos = 1 and
  spos = 2
  or
  f.hasGlobalOrStdName(["X509_NAME_get_text_by_NID", "EVP_PKEY_get_utf8_string_param"]) and
  bpos = 2 and
  spos = 3
  or
  f.hasGlobalOrStdName([
      "BIO_snprintf", "BN_signed_lebin2bn", "BIO_new_mem_buf", "BN_lebin2bn", "BN_bin2bn",
      "EVP_read_pw_string", "EVP_read_pw_string", "strftime", "strnlen", "fgets", "snprintf",
      "vsnprintf"
    ]) and
  bpos = 0 and
  spos = 1
  or
  f.hasGlobalOrStdName(["AES_ige_encrypt", "memchr"]) and bpos = 0 and spos = 2
  or
  f.hasGlobalOrStdName("EVP_MAC_final") and bpos = 1 and spos = 3
  or
  f.hasGlobalOrStdName("OBJ_obj2txt") and bpos = 2 and spos = 1
  or
  f.hasGlobalOrStdName("EVP_CIPHER_CTX_ctrl") and bpos = 3 and spos = 2
  or
  f.hasGlobalOrStdName(["EVP_PKEY_get_octet_string_param", "getnameinfo"]) and bpos = 2 and spos = 3
  or
  f.hasGlobalOrStdName([
      "EVP_DecryptUpdate", "EVP_EncryptUpdate", "EVP_PKEY_encrypt", "EVP_PKEY_sign",
      "EVP_CipherUpdate"
    ]) and
  bpos = 3 and
  spos = 4
  or
  f.hasGlobalOrStdName("getnameinfo") and bpos = 4 and spos = 5
}

from FunctionCall fc
where
  exists(ArrayType array, int bufArgPos, int sizeArgPos |
    numberArgument(fc.getTarget(), bufArgPos, sizeArgPos) and
    fc.getArgument(pragma[only_bind_into](sizeArgPos)).getValue().toInt() > array.getByteSize() and
    fc.getArgument(pragma[only_bind_into](bufArgPos))
        .(VariableAccess)
        .getTarget()
        .getADeclarationEntry()
        .getType() = array
  )
select fc,
  "Access beyond the bounds of the allocated memory is possible, the size argument used is greater than the size of the buffer."
