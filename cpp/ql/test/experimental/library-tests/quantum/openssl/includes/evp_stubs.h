#ifndef OSSL_EVP_H
#define OSSL_EVP_H

// Common defines and integer types.
#define NULL 0

# define         EVP_CTRL_INIT                   0x0
# define         EVP_CTRL_SET_KEY_LENGTH         0x1
# define         EVP_CTRL_GET_RC2_KEY_BITS       0x2
# define         EVP_CTRL_SET_RC2_KEY_BITS       0x3
# define         EVP_CTRL_GET_RC5_ROUNDS         0x4
# define         EVP_CTRL_SET_RC5_ROUNDS         0x5
# define         EVP_CTRL_RAND_KEY               0x6
# define         EVP_CTRL_PBE_PRF_NID            0x7
# define         EVP_CTRL_COPY                   0x8
# define         EVP_CTRL_AEAD_SET_IVLEN         0x9
# define         EVP_CTRL_AEAD_GET_TAG           0x10
# define         EVP_CTRL_AEAD_SET_TAG           0x11
# define         EVP_CTRL_AEAD_SET_IV_FIXED      0x12
# define         EVP_CTRL_GCM_SET_IVLEN          EVP_CTRL_AEAD_SET_IVLEN
# define         EVP_CTRL_GCM_GET_TAG            EVP_CTRL_AEAD_GET_TAG
# define         EVP_CTRL_GCM_SET_TAG            EVP_CTRL_AEAD_SET_TAG
# define         EVP_CTRL_GCM_SET_IV_FIXED       EVP_CTRL_AEAD_SET_IV_FIXED
# define         EVP_CTRL_GCM_IV_GEN             0x13
# define         EVP_CTRL_CCM_SET_IVLEN          EVP_CTRL_AEAD_SET_IVLEN
# define         EVP_CTRL_CCM_GET_TAG            EVP_CTRL_AEAD_GET_TAG
# define         EVP_CTRL_CCM_SET_TAG            EVP_CTRL_AEAD_SET_TAG
# define         EVP_CTRL_CCM_SET_IV_FIXED       EVP_CTRL_AEAD_SET_IV_FIXED
# define         EVP_CTRL_CCM_SET_L              0x14
# define         EVP_CTRL_CCM_SET_MSGLEN         0x15
# define         EVP_MAX_MD_SIZE                 64

typedef unsigned long size_t;

typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

// Forward declarations for opaque structs
struct rsa_st;
struct dsa_st;
struct dh_st;
struct ec_key_st;
struct DSA_SIG_st;
typedef struct rsa_st RSA;
typedef struct dsa_st DSA;
typedef struct dh_st DH;
typedef struct ec_key_st EC_KEY;
typedef struct DSA_SIG_st DSA_SIG;;

// Type aliases.
typedef int OSSL_PROVIDER;

typedef int OSSL_FUNC_keymgmt_import_fn;

typedef int OSSL_FUNC_digest_get_ctx_params_fn;

typedef int OSSL_FUNC_cipher_settable_ctx_params_fn;

typedef int ASN1_STRING;

typedef int OSSL_FUNC_mac_set_ctx_params_fn;

typedef int OSSL_FUNC_signature_digest_verify_update_fn;

typedef int OSSL_FUNC_provider_get_reason_strings_fn;

typedef int OSSL_FUNC_core_get_params_fn;

typedef int OSSL_FUNC_rand_get_seed_fn;

typedef int OSSL_FUNC_rand_instantiate_fn;

typedef int OSSL_FUNC_keymgmt_gen_get_params_fn;

typedef int EVP_PKEY_gen_cb;

typedef int OSSL_FUNC_provider_unquery_operation_fn;

typedef int OSSL_FUNC_cleanup_user_entropy_fn;

typedef int OSSL_FUNC_asym_cipher_decrypt_fn;

typedef int OSSL_FUNC_cipher_pipeline_decrypt_init_fn;

typedef int X509_PUBKEY;

typedef int OSSL_FUNC_BIO_puts_fn;

typedef int OSSL_FUNC_signature_verify_fn;

typedef int OSSL_FUNC_encoder_gettable_params_fn;

typedef int OSSL_FUNC_keymgmt_validate_fn;

typedef int EVP_PBE_KEYGEN_EX;

typedef int OSSL_FUNC_keyexch_dupctx_fn;

typedef int OSSL_FUNC_kdf_newctx_fn;

typedef int OSSL_FUNC_signature_digest_verify_final_fn;

typedef int OSSL_FUNC_signature_set_ctx_params_fn;

typedef int OSSL_FUNC_rand_reseed_fn;

typedef int OSSL_FUNC_SSL_QUIC_TLS_crypto_release_rcd_fn;

typedef int OSSL_FUNC_store_open_fn;

typedef int OSSL_FUNC_encoder_newctx_fn;

typedef int EVP_KEYMGMT;

typedef int OSSL_FUNC_core_vset_error_fn;

typedef int EVP_KEYEXCH;

typedef int OSSL_FUNC_signature_gettable_ctx_md_params_fn;

typedef int OSSL_FUNC_CRYPTO_secure_free_fn;

typedef int OSSL_FUNC_keymgmt_import_types_fn;

typedef int OSSL_FUNC_signature_sign_message_update_fn;

typedef int OSSL_FUNC_keymgmt_gen_gettable_params_fn;

typedef int OSSL_FUNC_cipher_update_fn;

typedef int OSSL_FUNC_mac_newctx_fn;

typedef int OSSL_FUNC_keymgmt_set_params_fn;

typedef int X509_ALGOR;

typedef int OSSL_FUNC_signature_get_ctx_params_fn;

typedef int ASN1_ITEM;

typedef int EVP_SIGNATURE;

typedef int OSSL_FUNC_CRYPTO_realloc_fn;

typedef int OSSL_FUNC_BIO_new_file_fn;

typedef int OSSL_FUNC_signature_sign_message_final_fn;

typedef int OSSL_FUNC_cipher_newctx_fn;

typedef int OSSL_FUNC_rand_nonce_fn;

typedef int EVP_MD;

typedef int OSSL_FUNC_kdf_reset_fn;

typedef int OSSL_FUNC_keyexch_settable_ctx_params_fn;

typedef int OSSL_FUNC_store_export_object_fn;

typedef int OSSL_FUNC_CRYPTO_secure_allocated_fn;

typedef int OSSL_FUNC_cipher_pipeline_update_fn;

typedef int OSSL_FUNC_keyexch_freectx_fn;

typedef int OSSL_FUNC_kdf_gettable_params_fn;

typedef int OSSL_FUNC_rand_set_ctx_params_fn;

typedef int OSSL_FUNC_signature_verify_message_init_fn;

typedef int OSSL_FUNC_keymgmt_free_fn;

typedef int OSSL_FUNC_rand_gettable_ctx_params_fn;

typedef int OSSL_FUNC_signature_digest_sign_update_fn;

typedef int OSSL_FUNC_keymgmt_has_fn;

typedef int OSSL_FUNC_kdf_get_ctx_params_fn;

typedef int OSSL_FUNC_provider_get0_dispatch_fn;

typedef int OSSL_FUNC_signature_verify_message_update_fn;

typedef int OSSL_FUNC_rand_lock_fn;

typedef int EVP_KEM;

typedef int OSSL_FUNC_BIO_read_ex_fn;

typedef int X509_SIG_INFO;

typedef int OSSL_FUNC_keymgmt_import_types_ex_fn;

typedef int OSSL_FUNC_encoder_free_object_fn;

typedef int OSSL_FUNC_asym_cipher_decrypt_init_fn;

typedef int OSSL_FUNC_SSL_QUIC_TLS_alert_fn;

typedef int OSSL_FUNC_cipher_get_params_fn;

typedef int OSSL_FUNC_get_nonce_fn;

typedef int ASN1_OBJECT;

typedef int OSSL_LIB_CTX;

typedef int OSSL_FUNC_keymgmt_gen_set_params_fn;

typedef int OSSL_FUNC_provider_deregister_child_cb_fn;

typedef int OSSL_PARAM;

typedef int OSSL_FUNC_decoder_gettable_params_fn;

typedef int OSSL_FUNC_cipher_pipeline_final_fn;

typedef int OSSL_FUNC_signature_freectx_fn;

typedef int EVP_PKEY_METHOD;

typedef int OSSL_FUNC_CRYPTO_zalloc_fn;

typedef int OSSL_FUNC_keymgmt_query_operation_name_fn;

typedef int OSSL_FUNC_core_set_error_mark_fn;

typedef int OSSL_FUNC_asym_cipher_gettable_ctx_params_fn;

typedef int OSSL_FUNC_CRYPTO_free_fn;

typedef int OSSL_FUNC_indicator_cb_fn;

typedef int OSSL_FUNC_kdf_freectx_fn;

typedef int ENGINE;

typedef int EVP_PKEY;

typedef int PKCS8_PRIV_KEY_INFO;

typedef int OSSL_FUNC_signature_digest_verify_fn;

typedef int OSSL_FUNC_mac_final_fn;

typedef int OSSL_FUNC_core_pop_error_to_mark_fn;

typedef int OSSL_FUNC_signature_verify_recover_fn;

typedef int OSSL_FUNC_keymgmt_gen_settable_params_fn;

typedef int OSSL_FUNC_provider_self_test_fn;

typedef int OSSL_FUNC_digest_gettable_params_fn;

typedef int OSSL_FUNC_CRYPTO_secure_malloc_fn;

typedef int OSSL_FUNC_keymgmt_get_params_fn;

typedef int OSSL_FUNC_mac_freectx_fn;

typedef int OSSL_FUNC_cleanup_user_nonce_fn;

typedef int EVP_SKEYMGMT;

typedef int OSSL_FUNC_core_set_error_debug_fn;

typedef int OSSL_FUNC_cipher_decrypt_skey_init_fn;

typedef int OSSL_FUNC_BIO_new_membuf_fn;

typedef int OSSL_FUNC_provider_query_operation_fn;

typedef int OSSL_FUNC_signature_set_ctx_md_params_fn;

typedef int OSSL_FUNC_encoder_does_selection_fn;

typedef int OSSL_FUNC_kem_get_ctx_params_fn;

typedef int OSSL_FUNC_cipher_gettable_params_fn;

typedef int OSSL_FUNC_digest_final_fn;

typedef int OSSL_FUNC_rand_generate_fn;

typedef int EVP_PKEY_CTX;

typedef int OSSL_FUNC_kem_decapsulate_fn;

typedef int OSSL_FUNC_skeymgmt_generate_fn;

typedef int OSSL_FUNC_asym_cipher_encrypt_init_fn;

typedef int OSSL_FUNC_kdf_get_params_fn;

typedef int OSSL_FUNC_cipher_encrypt_skey_init_fn;

typedef int OSSL_FUNC_encoder_get_params_fn;

typedef int OSSL_FUNC_asym_cipher_freectx_fn;

typedef int OSSL_FUNC_CRYPTO_secure_clear_free_fn;

typedef int OSSL_FUNC_store_load_fn;

typedef int OSSL_FUNC_digest_update_fn;

typedef int OSSL_FUNC_provider_up_ref_fn;

typedef int OSSL_FUNC_SSL_QUIC_TLS_crypto_recv_rcd_fn;

typedef int OSSL_FUNC_signature_digest_sign_init_fn;

typedef int OSSL_FUNC_keymgmt_load_fn;

typedef int OSSL_FUNC_keyexch_gettable_ctx_params_fn;

typedef int OSSL_FUNC_rand_get_params_fn;

typedef int OSSL_FUNC_rand_verify_zeroization_fn;

typedef int OSSL_FUNC_skeymgmt_export_fn;

typedef int OSSL_FUNC_BIO_free_fn;

typedef int OSSL_FUNC_rand_settable_ctx_params_fn;

typedef int OSSL_FUNC_cleanup_entropy_fn;

typedef int OSSL_FUNC_encoder_settable_ctx_params_fn;

typedef int OSSL_DISPATCH;

typedef int OSSL_FUNC_OPENSSL_cleanse_fn;

typedef int OSSL_FUNC_digest_dupctx_fn;

typedef int OSSL_FUNC_kem_decapsulate_init_fn;

typedef int EVP_MAC_CTX;

typedef int OSSL_FUNC_digest_squeeze_fn;

typedef int OSSL_FUNC_keyexch_set_ctx_params_fn;

typedef int EVP_ENCODE_CTX;

typedef int OSSL_FUNC_BIO_vsnprintf_fn;

typedef int OSSL_FUNC_mac_dupctx_fn;

typedef int OSSL_FUNC_kdf_derive_fn;

typedef int OSSL_FUNC_encoder_set_ctx_params_fn;

typedef int OSSL_FUNC_rand_freectx_fn;

typedef int OSSL_FUNC_BIO_ctrl_fn;

typedef int EVP_CIPHER;

typedef int OSSL_FUNC_cipher_set_ctx_params_fn;

typedef int OSSL_FUNC_rand_enable_locking_fn;

typedef int OSSL_FUNC_keyexch_newctx_fn;

typedef int OSSL_FUNC_signature_settable_ctx_params_fn;

typedef int OSSL_FUNC_provider_gettable_params_fn;

typedef int OSSL_FUNC_keymgmt_gen_set_template_fn;

typedef int OSSL_FUNC_keymgmt_settable_params_fn;

typedef int OSSL_FUNC_keymgmt_gen_cleanup_fn;

typedef int OSSL_FUNC_kdf_set_ctx_params_fn;

typedef int OSSL_FUNC_rand_unlock_fn;

typedef int OSSL_FUNC_SSL_QUIC_TLS_yield_secret_fn;

typedef int OSSL_FUNC_signature_digest_sign_fn;

typedef int OSSL_FUNC_keymgmt_gettable_params_fn;

typedef int OSSL_FUNC_kem_auth_encapsulate_init_fn;

typedef int OSSL_FUNC_kem_encapsulate_fn;

typedef int OSSL_FUNC_CRYPTO_secure_zalloc_fn;

typedef int OSSL_FUNC_rand_get_ctx_params_fn;

typedef int OSSL_FUNC_store_delete_fn;

typedef int OSSL_FUNC_cipher_pipeline_encrypt_init_fn;

typedef int OSSL_FUNC_cipher_dupctx_fn;

typedef int OSSL_FUNC_store_settable_ctx_params_fn;

typedef int FILE;

typedef int OSSL_FUNC_provider_teardown_fn;

typedef int OSSL_FUNC_kdf_dupctx_fn;

typedef int OSSL_FUNC_decoder_newctx_fn;

typedef int ASN1_BIT_STRING;

typedef int OSSL_FUNC_core_clear_last_error_mark_fn;

typedef int OSSL_FUNC_core_obj_create_fn;

typedef int OSSL_FUNC_keyexch_init_fn;

typedef int OSSL_FUNC_kem_gettable_ctx_params_fn;

typedef int EVP_MD_CTX;

typedef int OSSL_FUNC_decoder_decode_fn;

typedef int OSSL_FUNC_mac_gettable_params_fn;

typedef int OSSL_FUNC_kem_set_ctx_params_fn;

typedef int OSSL_FUNC_encoder_encode_fn;

typedef int OSSL_FUNC_core_gettable_params_fn;

typedef int OSSL_FUNC_mac_gettable_ctx_params_fn;

typedef int OSSL_FUNC_get_user_entropy_fn;

typedef int OSSL_FUNC_kdf_gettable_ctx_params_fn;

typedef int OSSL_FUNC_keymgmt_gen_fn;

typedef int OSSL_FUNC_keyexch_set_peer_fn;

typedef int OSSL_FUNC_core_obj_add_sigid_fn;

typedef int OSSL_FUNC_keymgmt_export_types_ex_fn;

typedef int OSSL_FUNC_kem_newctx_fn;

typedef int OSSL_FUNC_signature_sign_init_fn;

typedef int OSSL_FUNC_asym_cipher_get_ctx_params_fn;

typedef int OSSL_FUNC_CRYPTO_clear_free_fn;

typedef int OSSL_FUNC_encoder_freectx_fn;

typedef int OSSL_FUNC_kem_freectx_fn;

typedef int OSSL_FUNC_provider_get0_provider_ctx_fn;

typedef int OSSL_FUNC_digest_copyctx_fn;

typedef int OSSL_FUNC_provider_name_fn;

typedef int OSSL_FUNC_cipher_decrypt_init_fn;

typedef int EVP_PKEY_ASN1_METHOD;

typedef int OSSL_FUNC_keyexch_get_ctx_params_fn;

typedef int OSSL_FUNC_store_set_ctx_params_fn;

typedef int ASN1_TYPE;

typedef int OSSL_FUNC_skeymgmt_imp_settable_params_fn;

typedef int OSSL_FUNC_cipher_get_ctx_params_fn;

typedef int EVP_MAC;

typedef int OSSL_FUNC_store_attach_fn;

typedef int OSSL_FUNC_signature_get_ctx_md_params_fn;

typedef int OSSL_FUNC_encoder_import_object_fn;

typedef int OSSL_FUNC_cleanup_nonce_fn;

typedef int OSSL_FUNC_kem_auth_decapsulate_init_fn;

typedef int OSSL_CALLBACK;

typedef int OSSL_FUNC_skeymgmt_import_fn;

typedef int OSSL_FUNC_cipher_freectx_fn;

typedef int OSSL_FUNC_asym_cipher_dupctx_fn;

typedef int OSSL_FUNC_SSL_QUIC_TLS_crypto_send_fn;

typedef int OSSL_FUNC_CRYPTO_clear_realloc_fn;

typedef int OSSL_FUNC_signature_verify_recover_init_fn;

typedef int OSSL_FUNC_provider_free_fn;

typedef int EVP_RAND;

typedef int OSSL_FUNC_digest_newctx_fn;

typedef int OSSL_FUNC_cipher_final_fn;

typedef int OSSL_FUNC_keymgmt_new_fn;

typedef int EVP_CIPHER_CTX;

typedef int OSSL_FUNC_decoder_does_selection_fn;

typedef int OSSL_FUNC_signature_digest_verify_init_fn;

typedef int OSSL_FUNC_digest_set_ctx_params_fn;

typedef int OSSL_FUNC_rand_newctx_fn;

typedef int OSSL_FUNC_BIO_vprintf_fn;

typedef int OSSL_FUNC_keymgmt_gen_init_fn;

typedef int EVP_RAND_CTX;

typedef int OSSL_FUNC_store_close_fn;

typedef int OSSL_FUNC_asym_cipher_encrypt_fn;

typedef int OSSL_FUNC_mac_get_params_fn;

typedef int OSSL_FUNC_get_entropy_fn;

typedef int OSSL_FUNC_digest_gettable_ctx_params_fn;

typedef int OSSL_FUNC_SSL_QUIC_TLS_got_transport_params_fn;

typedef int OSSL_FUNC_skeymgmt_free_fn;

typedef int OSSL_FUNC_mac_settable_ctx_params_fn;

typedef int OSSL_FUNC_decoder_export_object_fn;

typedef int OSSL_FUNC_rand_clear_seed_fn;

typedef int OSSL_FUNC_mac_get_ctx_params_fn;

typedef int OSSL_FUNC_digest_digest_fn;

typedef int EVP_SKEY;

typedef int OSSL_FUNC_cipher_gettable_ctx_params_fn;

typedef int OSSL_FUNC_CRYPTO_malloc_fn;

typedef int OSSL_FUNC_asym_cipher_settable_ctx_params_fn;

typedef int OSSL_FUNC_signature_dupctx_fn;

typedef int OSSL_FUNC_BIO_write_ex_fn;

typedef int OSSL_FUNC_rand_set_callbacks_fn;

typedef int OSSL_FUNC_keymgmt_match_fn;

typedef int OSSL_FUNC_signature_digest_sign_final_fn;

typedef int OSSL_FUNC_provider_get_params_fn;

typedef int OSSL_FUNC_BIO_gets_fn;

typedef int OSSL_FUNC_cipher_encrypt_init_fn;

typedef int OSSL_FUNC_signature_verify_message_final_fn;

typedef int BIGNUM;

typedef int OSSL_FUNC_digest_freectx_fn;

typedef int OSSL_FUNC_asym_cipher_set_ctx_params_fn;

typedef int OSSL_FUNC_signature_gettable_ctx_params_fn;

typedef int BIO;

typedef int OSSL_FUNC_digest_get_params_fn;

typedef int OSSL_FUNC_skeymgmt_get_key_id_fn;

typedef int OSSL_FUNC_rand_uninstantiate_fn;

typedef int OSSL_FUNC_decoder_get_params_fn;

typedef int OSSL_FUNC_signature_newctx_fn;

typedef int OSSL_FUNC_signature_sign_fn;

typedef int OSSL_FUNC_decoder_set_ctx_params_fn;

typedef int OSSL_FUNC_kem_dupctx_fn;

typedef int OSSL_FUNC_get_user_nonce_fn;

typedef int OSSL_FUNC_mac_init_skey_fn;

typedef int ASN1_PCTX;

typedef int OSSL_FUNC_provider_get_capabilities_fn;

typedef int OSSL_FUNC_provider_register_child_cb_fn;

typedef int OSSL_FUNC_kem_settable_ctx_params_fn;

typedef int OSSL_FUNC_signature_query_key_types_fn;

typedef int OSSL_FUNC_signature_settable_ctx_md_params_fn;

typedef int OSSL_FUNC_asym_cipher_newctx_fn;

typedef int OSSL_FUNC_store_open_ex_fn;

typedef int OSSL_FUNC_keyexch_derive_fn;

typedef int OSSL_FUNC_kdf_settable_ctx_params_fn;

typedef int OSSL_FUNC_skeymgmt_gen_settable_params_fn;

typedef int OSSL_FUNC_digest_settable_ctx_params_fn;

typedef int OSSL_FUNC_kem_encapsulate_init_fn;

typedef int OSSL_FUNC_core_new_error_fn;

typedef int OSSL_FUNC_BIO_up_ref_fn;

typedef int OSSL_FUNC_self_test_cb_fn;

typedef int OSSL_FUNC_keymgmt_export_types_fn;

typedef int OSSL_FUNC_core_get_libctx_fn;

typedef int OSSL_FUNC_digest_init_fn;

typedef int EVP_ASYM_CIPHER;

typedef int OSSL_FUNC_decoder_settable_ctx_params_fn;

typedef int OSSL_FUNC_signature_sign_message_init_fn;

typedef int OSSL_FUNC_rand_gettable_params_fn;

typedef int OSSL_FUNC_mac_update_fn;

typedef int OSSL_FUNC_keymgmt_export_fn;

typedef int OSSL_FUNC_provider_random_bytes_fn;

typedef int OSSL_FUNC_decoder_freectx_fn;

typedef int OSSL_FUNC_mac_init_fn;

typedef int OSSL_FUNC_store_eof_fn;

typedef int OSSL_FUNC_signature_verify_init_fn;

typedef int EVP_PBE_KEYGEN;

typedef int OSSL_FUNC_core_thread_start_fn;

typedef int OSSL_FUNC_cipher_cipher_fn;

typedef int OSSL_FUNC_keymgmt_dup_fn;

// Function stubs.
OSSL_FUNC_core_gettable_params_fn * OSSL_FUNC_core_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_get_params_fn * OSSL_FUNC_core_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_thread_start_fn * OSSL_FUNC_core_thread_start(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_get_libctx_fn * OSSL_FUNC_core_get_libctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_new_error_fn * OSSL_FUNC_core_new_error(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_set_error_debug_fn * OSSL_FUNC_core_set_error_debug(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_vset_error_fn * OSSL_FUNC_core_vset_error(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_set_error_mark_fn * OSSL_FUNC_core_set_error_mark(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_clear_last_error_mark_fn * OSSL_FUNC_core_clear_last_error_mark(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_pop_error_to_mark_fn * OSSL_FUNC_core_pop_error_to_mark(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_obj_add_sigid_fn * OSSL_FUNC_core_obj_add_sigid(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_core_obj_create_fn * OSSL_FUNC_core_obj_create(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_malloc_fn * OSSL_FUNC_CRYPTO_malloc(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_zalloc_fn * OSSL_FUNC_CRYPTO_zalloc(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_free_fn * OSSL_FUNC_CRYPTO_free(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_clear_free_fn * OSSL_FUNC_CRYPTO_clear_free(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_realloc_fn * OSSL_FUNC_CRYPTO_realloc(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_clear_realloc_fn * OSSL_FUNC_CRYPTO_clear_realloc(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_secure_malloc_fn * OSSL_FUNC_CRYPTO_secure_malloc(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_secure_zalloc_fn * OSSL_FUNC_CRYPTO_secure_zalloc(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_secure_free_fn * OSSL_FUNC_CRYPTO_secure_free(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_secure_clear_free_fn * OSSL_FUNC_CRYPTO_secure_clear_free(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_CRYPTO_secure_allocated_fn * OSSL_FUNC_CRYPTO_secure_allocated(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_OPENSSL_cleanse_fn * OSSL_FUNC_OPENSSL_cleanse(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_new_file_fn * OSSL_FUNC_BIO_new_file(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_new_membuf_fn * OSSL_FUNC_BIO_new_membuf(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_read_ex_fn * OSSL_FUNC_BIO_read_ex(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_write_ex_fn * OSSL_FUNC_BIO_write_ex(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_gets_fn * OSSL_FUNC_BIO_gets(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_puts_fn * OSSL_FUNC_BIO_puts(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_up_ref_fn * OSSL_FUNC_BIO_up_ref(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_free_fn * OSSL_FUNC_BIO_free(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_vprintf_fn * OSSL_FUNC_BIO_vprintf(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_vsnprintf_fn * OSSL_FUNC_BIO_vsnprintf(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_BIO_ctrl_fn * OSSL_FUNC_BIO_ctrl(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_indicator_cb_fn * OSSL_FUNC_indicator_cb(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_self_test_cb_fn * OSSL_FUNC_self_test_cb(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_get_entropy_fn * OSSL_FUNC_get_entropy(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_get_user_entropy_fn * OSSL_FUNC_get_user_entropy(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cleanup_entropy_fn * OSSL_FUNC_cleanup_entropy(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cleanup_user_entropy_fn * OSSL_FUNC_cleanup_user_entropy(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_get_nonce_fn * OSSL_FUNC_get_nonce(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_get_user_nonce_fn * OSSL_FUNC_get_user_nonce(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cleanup_nonce_fn * OSSL_FUNC_cleanup_nonce(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cleanup_user_nonce_fn * OSSL_FUNC_cleanup_user_nonce(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_register_child_cb_fn * OSSL_FUNC_provider_register_child_cb(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_deregister_child_cb_fn * OSSL_FUNC_provider_deregister_child_cb(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_name_fn * OSSL_FUNC_provider_name(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_get0_provider_ctx_fn * OSSL_FUNC_provider_get0_provider_ctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_get0_dispatch_fn * OSSL_FUNC_provider_get0_dispatch(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_up_ref_fn * OSSL_FUNC_provider_up_ref(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_free_fn * OSSL_FUNC_provider_free(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_teardown_fn * OSSL_FUNC_provider_teardown(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_gettable_params_fn * OSSL_FUNC_provider_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_get_params_fn * OSSL_FUNC_provider_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_query_operation_fn * OSSL_FUNC_provider_query_operation(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_unquery_operation_fn * OSSL_FUNC_provider_unquery_operation(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_get_reason_strings_fn * OSSL_FUNC_provider_get_reason_strings(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_get_capabilities_fn * OSSL_FUNC_provider_get_capabilities(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_self_test_fn * OSSL_FUNC_provider_self_test(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_provider_random_bytes_fn * OSSL_FUNC_provider_random_bytes(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_SSL_QUIC_TLS_crypto_send_fn * OSSL_FUNC_SSL_QUIC_TLS_crypto_send(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_SSL_QUIC_TLS_crypto_recv_rcd_fn * OSSL_FUNC_SSL_QUIC_TLS_crypto_recv_rcd(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_SSL_QUIC_TLS_crypto_release_rcd_fn * OSSL_FUNC_SSL_QUIC_TLS_crypto_release_rcd(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_SSL_QUIC_TLS_yield_secret_fn * OSSL_FUNC_SSL_QUIC_TLS_yield_secret(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_SSL_QUIC_TLS_got_transport_params_fn * OSSL_FUNC_SSL_QUIC_TLS_got_transport_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_SSL_QUIC_TLS_alert_fn * OSSL_FUNC_SSL_QUIC_TLS_alert(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_newctx_fn * OSSL_FUNC_digest_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_init_fn * OSSL_FUNC_digest_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_update_fn * OSSL_FUNC_digest_update(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_final_fn * OSSL_FUNC_digest_final(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_squeeze_fn * OSSL_FUNC_digest_squeeze(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_digest_fn * OSSL_FUNC_digest_digest(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_freectx_fn * OSSL_FUNC_digest_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_dupctx_fn * OSSL_FUNC_digest_dupctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_copyctx_fn * OSSL_FUNC_digest_copyctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_get_params_fn * OSSL_FUNC_digest_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_set_ctx_params_fn * OSSL_FUNC_digest_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_get_ctx_params_fn * OSSL_FUNC_digest_get_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_gettable_params_fn * OSSL_FUNC_digest_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_settable_ctx_params_fn * OSSL_FUNC_digest_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_digest_gettable_ctx_params_fn * OSSL_FUNC_digest_gettable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_newctx_fn * OSSL_FUNC_cipher_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_encrypt_init_fn * OSSL_FUNC_cipher_encrypt_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_decrypt_init_fn * OSSL_FUNC_cipher_decrypt_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_update_fn * OSSL_FUNC_cipher_update(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_final_fn * OSSL_FUNC_cipher_final(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_cipher_fn * OSSL_FUNC_cipher_cipher(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_pipeline_encrypt_init_fn * OSSL_FUNC_cipher_pipeline_encrypt_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_pipeline_decrypt_init_fn * OSSL_FUNC_cipher_pipeline_decrypt_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_pipeline_update_fn * OSSL_FUNC_cipher_pipeline_update(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_pipeline_final_fn * OSSL_FUNC_cipher_pipeline_final(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_freectx_fn * OSSL_FUNC_cipher_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_dupctx_fn * OSSL_FUNC_cipher_dupctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_get_params_fn * OSSL_FUNC_cipher_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_get_ctx_params_fn * OSSL_FUNC_cipher_get_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_set_ctx_params_fn * OSSL_FUNC_cipher_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_gettable_params_fn * OSSL_FUNC_cipher_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_settable_ctx_params_fn * OSSL_FUNC_cipher_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_gettable_ctx_params_fn * OSSL_FUNC_cipher_gettable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_encrypt_skey_init_fn * OSSL_FUNC_cipher_encrypt_skey_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_cipher_decrypt_skey_init_fn * OSSL_FUNC_cipher_decrypt_skey_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_newctx_fn * OSSL_FUNC_mac_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_dupctx_fn * OSSL_FUNC_mac_dupctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_freectx_fn * OSSL_FUNC_mac_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_init_fn * OSSL_FUNC_mac_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_update_fn * OSSL_FUNC_mac_update(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_final_fn * OSSL_FUNC_mac_final(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_gettable_params_fn * OSSL_FUNC_mac_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_gettable_ctx_params_fn * OSSL_FUNC_mac_gettable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_settable_ctx_params_fn * OSSL_FUNC_mac_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_get_params_fn * OSSL_FUNC_mac_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_get_ctx_params_fn * OSSL_FUNC_mac_get_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_set_ctx_params_fn * OSSL_FUNC_mac_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_mac_init_skey_fn * OSSL_FUNC_mac_init_skey(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_newctx_fn * OSSL_FUNC_kdf_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_dupctx_fn * OSSL_FUNC_kdf_dupctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_freectx_fn * OSSL_FUNC_kdf_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_reset_fn * OSSL_FUNC_kdf_reset(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_derive_fn * OSSL_FUNC_kdf_derive(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_gettable_params_fn * OSSL_FUNC_kdf_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_gettable_ctx_params_fn * OSSL_FUNC_kdf_gettable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_settable_ctx_params_fn * OSSL_FUNC_kdf_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_get_params_fn * OSSL_FUNC_kdf_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_get_ctx_params_fn * OSSL_FUNC_kdf_get_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kdf_set_ctx_params_fn * OSSL_FUNC_kdf_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_newctx_fn * OSSL_FUNC_rand_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_freectx_fn * OSSL_FUNC_rand_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_instantiate_fn * OSSL_FUNC_rand_instantiate(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_uninstantiate_fn * OSSL_FUNC_rand_uninstantiate(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_generate_fn * OSSL_FUNC_rand_generate(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_reseed_fn * OSSL_FUNC_rand_reseed(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_nonce_fn * OSSL_FUNC_rand_nonce(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_enable_locking_fn * OSSL_FUNC_rand_enable_locking(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_lock_fn * OSSL_FUNC_rand_lock(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_unlock_fn * OSSL_FUNC_rand_unlock(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_gettable_params_fn * OSSL_FUNC_rand_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_gettable_ctx_params_fn * OSSL_FUNC_rand_gettable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_settable_ctx_params_fn * OSSL_FUNC_rand_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_get_params_fn * OSSL_FUNC_rand_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_get_ctx_params_fn * OSSL_FUNC_rand_get_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_set_ctx_params_fn * OSSL_FUNC_rand_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_set_callbacks_fn * OSSL_FUNC_rand_set_callbacks(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_verify_zeroization_fn * OSSL_FUNC_rand_verify_zeroization(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_get_seed_fn * OSSL_FUNC_rand_get_seed(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_rand_clear_seed_fn * OSSL_FUNC_rand_clear_seed(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_new_fn * OSSL_FUNC_keymgmt_new(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_gen_init_fn * OSSL_FUNC_keymgmt_gen_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_gen_set_template_fn * OSSL_FUNC_keymgmt_gen_set_template(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_gen_set_params_fn * OSSL_FUNC_keymgmt_gen_set_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_gen_settable_params_fn * OSSL_FUNC_keymgmt_gen_settable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_gen_get_params_fn * OSSL_FUNC_keymgmt_gen_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_gen_gettable_params_fn * OSSL_FUNC_keymgmt_gen_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_gen_fn * OSSL_FUNC_keymgmt_gen(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_gen_cleanup_fn * OSSL_FUNC_keymgmt_gen_cleanup(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_load_fn * OSSL_FUNC_keymgmt_load(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_free_fn * OSSL_FUNC_keymgmt_free(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_get_params_fn * OSSL_FUNC_keymgmt_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_gettable_params_fn * OSSL_FUNC_keymgmt_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_set_params_fn * OSSL_FUNC_keymgmt_set_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_settable_params_fn * OSSL_FUNC_keymgmt_settable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_query_operation_name_fn * OSSL_FUNC_keymgmt_query_operation_name(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_has_fn * OSSL_FUNC_keymgmt_has(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_validate_fn * OSSL_FUNC_keymgmt_validate(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_match_fn * OSSL_FUNC_keymgmt_match(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_import_fn * OSSL_FUNC_keymgmt_import(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_import_types_fn * OSSL_FUNC_keymgmt_import_types(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_export_fn * OSSL_FUNC_keymgmt_export(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_export_types_fn * OSSL_FUNC_keymgmt_export_types(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_dup_fn * OSSL_FUNC_keymgmt_dup(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_import_types_ex_fn * OSSL_FUNC_keymgmt_import_types_ex(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keymgmt_export_types_ex_fn * OSSL_FUNC_keymgmt_export_types_ex(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_newctx_fn * OSSL_FUNC_keyexch_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_init_fn * OSSL_FUNC_keyexch_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_derive_fn * OSSL_FUNC_keyexch_derive(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_set_peer_fn * OSSL_FUNC_keyexch_set_peer(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_freectx_fn * OSSL_FUNC_keyexch_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_dupctx_fn * OSSL_FUNC_keyexch_dupctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_set_ctx_params_fn * OSSL_FUNC_keyexch_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_settable_ctx_params_fn * OSSL_FUNC_keyexch_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_get_ctx_params_fn * OSSL_FUNC_keyexch_get_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_keyexch_gettable_ctx_params_fn * OSSL_FUNC_keyexch_gettable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_newctx_fn * OSSL_FUNC_signature_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_sign_init_fn * OSSL_FUNC_signature_sign_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_sign_fn * OSSL_FUNC_signature_sign(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_sign_message_init_fn * OSSL_FUNC_signature_sign_message_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_sign_message_update_fn * OSSL_FUNC_signature_sign_message_update(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_sign_message_final_fn * OSSL_FUNC_signature_sign_message_final(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_verify_init_fn * OSSL_FUNC_signature_verify_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_verify_fn * OSSL_FUNC_signature_verify(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_verify_message_init_fn * OSSL_FUNC_signature_verify_message_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_verify_message_update_fn * OSSL_FUNC_signature_verify_message_update(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_verify_message_final_fn * OSSL_FUNC_signature_verify_message_final(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_verify_recover_init_fn * OSSL_FUNC_signature_verify_recover_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_verify_recover_fn * OSSL_FUNC_signature_verify_recover(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_digest_sign_init_fn * OSSL_FUNC_signature_digest_sign_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_digest_sign_update_fn * OSSL_FUNC_signature_digest_sign_update(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_digest_sign_final_fn * OSSL_FUNC_signature_digest_sign_final(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_digest_sign_fn * OSSL_FUNC_signature_digest_sign(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_digest_verify_init_fn * OSSL_FUNC_signature_digest_verify_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_digest_verify_update_fn * OSSL_FUNC_signature_digest_verify_update(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_digest_verify_final_fn * OSSL_FUNC_signature_digest_verify_final(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_digest_verify_fn * OSSL_FUNC_signature_digest_verify(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_freectx_fn * OSSL_FUNC_signature_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_dupctx_fn * OSSL_FUNC_signature_dupctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_get_ctx_params_fn * OSSL_FUNC_signature_get_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_gettable_ctx_params_fn * OSSL_FUNC_signature_gettable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_set_ctx_params_fn * OSSL_FUNC_signature_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_settable_ctx_params_fn * OSSL_FUNC_signature_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_get_ctx_md_params_fn * OSSL_FUNC_signature_get_ctx_md_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_gettable_ctx_md_params_fn * OSSL_FUNC_signature_gettable_ctx_md_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_set_ctx_md_params_fn * OSSL_FUNC_signature_set_ctx_md_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_settable_ctx_md_params_fn * OSSL_FUNC_signature_settable_ctx_md_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_signature_query_key_types_fn * OSSL_FUNC_signature_query_key_types(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_skeymgmt_free_fn * OSSL_FUNC_skeymgmt_free(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_skeymgmt_imp_settable_params_fn * OSSL_FUNC_skeymgmt_imp_settable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_skeymgmt_import_fn * OSSL_FUNC_skeymgmt_import(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_skeymgmt_export_fn * OSSL_FUNC_skeymgmt_export(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_skeymgmt_gen_settable_params_fn * OSSL_FUNC_skeymgmt_gen_settable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_skeymgmt_generate_fn * OSSL_FUNC_skeymgmt_generate(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_skeymgmt_get_key_id_fn * OSSL_FUNC_skeymgmt_get_key_id(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_newctx_fn * OSSL_FUNC_asym_cipher_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_encrypt_init_fn * OSSL_FUNC_asym_cipher_encrypt_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_encrypt_fn * OSSL_FUNC_asym_cipher_encrypt(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_decrypt_init_fn * OSSL_FUNC_asym_cipher_decrypt_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_decrypt_fn * OSSL_FUNC_asym_cipher_decrypt(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_freectx_fn * OSSL_FUNC_asym_cipher_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_dupctx_fn * OSSL_FUNC_asym_cipher_dupctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_get_ctx_params_fn * OSSL_FUNC_asym_cipher_get_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_gettable_ctx_params_fn * OSSL_FUNC_asym_cipher_gettable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_set_ctx_params_fn * OSSL_FUNC_asym_cipher_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_asym_cipher_settable_ctx_params_fn * OSSL_FUNC_asym_cipher_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_newctx_fn * OSSL_FUNC_kem_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_encapsulate_init_fn * OSSL_FUNC_kem_encapsulate_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_auth_encapsulate_init_fn * OSSL_FUNC_kem_auth_encapsulate_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_encapsulate_fn * OSSL_FUNC_kem_encapsulate(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_decapsulate_init_fn * OSSL_FUNC_kem_decapsulate_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_auth_decapsulate_init_fn * OSSL_FUNC_kem_auth_decapsulate_init(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_decapsulate_fn * OSSL_FUNC_kem_decapsulate(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_freectx_fn * OSSL_FUNC_kem_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_dupctx_fn * OSSL_FUNC_kem_dupctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_get_ctx_params_fn * OSSL_FUNC_kem_get_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_gettable_ctx_params_fn * OSSL_FUNC_kem_gettable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_set_ctx_params_fn * OSSL_FUNC_kem_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_kem_settable_ctx_params_fn * OSSL_FUNC_kem_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_newctx_fn * OSSL_FUNC_encoder_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_freectx_fn * OSSL_FUNC_encoder_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_get_params_fn * OSSL_FUNC_encoder_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_gettable_params_fn * OSSL_FUNC_encoder_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_set_ctx_params_fn * OSSL_FUNC_encoder_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_settable_ctx_params_fn * OSSL_FUNC_encoder_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_does_selection_fn * OSSL_FUNC_encoder_does_selection(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_encode_fn * OSSL_FUNC_encoder_encode(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_import_object_fn * OSSL_FUNC_encoder_import_object(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_encoder_free_object_fn * OSSL_FUNC_encoder_free_object(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_decoder_newctx_fn * OSSL_FUNC_decoder_newctx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_decoder_freectx_fn * OSSL_FUNC_decoder_freectx(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_decoder_get_params_fn * OSSL_FUNC_decoder_get_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_decoder_gettable_params_fn * OSSL_FUNC_decoder_gettable_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_decoder_set_ctx_params_fn * OSSL_FUNC_decoder_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_decoder_settable_ctx_params_fn * OSSL_FUNC_decoder_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_decoder_does_selection_fn * OSSL_FUNC_decoder_does_selection(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_decoder_decode_fn * OSSL_FUNC_decoder_decode(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_decoder_export_object_fn * OSSL_FUNC_decoder_export_object(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_open_fn * OSSL_FUNC_store_open(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_attach_fn * OSSL_FUNC_store_attach(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_settable_ctx_params_fn * OSSL_FUNC_store_settable_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_set_ctx_params_fn * OSSL_FUNC_store_set_ctx_params(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_load_fn * OSSL_FUNC_store_load(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_eof_fn * OSSL_FUNC_store_eof(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_close_fn * OSSL_FUNC_store_close(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_export_object_fn * OSSL_FUNC_store_export_object(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_delete_fn * OSSL_FUNC_store_delete(const OSSL_DISPATCH * opf) {
    return NULL;
}

OSSL_FUNC_store_open_ex_fn * OSSL_FUNC_store_open_ex(const OSSL_DISPATCH * opf) {
    return NULL;
}

int EVP_set_default_properties(OSSL_LIB_CTX * libctx, const char * propq) {
    return 0;
}

char * EVP_get1_default_properties(OSSL_LIB_CTX * libctx) {
    return NULL;
}

int EVP_default_properties_is_fips_enabled(OSSL_LIB_CTX * libctx) {
    return 0;
}

int EVP_default_properties_enable_fips(OSSL_LIB_CTX * libctx, int enable) {
    return 0;
}

EVP_MD * EVP_MD_meth_new(int md_type, int pkey_type) {
    return NULL;
}

EVP_MD * EVP_MD_meth_dup(const EVP_MD * md) {
    return NULL;
}

void EVP_MD_meth_free(EVP_MD * md) ;


int EVP_MD_meth_set_input_blocksize(EVP_MD * md, int blocksize) {
    return 0;
}

int EVP_MD_meth_set_result_size(EVP_MD * md, int resultsize) {
    return 0;
}

int EVP_MD_meth_set_app_datasize(EVP_MD * md, int datasize) {
    return 0;
}

int EVP_MD_meth_set_flags(EVP_MD * md, unsigned long flags) {
    return 0;
}

int EVP_MD_meth_set_init(EVP_MD * md, int (*init)(EVP_MD_CTX *)) {
    return 0;
}

int EVP_MD_meth_set_update(EVP_MD * md, int (*update)(EVP_MD_CTX *, const void *, size_t)) {
    return 0;
}

int EVP_MD_meth_set_final(EVP_MD * md, int (*final)(EVP_MD_CTX *, unsigned char *)) {
    return 0;
}

int EVP_MD_meth_set_copy(EVP_MD * md, int (*copy)(EVP_MD_CTX *, const EVP_MD_CTX *)) {
    return 0;
}

int EVP_MD_meth_set_cleanup(EVP_MD * md, int (*cleanup)(EVP_MD_CTX *)) {
    return 0;
}

int EVP_MD_meth_set_ctrl(EVP_MD * md, int (*ctrl)(EVP_MD_CTX *, int, int, void *)) {
    return 0;
}

int EVP_MD_meth_get_input_blocksize(const EVP_MD * md) {
    return 0;
}

int EVP_MD_meth_get_result_size(const EVP_MD * md) {
    return 0;
}

int EVP_MD_meth_get_app_datasize(const EVP_MD * md) {
    return 0;
}

unsigned long EVP_MD_meth_get_flags(const EVP_MD * md) {
    return 0;
}

int EVP_MD_meth_get_init(const EVP_MD * md) {
    return 0;
}

int EVP_MD_meth_get_update(const EVP_MD * md) {
    return 0;
}

int EVP_MD_meth_get_final(const EVP_MD * md) {
    return 0;
}

int EVP_MD_meth_get_copy(const EVP_MD * md) {
    return 0;
}

int EVP_MD_meth_get_cleanup(const EVP_MD * md) {
    return 0;
}

int EVP_MD_meth_get_ctrl(const EVP_MD * md) {
    return 0;
}

EVP_CIPHER * EVP_CIPHER_meth_new(int cipher_type, int block_size, int key_len) {
    return NULL;
}

EVP_CIPHER * EVP_CIPHER_meth_dup(const EVP_CIPHER * cipher) {
    return NULL;
}

void EVP_CIPHER_meth_free(EVP_CIPHER * cipher) ;


int EVP_CIPHER_meth_set_iv_length(EVP_CIPHER * cipher, int iv_len) {
    return 0;
}

int EVP_CIPHER_meth_set_flags(EVP_CIPHER * cipher, unsigned long flags) {
    return 0;
}

int EVP_CIPHER_meth_set_impl_ctx_size(EVP_CIPHER * cipher, int ctx_size) {
    return 0;
}

int EVP_CIPHER_meth_set_init(EVP_CIPHER * cipher, int (*init)(EVP_CIPHER_CTX *, const unsigned char *, const unsigned char *, int)) {
    return 0;
}

int EVP_CIPHER_meth_set_do_cipher(EVP_CIPHER * cipher, int (*do_cipher)(EVP_CIPHER_CTX *, unsigned char *, const unsigned char *, size_t)) {
    return 0;
}

int EVP_CIPHER_meth_set_cleanup(EVP_CIPHER * cipher, int (*cleanup)(EVP_CIPHER_CTX *)) {
    return 0;
}

int EVP_CIPHER_meth_set_set_asn1_params(EVP_CIPHER * cipher, int (*set_asn1_parameters)(EVP_CIPHER_CTX *, ASN1_TYPE *)) {
    return 0;
}

int EVP_CIPHER_meth_set_get_asn1_params(EVP_CIPHER * cipher, int (*get_asn1_parameters)(EVP_CIPHER_CTX *, ASN1_TYPE *)) {
    return 0;
}

int EVP_CIPHER_meth_set_ctrl(EVP_CIPHER * cipher, int (*ctrl)(EVP_CIPHER_CTX *, int, int, void *)) {
    return 0;
}

int EVP_CIPHER_meth_get_init(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_meth_get_do_cipher(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_meth_get_cleanup(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_meth_get_set_asn1_params(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_meth_get_get_asn1_params(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_meth_get_ctrl(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_MD_get_type(const EVP_MD * md) {
    return 0;
}

const char * EVP_MD_get0_name(const EVP_MD * md) {
    return NULL;
}

const char * EVP_MD_get0_description(const EVP_MD * md) {
    return NULL;
}

int EVP_MD_is_a(const EVP_MD * md, const char * name) {
    return 0;
}

int EVP_MD_names_do_all(const EVP_MD * md, void (*fn)(const char *, void *), void * data) {
    return 0;
}

const OSSL_PROVIDER * EVP_MD_get0_provider(const EVP_MD * md) {
    return NULL;
}

int EVP_MD_get_pkey_type(const EVP_MD * md) {
    return 0;
}

int EVP_MD_get_size(const EVP_MD * md) {
    return 0;
}

int EVP_MD_get_block_size(const EVP_MD * md) {
    return 0;
}

unsigned long EVP_MD_get_flags(const EVP_MD * md) {
    return 0;
}

int EVP_MD_xof(const EVP_MD * md) {
    return 0;
}

const EVP_MD * EVP_MD_CTX_get0_md(const EVP_MD_CTX * ctx) {
    return NULL;
}

EVP_MD * EVP_MD_CTX_get1_md(EVP_MD_CTX * ctx) {
    return NULL;
}

const EVP_MD * EVP_MD_CTX_md(const EVP_MD_CTX * ctx) {
    return NULL;
}

int EVP_MD_CTX_update_fn(EVP_MD_CTX * ctx) {
    return 0;
}

void EVP_MD_CTX_set_update_fn(EVP_MD_CTX * ctx, int (*update)(EVP_MD_CTX *, const void *, size_t)) ;


int EVP_MD_CTX_get_size_ex(const EVP_MD_CTX * ctx) {
    return 0;
}

EVP_PKEY_CTX * EVP_MD_CTX_get_pkey_ctx(const EVP_MD_CTX * ctx) {
    return NULL;
}

void EVP_MD_CTX_set_pkey_ctx(EVP_MD_CTX * ctx, EVP_PKEY_CTX * pctx) ;


void * EVP_MD_CTX_get0_md_data(const EVP_MD_CTX * ctx) {
    return NULL;
}

int EVP_CIPHER_get_nid(const EVP_CIPHER * cipher) {
    return 0;
}

const char * EVP_CIPHER_get0_name(const EVP_CIPHER * cipher) {
    return NULL;
}

const char * EVP_CIPHER_get0_description(const EVP_CIPHER * cipher) {
    return NULL;
}

int EVP_CIPHER_is_a(const EVP_CIPHER * cipher, const char * name) {
    return 0;
}

int EVP_CIPHER_names_do_all(const EVP_CIPHER * cipher, void (*fn)(const char *, void *), void * data) {
    return 0;
}

const OSSL_PROVIDER * EVP_CIPHER_get0_provider(const EVP_CIPHER * cipher) {
    return NULL;
}

int EVP_CIPHER_get_block_size(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_impl_ctx_size(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_get_key_length(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_get_iv_length(const EVP_CIPHER * cipher) {
    return 0;
}

unsigned long EVP_CIPHER_get_flags(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_get_mode(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_CIPHER_get_type(const EVP_CIPHER * cipher) {
    return 0;
}

EVP_CIPHER * EVP_CIPHER_fetch(OSSL_LIB_CTX * ctx, const char * algorithm, const char * properties) {
    return NULL;
}

int EVP_CIPHER_can_pipeline(const EVP_CIPHER * cipher, int enc) {
    return 0;
}

int EVP_CIPHER_up_ref(EVP_CIPHER * cipher) {
    return 0;
}

void EVP_CIPHER_free(EVP_CIPHER * cipher) ;


const EVP_CIPHER * EVP_CIPHER_CTX_get0_cipher(const EVP_CIPHER_CTX * ctx) {
    return NULL;
}

EVP_CIPHER * EVP_CIPHER_CTX_get1_cipher(EVP_CIPHER_CTX * ctx) {
    return NULL;
}

int EVP_CIPHER_CTX_is_encrypting(const EVP_CIPHER_CTX * ctx) {
    return 0;
}

int EVP_CIPHER_CTX_get_nid(const EVP_CIPHER_CTX * ctx) {
    return 0;
}

int EVP_CIPHER_CTX_get_block_size(const EVP_CIPHER_CTX * ctx) {
    return 0;
}

int EVP_CIPHER_CTX_get_key_length(const EVP_CIPHER_CTX * ctx) {
    return 0;
}

int EVP_CIPHER_CTX_get_iv_length(const EVP_CIPHER_CTX * ctx) {
    return 0;
}

int EVP_CIPHER_CTX_get_tag_length(const EVP_CIPHER_CTX * ctx) {
    return 0;
}

const EVP_CIPHER * EVP_CIPHER_CTX_cipher(const EVP_CIPHER_CTX * ctx) {
    return NULL;
}

const unsigned char * EVP_CIPHER_CTX_iv(const EVP_CIPHER_CTX * ctx) {
    return NULL;
}

const unsigned char * EVP_CIPHER_CTX_original_iv(const EVP_CIPHER_CTX * ctx) {
    return NULL;
}

unsigned char * EVP_CIPHER_CTX_iv_noconst(EVP_CIPHER_CTX * ctx) {
    return NULL;
}

int EVP_CIPHER_CTX_get_updated_iv(EVP_CIPHER_CTX * ctx, void * buf, size_t len) {
    return 0;
}

int EVP_CIPHER_CTX_get_original_iv(EVP_CIPHER_CTX * ctx, void * buf, size_t len) {
    return 0;
}

unsigned char * EVP_CIPHER_CTX_buf_noconst(EVP_CIPHER_CTX * ctx) {
    return NULL;
}

int EVP_CIPHER_CTX_get_num(const EVP_CIPHER_CTX * ctx) {
    return 0;
}

int EVP_CIPHER_CTX_set_num(EVP_CIPHER_CTX * ctx, int num) {
    return 0;
}

EVP_CIPHER_CTX * EVP_CIPHER_CTX_dup(const EVP_CIPHER_CTX * in) {
    return NULL;
}

int EVP_CIPHER_CTX_copy(EVP_CIPHER_CTX * out, const EVP_CIPHER_CTX * in) {
    return 0;
}

void * EVP_CIPHER_CTX_get_app_data(const EVP_CIPHER_CTX * ctx) {
    return NULL;
}

void EVP_CIPHER_CTX_set_app_data(EVP_CIPHER_CTX * ctx, void * data) ;


void * EVP_CIPHER_CTX_get_cipher_data(const EVP_CIPHER_CTX * ctx) {
    return NULL;
}

void * EVP_CIPHER_CTX_set_cipher_data(EVP_CIPHER_CTX * ctx, void * cipher_data) {
    return NULL;
}

int EVP_Cipher(EVP_CIPHER_CTX * c, unsigned char * out, const unsigned char * in, unsigned int inl) {
    return 0;
}

int EVP_MD_get_params(const EVP_MD * digest, OSSL_PARAM * params) {
    return 0;
}

int EVP_MD_CTX_set_params(EVP_MD_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_MD_CTX_get_params(EVP_MD_CTX * ctx, OSSL_PARAM * params) {
    return 0;
}

const OSSL_PARAM * EVP_MD_gettable_params(const EVP_MD * digest) {
    return NULL;
}

const OSSL_PARAM * EVP_MD_settable_ctx_params(const EVP_MD * md) {
    return NULL;
}

const OSSL_PARAM * EVP_MD_gettable_ctx_params(const EVP_MD * md) {
    return NULL;
}

const OSSL_PARAM * EVP_MD_CTX_settable_params(EVP_MD_CTX * ctx) {
    return NULL;
}

const OSSL_PARAM * EVP_MD_CTX_gettable_params(EVP_MD_CTX * ctx) {
    return NULL;
}

int EVP_MD_CTX_ctrl(EVP_MD_CTX * ctx, int cmd, int p1, void * p2) {
    return 0;
}

EVP_MD_CTX * EVP_MD_CTX_new(void) {
    return NULL;
}

int EVP_MD_CTX_reset(EVP_MD_CTX * ctx) {
    return 0;
}

void EVP_MD_CTX_free(EVP_MD_CTX * ctx) ;


EVP_MD_CTX * EVP_MD_CTX_dup(const EVP_MD_CTX * in) {
    return NULL;
}

int EVP_MD_CTX_copy_ex(EVP_MD_CTX * out, const EVP_MD_CTX * in) {
    return 0;
}

void EVP_MD_CTX_set_flags(EVP_MD_CTX * ctx, int flags) ;


void EVP_MD_CTX_clear_flags(EVP_MD_CTX * ctx, int flags) ;


int EVP_MD_CTX_test_flags(const EVP_MD_CTX * ctx, int flags) {
    return 0;
}

int EVP_DigestInit_ex2(EVP_MD_CTX * ctx, const EVP_MD * type, const OSSL_PARAM * params) {
    return 0;
}

int EVP_DigestInit_ex(EVP_MD_CTX * ctx, const EVP_MD * type, ENGINE * impl) {
    return 0;
}

int EVP_DigestUpdate(EVP_MD_CTX * ctx, const void * d, size_t cnt) {
    return 0;
}

int EVP_DigestFinal_ex(EVP_MD_CTX * ctx, unsigned char * md, unsigned int * s) {
    return 0;
}

int EVP_Digest(const void * data, size_t count, unsigned char * md, unsigned int * size, const EVP_MD * type, ENGINE * impl) {
    return 0;
}

int EVP_Q_digest(OSSL_LIB_CTX * libctx, const char * name, const char * propq, const void * data, size_t datalen, unsigned char * md, size_t * mdlen) {
    return 0;
}

int EVP_MD_CTX_copy(EVP_MD_CTX * out, const EVP_MD_CTX * in) {
    return 0;
}

int EVP_DigestInit(EVP_MD_CTX * ctx, const EVP_MD * type) {
    return 0;
}

int EVP_DigestFinal(EVP_MD_CTX * ctx, unsigned char * md, unsigned int * s) {
    return 0;
}

int EVP_DigestFinalXOF(EVP_MD_CTX * ctx, unsigned char * out, size_t outlen) {
    return 0;
}

int EVP_DigestSqueeze(EVP_MD_CTX * ctx, unsigned char * out, size_t outlen) {
    return 0;
}

EVP_MD * EVP_MD_fetch(OSSL_LIB_CTX * ctx, const char * algorithm, const char * properties) {
    return NULL;
}

int EVP_MD_up_ref(EVP_MD * md) {
    return 0;
}

void EVP_MD_free(EVP_MD * md) ;


int EVP_read_pw_string(char * buf, int length, const char * prompt, int verify) {
    return 0;
}

int EVP_read_pw_string_min(char * buf, int minlen, int maxlen, const char * prompt, int verify) {
    return 0;
}

void EVP_set_pw_prompt(const char * prompt) ;


char * EVP_get_pw_prompt(void) {
    return NULL;
}

int EVP_BytesToKey(const EVP_CIPHER * type, const EVP_MD * md, const unsigned char * salt, const unsigned char * data, int datal, int count, unsigned char * key, unsigned char * iv) {
    return 0;
}

void EVP_CIPHER_CTX_set_flags(EVP_CIPHER_CTX * ctx, int flags) ;


void EVP_CIPHER_CTX_clear_flags(EVP_CIPHER_CTX * ctx, int flags) ;


int EVP_CIPHER_CTX_test_flags(const EVP_CIPHER_CTX * ctx, int flags) {
    return 0;
}

int EVP_EncryptInit(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, const unsigned char * key, const unsigned char * iv) {
    return 0;
}

int EVP_EncryptInit_ex(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, ENGINE * impl, const unsigned char * key, const unsigned char * iv) {
    return 0;
}

int EVP_EncryptInit_ex2(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, const unsigned char * key, const unsigned char * iv, const OSSL_PARAM * params) {
    return 0;
}

int EVP_EncryptUpdate(EVP_CIPHER_CTX * ctx, unsigned char * out, int * outl, const unsigned char * in, int inl) {
    return 0;
}

int EVP_EncryptFinal_ex(EVP_CIPHER_CTX * ctx, unsigned char * out, int * outl) {
    return 0;
}

int EVP_EncryptFinal(EVP_CIPHER_CTX * ctx, unsigned char * out, int * outl) {
    return 0;
}

int EVP_DecryptInit(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, const unsigned char * key, const unsigned char * iv) {
    return 0;
}

int EVP_DecryptInit_ex(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, ENGINE * impl, const unsigned char * key, const unsigned char * iv) {
    return 0;
}

int EVP_DecryptInit_ex2(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, const unsigned char * key, const unsigned char * iv, const OSSL_PARAM * params) {
    return 0;
}

int EVP_DecryptUpdate(EVP_CIPHER_CTX * ctx, unsigned char * out, int * outl, const unsigned char * in, int inl) {
    return 0;
}

int EVP_DecryptFinal(EVP_CIPHER_CTX * ctx, unsigned char * outm, int * outl) {
    return 0;
}

int EVP_DecryptFinal_ex(EVP_CIPHER_CTX * ctx, unsigned char * outm, int * outl) {
    return 0;
}

int EVP_CipherInit(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, const unsigned char * key, const unsigned char * iv, int enc) {
    return 0;
}

int EVP_CipherInit_ex(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, ENGINE * impl, const unsigned char * key, const unsigned char * iv, int enc) {
    return 0;
}

int EVP_CipherInit_SKEY(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, EVP_SKEY * skey, const unsigned char * iv, size_t iv_len, int enc, const OSSL_PARAM * params) {
    return 0;
}

int EVP_CipherInit_ex2(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, const unsigned char * key, const unsigned char * iv, int enc, const OSSL_PARAM * params) {
    return 0;
}

int EVP_CipherUpdate(EVP_CIPHER_CTX * ctx, unsigned char * out, int * outl, const unsigned char * in, int inl) {
    return 0;
}

int EVP_CipherFinal(EVP_CIPHER_CTX * ctx, unsigned char * outm, int * outl) {
    return 0;
}

int EVP_CipherPipelineEncryptInit(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, const unsigned char * key, size_t keylen, size_t numpipes, const unsigned char ** iv, size_t ivlen) {
    return 0;
}

int EVP_CipherPipelineDecryptInit(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * cipher, const unsigned char * key, size_t keylen, size_t numpipes, const unsigned char ** iv, size_t ivlen) {
    return 0;
}

int EVP_CipherPipelineUpdate(EVP_CIPHER_CTX * ctx, unsigned char ** out, size_t * outl, const size_t * outsize, const unsigned char ** in, const size_t * inl) {
    return 0;
}

int EVP_CipherPipelineFinal(EVP_CIPHER_CTX * ctx, unsigned char ** outm, size_t * outl, const size_t * outsize) {
    return 0;
}

int EVP_CipherFinal_ex(EVP_CIPHER_CTX * ctx, unsigned char * outm, int * outl) {
    return 0;
}

int EVP_SignFinal(EVP_MD_CTX * ctx, unsigned char * md, unsigned int * s, EVP_PKEY * pkey) {
    return 0;
}

int EVP_SignFinal_ex(EVP_MD_CTX * ctx, unsigned char * md, unsigned int * s, EVP_PKEY * pkey, OSSL_LIB_CTX * libctx, const char * propq) {
    return 0;
}

int EVP_DigestSign(EVP_MD_CTX * ctx, unsigned char * sigret, size_t * siglen, const unsigned char * tbs, size_t tbslen) {
    return 0;
}

int EVP_VerifyFinal(EVP_MD_CTX * ctx, const unsigned char * sigbuf, unsigned int siglen, EVP_PKEY * pkey) {
    return 0;
}

int EVP_VerifyFinal_ex(EVP_MD_CTX * ctx, const unsigned char * sigbuf, unsigned int siglen, EVP_PKEY * pkey, OSSL_LIB_CTX * libctx, const char * propq) {
    return 0;
}

int EVP_DigestVerify(EVP_MD_CTX * ctx, const unsigned char * sigret, size_t siglen, const unsigned char * tbs, size_t tbslen) {
    return 0;
}

int EVP_DigestSignInit_ex(EVP_MD_CTX * ctx, EVP_PKEY_CTX ** pctx, const char * mdname, OSSL_LIB_CTX * libctx, const char * props, EVP_PKEY * pkey, const OSSL_PARAM * params) {
    return 0;
}

int EVP_DigestSignInit(EVP_MD_CTX * ctx, EVP_PKEY_CTX ** pctx, const EVP_MD * type, ENGINE * e, EVP_PKEY * pkey) {
    return 0;
}

int EVP_DigestSignUpdate(EVP_MD_CTX * ctx, const void * data, size_t dsize) {
    return 0;
}

int EVP_DigestSignFinal(EVP_MD_CTX * ctx, unsigned char * sigret, size_t * siglen) {
    return 0;
}

int EVP_DigestVerifyInit_ex(EVP_MD_CTX * ctx, EVP_PKEY_CTX ** pctx, const char * mdname, OSSL_LIB_CTX * libctx, const char * props, EVP_PKEY * pkey, const OSSL_PARAM * params) {
    return 0;
}

int EVP_DigestVerifyInit(EVP_MD_CTX * ctx, EVP_PKEY_CTX ** pctx, const EVP_MD * type, ENGINE * e, EVP_PKEY * pkey) {
    return 0;
}

int EVP_DigestVerifyUpdate(EVP_MD_CTX * ctx, const void * data, size_t dsize) {
    return 0;
}

int EVP_DigestVerifyFinal(EVP_MD_CTX * ctx, const unsigned char * sig, size_t siglen) {
    return 0;
}

int EVP_OpenInit(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * type, const unsigned char * ek, int ekl, const unsigned char * iv, EVP_PKEY * priv) {
    return 0;
}

int EVP_OpenFinal(EVP_CIPHER_CTX * ctx, unsigned char * out, int * outl) {
    return 0;
}

int EVP_SealInit(EVP_CIPHER_CTX * ctx, const EVP_CIPHER * type, unsigned char ** ek, int * ekl, unsigned char * iv, EVP_PKEY ** pubk, int npubk) {
    return 0;
}

int EVP_SealFinal(EVP_CIPHER_CTX * ctx, unsigned char * out, int * outl) {
    return 0;
}

EVP_ENCODE_CTX * EVP_ENCODE_CTX_new(void) {
    return NULL;
}

void EVP_ENCODE_CTX_free(EVP_ENCODE_CTX * ctx) ;


int EVP_ENCODE_CTX_copy(EVP_ENCODE_CTX * dctx, const EVP_ENCODE_CTX * sctx) {
    return 0;
}

int EVP_ENCODE_CTX_num(EVP_ENCODE_CTX * ctx) {
    return 0;
}

void EVP_EncodeInit(EVP_ENCODE_CTX * ctx) ;


int EVP_EncodeUpdate(EVP_ENCODE_CTX * ctx, unsigned char * out, int * outl, const unsigned char * in, int inl) {
    return 0;
}

void EVP_EncodeFinal(EVP_ENCODE_CTX * ctx, unsigned char * out, int * outl) ;


int EVP_EncodeBlock(unsigned char * t, const unsigned char * f, int n) {
    return 0;
}

void EVP_DecodeInit(EVP_ENCODE_CTX * ctx) ;


int EVP_DecodeUpdate(EVP_ENCODE_CTX * ctx, unsigned char * out, int * outl, const unsigned char * in, int inl) {
    return 0;
}

int EVP_DecodeFinal(EVP_ENCODE_CTX * ctx, unsigned char * out, int * outl) {
    return 0;
}

int EVP_DecodeBlock(unsigned char * t, const unsigned char * f, int n) {
    return 0;
}

EVP_CIPHER_CTX * EVP_CIPHER_CTX_new(void) {
    return NULL;
}

int EVP_CIPHER_CTX_reset(EVP_CIPHER_CTX * c) {
    return 0;
}

void EVP_CIPHER_CTX_free(EVP_CIPHER_CTX * c) ;


int EVP_CIPHER_CTX_set_key_length(EVP_CIPHER_CTX * x, int keylen) {
    return 0;
}

int EVP_CIPHER_CTX_set_padding(EVP_CIPHER_CTX * c, int pad) {
    return 0;
}

int EVP_CIPHER_CTX_ctrl(EVP_CIPHER_CTX * ctx, int type, int arg, void * ptr) {
    return 0;
}

int EVP_CIPHER_CTX_rand_key(EVP_CIPHER_CTX * ctx, unsigned char * key) {
    return 0;
}

int EVP_CIPHER_get_params(EVP_CIPHER * cipher, OSSL_PARAM * params) {
    return 0;
}

int EVP_CIPHER_CTX_set_params(EVP_CIPHER_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_CIPHER_CTX_get_params(EVP_CIPHER_CTX * ctx, OSSL_PARAM * params) {
    return 0;
}

const OSSL_PARAM * EVP_CIPHER_gettable_params(const EVP_CIPHER * cipher) {
    return NULL;
}

const OSSL_PARAM * EVP_CIPHER_settable_ctx_params(const EVP_CIPHER * cipher) {
    return NULL;
}

const OSSL_PARAM * EVP_CIPHER_gettable_ctx_params(const EVP_CIPHER * cipher) {
    return NULL;
}

const OSSL_PARAM * EVP_CIPHER_CTX_settable_params(EVP_CIPHER_CTX * ctx) {
    return NULL;
}

const OSSL_PARAM * EVP_CIPHER_CTX_gettable_params(EVP_CIPHER_CTX * ctx) {
    return NULL;
}

int EVP_CIPHER_CTX_set_algor_params(EVP_CIPHER_CTX * ctx, const X509_ALGOR * alg) {
    return 0;
}

int EVP_CIPHER_CTX_get_algor_params(EVP_CIPHER_CTX * ctx, X509_ALGOR * alg) {
    return 0;
}

int EVP_CIPHER_CTX_get_algor(EVP_CIPHER_CTX * ctx, X509_ALGOR ** alg) {
    return 0;
}

const int * BIO_f_md(void) {
    return NULL;
}

const int * BIO_f_base64(void) {
    return NULL;
}

const int * BIO_f_cipher(void) {
    return NULL;
}

const int * BIO_f_reliable(void) {
    return NULL;
}

int BIO_set_cipher(BIO * b, const EVP_CIPHER * c, const unsigned char * k, const unsigned char * i, int enc) {
    return 0;
}

const EVP_MD * EVP_md_null(void) {
    return NULL;
}

const EVP_MD * EVP_md2(void) {
    return NULL;
}

const EVP_MD * EVP_md4(void) {
    return NULL;
}

const EVP_MD * EVP_md5(void) {
    return NULL;
}

const EVP_MD * EVP_md5_sha1(void) {
    return NULL;
}

const EVP_MD * EVP_blake2b512(void) {
    return NULL;
}

const EVP_MD * EVP_blake2s256(void) {
    return NULL;
}

const EVP_MD * EVP_sha1(void) {
    return NULL;
}

const EVP_MD * EVP_sha224(void) {
    return NULL;
}

const EVP_MD * EVP_sha256(void) {
    return NULL;
}

const EVP_MD * EVP_sha384(void) {
    return NULL;
}

const EVP_MD * EVP_sha512(void) {
    return NULL;
}

const EVP_MD * EVP_sha512_224(void) {
    return NULL;
}

const EVP_MD * EVP_sha512_256(void) {
    return NULL;
}

const EVP_MD * EVP_sha3_224(void) {
    return NULL;
}

const EVP_MD * EVP_sha3_256(void) {
    return NULL;
}

const EVP_MD * EVP_sha3_384(void) {
    return NULL;
}

const EVP_MD * EVP_sha3_512(void) {
    return NULL;
}

const EVP_MD * EVP_shake128(void) {
    return NULL;
}

const EVP_MD * EVP_shake256(void) {
    return NULL;
}

const EVP_MD * EVP_mdc2(void) {
    return NULL;
}

const EVP_MD * EVP_ripemd160(void) {
    return NULL;
}

const EVP_MD * EVP_whirlpool(void) {
    return NULL;
}

const EVP_MD * EVP_sm3(void) {
    return NULL;
}

const EVP_CIPHER * EVP_enc_null(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede3(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede3_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_cfb64(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede_cfb64(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede3_cfb64(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede3_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede3_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede3_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede3_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_desx_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_des_ede3_wrap(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc4(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc4_40(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc4_hmac_md5(void) {
    return NULL;
}

const EVP_CIPHER * EVP_idea_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_idea_cfb64(void) {
    return NULL;
}

const EVP_CIPHER * EVP_idea_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_idea_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc2_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc2_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc2_40_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc2_64_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc2_cfb64(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc2_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_bf_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_bf_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_bf_cfb64(void) {
    return NULL;
}

const EVP_CIPHER * EVP_bf_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_cast5_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_cast5_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_cast5_cfb64(void) {
    return NULL;
}

const EVP_CIPHER * EVP_cast5_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc5_32_12_16_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc5_32_12_16_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc5_32_12_16_cfb64(void) {
    return NULL;
}

const EVP_CIPHER * EVP_rc5_32_12_16_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_ctr(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_ccm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_gcm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_xts(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_wrap(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_wrap_pad(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_ocb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_ctr(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_ccm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_gcm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_wrap(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_wrap_pad(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_192_ocb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_ctr(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_ccm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_gcm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_xts(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_wrap(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_wrap_pad(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_ocb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_cbc_hmac_sha1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_cbc_hmac_sha1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_128_cbc_hmac_sha256(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aes_256_cbc_hmac_sha256(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_128_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_128_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_128_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_128_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_128_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_128_ctr(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_128_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_128_gcm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_128_ccm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_192_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_192_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_192_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_192_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_192_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_192_ctr(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_192_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_192_gcm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_192_ccm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_256_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_256_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_256_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_256_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_256_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_256_ctr(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_256_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_256_gcm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_aria_256_ccm(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_128_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_128_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_128_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_128_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_128_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_128_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_128_ctr(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_192_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_192_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_192_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_192_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_192_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_192_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_192_ctr(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_256_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_256_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_256_cfb1(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_256_cfb8(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_256_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_256_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_camellia_256_ctr(void) {
    return NULL;
}

const EVP_CIPHER * EVP_chacha20(void) {
    return NULL;
}

const EVP_CIPHER * EVP_chacha20_poly1305(void) {
    return NULL;
}

const EVP_CIPHER * EVP_seed_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_seed_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_seed_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_seed_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_sm4_ecb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_sm4_cbc(void) {
    return NULL;
}

const EVP_CIPHER * EVP_sm4_cfb128(void) {
    return NULL;
}

const EVP_CIPHER * EVP_sm4_ofb(void) {
    return NULL;
}

const EVP_CIPHER * EVP_sm4_ctr(void) {
    return NULL;
}

int EVP_add_cipher(const EVP_CIPHER * cipher) {
    return 0;
}

int EVP_add_digest(const EVP_MD * digest) {
    return 0;
}

const EVP_CIPHER * EVP_get_cipherbyname(const char * name) {
    return NULL;
}

const EVP_MD * EVP_get_digestbyname(const char * name) {
    return NULL;
}

void EVP_CIPHER_do_all(void (*fn)(const EVP_CIPHER *, const char *, const char *, void *), void * arg) ;


void EVP_CIPHER_do_all_sorted(void (*fn)(const EVP_CIPHER *, const char *, const char *, void *), void * arg) ;


void EVP_CIPHER_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_CIPHER *, void *), void * arg) ;


void EVP_MD_do_all(void (*fn)(const EVP_MD *, const char *, const char *, void *), void * arg) ;


void EVP_MD_do_all_sorted(void (*fn)(const EVP_MD *, const char *, const char *, void *), void * arg) ;


void EVP_MD_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_MD *, void *), void * arg) ;


EVP_MAC * EVP_MAC_fetch(OSSL_LIB_CTX * libctx, const char * algorithm, const char * properties) {
    return NULL;
}

int EVP_MAC_up_ref(EVP_MAC * mac) {
    return 0;
}

void EVP_MAC_free(EVP_MAC * mac) ;


const char * EVP_MAC_get0_name(const EVP_MAC * mac) {
    return NULL;
}

const char * EVP_MAC_get0_description(const EVP_MAC * mac) {
    return NULL;
}

int EVP_MAC_is_a(const EVP_MAC * mac, const char * name) {
    return 0;
}

const OSSL_PROVIDER * EVP_MAC_get0_provider(const EVP_MAC * mac) {
    return NULL;
}

int EVP_MAC_get_params(EVP_MAC * mac, OSSL_PARAM * params) {
    return 0;
}

EVP_MAC_CTX * EVP_MAC_CTX_new(EVP_MAC * mac) {
    return NULL;
}

void EVP_MAC_CTX_free(EVP_MAC_CTX * ctx) ;


EVP_MAC_CTX * EVP_MAC_CTX_dup(const EVP_MAC_CTX * src) {
    return NULL;
}

EVP_MAC * EVP_MAC_CTX_get0_mac(EVP_MAC_CTX * ctx) {
    return NULL;
}

int EVP_MAC_CTX_get_params(EVP_MAC_CTX * ctx, OSSL_PARAM * params) {
    return 0;
}

int EVP_MAC_CTX_set_params(EVP_MAC_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

size_t EVP_MAC_CTX_get_mac_size(EVP_MAC_CTX * ctx) {
    return 0;
}

size_t EVP_MAC_CTX_get_block_size(EVP_MAC_CTX * ctx) {
    return 0;
}

unsigned char * EVP_Q_mac(OSSL_LIB_CTX * libctx, const char * name, const char * propq, const char * subalg, const OSSL_PARAM * params, const void * key, size_t keylen, const unsigned char * data, size_t datalen, unsigned char * out, size_t outsize, size_t * outlen) {
    return NULL;
}

int EVP_MAC_init(EVP_MAC_CTX * ctx, const unsigned char * key, size_t keylen, const OSSL_PARAM * params) {
    return 0;
}

int EVP_MAC_init_SKEY(EVP_MAC_CTX * ctx, EVP_SKEY * skey, const OSSL_PARAM * params) {
    return 0;
}

int EVP_MAC_update(EVP_MAC_CTX * ctx, const unsigned char * data, size_t datalen) {
    return 0;
}

int EVP_MAC_final(EVP_MAC_CTX * ctx, unsigned char * out, size_t * outl, size_t outsize) {
    return 0;
}

int EVP_MAC_finalXOF(EVP_MAC_CTX * ctx, unsigned char * out, size_t outsize) {
    return 0;
}

const OSSL_PARAM * EVP_MAC_gettable_params(const EVP_MAC * mac) {
    return NULL;
}

const OSSL_PARAM * EVP_MAC_gettable_ctx_params(const EVP_MAC * mac) {
    return NULL;
}

const OSSL_PARAM * EVP_MAC_settable_ctx_params(const EVP_MAC * mac) {
    return NULL;
}

const OSSL_PARAM * EVP_MAC_CTX_gettable_params(EVP_MAC_CTX * ctx) {
    return NULL;
}

const OSSL_PARAM * EVP_MAC_CTX_settable_params(EVP_MAC_CTX * ctx) {
    return NULL;
}

void EVP_MAC_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_MAC *, void *), void * arg) ;


int EVP_MAC_names_do_all(const EVP_MAC * mac, void (*fn)(const char *, void *), void * data) {
    return 0;
}

EVP_RAND * EVP_RAND_fetch(OSSL_LIB_CTX * libctx, const char * algorithm, const char * properties) {
    return NULL;
}

int EVP_RAND_up_ref(EVP_RAND * rand) {
    return 0;
}

void EVP_RAND_free(EVP_RAND * rand) ;


const char * EVP_RAND_get0_name(const EVP_RAND * rand) {
    return NULL;
}

const char * EVP_RAND_get0_description(const EVP_RAND * md) {
    return NULL;
}

int EVP_RAND_is_a(const EVP_RAND * rand, const char * name) {
    return 0;
}

const OSSL_PROVIDER * EVP_RAND_get0_provider(const EVP_RAND * rand) {
    return NULL;
}

int EVP_RAND_get_params(EVP_RAND * rand, OSSL_PARAM * params) {
    return 0;
}

EVP_RAND_CTX * EVP_RAND_CTX_new(EVP_RAND * rand, EVP_RAND_CTX * parent) {
    return NULL;
}

int EVP_RAND_CTX_up_ref(EVP_RAND_CTX * ctx) {
    return 0;
}

void EVP_RAND_CTX_free(EVP_RAND_CTX * ctx) ;


EVP_RAND * EVP_RAND_CTX_get0_rand(EVP_RAND_CTX * ctx) {
    return NULL;
}

int EVP_RAND_CTX_get_params(EVP_RAND_CTX * ctx, OSSL_PARAM * params) {
    return 0;
}

int EVP_RAND_CTX_set_params(EVP_RAND_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

const OSSL_PARAM * EVP_RAND_gettable_params(const EVP_RAND * rand) {
    return NULL;
}

const OSSL_PARAM * EVP_RAND_gettable_ctx_params(const EVP_RAND * rand) {
    return NULL;
}

const OSSL_PARAM * EVP_RAND_settable_ctx_params(const EVP_RAND * rand) {
    return NULL;
}

const OSSL_PARAM * EVP_RAND_CTX_gettable_params(EVP_RAND_CTX * ctx) {
    return NULL;
}

const OSSL_PARAM * EVP_RAND_CTX_settable_params(EVP_RAND_CTX * ctx) {
    return NULL;
}

void EVP_RAND_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_RAND *, void *), void * arg) ;


int EVP_RAND_names_do_all(const EVP_RAND * rand, void (*fn)(const char *, void *), void * data) {
    return 0;
}

int EVP_RAND_instantiate(EVP_RAND_CTX * ctx, unsigned int strength, int prediction_resistance, const unsigned char * pstr, size_t pstr_len, const OSSL_PARAM * params) {
    return 0;
}

int EVP_RAND_uninstantiate(EVP_RAND_CTX * ctx) {
    return 0;
}

int EVP_RAND_generate(EVP_RAND_CTX * ctx, unsigned char * out, size_t outlen, unsigned int strength, int prediction_resistance, const unsigned char * addin, size_t addin_len) {
    return 0;
}

int EVP_RAND_reseed(EVP_RAND_CTX * ctx, int prediction_resistance, const unsigned char * ent, size_t ent_len, const unsigned char * addin, size_t addin_len) {
    return 0;
}

int EVP_RAND_nonce(EVP_RAND_CTX * ctx, unsigned char * out, size_t outlen) {
    return 0;
}

int EVP_RAND_enable_locking(EVP_RAND_CTX * ctx) {
    return 0;
}

int EVP_RAND_verify_zeroization(EVP_RAND_CTX * ctx) {
    return 0;
}

unsigned int EVP_RAND_get_strength(EVP_RAND_CTX * ctx) {
    return 0;
}

int EVP_RAND_get_state(EVP_RAND_CTX * ctx) {
    return 0;
}

int EVP_PKEY_decrypt_old(unsigned char * dec_key, const unsigned char * enc_key, int enc_key_len, EVP_PKEY * private_key) {
    return 0;
}

int EVP_PKEY_encrypt_old(unsigned char * enc_key, const unsigned char * key, int key_len, EVP_PKEY * pub_key) {
    return 0;
}

int EVP_PKEY_is_a(const EVP_PKEY * pkey, const char * name) {
    return 0;
}

int EVP_PKEY_type_names_do_all(const EVP_PKEY * pkey, void (*fn)(const char *, void *), void * data) {
    return 0;
}

int EVP_PKEY_type(int type) {
    return 0;
}

int EVP_PKEY_get_id(const EVP_PKEY * pkey) {
    return 0;
}

int EVP_PKEY_get_base_id(const EVP_PKEY * pkey) {
    return 0;
}

int EVP_PKEY_get_bits(const EVP_PKEY * pkey) {
    return 0;
}

int EVP_PKEY_get_security_bits(const EVP_PKEY * pkey) {
    return 0;
}

int EVP_PKEY_get_size(const EVP_PKEY * pkey) {
    return 0;
}

int EVP_PKEY_can_sign(const EVP_PKEY * pkey) {
    return 0;
}

int EVP_PKEY_set_type(EVP_PKEY * pkey, int type) {
    return 0;
}

int EVP_PKEY_set_type_str(EVP_PKEY * pkey, const char * str, int len) {
    return 0;
}

int EVP_PKEY_set_type_by_keymgmt(EVP_PKEY * pkey, EVP_KEYMGMT * keymgmt) {
    return 0;
}

int EVP_PKEY_set1_engine(EVP_PKEY * pkey, ENGINE * e) {
    return 0;
}

ENGINE * EVP_PKEY_get0_engine(const EVP_PKEY * pkey) {
    return NULL;
}

int EVP_PKEY_assign(EVP_PKEY * pkey, int type, void * key) {
    return 0;
}

void * EVP_PKEY_get0(const EVP_PKEY * pkey) {
    return NULL;
}

const unsigned char * EVP_PKEY_get0_hmac(const EVP_PKEY * pkey, size_t * len) {
    return NULL;
}

const unsigned char * EVP_PKEY_get0_poly1305(const EVP_PKEY * pkey, size_t * len) {
    return NULL;
}

const unsigned char * EVP_PKEY_get0_siphash(const EVP_PKEY * pkey, size_t * len) {
    return NULL;
}

int EVP_PKEY_set1_RSA(EVP_PKEY * pkey, struct rsa_st * key) {
    return 0;
}

const struct rsa_st * EVP_PKEY_get0_RSA(const EVP_PKEY * pkey) {
    return NULL;
}

struct rsa_st * EVP_PKEY_get1_RSA(EVP_PKEY * pkey) {
    return NULL;
}

int EVP_PKEY_set1_DSA(EVP_PKEY * pkey, struct dsa_st * key) {
    return 0;
}

const struct dsa_st * EVP_PKEY_get0_DSA(const EVP_PKEY * pkey) {
    return NULL;
}

struct dsa_st * EVP_PKEY_get1_DSA(EVP_PKEY * pkey) {
    return NULL;
}

int EVP_PKEY_set1_DH(EVP_PKEY * pkey, struct dh_st * key) {
    return 0;
}

const struct dh_st * EVP_PKEY_get0_DH(const EVP_PKEY * pkey) {
    return NULL;
}

struct dh_st * EVP_PKEY_get1_DH(EVP_PKEY * pkey) {
    return NULL;
}

int EVP_PKEY_set1_EC_KEY(EVP_PKEY * pkey, struct ec_key_st * key) {
    return 0;
}

const struct ec_key_st * EVP_PKEY_get0_EC_KEY(const EVP_PKEY * pkey) {
    return NULL;
}

struct ec_key_st * EVP_PKEY_get1_EC_KEY(EVP_PKEY * pkey) {
    return NULL;
}

EVP_PKEY * EVP_PKEY_new(void) {
    return NULL;
}

int EVP_PKEY_up_ref(EVP_PKEY * pkey) {
    return 0;
}

EVP_PKEY * EVP_PKEY_dup(EVP_PKEY * pkey) {
    return NULL;
}

void EVP_PKEY_free(EVP_PKEY * pkey) ;


const char * EVP_PKEY_get0_description(const EVP_PKEY * pkey) {
    return NULL;
}

const OSSL_PROVIDER * EVP_PKEY_get0_provider(const EVP_PKEY * key) {
    return NULL;
}

EVP_PKEY * d2i_PublicKey(int type, EVP_PKEY ** a, const unsigned char ** pp, long length) {
    return NULL;
}

int i2d_PublicKey(const EVP_PKEY * a, unsigned char ** pp) {
    return 0;
}

EVP_PKEY * d2i_PrivateKey_ex(int type, EVP_PKEY ** a, const unsigned char ** pp, long length, OSSL_LIB_CTX * libctx, const char * propq) {
    return NULL;
}

EVP_PKEY * d2i_PrivateKey(int type, EVP_PKEY ** a, const unsigned char ** pp, long length) {
    return NULL;
}

EVP_PKEY * d2i_AutoPrivateKey_ex(EVP_PKEY ** a, const unsigned char ** pp, long length, OSSL_LIB_CTX * libctx, const char * propq) {
    return NULL;
}

EVP_PKEY * d2i_AutoPrivateKey(EVP_PKEY ** a, const unsigned char ** pp, long length) {
    return NULL;
}

int i2d_PrivateKey(const EVP_PKEY * a, unsigned char ** pp) {
    return 0;
}

int i2d_PKCS8PrivateKey(const EVP_PKEY * a, unsigned char ** pp) {
    return 0;
}

int i2d_KeyParams(const EVP_PKEY * a, unsigned char ** pp) {
    return 0;
}

EVP_PKEY * d2i_KeyParams(int type, EVP_PKEY ** a, const unsigned char ** pp, long length) {
    return NULL;
}

int i2d_KeyParams_bio(BIO * bp, const EVP_PKEY * pkey) {
    return 0;
}

EVP_PKEY * d2i_KeyParams_bio(int type, EVP_PKEY ** a, BIO * in) {
    return NULL;
}

int EVP_PKEY_copy_parameters(EVP_PKEY * to, const EVP_PKEY * from) {
    return 0;
}

int EVP_PKEY_missing_parameters(const EVP_PKEY * pkey) {
    return 0;
}

int EVP_PKEY_save_parameters(EVP_PKEY * pkey, int mode) {
    return 0;
}

int EVP_PKEY_parameters_eq(const EVP_PKEY * a, const EVP_PKEY * b) {
    return 0;
}

int EVP_PKEY_eq(const EVP_PKEY * a, const EVP_PKEY * b) {
    return 0;
}

int EVP_PKEY_cmp_parameters(const EVP_PKEY * a, const EVP_PKEY * b) {
    return 0;
}

int EVP_PKEY_cmp(const EVP_PKEY * a, const EVP_PKEY * b) {
    return 0;
}

int EVP_PKEY_print_public(BIO * out, const EVP_PKEY * pkey, int indent, ASN1_PCTX * pctx) {
    return 0;
}

int EVP_PKEY_print_private(BIO * out, const EVP_PKEY * pkey, int indent, ASN1_PCTX * pctx) {
    return 0;
}

int EVP_PKEY_print_params(BIO * out, const EVP_PKEY * pkey, int indent, ASN1_PCTX * pctx) {
    return 0;
}

int EVP_PKEY_print_public_fp(FILE * fp, const EVP_PKEY * pkey, int indent, ASN1_PCTX * pctx) {
    return 0;
}

int EVP_PKEY_print_private_fp(FILE * fp, const EVP_PKEY * pkey, int indent, ASN1_PCTX * pctx) {
    return 0;
}

int EVP_PKEY_print_params_fp(FILE * fp, const EVP_PKEY * pkey, int indent, ASN1_PCTX * pctx) {
    return 0;
}

int EVP_PKEY_get_default_digest_nid(EVP_PKEY * pkey, int * pnid) {
    return 0;
}

int EVP_PKEY_get_default_digest_name(EVP_PKEY * pkey, char * mdname, size_t mdname_sz) {
    return 0;
}

int EVP_PKEY_digestsign_supports_digest(EVP_PKEY * pkey, OSSL_LIB_CTX * libctx, const char * name, const char * propq) {
    return 0;
}

int EVP_PKEY_set1_encoded_public_key(EVP_PKEY * pkey, const unsigned char * pub, size_t publen) {
    return 0;
}

size_t EVP_PKEY_get1_encoded_public_key(EVP_PKEY * pkey, unsigned char ** ppub) {
    return 0;
}

int EVP_CIPHER_param_to_asn1(EVP_CIPHER_CTX * c, ASN1_TYPE * type) {
    return 0;
}

int EVP_CIPHER_asn1_to_param(EVP_CIPHER_CTX * c, ASN1_TYPE * type) {
    return 0;
}

int EVP_CIPHER_set_asn1_iv(EVP_CIPHER_CTX * c, ASN1_TYPE * type) {
    return 0;
}

int EVP_CIPHER_get_asn1_iv(EVP_CIPHER_CTX * c, ASN1_TYPE * type) {
    return 0;
}

int PKCS5_PBE_keyivgen(EVP_CIPHER_CTX * ctx, const char * pass, int passlen, ASN1_TYPE * param, const EVP_CIPHER * cipher, const EVP_MD * md, int en_de) {
    return 0;
}

int PKCS5_PBE_keyivgen_ex(EVP_CIPHER_CTX * cctx, const char * pass, int passlen, ASN1_TYPE * param, const EVP_CIPHER * cipher, const EVP_MD * md, int en_de, OSSL_LIB_CTX * libctx, const char * propq) {
    return 0;
}

int PKCS5_PBKDF2_HMAC_SHA1(const char * pass, int passlen, const unsigned char * salt, int saltlen, int iter, int keylen, unsigned char * out) {
    return 0;
}

int PKCS5_PBKDF2_HMAC(const char * pass, int passlen, const unsigned char * salt, int saltlen, int iter, const EVP_MD * digest, int keylen, unsigned char * out) {
    return 0;
}

int PKCS5_v2_PBE_keyivgen(EVP_CIPHER_CTX * ctx, const char * pass, int passlen, ASN1_TYPE * param, const EVP_CIPHER * cipher, const EVP_MD * md, int en_de) {
    return 0;
}

int PKCS5_v2_PBE_keyivgen_ex(EVP_CIPHER_CTX * ctx, const char * pass, int passlen, ASN1_TYPE * param, const EVP_CIPHER * cipher, const EVP_MD * md, int en_de, OSSL_LIB_CTX * libctx, const char * propq) {
    return 0;
}

int EVP_PBE_scrypt(const char * pass, size_t passlen, const unsigned char * salt, size_t saltlen, uint64_t N, uint64_t r, uint64_t p, uint64_t maxmem, unsigned char * key, size_t keylen) {
    return 0;
}

int EVP_PBE_scrypt_ex(const char * pass, size_t passlen, const unsigned char * salt, size_t saltlen, uint64_t N, uint64_t r, uint64_t p, uint64_t maxmem, unsigned char * key, size_t keylen, OSSL_LIB_CTX * ctx, const char * propq) {
    return 0;
}

int PKCS5_v2_scrypt_keyivgen(EVP_CIPHER_CTX * ctx, const char * pass, int passlen, ASN1_TYPE * param, const EVP_CIPHER * c, const EVP_MD * md, int en_de) {
    return 0;
}

int PKCS5_v2_scrypt_keyivgen_ex(EVP_CIPHER_CTX * ctx, const char * pass, int passlen, ASN1_TYPE * param, const EVP_CIPHER * c, const EVP_MD * md, int en_de, OSSL_LIB_CTX * libctx, const char * propq) {
    return 0;
}

void PKCS5_PBE_add(void) ;


int EVP_PBE_CipherInit(ASN1_OBJECT * pbe_obj, const char * pass, int passlen, ASN1_TYPE * param, EVP_CIPHER_CTX * ctx, int en_de) {
    return 0;
}

int EVP_PBE_CipherInit_ex(ASN1_OBJECT * pbe_obj, const char * pass, int passlen, ASN1_TYPE * param, EVP_CIPHER_CTX * ctx, int en_de, OSSL_LIB_CTX * libctx, const char * propq) {
    return 0;
}

int EVP_PBE_alg_add_type(int pbe_type, int pbe_nid, int cipher_nid, int md_nid, EVP_PBE_KEYGEN * keygen) {
    return 0;
}

int EVP_PBE_alg_add(int nid, const EVP_CIPHER * cipher, const EVP_MD * md, EVP_PBE_KEYGEN * keygen) {
    return 0;
}

int EVP_PBE_find(int type, int pbe_nid, int * pcnid, int * pmnid, EVP_PBE_KEYGEN ** pkeygen) {
    return 0;
}

int EVP_PBE_find_ex(int type, int pbe_nid, int * pcnid, int * pmnid, EVP_PBE_KEYGEN ** pkeygen, EVP_PBE_KEYGEN_EX ** pkeygen_ex) {
    return 0;
}

void EVP_PBE_cleanup(void) ;


int EVP_PBE_get(int * ptype, int * ppbe_nid, size_t num) {
    return 0;
}

int EVP_PKEY_asn1_get_count(void) {
    return 0;
}

const EVP_PKEY_ASN1_METHOD * EVP_PKEY_asn1_get0(int idx) {
    return NULL;
}

const EVP_PKEY_ASN1_METHOD * EVP_PKEY_asn1_find(ENGINE ** pe, int type) {
    return NULL;
}

const EVP_PKEY_ASN1_METHOD * EVP_PKEY_asn1_find_str(ENGINE ** pe, const char * str, int len) {
    return NULL;
}

int EVP_PKEY_asn1_add0(const EVP_PKEY_ASN1_METHOD * ameth) {
    return 0;
}

int EVP_PKEY_asn1_add_alias(int to, int from) {
    return 0;
}

int EVP_PKEY_asn1_get0_info(int * ppkey_id, int * pkey_base_id, int * ppkey_flags, const char ** pinfo, const char ** ppem_str, const EVP_PKEY_ASN1_METHOD * ameth) {
    return 0;
}

const EVP_PKEY_ASN1_METHOD * EVP_PKEY_get0_asn1(const EVP_PKEY * pkey) {
    return NULL;
}

EVP_PKEY_ASN1_METHOD * EVP_PKEY_asn1_new(int id, int flags, const char * pem_str, const char * info) {
    return NULL;
}

void EVP_PKEY_asn1_copy(EVP_PKEY_ASN1_METHOD * dst, const EVP_PKEY_ASN1_METHOD * src) ;


void EVP_PKEY_asn1_free(EVP_PKEY_ASN1_METHOD * ameth) ;


void EVP_PKEY_asn1_set_public(EVP_PKEY_ASN1_METHOD * ameth, int (*pub_decode)(EVP_PKEY *, const X509_PUBKEY *), int (*pub_encode)(X509_PUBKEY *, const EVP_PKEY *), int (*pub_cmp)(const EVP_PKEY *, const EVP_PKEY *), int (*pub_print)(BIO *, const EVP_PKEY *, int, ASN1_PCTX *), int (*pkey_size)(const EVP_PKEY *), int (*pkey_bits)(const EVP_PKEY *)) ;


void EVP_PKEY_asn1_set_private(EVP_PKEY_ASN1_METHOD * ameth, int (*priv_decode)(EVP_PKEY *, const PKCS8_PRIV_KEY_INFO *), int (*priv_encode)(PKCS8_PRIV_KEY_INFO *, const EVP_PKEY *), int (*priv_print)(BIO *, const EVP_PKEY *, int, ASN1_PCTX *)) ;


void EVP_PKEY_asn1_set_param(EVP_PKEY_ASN1_METHOD * ameth, int (*param_decode)(EVP_PKEY *, const unsigned char **, int), int (*param_encode)(const EVP_PKEY *, unsigned char **), int (*param_missing)(const EVP_PKEY *), int (*param_copy)(EVP_PKEY *, const EVP_PKEY *), int (*param_cmp)(const EVP_PKEY *, const EVP_PKEY *), int (*param_print)(BIO *, const EVP_PKEY *, int, ASN1_PCTX *)) ;


void EVP_PKEY_asn1_set_free(EVP_PKEY_ASN1_METHOD * ameth, void (*pkey_free)(EVP_PKEY *)) ;


void EVP_PKEY_asn1_set_ctrl(EVP_PKEY_ASN1_METHOD * ameth, int (*pkey_ctrl)(EVP_PKEY *, int, long, void *)) ;


void EVP_PKEY_asn1_set_item(EVP_PKEY_ASN1_METHOD * ameth, int (*item_verify)(EVP_MD_CTX *, const ASN1_ITEM *, const void *, const X509_ALGOR *, const ASN1_BIT_STRING *, EVP_PKEY *), int (*item_sign)(EVP_MD_CTX *, const ASN1_ITEM *, const void *, X509_ALGOR *, X509_ALGOR *, ASN1_BIT_STRING *)) ;


void EVP_PKEY_asn1_set_siginf(EVP_PKEY_ASN1_METHOD * ameth, int (*siginf_set)(X509_SIG_INFO *, const X509_ALGOR *, const ASN1_STRING *)) ;


void EVP_PKEY_asn1_set_check(EVP_PKEY_ASN1_METHOD * ameth, int (*pkey_check)(const EVP_PKEY *)) ;


void EVP_PKEY_asn1_set_public_check(EVP_PKEY_ASN1_METHOD * ameth, int (*pkey_pub_check)(const EVP_PKEY *)) ;


void EVP_PKEY_asn1_set_param_check(EVP_PKEY_ASN1_METHOD * ameth, int (*pkey_param_check)(const EVP_PKEY *)) ;


void EVP_PKEY_asn1_set_set_priv_key(EVP_PKEY_ASN1_METHOD * ameth, int (*set_priv_key)(EVP_PKEY *, const unsigned char *, size_t)) ;


void EVP_PKEY_asn1_set_set_pub_key(EVP_PKEY_ASN1_METHOD * ameth, int (*set_pub_key)(EVP_PKEY *, const unsigned char *, size_t)) ;


void EVP_PKEY_asn1_set_get_priv_key(EVP_PKEY_ASN1_METHOD * ameth, int (*get_priv_key)(const EVP_PKEY *, unsigned char *, size_t *)) ;


void EVP_PKEY_asn1_set_get_pub_key(EVP_PKEY_ASN1_METHOD * ameth, int (*get_pub_key)(const EVP_PKEY *, unsigned char *, size_t *)) ;


void EVP_PKEY_asn1_set_security_bits(EVP_PKEY_ASN1_METHOD * ameth, int (*pkey_security_bits)(const EVP_PKEY *)) ;


int EVP_PKEY_CTX_get_signature_md(EVP_PKEY_CTX * ctx, const EVP_MD ** md) {
    return 0;
}

int EVP_PKEY_CTX_set_signature_md(EVP_PKEY_CTX * ctx, const EVP_MD * md) {
    return 0;
}

int EVP_PKEY_CTX_set1_id(EVP_PKEY_CTX * ctx, const void * id, int len) {
    return 0;
}

int EVP_PKEY_CTX_get1_id(EVP_PKEY_CTX * ctx, void * id) {
    return 0;
}

int EVP_PKEY_CTX_get1_id_len(EVP_PKEY_CTX * ctx, size_t * id_len) {
    return 0;
}

int EVP_PKEY_CTX_set_kem_op(EVP_PKEY_CTX * ctx, const char * op) {
    return 0;
}

const char * EVP_PKEY_get0_type_name(const EVP_PKEY * key) {
    return NULL;
}

int EVP_PKEY_CTX_set_mac_key(EVP_PKEY_CTX * ctx, const unsigned char * key, int keylen) {
    return 0;
}

const EVP_PKEY_METHOD * EVP_PKEY_meth_find(int type) {
    return NULL;
}

EVP_PKEY_METHOD * EVP_PKEY_meth_new(int id, int flags) {
    return NULL;
}

void EVP_PKEY_meth_get0_info(int * ppkey_id, int * pflags, const EVP_PKEY_METHOD * meth) ;


void EVP_PKEY_meth_copy(EVP_PKEY_METHOD * dst, const EVP_PKEY_METHOD * src) ;


void EVP_PKEY_meth_free(EVP_PKEY_METHOD * pmeth) ;


int EVP_PKEY_meth_add0(const EVP_PKEY_METHOD * pmeth) {
    return 0;
}

int EVP_PKEY_meth_remove(const EVP_PKEY_METHOD * pmeth) {
    return 0;
}

size_t EVP_PKEY_meth_get_count(void) {
    return 0;
}

const EVP_PKEY_METHOD * EVP_PKEY_meth_get0(size_t idx) {
    return NULL;
}

EVP_KEYMGMT * EVP_KEYMGMT_fetch(OSSL_LIB_CTX * ctx, const char * algorithm, const char * properties) {
    return NULL;
}

int EVP_KEYMGMT_up_ref(EVP_KEYMGMT * keymgmt) {
    return 0;
}

void EVP_KEYMGMT_free(EVP_KEYMGMT * keymgmt) ;


const OSSL_PROVIDER * EVP_KEYMGMT_get0_provider(const EVP_KEYMGMT * keymgmt) {
    return NULL;
}

const char * EVP_KEYMGMT_get0_name(const EVP_KEYMGMT * keymgmt) {
    return NULL;
}

const char * EVP_KEYMGMT_get0_description(const EVP_KEYMGMT * keymgmt) {
    return NULL;
}

int EVP_KEYMGMT_is_a(const EVP_KEYMGMT * keymgmt, const char * name) {
    return 0;
}

void EVP_KEYMGMT_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_KEYMGMT *, void *), void * arg) ;


int EVP_KEYMGMT_names_do_all(const EVP_KEYMGMT * keymgmt, void (*fn)(const char *, void *), void * data) {
    return 0;
}

const OSSL_PARAM * EVP_KEYMGMT_gettable_params(const EVP_KEYMGMT * keymgmt) {
    return NULL;
}

const OSSL_PARAM * EVP_KEYMGMT_settable_params(const EVP_KEYMGMT * keymgmt) {
    return NULL;
}

const OSSL_PARAM * EVP_KEYMGMT_gen_settable_params(const EVP_KEYMGMT * keymgmt) {
    return NULL;
}

const OSSL_PARAM * EVP_KEYMGMT_gen_gettable_params(const EVP_KEYMGMT * keymgmt) {
    return NULL;
}

EVP_SKEYMGMT * EVP_SKEYMGMT_fetch(OSSL_LIB_CTX * ctx, const char * algorithm, const char * properties) {
    return NULL;
}

int EVP_SKEYMGMT_up_ref(EVP_SKEYMGMT * keymgmt) {
    return 0;
}

void EVP_SKEYMGMT_free(EVP_SKEYMGMT * keymgmt) ;


const OSSL_PROVIDER * EVP_SKEYMGMT_get0_provider(const EVP_SKEYMGMT * keymgmt) {
    return NULL;
}

const char * EVP_SKEYMGMT_get0_name(const EVP_SKEYMGMT * keymgmt) {
    return NULL;
}

const char * EVP_SKEYMGMT_get0_description(const EVP_SKEYMGMT * keymgmt) {
    return NULL;
}

int EVP_SKEYMGMT_is_a(const EVP_SKEYMGMT * keymgmt, const char * name) {
    return 0;
}

void EVP_SKEYMGMT_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_SKEYMGMT *, void *), void * arg) ;


int EVP_SKEYMGMT_names_do_all(const EVP_SKEYMGMT * keymgmt, void (*fn)(const char *, void *), void * data) {
    return 0;
}

const OSSL_PARAM * EVP_SKEYMGMT_get0_gen_settable_params(const EVP_SKEYMGMT * skeymgmt) {
    return NULL;
}

const OSSL_PARAM * EVP_SKEYMGMT_get0_imp_settable_params(const EVP_SKEYMGMT * skeymgmt) {
    return NULL;
}

EVP_PKEY_CTX * EVP_PKEY_CTX_new(EVP_PKEY * pkey, ENGINE * e) {
    return NULL;
}

EVP_PKEY_CTX * EVP_PKEY_CTX_new_id(int id, ENGINE * e) {
    return NULL;
}

EVP_PKEY_CTX * EVP_PKEY_CTX_new_from_name(OSSL_LIB_CTX * libctx, const char * name, const char * propquery) {
    return NULL;
}

EVP_PKEY_CTX * EVP_PKEY_CTX_new_from_pkey(OSSL_LIB_CTX * libctx, EVP_PKEY * pkey, const char * propquery) {
    return NULL;
}

EVP_PKEY_CTX * EVP_PKEY_CTX_dup(const EVP_PKEY_CTX * ctx) {
    return NULL;
}

void EVP_PKEY_CTX_free(EVP_PKEY_CTX * ctx) ;


int EVP_PKEY_CTX_is_a(EVP_PKEY_CTX * ctx, const char * keytype) {
    return 0;
}

int EVP_PKEY_CTX_get_params(EVP_PKEY_CTX * ctx, OSSL_PARAM * params) {
    return 0;
}

const OSSL_PARAM * EVP_PKEY_CTX_gettable_params(const EVP_PKEY_CTX * ctx) {
    return NULL;
}

int EVP_PKEY_CTX_set_params(EVP_PKEY_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

const OSSL_PARAM * EVP_PKEY_CTX_settable_params(const EVP_PKEY_CTX * ctx) {
    return NULL;
}

int EVP_PKEY_CTX_set_algor_params(EVP_PKEY_CTX * ctx, const X509_ALGOR * alg) {
    return 0;
}

int EVP_PKEY_CTX_get_algor_params(EVP_PKEY_CTX * ctx, X509_ALGOR * alg) {
    return 0;
}

int EVP_PKEY_CTX_get_algor(EVP_PKEY_CTX * ctx, X509_ALGOR ** alg) {
    return 0;
}

int EVP_PKEY_CTX_ctrl(EVP_PKEY_CTX * ctx, int keytype, int optype, int cmd, int p1, void * p2) {
    return 0;
}

int EVP_PKEY_CTX_ctrl_str(EVP_PKEY_CTX * ctx, const char * type, const char * value) {
    return 0;
}

int EVP_PKEY_CTX_ctrl_uint64(EVP_PKEY_CTX * ctx, int keytype, int optype, int cmd, uint64_t value) {
    return 0;
}

int EVP_PKEY_CTX_str2ctrl(EVP_PKEY_CTX * ctx, int cmd, const char * str) {
    return 0;
}

int EVP_PKEY_CTX_hex2ctrl(EVP_PKEY_CTX * ctx, int cmd, const char * hex) {
    return 0;
}

int EVP_PKEY_CTX_md(EVP_PKEY_CTX * ctx, int optype, int cmd, const char * md) {
    return 0;
}

int EVP_PKEY_CTX_get_operation(EVP_PKEY_CTX * ctx) {
    return 0;
}

void EVP_PKEY_CTX_set0_keygen_info(EVP_PKEY_CTX * ctx, int * dat, int datlen) ;


EVP_PKEY * EVP_PKEY_new_mac_key(int type, ENGINE * e, const unsigned char * key, int keylen) {
    return NULL;
}

EVP_PKEY * EVP_PKEY_new_raw_private_key_ex(OSSL_LIB_CTX * libctx, const char * keytype, const char * propq, const unsigned char * priv, size_t len) {
    return NULL;
}

EVP_PKEY * EVP_PKEY_new_raw_private_key(int type, ENGINE * e, const unsigned char * priv, size_t len) {
    return NULL;
}

EVP_PKEY * EVP_PKEY_new_raw_public_key_ex(OSSL_LIB_CTX * libctx, const char * keytype, const char * propq, const unsigned char * pub, size_t len) {
    return NULL;
}

EVP_PKEY * EVP_PKEY_new_raw_public_key(int type, ENGINE * e, const unsigned char * pub, size_t len) {
    return NULL;
}

int EVP_PKEY_get_raw_private_key(const EVP_PKEY * pkey, unsigned char * priv, size_t * len) {
    return 0;
}

int EVP_PKEY_get_raw_public_key(const EVP_PKEY * pkey, unsigned char * pub, size_t * len) {
    return 0;
}

EVP_PKEY * EVP_PKEY_new_CMAC_key(ENGINE * e, const unsigned char * priv, size_t len, const EVP_CIPHER * cipher) {
    return NULL;
}

void EVP_PKEY_CTX_set_data(EVP_PKEY_CTX * ctx, void * data) ;


void * EVP_PKEY_CTX_get_data(const EVP_PKEY_CTX * ctx) {
    return NULL;
}

EVP_PKEY * EVP_PKEY_CTX_get0_pkey(EVP_PKEY_CTX * ctx) {
    return NULL;
}

EVP_PKEY * EVP_PKEY_CTX_get0_peerkey(EVP_PKEY_CTX * ctx) {
    return NULL;
}

void EVP_PKEY_CTX_set_app_data(EVP_PKEY_CTX * ctx, void * data) ;


void * EVP_PKEY_CTX_get_app_data(EVP_PKEY_CTX * ctx) {
    return NULL;
}

int EVP_PKEY_CTX_set_signature(EVP_PKEY_CTX * pctx, const unsigned char * sig, size_t siglen) {
    return 0;
}

void EVP_SIGNATURE_free(EVP_SIGNATURE * signature) ;


int EVP_SIGNATURE_up_ref(EVP_SIGNATURE * signature) {
    return 0;
}

OSSL_PROVIDER * EVP_SIGNATURE_get0_provider(const EVP_SIGNATURE * signature) {
    return NULL;
}

EVP_SIGNATURE * EVP_SIGNATURE_fetch(OSSL_LIB_CTX * ctx, const char * algorithm, const char * properties) {
    return NULL;
}

int EVP_SIGNATURE_is_a(const EVP_SIGNATURE * signature, const char * name) {
    return 0;
}

const char * EVP_SIGNATURE_get0_name(const EVP_SIGNATURE * signature) {
    return NULL;
}

const char * EVP_SIGNATURE_get0_description(const EVP_SIGNATURE * signature) {
    return NULL;
}

void EVP_SIGNATURE_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_SIGNATURE *, void *), void * data) ;


int EVP_SIGNATURE_names_do_all(const EVP_SIGNATURE * signature, void (*fn)(const char *, void *), void * data) {
    return 0;
}

const OSSL_PARAM * EVP_SIGNATURE_gettable_ctx_params(const EVP_SIGNATURE * sig) {
    return NULL;
}

const OSSL_PARAM * EVP_SIGNATURE_settable_ctx_params(const EVP_SIGNATURE * sig) {
    return NULL;
}

void EVP_ASYM_CIPHER_free(EVP_ASYM_CIPHER * cipher) ;


int EVP_ASYM_CIPHER_up_ref(EVP_ASYM_CIPHER * cipher) {
    return 0;
}

OSSL_PROVIDER * EVP_ASYM_CIPHER_get0_provider(const EVP_ASYM_CIPHER * cipher) {
    return NULL;
}

EVP_ASYM_CIPHER * EVP_ASYM_CIPHER_fetch(OSSL_LIB_CTX * ctx, const char * algorithm, const char * properties) {
    return NULL;
}

int EVP_ASYM_CIPHER_is_a(const EVP_ASYM_CIPHER * cipher, const char * name) {
    return 0;
}

const char * EVP_ASYM_CIPHER_get0_name(const EVP_ASYM_CIPHER * cipher) {
    return NULL;
}

const char * EVP_ASYM_CIPHER_get0_description(const EVP_ASYM_CIPHER * cipher) {
    return NULL;
}

void EVP_ASYM_CIPHER_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_ASYM_CIPHER *, void *), void * arg) ;


int EVP_ASYM_CIPHER_names_do_all(const EVP_ASYM_CIPHER * cipher, void (*fn)(const char *, void *), void * data) {
    return 0;
}

const OSSL_PARAM * EVP_ASYM_CIPHER_gettable_ctx_params(const EVP_ASYM_CIPHER * ciph) {
    return NULL;
}

const OSSL_PARAM * EVP_ASYM_CIPHER_settable_ctx_params(const EVP_ASYM_CIPHER * ciph) {
    return NULL;
}

void EVP_KEM_free(EVP_KEM * wrap) ;


int EVP_KEM_up_ref(EVP_KEM * wrap) {
    return 0;
}

OSSL_PROVIDER * EVP_KEM_get0_provider(const EVP_KEM * wrap) {
    return NULL;
}

EVP_KEM * EVP_KEM_fetch(OSSL_LIB_CTX * ctx, const char * algorithm, const char * properties) {
    return NULL;
}

int EVP_KEM_is_a(const EVP_KEM * wrap, const char * name) {
    return 0;
}

const char * EVP_KEM_get0_name(const EVP_KEM * wrap) {
    return NULL;
}

const char * EVP_KEM_get0_description(const EVP_KEM * wrap) {
    return NULL;
}

void EVP_KEM_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_KEM *, void *), void * arg) ;


int EVP_KEM_names_do_all(const EVP_KEM * wrap, void (*fn)(const char *, void *), void * data) {
    return 0;
}

const OSSL_PARAM * EVP_KEM_gettable_ctx_params(const EVP_KEM * kem) {
    return NULL;
}

const OSSL_PARAM * EVP_KEM_settable_ctx_params(const EVP_KEM * kem) {
    return NULL;
}

int EVP_PKEY_sign_init(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_sign_init_ex(EVP_PKEY_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_sign_init_ex2(EVP_PKEY_CTX * ctx, EVP_SIGNATURE * algo, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_sign(EVP_PKEY_CTX * ctx, unsigned char * sig, size_t * siglen, const unsigned char * tbs, size_t tbslen) {
    return 0;
}

int EVP_PKEY_sign_message_init(EVP_PKEY_CTX * ctx, EVP_SIGNATURE * algo, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_sign_message_update(EVP_PKEY_CTX * ctx, const unsigned char * in, size_t inlen) {
    return 0;
}

int EVP_PKEY_sign_message_final(EVP_PKEY_CTX * ctx, unsigned char * sig, size_t * siglen) {
    return 0;
}

int EVP_PKEY_verify_init(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_verify_init_ex(EVP_PKEY_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_verify_init_ex2(EVP_PKEY_CTX * ctx, EVP_SIGNATURE * algo, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_verify(EVP_PKEY_CTX * ctx, const unsigned char * sig, size_t siglen, const unsigned char * tbs, size_t tbslen) {
    return 0;
}

int EVP_PKEY_verify_message_init(EVP_PKEY_CTX * ctx, EVP_SIGNATURE * algo, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_verify_message_update(EVP_PKEY_CTX * ctx, const unsigned char * in, size_t inlen) {
    return 0;
}

int EVP_PKEY_verify_message_final(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_verify_recover_init(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_verify_recover_init_ex(EVP_PKEY_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_verify_recover_init_ex2(EVP_PKEY_CTX * ctx, EVP_SIGNATURE * algo, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_verify_recover(EVP_PKEY_CTX * ctx, unsigned char * rout, size_t * routlen, const unsigned char * sig, size_t siglen) {
    return 0;
}

int EVP_PKEY_encrypt_init(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_encrypt_init_ex(EVP_PKEY_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_encrypt(EVP_PKEY_CTX * ctx, unsigned char * out, size_t * outlen, const unsigned char * in, size_t inlen) {
    return 0;
}

int EVP_PKEY_decrypt_init(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_decrypt_init_ex(EVP_PKEY_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_decrypt(EVP_PKEY_CTX * ctx, unsigned char * out, size_t * outlen, const unsigned char * in, size_t inlen) {
    return 0;
}

int EVP_PKEY_derive_init(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_derive_init_ex(EVP_PKEY_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_derive_set_peer_ex(EVP_PKEY_CTX * ctx, EVP_PKEY * peer, int validate_peer) {
    return 0;
}

int EVP_PKEY_derive_set_peer(EVP_PKEY_CTX * ctx, EVP_PKEY * peer) {
    return 0;
}

int EVP_PKEY_derive(EVP_PKEY_CTX * ctx, unsigned char * key, size_t * keylen) {
    return 0;
}

int EVP_PKEY_encapsulate_init(EVP_PKEY_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_auth_encapsulate_init(EVP_PKEY_CTX * ctx, EVP_PKEY * authpriv, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_encapsulate(EVP_PKEY_CTX * ctx, unsigned char * wrappedkey, size_t * wrappedkeylen, unsigned char * genkey, size_t * genkeylen) {
    return 0;
}

int EVP_PKEY_decapsulate_init(EVP_PKEY_CTX * ctx, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_auth_decapsulate_init(EVP_PKEY_CTX * ctx, EVP_PKEY * authpub, const OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_decapsulate(EVP_PKEY_CTX * ctx, unsigned char * unwrapped, size_t * unwrappedlen, const unsigned char * wrapped, size_t wrappedlen) {
    return 0;
}

int EVP_PKEY_fromdata_init(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_fromdata(EVP_PKEY_CTX * ctx, EVP_PKEY ** ppkey, int selection, OSSL_PARAM * param) {
    return 0;
}

const OSSL_PARAM * EVP_PKEY_fromdata_settable(EVP_PKEY_CTX * ctx, int selection) {
    return NULL;
}

int EVP_PKEY_todata(const EVP_PKEY * pkey, int selection, OSSL_PARAM ** params) {
    return 0;
}

int EVP_PKEY_export(const EVP_PKEY * pkey, int selection, OSSL_CALLBACK * export_cb, void * export_cbarg) {
    return 0;
}

const OSSL_PARAM * EVP_PKEY_gettable_params(const EVP_PKEY * pkey) {
    return NULL;
}

int EVP_PKEY_get_params(const EVP_PKEY * pkey, OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_get_int_param(const EVP_PKEY * pkey, const char * key_name, int * out) {
    return 0;
}

int EVP_PKEY_get_size_t_param(const EVP_PKEY * pkey, const char * key_name, size_t * out) {
    return 0;
}

int EVP_PKEY_get_bn_param(const EVP_PKEY * pkey, const char * key_name, BIGNUM ** bn) {
    return 0;
}

int EVP_PKEY_get_utf8_string_param(const EVP_PKEY * pkey, const char * key_name, char * str, size_t max_buf_sz, size_t * out_sz) {
    return 0;
}

int EVP_PKEY_get_octet_string_param(const EVP_PKEY * pkey, const char * key_name, unsigned char * buf, size_t max_buf_sz, size_t * out_sz) {
    return 0;
}

const OSSL_PARAM * EVP_PKEY_settable_params(const EVP_PKEY * pkey) {
    return NULL;
}

int EVP_PKEY_set_params(EVP_PKEY * pkey, OSSL_PARAM * params) {
    return 0;
}

int EVP_PKEY_set_int_param(EVP_PKEY * pkey, const char * key_name, int in) {
    return 0;
}

int EVP_PKEY_set_size_t_param(EVP_PKEY * pkey, const char * key_name, size_t in) {
    return 0;
}

int EVP_PKEY_set_bn_param(EVP_PKEY * pkey, const char * key_name, const BIGNUM * bn) {
    return 0;
}

int EVP_PKEY_set_utf8_string_param(EVP_PKEY * pkey, const char * key_name, const char * str) {
    return 0;
}

int EVP_PKEY_set_octet_string_param(EVP_PKEY * pkey, const char * key_name, const unsigned char * buf, size_t bsize) {
    return 0;
}

int EVP_PKEY_get_ec_point_conv_form(const EVP_PKEY * pkey) {
    return 0;
}

int EVP_PKEY_get_field_type(const EVP_PKEY * pkey) {
    return 0;
}

EVP_PKEY * EVP_PKEY_Q_keygen(OSSL_LIB_CTX * libctx, const char * propq, const char * type, ...) {
    return NULL;
}

int EVP_PKEY_paramgen_init(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_paramgen(EVP_PKEY_CTX * ctx, EVP_PKEY ** ppkey) {
    return 0;
}

int EVP_PKEY_keygen_init(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_keygen(EVP_PKEY_CTX * ctx, EVP_PKEY ** ppkey) {
    return 0;
}

int EVP_PKEY_generate(EVP_PKEY_CTX * ctx, EVP_PKEY ** ppkey) {
    return 0;
}

int EVP_PKEY_check(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_public_check(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_public_check_quick(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_param_check(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_param_check_quick(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_private_check(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_pairwise_check(EVP_PKEY_CTX * ctx) {
    return 0;
}

int EVP_PKEY_set_ex_data(EVP_PKEY * key, int idx, void * arg) {
    return 0;
}

void * EVP_PKEY_get_ex_data(const EVP_PKEY * key, int idx) {
    return NULL;
}

void EVP_PKEY_CTX_set_cb(EVP_PKEY_CTX * ctx, EVP_PKEY_gen_cb * cb) ;


EVP_PKEY_gen_cb * EVP_PKEY_CTX_get_cb(EVP_PKEY_CTX * ctx) {
    return NULL;
}

int EVP_PKEY_CTX_get_keygen_info(EVP_PKEY_CTX * ctx, int idx) {
    return 0;
}

void EVP_PKEY_meth_set_init(EVP_PKEY_METHOD * pmeth, int (*init)(EVP_PKEY_CTX *)) ;


void EVP_PKEY_meth_set_copy(EVP_PKEY_METHOD * pmeth, int (*copy)(EVP_PKEY_CTX *, const EVP_PKEY_CTX *)) ;


void EVP_PKEY_meth_set_cleanup(EVP_PKEY_METHOD * pmeth, void (*cleanup)(EVP_PKEY_CTX *)) ;


void EVP_PKEY_meth_set_paramgen(EVP_PKEY_METHOD * pmeth, int (*paramgen_init)(EVP_PKEY_CTX *), int (*paramgen)(EVP_PKEY_CTX *, EVP_PKEY *)) ;


void EVP_PKEY_meth_set_keygen(EVP_PKEY_METHOD * pmeth, int (*keygen_init)(EVP_PKEY_CTX *), int (*keygen)(EVP_PKEY_CTX *, EVP_PKEY *)) ;


void EVP_PKEY_meth_set_sign(EVP_PKEY_METHOD * pmeth, int (*sign_init)(EVP_PKEY_CTX *), int (*sign)(EVP_PKEY_CTX *, unsigned char *, size_t *, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_set_verify(EVP_PKEY_METHOD * pmeth, int (*verify_init)(EVP_PKEY_CTX *), int (*verify)(EVP_PKEY_CTX *, const unsigned char *, size_t, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_set_verify_recover(EVP_PKEY_METHOD * pmeth, int (*verify_recover_init)(EVP_PKEY_CTX *), int (*verify_recover)(EVP_PKEY_CTX *, unsigned char *, size_t *, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_set_signctx(EVP_PKEY_METHOD * pmeth, int (*signctx_init)(EVP_PKEY_CTX *, EVP_MD_CTX *), int (*signctx)(EVP_PKEY_CTX *, unsigned char *, size_t *, EVP_MD_CTX *)) ;


void EVP_PKEY_meth_set_verifyctx(EVP_PKEY_METHOD * pmeth, int (*verifyctx_init)(EVP_PKEY_CTX *, EVP_MD_CTX *), int (*verifyctx)(EVP_PKEY_CTX *, const unsigned char *, int, EVP_MD_CTX *)) ;


void EVP_PKEY_meth_set_encrypt(EVP_PKEY_METHOD * pmeth, int (*encrypt_init)(EVP_PKEY_CTX *), int (*encryptfn)(EVP_PKEY_CTX *, unsigned char *, size_t *, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_set_decrypt(EVP_PKEY_METHOD * pmeth, int (*decrypt_init)(EVP_PKEY_CTX *), int (*decrypt)(EVP_PKEY_CTX *, unsigned char *, size_t *, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_set_derive(EVP_PKEY_METHOD * pmeth, int (*derive_init)(EVP_PKEY_CTX *), int (*derive)(EVP_PKEY_CTX *, unsigned char *, size_t *)) ;


void EVP_PKEY_meth_set_ctrl(EVP_PKEY_METHOD * pmeth, int (*ctrl)(EVP_PKEY_CTX *, int, int, void *), int (*ctrl_str)(EVP_PKEY_CTX *, const char *, const char *)) ;


void EVP_PKEY_meth_set_digestsign(EVP_PKEY_METHOD * pmeth, int (*digestsign)(EVP_MD_CTX *, unsigned char *, size_t *, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_set_digestverify(EVP_PKEY_METHOD * pmeth, int (*digestverify)(EVP_MD_CTX *, const unsigned char *, size_t, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_set_check(EVP_PKEY_METHOD * pmeth, int (*check)(EVP_PKEY *)) ;


void EVP_PKEY_meth_set_public_check(EVP_PKEY_METHOD * pmeth, int (*check)(EVP_PKEY *)) ;


void EVP_PKEY_meth_set_param_check(EVP_PKEY_METHOD * pmeth, int (*check)(EVP_PKEY *)) ;


void EVP_PKEY_meth_set_digest_custom(EVP_PKEY_METHOD * pmeth, int (*digest_custom)(EVP_PKEY_CTX *, EVP_MD_CTX *)) ;


void EVP_PKEY_meth_get_init(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *)) ;


void EVP_PKEY_meth_get_copy(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *, const EVP_PKEY_CTX *)) ;


void EVP_PKEY_meth_get_cleanup(const EVP_PKEY_METHOD * pmeth, void (**)(EVP_PKEY_CTX *)) ;


void EVP_PKEY_meth_get_paramgen(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *), int (**)(EVP_PKEY_CTX *, EVP_PKEY *)) ;


void EVP_PKEY_meth_get_keygen(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *), int (**)(EVP_PKEY_CTX *, EVP_PKEY *)) ;


void EVP_PKEY_meth_get_sign(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *), int (**)(EVP_PKEY_CTX *, unsigned char *, size_t *, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_get_verify(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *), int (**)(EVP_PKEY_CTX *, const unsigned char *, size_t, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_get_verify_recover(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *), int (**)(EVP_PKEY_CTX *, unsigned char *, size_t *, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_get_signctx(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *, EVP_MD_CTX *), int (**)(EVP_PKEY_CTX *, unsigned char *, size_t *, EVP_MD_CTX *)) ;


void EVP_PKEY_meth_get_verifyctx(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *, EVP_MD_CTX *), int (**)(EVP_PKEY_CTX *, const unsigned char *, int, EVP_MD_CTX *)) ;


void EVP_PKEY_meth_get_encrypt(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *), int (**)(EVP_PKEY_CTX *, unsigned char *, size_t *, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_get_decrypt(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *), int (**)(EVP_PKEY_CTX *, unsigned char *, size_t *, const unsigned char *, size_t)) ;


void EVP_PKEY_meth_get_derive(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *), int (**)(EVP_PKEY_CTX *, unsigned char *, size_t *)) ;


void EVP_PKEY_meth_get_ctrl(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *, int, int, void *), int (**)(EVP_PKEY_CTX *, const char *, const char *)) ;


void EVP_PKEY_meth_get_digestsign(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_MD_CTX *, unsigned char *, size_t *, const unsigned char *, size_t));

void EVP_PKEY_meth_get_digestverify(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_MD_CTX *, const unsigned char *, size_t, const unsigned char *, size_t));

void EVP_PKEY_meth_get_check(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY *));

void EVP_PKEY_meth_get_public_check(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY *));

void EVP_PKEY_meth_get_param_check(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY *));

void EVP_PKEY_meth_get_digest_custom(const EVP_PKEY_METHOD * pmeth, int (**)(EVP_PKEY_CTX *, EVP_MD_CTX *));

void EVP_KEYEXCH_free(EVP_KEYEXCH * exchange) ;


int EVP_KEYEXCH_up_ref(EVP_KEYEXCH * exchange) {
    return 0;
}

EVP_KEYEXCH * EVP_KEYEXCH_fetch(OSSL_LIB_CTX * ctx, const char * algorithm, const char * properties) {
    return NULL;
}

OSSL_PROVIDER * EVP_KEYEXCH_get0_provider(const EVP_KEYEXCH * exchange) {
    return NULL;
}

int EVP_KEYEXCH_is_a(const EVP_KEYEXCH * keyexch, const char * name) {
    return 0;
}

const char * EVP_KEYEXCH_get0_name(const EVP_KEYEXCH * keyexch) {
    return NULL;
}

const char * EVP_KEYEXCH_get0_description(const EVP_KEYEXCH * keyexch) {
    return NULL;
}

void EVP_KEYEXCH_do_all_provided(OSSL_LIB_CTX * libctx, void (*fn)(EVP_KEYEXCH *, void *), void * data) ;


int EVP_KEYEXCH_names_do_all(const EVP_KEYEXCH * keyexch, void (*fn)(const char *, void *), void * data) {
    return 0;
}

const OSSL_PARAM * EVP_KEYEXCH_gettable_ctx_params(const EVP_KEYEXCH * keyexch) {
    return NULL;
}

const OSSL_PARAM * EVP_KEYEXCH_settable_ctx_params(const EVP_KEYEXCH * keyexch) {
    return NULL;
}

void EVP_add_alg_module(void) ;


int EVP_PKEY_CTX_set_group_name(EVP_PKEY_CTX * ctx, const char * name) {
    return 0;
}

int EVP_PKEY_CTX_get_group_name(EVP_PKEY_CTX * ctx, char * name, size_t namelen) {
    return 0;
}

int EVP_PKEY_get_group_name(const EVP_PKEY * pkey, char * name, size_t name_sz, size_t * gname_len) {
    return 0;
}

OSSL_LIB_CTX * EVP_PKEY_CTX_get0_libctx(EVP_PKEY_CTX * ctx) {
    return NULL;
}

const char * EVP_PKEY_CTX_get0_propq(const EVP_PKEY_CTX * ctx) {
    return NULL;
}

const OSSL_PROVIDER * EVP_PKEY_CTX_get0_provider(const EVP_PKEY_CTX * ctx) {
    return NULL;
}

int EVP_SKEY_is_a(const EVP_SKEY * skey, const char * name) {
    return 0;
}

EVP_SKEY * EVP_SKEY_import(OSSL_LIB_CTX * libctx, const char * skeymgmtname, const char * propquery, int selection, const OSSL_PARAM * params) {
    return NULL;
}

EVP_SKEY * EVP_SKEY_generate(OSSL_LIB_CTX * libctx, const char * skeymgmtname, const char * propquery, const OSSL_PARAM * params) {
    return NULL;
}

EVP_SKEY * EVP_SKEY_import_raw_key(OSSL_LIB_CTX * libctx, const char * skeymgmtname, unsigned char * key, size_t keylen, const char * propquery) {
    return NULL;
}

int EVP_SKEY_get0_raw_key(const EVP_SKEY * skey, const unsigned char ** key, size_t * len) {
    return 0;
}

const char * EVP_SKEY_get0_key_id(const EVP_SKEY * skey) {
    return NULL;
}

int EVP_SKEY_export(const EVP_SKEY * skey, int selection, OSSL_CALLBACK * export_cb, void * export_cbarg) {
    return 0;
}

int EVP_SKEY_up_ref(EVP_SKEY * skey) {
    return 0;
}

void EVP_SKEY_free(EVP_SKEY * skey) ;


const char * EVP_SKEY_get0_skeymgmt_name(const EVP_SKEY * skey) {
    return NULL;
}

const char * EVP_SKEY_get0_provider_name(const EVP_SKEY * skey) {
    return NULL;
}

EVP_SKEY * EVP_SKEY_to_provider(EVP_SKEY * skey, OSSL_LIB_CTX * libctx, OSSL_PROVIDER * prov, const char * propquery) {
    return NULL;
}

int ERR_get_error() {
    return 0;
}

void ERR_error_string_n(int error, char* buf, int len) {
    return;
}

int EVP_SignInit(EVP_MD_CTX *ctx, const EVP_MD *type) {
    return 0;
}

int EVP_SignUpdate(EVP_MD_CTX *ctx, const unsigned char *data, size_t len) {
    return 0;
}

void* OPENSSL_malloc(size_t size) {
    return NULL;
}

void OPENSSL_free(void *ptr) {
    return;
}

int EVP_PKEY_CTX_set_rsa_keygen_bits(EVP_PKEY_CTX *ctx, int bits) {
    return 0;
}

int EVP_PKEY_CTX_set_rsa_pss_saltlen(EVP_PKEY_CTX *ctx, int saltlen) {
    return 0;
}

int RSA_do_verify(const unsigned char *dgst, int dgst_len, DSA_SIG *sig, DSA *dsa) {
    return 1;
}

int DSA_do_verify(const unsigned char *dgst, int dgst_len, DSA_SIG *sig, DSA *dsa) {
    return 1;
}

int RSA_free(RSA *rsa) {
    return 1;
}

int DSA_free(DSA *dsa) {
    return 1;
}

int EVP_PKEY_size(const EVP_PKEY * pkey) {
    return 0;
}

int EVP_VerifyInit(EVP_MD_CTX * ctx, const EVP_MD * type) {
    return 0;
}

int EVP_VerifyUpdate(EVP_MD_CTX * ctx, const void * data, size_t dsize) {
    return 0;
}

int printf(const char*, ...) {
    return NULL;
}

int strlen(const char *s) {
    return NULL;
}

void* memset(void *s, int c, size_t n) {
    return NULL;
}

int RSA_size(const RSA * rsa) {
    return 0;
}

int RSA_sign(int type, const unsigned char * m, unsigned int m_length, unsigned char * sigret, unsigned int * siglen, RSA * rsa) {
    return 0;
}

int RSA_verify(int type, const unsigned char * m, unsigned int m_length, const unsigned char * sigbuf, unsigned int siglen, RSA * rsa) {
    return 0;
}

int EVP_PKEY_CTX_set_rsa_padding(EVP_PKEY_CTX * ctx, int padding) {
    return 0;
}

int EVP_PKEY_CTX_set_dsa_paramgen_bits(EVP_PKEY_CTX * ctx, int bits) {
    return 0;
}

int DSA_size(const DSA * dsa) {
    return 0;
}

DSA_SIG * DSA_SIG_new(void) {
    return NULL;
}

void DSA_SIG_free(DSA_SIG * sig) ;

DSA_SIG * DSA_do_sign(const unsigned char * dgst, int dgst_len, DSA * dsa) {
    return NULL;
}

void DSA_SIG_get0(const DSA_SIG * sig, const BIGNUM ** pr, const BIGNUM ** ps) ;

int DSA_SIG_set0(DSA_SIG * sig, BIGNUM * r, BIGNUM * s) {
    return 0;
}

int BN_num_bytes(const BIGNUM * a) {
    return 0;
}

int BN_bn2bin(const BIGNUM * a, unsigned char * to) {
    return 0;
}

BIGNUM * BN_new(void) {
    return NULL;
}

void BN_free(BIGNUM * a) ;

BIGNUM * BN_bin2bn(const unsigned char * s, int len, BIGNUM * ret) {
    return NULL;
}

void OpenSSL_add_all_algorithms(void) ;

void ERR_load_crypto_strings(void) ;

#endif /* OSSL_EVP_H */
