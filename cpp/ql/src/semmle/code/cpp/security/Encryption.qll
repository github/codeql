/**
 * Provides predicates relating to encryption in C and C++.
 */
import cpp

/**
 * Returns an algorithm that is known to be insecure.
 */
string algorithmBlacklist() {
  result = "DES" or
  result = "RC2" or
  result = "RC4" or
  result = "RC5" or
  result = "ARCFOUR" // a variant of RC4
}

/**
 * Returns the name of a hash algorithm that is insecure if it is being used for
 * encryption (but it is hard to know when that is happening).
 */
string hashAlgorithmBlacklist() {
  result = "SHA1" or
  result = "MD5"
}

/**
 * Returns a regular expression for matching strings that look like they
 * contain an algorithm that is known to be insecure.
 */
string algorithmBlacklistRegex() {
  result =
    // algorithms usually appear in names surrounded by characters that are not
    // alphabetical characters in the same case. This handles the upper and lower
    // case cases
    "(^|.*[^A-Z])(" + strictconcat(algorithmBlacklist(), "|") + ")([^A-Z].*|$)" + "|" +
      // for lowercase, we want to be careful to avoid being confused by camelCase
      // hence we require two preceding uppercase letters to be sure of a case switch,
      // or a preceding non-alphabetic character
      "(^|.*[A-Z]{2}|.*[^a-zA-Z])(" + strictconcat(algorithmBlacklist().toLowerCase(), "|") +
      ")([^a-z].*|$)"
}

/**
 * Returns an algorithms that is known to be secure.
 */
string algorithmWhitelist() {
  result = "RSA" or
  result = "SHA256" or
  result = "CCM" or
  result = "GCM" or
  result = "AES" or
  result = "Blowfish" or
  result = "ECIES"
}

/**
 * Returns a regular expression for matching strings that look like they
 * contain an algorithm that is known to be secure.
 */
string algorithmWhitelistRegex() {
  // The implementation of this is a duplicate of algorithmBlacklistRegex, as
  // it isn't possible to have string -> string functions at the moment
  // algorithms usually appear in names surrounded by characters that are not
  // alphabetical characters in the same case. This handles the upper and lower
  // case cases
  result = "(^|.*[^A-Z])" + algorithmWhitelist() + "([^A-Z].*|$)"
  or
  // for lowercase, we want to be careful to avoid being confused by camelCase
  // hence we require two preceding uppercase letters to be sure of a case
  // switch, or a preceding non-alphabetic character
  result = "(^|.*[A-Z]{2}|.*[^a-zA-Z])" + algorithmWhitelist().toLowerCase() + "([^a-z].*|$)"
}
