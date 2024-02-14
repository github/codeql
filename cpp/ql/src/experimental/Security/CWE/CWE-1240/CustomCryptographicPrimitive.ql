/**
 * @name Implementation of a cryptographic primitive
 * @description Writing your own cryptographic primitives is prone to errors and omissions that weaken cryptographic protection.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/crypto-primitive
 * @tags security
 *       experimental
 *       external/cwe/cwe-1240
 */

import cpp

/**
 * Gets a word that might be in the name of an encryption function.
 */
string encryptionWord() {
  exists(string word |
    // `(?<!P)` is negative lookbehind, i.e. the match is not preceded by `P`.
    // `(?!P)` is negative lookahead, i.e. the match is not followed by `P`.
    word =
      [
        "Crypt", "Cipher", "Aes", "Rijndael",
        //"(?<!Wi|Co|No)Des(?!truct)",
        "(?<!C)Rc[0-9]", "(?<!Cha|Unive)Rsa", "Blowfish", "Twofish", "Idea", "Kyber", "(?<!V)Aria",
        //"Asn[0-9]",
        "Camellia",
        //"(?<!Bit|Type)Cast",
        "Chacha", "ChaCha", "Poly[0-9]", "Ripemd", "Whirlpool", "Sbox", "SBox", "Cblock", "CBlock",
        "Sub.?Bytes?", "Mix.?Columns?", "ECDH", "ECDSA", "EdDSA", "ECMQV", "ECQV", "Curve[0-9][0-9]"
      ] and
    (
      result = word or
      result = word.toLowerCase() + "(?![a-z])" or // avoid matching middles of words
      result = word.toUpperCase() + "(?![A-Z])" // avoid matching middles of words
    )
  )
}

/**
 * Holds if `f` is a function whose name suggests it may be doing encryption
 * (but may or may not actually implement an encryption primitive itself).
 */
predicate likelyEncryptionFunction(Function f) {
  exists(string fName | fName = f.getName() |
    fName.regexpMatch(".*(" + concat(encryptionWord(), "|") + ").*")
  )
}

/**
 * Holds if `t` is a type that is common in encryption-like computations. That
 * is, an integral type or array of integral type elements.
 */
predicate computeHeuristicType(Type t) {
  t instanceof IntegralType or
  computeHeuristicType(t.(ArrayType).getBaseType().getUnspecifiedType())
}

/**
 * Holds if `e` is an operation that is common in encryption-like computations.
 * Looking for clusters of these tends to find things like encryption,
 * compression, random number generation, graphics processing and other compute
 * heavy algorithms.
 */
predicate computeHeuristic(Expr e) {
  (
    e instanceof BitwiseXorExpr or
    e instanceof AssignXorExpr or
    e instanceof LShiftExpr or
    e instanceof AssignLShiftExpr or
    e instanceof RShiftExpr or
    e instanceof AssignRShiftExpr or
    e instanceof ArrayExpr
  ) and
  computeHeuristicType(e.getUnspecifiedType())
}

/**
 * Gets the name of an established cryptography library or likely third party directory.
 */
string encryptionLibraryName() {
  result =
    [
      "libssh", "openssl", "boringssl", "mbed", "libsodium", "libsrtp", "third.?party", "library",
      "deps"
    ]
}

/**
 * Holds if `f` is a file that is likely to be inside an established
 * cryptography library.
 */
predicate isLibrary(File f) {
  f.getAbsolutePath().regexpMatch("(?i).*(" + concat(encryptionLibraryName(), "|") + ").*")
  or
  // assume that any result that would be found outside the source location is in a crypto library
  not exists(f.getFile().getRelativePath())
}

from Function f, int amount
where
  likelyEncryptionFunction(f) and
  amount = strictcount(Expr e | computeHeuristic(e) and e.getEnclosingFunction() = f) and
  amount >= 8 and
  not isLibrary(f.getFile())
select f,
  "This function, \"" + f.getName() +
    "\", may be a custom implementation of a cryptographic primitive."
