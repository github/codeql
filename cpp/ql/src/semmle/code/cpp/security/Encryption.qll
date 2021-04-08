/**
 * Provides predicates relating to encryption in C and C++.
 */

import cpp

/**
 * Gets the name of an algorithm that is known to be insecure.
 */
string getAnInsecureAlgorithmName() {
  result = "DES" or
  result = "RC2" or
  result = "RC4" or
  result = "RC5" or
  result = "ARCFOUR" // a variant of RC4
}

/**
 * Gets the name of a hash algorithm that is insecure if it is being used for
 * encryption (but it is hard to know when that is happening).
 */
string getAnInsecureHashAlgorithmName() {
  result = "SHA1" or
  result = "MD5"
}

/**
 * Gets the regular expression used for matching strings that look like they
 * contain an algorithm that is known to be insecure.
 */
string getInsecureAlgorithmRegex() {
  result =
    // algorithms usually appear in names surrounded by characters that are not
    // alphabetical characters in the same case. This handles the upper and lower
    // case cases
    "(^|.*[^A-Z])(" + strictconcat(getAnInsecureAlgorithmName(), "|") + ")([^A-Z].*|$)" + "|" +
      // for lowercase, we want to be careful to avoid being confused by camelCase
      // hence we require two preceding uppercase letters to be sure of a case switch,
      // or a preceding non-alphabetic character
      "(^|.*[A-Z]{2}|.*[^a-zA-Z])(" + strictconcat(getAnInsecureAlgorithmName().toLowerCase(), "|") +
      ")([^a-z].*|$)"
}

/**
 * Gets the name of an algorithm that is known to be secure.
 */
string getASecureAlgorithmName() {
  result = "RSA" or
  result = "SHA256" or
  result = "CCM" or
  result = "GCM" or
  result = "AES" or
  result = "Blowfish" or
  result = "ECIES"
}

/**
 * Gets a regular expression for matching strings that look like they
 * contain an algorithm that is known to be secure.
 */
string getSecureAlgorithmRegex() {
  result =
    // algorithms usually appear in names surrounded by characters that are not
    // alphabetical characters in the same case. This handles the upper and lower
    // case cases
    "(^|.*[^A-Z])(" + strictconcat(getASecureAlgorithmName(), "|") + ")([^A-Z].*|$)" + "|" +
      // for lowercase, we want to be careful to avoid being confused by camelCase
      // hence we require two preceding uppercase letters to be sure of a case
      // switch, or a preceding non-alphabetic character
      "(^|.*[A-Z]{2}|.*[^a-zA-Z])(" + strictconcat(getASecureAlgorithmName().toLowerCase(), "|") +
      ")([^a-z].*|$)"
}

/**
 * DEPRECATED: Terminology has been updated. Use `getAnInsecureAlgorithmName()`
 * instead.
 */
deprecated string algorithmBlacklist() { result = getAnInsecureAlgorithmName() }

/**
 * DEPRECATED: Terminology has been updated. Use
 * `getAnInsecureHashAlgorithmName()` instead.
 */
deprecated string hashAlgorithmBlacklist() { result = getAnInsecureHashAlgorithmName() }

/**
 * DEPRECATED: Terminology has been updated. Use `getInsecureAlgorithmRegex()` instead.
 */
deprecated string algorithmBlacklistRegex() { result = getInsecureAlgorithmRegex() }

/**
 * DEPRECATED: Terminology has been updated. Use `getASecureAlgorithmName()`
 * instead.
 */
deprecated string algorithmWhitelist() { result = getASecureAlgorithmName() }

/**
 * DEPRECATED: Terminology has been updated. Use `getSecureAlgorithmRegex()` instead.
 */
deprecated string algorithmWhitelistRegex() { result = getSecureAlgorithmRegex() }
