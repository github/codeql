/**
 * This file contains predicates create to build up initial data sets for OpenSSL
 * predicates. E.g., These predicates were used to assist in associating all
 * openSSL functions with their known crypto algorithms.
 */

import cpp
import experimental.cryptography.CryptoAlgorithmNames
import experimental.cryptography.utils.OpenSSL.CryptoFunction

private string basicNormalizeFunctionName(Function f, string algType) {
  isKnownAlgorithm(result, algType) and
  exists(string normStr | normStr = f.getName().toUpperCase().regexpReplaceAll("[-_ ]|/", "") |
    normStr.matches("%" + result + "%")
  )
}

/**
 * Converts a raw OpenSSL algorithm to a normalized algorithm name.
 *
 * If more than one match occurs for a given algorithm type, normalize attempts to find the "max"
 * string (max in terms of string length) e.g., matching AES128 to AES128 and not simply AES.
 *
 * An unknown algorithm is only identified if there exists no known algorithm found for any algorithm type.
 *
 * `f` is the function name to normalize.
 * `algType` is a string representing the classification of the algorithm (see `CryptoAlgorithmNames`)
 */
private string privateNormalizeFunctionName(Function f, string algType) {
  result = basicNormalizeFunctionName(f, algType) and
  not exists(string res2 |
    result != res2 and
    res2 = basicNormalizeFunctionName(f, algType) and
    res2.length() > result.length()
  ) and
  // Addressing bad normalization case-by-case
  // CASE: ES256 being identified when the algorithm is AES256
  (
    result.matches("ES256")
    implies
    not exists(string res2 | res2 = basicNormalizeFunctionName(f, _) and res2.matches("AES%"))
  )
}

/**
 * Normalizes a function name to a known algorithm name, similar to `normalizeName`.
 * A function is not, however, allowed to be UNKNOWN. The function either
 * normalizes to a known algorithm name, or the predicate does not hold (no result).
 *
 * The predicate attempts to restrict normalization to what looks like an openssl
 * library by looking for functions only in an openssl path (see `isPossibleOpenSSLFunction`).
 * This may give false postive functions if a directory erronously appears to be openssl;
 * however, we take the stance that if a function
 * exists strongly mapping to a known function name in a directory such as these,
 * regardless of whether its actually a part of openSSL or not, we will analyze it as though it were.
 */
string normalizeFunctionName(Function f, string algType) {
  algType != "UNKNOWN" and
  result = privateNormalizeFunctionName(f, algType) and
  openSSLLibraryFunc(f) and
  // Addressing false positives
  // For algorithm names less than or equal to 4, we must see the algorithm name
  // in the original function as upper case (it can't be split between tokens)
  // One exception found is DES_xcbc_encrypt, this is DESX
  (
    (result.length() <= 4 and result != "DESX")
    implies
    f.getName().toUpperCase().matches("%" + result + "%")
  ) and
  (
    (result.length() <= 4 and result = "DESX")
    implies
    (f.getName().toUpperCase().matches("%DESX%") or f.getName().toUpperCase().matches("%DES_X%"))
  ) and
  // (result.length() <= 3 implies (not f.getName().toUpperCase().regexpMatch(".*" + result + "[a-zA-Z0-9].*|.*[a-zA-Z0-9]" + result + ".*")))
  // and
  // DES specific false positives
  (
    result.matches("DES")
    implies
    not f.getName().toUpperCase().regexpMatch(".*DES[a-zA-Z0-9].*|.*[a-zA-Z0-9]DES.*")
  ) and
  // ((result.matches("%DES%")) implies not exists(string s | s in ["DESCRIBE", "DESTROY", "DESCRIPTION", "DESCRIPTOR", "NODES"] |
  //     f.getName().toUpperCase().matches("%" + s + "%"))) and
  // SEED specific false positives
  (
    result.matches("%SEED%")
    implies
    not not exists(string s |
      s in ["NEW_SEED", "GEN_SEED", "SET_SEED", "GET_SEED", "GET0_SEED", "RESEED", "SEEDING"]
    |
      f.getName().toUpperCase().matches("%" + s + "%")
    )
  ) and
  // ARIA specific false positives
  (result.matches("%ARIA%") implies not f.getName().toUpperCase().matches("%VARIANT%"))
}

/**
 * Predicate to support name normalization.
 * Converts the raw name upper-case with no hyphen, slash, underscore, hash, or space.
 * Looks for substrings that are known algorithms, and normalizes the name.
 * If the algorithm cannot be determined or is in the ignorable list (`isIgnorableOpenSSLAlgorithm`)
 * this predicate will not resolve a name.
 *
 * Rationale for private: For normalization, we want to get the longest string for a normalized name match
 *       for a given algorithm type. I found this easier to express if the public normalizeName
 *       checks that the name is the longest, and that UNKNOWN is reserved if there exists no
 *       result from this predicate that is known.
 */
bindingset[name]
string privateNormalizeName(string name, string algType) {
  //not isIgnorableOpenSSLAlgorithm(name, _, _) and
  // targetOpenSSLAlgorithm(name, _) and
  isKnownAlgorithm(result, algType) and
  exists(string normStr | normStr = name.toUpperCase().regexpReplaceAll("[-_ ]|/", "") |
    normStr.matches("%" + result + "%")
  )
}

/**
 * Converts a raw OpenSSL algorithm to a normalized algorithm name.
 *
 * If more than one match occurs for a given algorithm type, normalize attempts to find the "max"
 * string (max in terms of string length) e.g., matching AES128 to AES128 and not simply AES.
 *
 * An unknown algorithm is only identified if there exists no known algorithm found for any algorithm type.
 *
 * `name` is the name to normalize.
 * `algType` is a string representing the classification of the algorithm (see `CryptoAlgorithmNames`)
 */
bindingset[name]
string normalizeName(string name, string algType) {
  (
    if exists(privateNormalizeName(name, _))
    then result = privateNormalizeName(name, algType)
    else (
      result = unknownAlgorithm() and algType = "UNKNOWN"
    )
  ) and
  not exists(string res2 |
    result != res2 and
    res2 = privateNormalizeName(name, algType) and
    res2.length() > result.length()
  ) and
  // Addressing bad normalization case-by-case
  // CASE: ES256 being identified when the algorithm is AES256
  (
    result.matches("ES256")
    implies
    not exists(string res2 | res2 = privateNormalizeName(name, _) and res2.matches("AES%"))
  )
}
