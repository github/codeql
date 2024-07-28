import cpp
import experimental.cryptography.utils.OpenSSL.LibraryFunction
import experimental.cryptography.CryptoAlgorithmNames

predicate inferredOpenSSLCryptoFunctionCall(Call c, string normalized, string algType) {
  inferredOpenSSLCryptoFunction(c.getTarget(), normalized, algType)
}

predicate inferredOpenSSLCryptoFunction(Function f, string normalized, string algType) {
  isPossibleOpenSSLFunction(f) and
  normalizeFunctionName(f, algType) = normalized
}

predicate isOpenSSLCryptoFunction(Function f, string normalized, string algType) {
  // NOTE: relying on inference as there are thousands of functions for crypto
  //       enumerating them all and maintaining the list seems problematic.
  //       For now, we will rely on dynamically inferring algorithms for function names.
  //       This has been seen to be reasonably efficient and accurate.
  inferredOpenSSLCryptoFunction(f, normalized, algType)
}

predicate isOpenSSLCryptoFunctionCall(Call c, string normalized, string algType) {
  isOpenSSLCryptoFunction(c.getTarget(), normalized, algType)
}

private string basicNormalizeFunctionName(Function f, string algType) {
  isPossibleOpenSSLFunction(f) and
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
  isPossibleOpenSSLFunction(f) and
  result = basicNormalizeFunctionName(f, algType) and
  not exists(string res2 |
    result != res2 and
    res2 = basicNormalizeFunctionName(f, algType) and
    res2.length() > result.length()
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
private string normalizeFunctionName(Function f, string algType) {
  algType != "UNKNOWN" and
  isPossibleOpenSSLFunction(f) and
  result = privateNormalizeFunctionName(f, algType) and
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
    result.matches("SEED")
    implies
    not exists(string s |
      s in [
          "SEED_SRC_GENERATE", "RAND", "NEW_SEED", "GEN_SEED", "SEED_GEN", "SET_SEED", "GET_SEED",
          "GET0_SEED", "RESEED", "SEEDING"
        ]
    |
      f.getName().toUpperCase().matches("%" + s + "%")
    )
  ) and
  // ARIA specific false positives
  (result.matches("ARIA") implies not f.getName().toUpperCase().matches("%VARIANT%")) and
  // CTR false positives
  (result.matches("CTR") implies not f.getName().toUpperCase().matches("%CTRL%")) and
  // ES false positives (e.g., ES256 from AES256)
  (result.matches("ES%") implies not f.getName().toUpperCase().matches("%AES%")) and
  // RSA false positives
  (result.matches("RSA") implies not f.getName().toUpperCase().matches("%UNIVERSAL%")) and
  //rsaz functions deemed to be too low level, and can be ignored
  not f.getLocation().getFile().getBaseName().matches("rsaz_exp.c") and
  // General False positives
  // Functions that 'get' do not set an algorithm, and therefore are considered ignorable
  not f.getName().toLowerCase().matches("%get%")
}
