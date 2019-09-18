// Common predicates relating to encryption in C and C++
import cpp

/** A blacklist of algorithms that are known to be insecure */
string algorithmBlacklist() {
  result = "DES" or
  result = "RC2" or
  result = "RC4" or
  result = "RC5" or
  result = "ARCFOUR" // a variant of RC4
}

// these are only bad if they're being used for encryption, and it's
// hard to know when that's happening
string hashAlgorithmBlacklist() {
  result = "SHA1" or
  result = "MD5"
}

/** A regex for matching strings that look like they contain a blacklisted algorithm */
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

/** A whitelist of algorithms that are known to be secure */
string algorithmWhitelist() {
  result = "RSA" or
  result = "SHA256" or
  result = "CCM" or
  result = "GCM" or
  result = "AES" or
  result = "Blowfish" or
  result = "ECIES"
}

/** A regex for matching strings that look like they contain a whitelisted algorithm */
string algorithmWhitelistRegex() {
  // The implementation of this is a duplicate of algorithmBlacklistRegex, as it isn't
  // possible to have string -> string functions at the moment
  // algorithms usually appear in names surrounded by characters that are not
  // alphabetical characters in the same case. This handles the upper and lower
  // case cases
  result = "(^|.*[^A-Z])" + algorithmWhitelist() + "([^A-Z].*|$)"
  or
  // for lowercase, we want to be careful to avoid being confused by camelCase
  // hence we require two preceding uppercase letters to be sure of a case switch,
  // or a preceding non-alphabetic character
  result = "(^|.*[A-Z]{2}|.*[^a-zA-Z])" + algorithmWhitelist().toLowerCase() + "([^a-z].*|$)"
}
