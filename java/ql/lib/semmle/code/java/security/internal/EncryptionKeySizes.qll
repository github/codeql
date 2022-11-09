/**
 * INTERNAL: Do not use.
 *
 * Provides predicates for recommended encryption key sizes.
 * Such that we can share this logic across our CodeQL analysis of different languages.
 */

/** Returns the minimum recommended key size for asymmetric algorithms (RSA, DSA, and DH). */
int minSecureKeySizeAsymmetricNonEc() { result = 2048 }

/** Returns the minimum recommended key size for elliptic curve (EC) algorithms. */
int minSecureKeySizeAsymmetricEc() { result = 256 }

/** Returns the minimum recommended key size for symmetric algorithmms (AES). */
int minSecureKeySizeSymmetric() { result = 128 }
