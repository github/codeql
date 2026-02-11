/*
 * Copyright 2019-2022 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

# pragma once
# include "type_stubs.h"

/*
 * DSA Paramgen types
 * Note, adding to this list requires adjustments to various checks
 * in dsa_gen range validation checks
 */
#define DSA_PARAMGEN_TYPE_FIPS_186_4   0   /* Use FIPS186-4 standard */
#define DSA_PARAMGEN_TYPE_FIPS_186_2   1   /* Use legacy FIPS186-2 standard */
#define DSA_PARAMGEN_TYPE_FIPS_DEFAULT 2

DSA *ossl_dsa_new(OSSL_LIB_CTX *libctx);
void ossl_dsa_set0_libctx(DSA *d, OSSL_LIB_CTX *libctx);

int ossl_dsa_generate_ffc_parameters(DSA *dsa, int type, int pbits, int qbits,
                                     BN_GENCB *cb);

int ossl_dsa_sign_int(int type, const unsigned char *dgst, int dlen,
                      unsigned char *sig, unsigned int *siglen, DSA *dsa,
                      unsigned int nonce_type, const char *digestname,
                      OSSL_LIB_CTX *libctx, const char *propq);

FFC_PARAMS *ossl_dsa_get0_params(DSA *dsa);
int ossl_dsa_ffc_params_fromdata(DSA *dsa, const OSSL_PARAM params[]);
int ossl_dsa_key_fromdata(DSA *dsa, const OSSL_PARAM params[],
                          int include_private);
DSA *ossl_dsa_key_from_pkcs8(const PKCS8_PRIV_KEY_INFO *p8inf,
                             OSSL_LIB_CTX *libctx, const char *propq);

int ossl_dsa_generate_public_key(BN_CTX *ctx, const DSA *dsa,
                                 const BIGNUM *priv_key, BIGNUM *pub_key);
int ossl_dsa_check_params(const DSA *dsa, int checktype, int *ret);
int ossl_dsa_check_pub_key(const DSA *dsa, const BIGNUM *pub_key, int *ret);
int ossl_dsa_check_pub_key_partial(const DSA *dsa, const BIGNUM *pub_key,
                                   int *ret);
int ossl_dsa_check_priv_key(const DSA *dsa, const BIGNUM *priv_key, int *ret);
int ossl_dsa_check_pairwise(const DSA *dsa);
int ossl_dsa_is_foreign(const DSA *dsa);
DSA *ossl_dsa_dup(const DSA *dsa, int selection);


int EVP_PKEY_CTX_set_dsa_paramgen_bits(EVP_PKEY_CTX *ctx, int nbits);
int EVP_PKEY_CTX_set_dsa_paramgen_q_bits(EVP_PKEY_CTX *ctx, int qbits);
int EVP_PKEY_CTX_set_dsa_paramgen_md_props(EVP_PKEY_CTX *ctx,
                                           const char *md_name,
                                           const char *md_properties);
int EVP_PKEY_CTX_set_dsa_paramgen_gindex(EVP_PKEY_CTX *ctx, int gindex);
int EVP_PKEY_CTX_set_dsa_paramgen_type(EVP_PKEY_CTX *ctx, const char *name);
int EVP_PKEY_CTX_set_dsa_paramgen_seed(EVP_PKEY_CTX *ctx,
                                       const unsigned char *seed,
                                       size_t seedlen);
int EVP_PKEY_CTX_set_dsa_paramgen_md(EVP_PKEY_CTX *ctx, const EVP_MD *md);

# define EVP_PKEY_CTRL_DSA_PARAMGEN_BITS         (EVP_PKEY_ALG_CTRL + 1)
# define EVP_PKEY_CTRL_DSA_PARAMGEN_Q_BITS       (EVP_PKEY_ALG_CTRL + 2)
# define EVP_PKEY_CTRL_DSA_PARAMGEN_MD           (EVP_PKEY_ALG_CTRL + 3)


#   define OPENSSL_DSA_MAX_MODULUS_BITS   10000

#  define OPENSSL_DSA_FIPS_MIN_MODULUS_BITS 1024

typedef int DSA_SIG;
DSA_SIG *DSA_SIG_new(void);
void DSA_SIG_free(DSA_SIG *a);

void DSA_SIG_get0(const DSA_SIG *sig, const BIGNUM **pr, const BIGNUM **ps);
int DSA_SIG_set0(DSA_SIG *sig, BIGNUM *r, BIGNUM *s);
