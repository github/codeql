/**
 * INTERNAL: Do not use.
 *
 * Provides predicates for recommended encryption key sizes.
 * Such that we can share this logic across our CodeQL analysis of different languages.
 */

/** Returns the minimum recommended key size for RSA. */
int minSecureKeySizeRsa() { result = 2048 }

/** Returns the minimum recommended key size for DSA. */
int minSecureKeySizeDsa() { result = 2048 }

/** Returns the minimum recommended key size for DH. */
int minSecureKeySizeDh() { result = 2048 }

/** Returns the minimum recommended key size for elliptic curve cryptography. */
int minSecureKeySizeEcc() { result = 256 }

/** Returns the minimum recommended key size for AES. */
int minSecureKeySizeAes() { result = 128 }
