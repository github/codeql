#pragma once

#define NULL 0

typedef unsigned long size_t;

typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

typedef int OSSL_PROVIDER;

typedef int OSSL_FUNC_keymgmt_import_fn;

typedef int OSSL_FUNC_digest_get_ctx_params_fn;

typedef int OSSL_FUNC_cipher_settable_ctx_params_fn;

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

typedef int RSA;

typedef int BIGNUM;

typedef int ENGINE;

typedef int RSA_METHOD;

struct asn1_string_st {
    int length;
    int type;
    unsigned char *data;
    /*
     * The value of the following field depends on the type being held.  It
     * is mostly being used for BIT_STRING so if the input data has a
     * non-zero 'unused bits' value, it will be handled correctly
     */
    long flags;
};

typedef struct asn1_string_st ASN1_INTEGER;
typedef struct asn1_string_st ASN1_ENUMERATED;
typedef struct asn1_string_st ASN1_BIT_STRING;
typedef struct asn1_string_st ASN1_OCTET_STRING;
typedef struct asn1_string_st ASN1_PRINTABLESTRING;
typedef struct asn1_string_st ASN1_T61STRING;
typedef struct asn1_string_st ASN1_IA5STRING;
typedef struct asn1_string_st ASN1_GENERALSTRING;
typedef struct asn1_string_st ASN1_UNIVERSALSTRING;
typedef struct asn1_string_st ASN1_BMPSTRING;
typedef struct asn1_string_st ASN1_UTCTIME;
typedef struct asn1_string_st ASN1_TIME;
typedef struct asn1_string_st ASN1_GENERALIZEDTIME;
typedef struct asn1_string_st ASN1_VISIBLESTRING;
typedef struct asn1_string_st ASN1_UTF8STRING;
typedef struct asn1_string_st ASN1_STRING;
typedef int ASN1_BOOLEAN;
typedef int ASN1_NULL;

typedef int EVP_CIPHER_INFO;

typedef int pem_password_cb;

typedef int X509_INFO;

typedef int RSA_PSS_PARAMS;

typedef int BN_GENCB;

typedef int BN_CTX;

typedef int BN_BLINDING;

typedef int BN_MONT_CTX;

typedef int d2i_of_void;

typedef int i2d_of_void;

typedef int OSSL_i2d_of_void_ctx;

typedef int DSA;

typedef int FFC_PARAMS;