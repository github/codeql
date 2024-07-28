import cpp
import experimental.cryptography.CryptoAlgorithmNames

predicate isValidAlgorithmLiteral(Literal e) {
  exists(getPossibleNidFromLiteral(e)) or e instanceof StringLiteral
}

int getNIDMax() {
  result = 2000
  // result = max(int nid | knownOpenSSLAlgorithm(_, nid, _, _))
}

/**
 * Resolves literal `e` to a known algorithm name, nid, normalized name, and algType
 * if `e` resolves to a known algorithm.
 * If this predicate does not hold, then `e` can be interpreted as being of `UNKNOWN` type.
 */
predicate resolveAlgorithmFromLiteral(Literal e, string normalized, string algType) {
  exists(int nid |
    nid = getPossibleNidFromLiteral(e) and knownOpenSSLAlgorithm(_, nid, normalized, algType)
  )
  or
  exists(string name |
    name = resolveAlgorithmAlias(e) and knownOpenSSLAlgorithm(name, _, normalized, algType)
  )
  or
  // if the algorithm name directly matches a known normalized algorithm name, assume it is an algorithm
  exists(string name |
    name = e.getValue().toUpperCase() and isKnownAlgorithm(name, algType) and normalized = name
  )
}

string resolveAlgorithmAlias(StringLiteral name) {
  exists(string lower | lower = name.getValue().toLowerCase() |
    // The result is an alias algorithm name if known
    result = getAlgorithmAlias(lower)
    or
    // or the name is itself a known algorithm
    knownOpenSSLAlgorithm(lower, _, _, _) and result = lower
  )
}

private int getPossibleNidFromLiteral(Literal e) {
  result = e.getValue().toInt() and
  not e instanceof CharLiteral and
  not e instanceof StringLiteral and
  // ASSUMPTION, no negative numbers are allowed
  // RATIONALE: this is a performance improvement to avoid having to trace every number
  not exists(UnaryMinusExpr u | u.getOperand() = e) and
  //  OPENSSL has a special macro for getting every line, ignore it
  not exists(MacroInvocation mi | mi.getExpr() = e and mi.getMacroName() = "OPENSSL_LINE") and
  // Filter out cases where an int is assigned into a pointer, e.g., char* x = NULL;
  not exists(Assignment a |
    a.getRValue() = e and a.getLValue().getType().getUnspecifiedType() instanceof PointerType
  ) and
  not exists(Initializer i |
    i.getExpr() = e and
    i.getDeclaration().getADeclarationEntry().getUnspecifiedType() instanceof PointerType
  ) and
  // Filter out cases where an int is returned into a pointer, e.g., return NULL;
  not exists(ReturnStmt r |
    r.getExpr() = e and
    r.getEnclosingFunction().getType().getUnspecifiedType() instanceof PointerType
  )
}

string getAlgorithmAlias(string alias) {
  customAliases(result, alias)
  or
  defaultAliases(result, alias)
}

/**
 * Finds aliases of known alagorithms defined by users (through obj_name_add and various macros pointing to this function)
 *
 * The `target` and `alias` are converted to lowercase to be of a standard form.
 */
predicate customAliases(string target, string alias) {
  exists(Call c | c.getTarget().getName().toLowerCase() = "obj_name_add" |
    target = c.getArgument(2).getValue().toLowerCase() and
    alias = c.getArgument(0).getValue().toLowerCase()
  )
}

/**
 * A hard-coded mapping of known algorithm aliases in OpenSSL.
 * This was derived by applying the same kind of logic foun din `customAliases` to the
 * OpenSSL code base directly.
 *
 * The `target` and `alias` are converted to lowercase to be of a standard form.
 */
predicate defaultAliases(string target, string alias) {
  alias = "aes128" and target = "aes-128-cbc"
  or
  alias = "aes192" and target = "aes-192-cbc"
  or
  alias = "aes256" and target = "aes-256-cbc"
  or
  alias = "aes128-wrap" and target = "id-aes128-wrap"
  or
  alias = "aes192-wrap" and target = "id-aes192-wrap"
  or
  alias = "aes256-wrap" and target = "id-aes256-wrap"
  or
  alias = "aes128-wrap-pad" and target = "id-aes128-wrap-pad"
  or
  alias = "aes192-wrap-pad" and target = "id-aes192-wrap-pad"
  or
  alias = "aes256-wrap-pad" and target = "id-aes256-wrap-pad"
  or
  alias = "aes-128-wrap" and target = "id-aes128-wrap"
  or
  alias = "aes-192-wrap" and target = "id-aes192-wrap"
  or
  alias = "aes-256-wrap" and target = "id-aes256-wrap"
  or
  alias = "aria128" and target = "aria-128-cbc"
  or
  alias = "aria192" and target = "aria-192-cbc"
  or
  alias = "aria256" and target = "aria-256-cbc"
  or
  alias = "aes128" and target = "aes-128-cbc"
  or
  alias = "bf" and target = "bf-cbc"
  or
  alias = "blowfish" and target = "bf-cbc"
  or
  alias = "camellia128" and target = "camellia-128-cbc"
  or
  alias = "camellia192" and target = "camellia-192-cbc"
  or
  alias = "camellia256" and target = "camellia-256-cbc"
  or
  alias = "cast" and target = "cast5-cbc"
  or
  alias = "cast-cbc" and target = "cast5-cbc"
  or
  alias = "des" and target = "des-cbc"
  or
  alias = "des-ede-ecb" and target = "des-ede"
  or
  alias = "des-ede3-ecb" and target = "des-ede3"
  or
  alias = "des3" and target = "des-ede3-cbc"
  or
  alias = "des3-wrap" and target = "id-smime-alg-cms3deswrap"
  or
  alias = "desx" and target = "desx-cbc"
  or
  alias = "idea" and target = "idea-cbc"
  or
  alias = "rc2" and target = "rc2-cbc"
  or
  alias = "rc2-128" and target = "rc2-cbc"
  or
  alias = "rc2-40" and target = "rc2-40-cbc"
  or
  alias = "rc2-64" and target = "rc2-64-cbc"
  or
  alias = "ripemd" and target = "ripemd160"
  or
  alias = "rmd160" and target = "ripemd160"
  or
  alias = "rsa-sha1-2" and target = "rsa-sha1"
  or
  alias = "seed" and target = "seed-cbc"
  or
  alias = "sm4" and target = "sm4-cbc"
  or
  alias = "ssl3-md5" and target = "md5"
  or
  alias = "ssl3-sha1" and target = "sha1"
}

/**
 * Enumeration of all known crypto algorithms for openSSL
 * `name` is all lower case (caller's must ensure they pass in lower case)
 * `nid` is the numeric id of the algorithm,
 * `normalized` is the normalized name of the algorithm (e.g., "AES128" for "aes-128-cbc")
 * `algType` is the type of algorithm (e.g., "SYMMETRIC_ENCRYPTION")
 */
predicate knownOpenSSLAlgorithm(string name, int nid, string normalized, string algType) {
  name = "rsa" and nid = 19 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "prime192v1" and nid = 409 and normalized = "PRIME192V1" and algType = "ELLIPTIC_CURVE"
  or
  name = "prime256v1" and nid = 415 and normalized = "PRIME256V1" and algType = "ELLIPTIC_CURVE"
  or
  name = "pbkdf2" and nid = 69 and normalized = "PBKDF2" and algType = "KEY_DERIVATION"
  or
  name = "dsa" and nid = 116 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "gost2001" and nid = 811 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost2012_256" and nid = 979 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost2012_512" and nid = 980 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "ed25519" and nid = 1087 and normalized = "ED25519" and algType = "ELLIPTIC_CURVE"
  or
  name = "ed448" and nid = 1088 and normalized = "ED448" and algType = "ELLIPTIC_CURVE"
  or
  name = "md2" and nid = 3 and normalized = "MD2" and algType = "HASH"
  or
  name = "sha" and nid = 41 and normalized = "SHA" and algType = "HASH"
  or
  name = "sha1" and nid = 64 and normalized = "SHA1" and algType = "HASH"
  or
  name = "scrypt" and nid = 973 and normalized = "SCRYPT" and algType = "KEY_DERIVATION"
  or
  name = "pkcs7" and nid = 20 and normalized = "PKCS7" and algType = "SYMMETRIC_PADDING"
  or
  name = "md4" and nid = 257 and normalized = "MD4" and algType = "HASH"
  or
  name = "md5" and nid = 4 and normalized = "MD5" and algType = "HASH"
  or
  name = "sha224" and nid = 675 and normalized = "SHA224" and algType = "HASH"
  or
  name = "sha256" and nid = 672 and normalized = "SHA256" and algType = "HASH"
  or
  name = "sha384" and nid = 673 and normalized = "SHA384" and algType = "HASH"
  or
  name = "sha512" and nid = 674 and normalized = "SHA512" and algType = "HASH"
  or
  name = "sha512-224" and nid = 1094 and normalized = "SHA512224" and algType = "HASH"
  or
  name = "sha512-256" and nid = 1095 and normalized = "SHA512256" and algType = "HASH"
  or
  name = "sha3-224" and nid = 1096 and normalized = "SHA3224" and algType = "HASH"
  or
  name = "sha3-256" and nid = 1097 and normalized = "SHA3256" and algType = "HASH"
  or
  name = "sha3-384" and nid = 1098 and normalized = "SHA3384" and algType = "HASH"
  or
  name = "sha3-512" and nid = 1099 and normalized = "SHA3512" and algType = "HASH"
  or
  name = "shake128" and nid = 1100 and normalized = "SHAKE128" and algType = "HASH"
  or
  name = "shake256" and nid = 1101 and normalized = "SHAKE256" and algType = "HASH"
  or
  name = "mdc2" and nid = 95 and normalized = "MDC2" and algType = "HASH"
  or
  name = "blake2b512" and nid = 1056 and normalized = "BLAKE2B" and algType = "HASH"
  or
  name = "blake2s256" and nid = 1057 and normalized = "BLAKE2S" and algType = "HASH"
  or
  name = "sm3" and nid = 1143 and normalized = "SM3" and algType = "HASH"
  or
  name = "aes-128-cbc" and nid = 419 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-cbc" and nid = 419 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aes-128-ecb" and nid = 418 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-ecb" and nid = 418 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "aes-192-cbc" and nid = 423 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-cbc" and nid = 423 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aes-192-ecb" and nid = 422 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-ecb" and nid = 422 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "aes-256-cbc" and nid = 427 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-cbc" and nid = 427 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aes-256-ecb" and nid = 426 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-ecb" and nid = 426 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "aria-128-cbc" and nid = 1066 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aria-128-cbc" and nid = 1066 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-128-cfb" and nid = 1067 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aria-128-cfb" and nid = 1067 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-128-ctr" and nid = 1069 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "aria-128-ctr" and nid = 1069 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-128-ecb" and nid = 1065 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "aria-128-ecb" and nid = 1065 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-128-ofb" and nid = 1068 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "aria-128-ofb" and nid = 1068 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-128-cfb1" and nid = 1080 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aria-128-cfb1" and nid = 1080 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-128-cfb8" and nid = 1083 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-128-cfb8" and nid = 1083 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "aria-192-cbc" and nid = 1071 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aria-192-cbc" and nid = 1071 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-192-cfb" and nid = 1072 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aria-192-cfb" and nid = 1072 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-192-ctr" and nid = 1074 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "aria-192-ctr" and nid = 1074 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-192-ecb" and nid = 1070 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "aria-192-ecb" and nid = 1070 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-192-ofb" and nid = 1073 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "aria-192-ofb" and nid = 1073 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-192-cfb1" and nid = 1081 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aria-192-cfb1" and nid = 1081 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-192-cfb8" and nid = 1084 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-192-cfb8" and nid = 1084 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "aria-256-cbc" and nid = 1076 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aria-256-cbc" and nid = 1076 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-256-cfb" and nid = 1077 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aria-256-cfb" and nid = 1077 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-256-ctr" and nid = 1079 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "aria-256-ctr" and nid = 1079 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-256-ecb" and nid = 1075 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "aria-256-ecb" and nid = 1075 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-256-ofb" and nid = 1078 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "aria-256-ofb" and nid = 1078 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-256-cfb1" and nid = 1082 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aria-256-cfb1" and nid = 1082 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-256-cfb8" and nid = 1085 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-256-cfb8" and nid = 1085 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "camellia-128-cbc" and
  nid = 751 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-cbc" and nid = 751 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "camellia-128-ecb" and
  nid = 754 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-ecb" and nid = 754 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "camellia-192-cbc" and
  nid = 752 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-cbc" and nid = 752 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "camellia-192-ecb" and
  nid = 755 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-ecb" and nid = 755 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "camellia-256-cbc" and
  nid = 753 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-cbc" and nid = 753 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "camellia-256-ecb" and
  nid = 756 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-ecb" and nid = 756 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "rc4" and nid = 5 and normalized = "RC4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rc4-40" and nid = 97 and normalized = "RC4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ecb" and nid = 29 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ecb" and nid = 29 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "des-ede" and nid = 32 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede3" and nid = 33 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede3" and nid = 33 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "des-cbc" and nid = 31 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-cbc" and nid = 31 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "des-ede-cbc" and nid = 43 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede-cbc" and nid = 43 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "des-ede-cbc" and nid = 43 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "des-ede3-cbc" and nid = 44 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede3-cbc" and nid = 44 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "des-cfb" and nid = 30 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-cfb" and nid = 30 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "des-ede-cfb" and nid = 60 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede-cfb" and nid = 60 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "des-ede3-cfb" and nid = 61 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede3-cfb" and nid = 61 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "des-ofb" and nid = 45 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ofb" and nid = 45 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "des-ede-ofb" and nid = 62 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede-ofb" and nid = 62 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "des-ede3-ofb" and nid = 63 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede3-ofb" and nid = 63 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "idea-cbc" and nid = 34 and normalized = "IDEA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "idea-cbc" and nid = 34 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "idea-ecb" and nid = 36 and normalized = "IDEA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "idea-ecb" and nid = 36 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "idea-cfb" and nid = 35 and normalized = "IDEA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "idea-cfb" and nid = 35 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "idea-ofb" and nid = 46 and normalized = "IDEA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "idea-ofb" and nid = 46 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "seed-cbc" and nid = 777 and normalized = "SEED" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "seed-cbc" and nid = 777 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "seed-ecb" and nid = 776 and normalized = "SEED" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "seed-ecb" and nid = 776 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "seed-cfb" and nid = 779 and normalized = "SEED" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "seed-cfb" and nid = 779 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "seed-ofb" and nid = 778 and normalized = "SEED" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "seed-ofb" and nid = 778 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "rc2-cbc" and nid = 37 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rc2-cbc" and nid = 37 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "rc2-ecb" and nid = 38 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rc2-ecb" and nid = 38 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "rc2-cfb" and nid = 39 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rc2-cfb" and nid = 39 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "rc2-ofb" and nid = 40 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rc2-ofb" and nid = 40 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "rc2-64-cbc" and nid = 166 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rc2-64-cbc" and nid = 166 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "rc2-40-cbc" and nid = 98 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rc2-40-cbc" and nid = 98 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "bf-cbc" and nid = 91 and normalized = "BF" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "bf-cbc" and nid = 91 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "bf-ecb" and nid = 92 and normalized = "BF" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "bf-ecb" and nid = 92 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "bf-cfb" and nid = 93 and normalized = "BF" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "bf-cfb" and nid = 93 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "bf-ofb" and nid = 94 and normalized = "BF" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "bf-ofb" and nid = 94 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "cast5-cbc" and nid = 108 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "cast5-cbc" and nid = 108 and normalized = "CAST5" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "cast5-ecb" and nid = 109 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "cast5-ecb" and nid = 109 and normalized = "CAST5" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "cast5-cfb" and nid = 110 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "cast5-cfb" and nid = 110 and normalized = "CAST5" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "cast5-ofb" and nid = 111 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "cast5-ofb" and nid = 111 and normalized = "CAST5" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-cbc" and nid = 1134 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-cbc" and nid = 1134 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "sm4-ecb" and nid = 1133 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-ecb" and nid = 1133 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "sm4-cfb" and nid = 1137 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-cfb" and nid = 1137 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "sm4-ofb" and nid = 1135 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-ofb" and nid = 1135 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "sm4-ctr" and nid = 1139 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-ctr" and nid = 1139 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "aes-128-gcm" and nid = 895 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-gcm" and nid = 895 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "secp160r1" and nid = 709 and normalized = "SECP160R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "ripemd160" and nid = 117 and normalized = "RIPEMD160" and algType = "HASH"
  or
  name = "whirlpool" and nid = 804 and normalized = "WHIRLPOOL" and algType = "HASH"
  or
  name = "rc5-cbc" and nid = 120 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "rc5-cbc" and nid = 120 and normalized = "RC5" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pss" and nid = 435 and normalized = "PSS" and algType = "ASYMMETRIC_PADDING"
  or
  name = "id-aes128-wrap" and
  nid = 788 and
  normalized = "AES128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes192-wrap" and
  nid = 789 and
  normalized = "AES192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes256-wrap" and
  nid = 790 and
  normalized = "AES256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes128-wrap-pad" and
  nid = 897 and
  normalized = "AES128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes192-wrap-pad" and
  nid = 900 and
  normalized = "AES192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes256-wrap-pad" and
  nid = 903 and
  normalized = "AES256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "chacha20" and nid = 1019 and normalized = "CHACHA20" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "secp112r1" and nid = 704 and normalized = "SECP112R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp112r2" and nid = 705 and normalized = "SECP112R2" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp128r1" and nid = 706 and normalized = "SECP128R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp128r2" and nid = 707 and normalized = "SECP128R2" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp160k1" and nid = 708 and normalized = "SECP160K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp160r2" and nid = 710 and normalized = "SECP160R2" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp192k1" and nid = 711 and normalized = "SECP192K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp224k1" and nid = 712 and normalized = "SECP224K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp224r1" and nid = 713 and normalized = "SECP224R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp256k1" and nid = 714 and normalized = "SECP256K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp384r1" and nid = 715 and normalized = "SECP384R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "secp521r1" and nid = 716 and normalized = "SECP521R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "prime192v2" and nid = 410 and normalized = "PRIME192V2" and algType = "ELLIPTIC_CURVE"
  or
  name = "prime192v3" and nid = 411 and normalized = "PRIME192V3" and algType = "ELLIPTIC_CURVE"
  or
  name = "prime239v1" and nid = 412 and normalized = "PRIME239V1" and algType = "ELLIPTIC_CURVE"
  or
  name = "prime239v2" and nid = 413 and normalized = "PRIME239V2" and algType = "ELLIPTIC_CURVE"
  or
  name = "prime239v3" and nid = 414 and normalized = "PRIME239V3" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect113r1" and nid = 717 and normalized = "SECT113R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect113r2" and nid = 718 and normalized = "SECT113R2" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect131r1" and nid = 719 and normalized = "SECT131R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect131r2" and nid = 720 and normalized = "SECT131R2" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect163k1" and nid = 721 and normalized = "SECT163K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect163r1" and nid = 722 and normalized = "SECT163R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect163r2" and nid = 723 and normalized = "SECT163R2" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect193r1" and nid = 724 and normalized = "SECT193R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect193r2" and nid = 725 and normalized = "SECT193R2" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect233k1" and nid = 726 and normalized = "SECT233K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect233r1" and nid = 727 and normalized = "SECT233R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect239k1" and nid = 728 and normalized = "SECT239K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect283k1" and nid = 729 and normalized = "SECT283K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect283r1" and nid = 730 and normalized = "SECT283R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect409k1" and nid = 731 and normalized = "SECT409K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect409r1" and nid = 732 and normalized = "SECT409R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect571k1" and nid = 733 and normalized = "SECT571K1" and algType = "ELLIPTIC_CURVE"
  or
  name = "sect571r1" and nid = 734 and normalized = "SECT571R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2pnb163v1" and nid = 684 and normalized = "C2PNB163V1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2pnb163v2" and nid = 685 and normalized = "C2PNB163V2" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2pnb163v3" and nid = 686 and normalized = "C2PNB163V3" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2pnb176v1" and nid = 687 and normalized = "C2PNB176V1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2tnb191v1" and nid = 688 and normalized = "C2TNB191V1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2tnb191v2" and nid = 689 and normalized = "C2TNB191V2" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2tnb191v3" and nid = 690 and normalized = "C2TNB191V3" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2pnb208w1" and nid = 693 and normalized = "C2PNB208W1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2tnb239v1" and nid = 694 and normalized = "C2TNB239V1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2tnb239v2" and nid = 695 and normalized = "C2TNB239V2" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2tnb239v3" and nid = 696 and normalized = "C2TNB239V3" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2pnb272w1" and nid = 699 and normalized = "C2PNB272W1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2pnb304w1" and nid = 700 and normalized = "C2PNB304W1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2tnb359v1" and nid = 701 and normalized = "C2TNB359V1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2pnb368w1" and nid = 702 and normalized = "C2PNB368W1" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2tnb431r1" and nid = 703 and normalized = "C2TNB431R1" and algType = "ELLIPTIC_CURVE"
  or
  name = "pkcs5" and nid = 187 and normalized = "PKCS5" and algType = "KEY_DERIVATION"
  or
  name = "aes-256-gcm" and nid = 901 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-gcm" and nid = 901 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "chacha20-poly1305" and nid = 1018 and normalized = "POLY1305" and algType = "HASH"
  or
  name = "chacha20-poly1305" and
  nid = 1018 and
  normalized = "CHACHA20POLY1305" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rsadsi" and nid = 1 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "pkcs7-data" and nid = 21 and normalized = "PKCS7" and algType = "SYMMETRIC_PADDING"
  or
  name = "desx-cbc" and nid = 80 and normalized = "DESX" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "desx-cbc" and nid = 80 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "md5-sha1" and nid = 114 and normalized = "SHA1" and algType = "HASH"
  or
  name = "rc5-ecb" and nid = 121 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "rc5-ecb" and nid = 121 and normalized = "RC5" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rc5-cfb" and nid = 122 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "rc5-cfb" and nid = 122 and normalized = "RC5" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rc5-ofb" and nid = 123 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "rc5-ofb" and nid = 123 and normalized = "RC5" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-alg-des40" and nid = 323 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-alg-dh-sig-hmac-sha1" and nid = 325 and normalized = "SHA1" and algType = "HASH"
  or
  name = "aes-128-ofb" and nid = 420 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-ofb" and nid = 420 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "aes-128-cfb" and nid = 421 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-cfb" and nid = 421 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aes-192-ofb" and nid = 424 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-ofb" and nid = 424 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "aes-192-cfb" and nid = 425 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-cfb" and nid = 425 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aes-256-ofb" and nid = 428 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-ofb" and nid = 428 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "aes-256-cfb" and nid = 429 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-cfb" and nid = 429 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "des-cdmf" and nid = 643 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-cfb1" and nid = 650 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-cfb1" and nid = 650 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aes-192-cfb1" and nid = 651 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-cfb1" and nid = 651 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aes-256-cfb1" and nid = 652 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-cfb1" and nid = 652 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "aes-128-cfb8" and nid = 653 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-cfb8" and nid = 653 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "aes-192-cfb8" and nid = 654 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-cfb8" and nid = 654 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "aes-256-cfb8" and nid = 655 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-cfb8" and nid = 655 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "des-cfb1" and nid = 656 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-cfb1" and nid = 656 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "des-cfb8" and nid = 657 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-cfb8" and nid = 657 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "des-ede3-cfb1" and nid = 658 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede3-cfb1" and nid = 658 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "des-ede3-cfb8" and nid = 659 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "des-ede3-cfb8" and nid = 659 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "c2onb191v4" and nid = 691 and normalized = "C2ONB191V4" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2onb191v5" and nid = 692 and normalized = "C2ONB191V5" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2onb239v4" and nid = 697 and normalized = "C2ONB239V4" and algType = "ELLIPTIC_CURVE"
  or
  name = "c2onb239v5" and nid = 698 and normalized = "C2ONB239V5" and algType = "ELLIPTIC_CURVE"
  or
  name = "camellia-128-cfb" and
  nid = 757 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-cfb" and nid = 757 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "camellia-192-cfb" and
  nid = 758 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-cfb" and nid = 758 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "camellia-256-cfb" and
  nid = 759 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-cfb" and nid = 759 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "camellia-128-cfb1" and
  nid = 760 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-cfb1" and nid = 760 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "camellia-192-cfb1" and
  nid = 761 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-cfb1" and nid = 761 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "camellia-256-cfb1" and
  nid = 762 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-cfb1" and nid = 762 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "camellia-128-cfb8" and
  nid = 763 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-cfb8" and nid = 763 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "camellia-192-cfb8" and
  nid = 764 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-cfb8" and nid = 764 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "camellia-256-cfb8" and
  nid = 765 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-cfb8" and nid = 765 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "camellia-128-ofb" and
  nid = 766 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-ofb" and nid = 766 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "camellia-192-ofb" and
  nid = 767 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-ofb" and nid = 767 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "camellia-256-ofb" and
  nid = 768 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-ofb" and nid = 768 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "hmac-md5" and nid = 780 and normalized = "MD5" and algType = "HASH"
  or
  name = "hmac-sha1" and nid = 781 and normalized = "SHA1" and algType = "HASH"
  or
  name = "md_gost94" and nid = 809 and normalized = "GOST94" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost94" and nid = 812 and normalized = "GOST94" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost89" and nid = 813 and normalized = "GOST89" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost89-cnt" and nid = 814 and normalized = "GOST89" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost-mac" and nid = 815 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "prf-gostr3411-94" and
  nid = 816 and
  normalized = "GOSTR341194" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost94cc" and nid = 850 and normalized = "GOST94" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost2001cc" and nid = 851 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-ccm" and nid = 896 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-ccm" and nid = 896 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "aes-192-gcm" and nid = 898 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-gcm" and nid = 898 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "aes-192-ccm" and nid = 899 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-ccm" and nid = 899 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "aes-256-ccm" and nid = 902 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-ccm" and nid = 902 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "aes-128-ctr" and nid = 904 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-ctr" and nid = 904 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "aes-192-ctr" and nid = 905 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-ctr" and nid = 905 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "aes-256-ctr" and nid = 906 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-ctr" and nid = 906 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "id-camellia128-wrap" and
  nid = 907 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-camellia192-wrap" and
  nid = 908 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-camellia256-wrap" and
  nid = 909 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "mgf1" and nid = 911 and normalized = "MGF1" and algType = "HASH"
  or
  name = "aes-128-xts" and nid = 913 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-xts" and nid = 913 and normalized = "XTS" and algType = "BLOCK_MODE"
  or
  name = "aes-256-xts" and nid = 914 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-xts" and nid = 914 and normalized = "XTS" and algType = "BLOCK_MODE"
  or
  name = "rc4-hmac-md5" and nid = 915 and normalized = "MD5" and algType = "HASH"
  or
  name = "rc4-hmac-md5" and nid = 915 and normalized = "RC4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-cbc-hmac-sha1" and nid = 916 and normalized = "SHA1" and algType = "HASH"
  or
  name = "aes-128-cbc-hmac-sha1" and
  nid = 916 and
  normalized = "AES128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-cbc-hmac-sha1" and nid = 916 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aes-192-cbc-hmac-sha1" and nid = 917 and normalized = "SHA1" and algType = "HASH"
  or
  name = "aes-192-cbc-hmac-sha1" and
  nid = 917 and
  normalized = "AES192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-cbc-hmac-sha1" and nid = 917 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aes-256-cbc-hmac-sha1" and
  nid = 918 and
  normalized = "AES256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-cbc-hmac-sha1" and nid = 918 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aes-128-cbc-hmac-sha256" and nid = 948 and normalized = "SHA256" and algType = "HASH"
  or
  name = "aes-128-cbc-hmac-sha256" and
  nid = 948 and
  normalized = "AES128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-cbc-hmac-sha256" and nid = 948 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aes-192-cbc-hmac-sha256" and nid = 949 and normalized = "SHA256" and algType = "HASH"
  or
  name = "aes-192-cbc-hmac-sha256" and
  nid = 949 and
  normalized = "AES192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-cbc-hmac-sha256" and nid = 949 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aes-256-cbc-hmac-sha256" and nid = 950 and normalized = "SHA256" and algType = "HASH"
  or
  name = "aes-256-cbc-hmac-sha256" and
  nid = 950 and
  normalized = "AES256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-cbc-hmac-sha256" and nid = 950 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "aes-128-ocb" and nid = 958 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-ocb" and nid = 959 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-ocb" and nid = 960 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-gcm" and
  nid = 961 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-gcm" and nid = 961 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "camellia-128-ccm" and
  nid = 962 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-ccm" and nid = 962 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "camellia-128-ctr" and
  nid = 963 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-128-ctr" and nid = 963 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "camellia-128-cmac" and
  nid = 964 and
  normalized = "CAMELLIA128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-gcm" and
  nid = 965 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-gcm" and nid = 965 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "camellia-192-ccm" and
  nid = 966 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-ccm" and nid = 966 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "camellia-192-ctr" and
  nid = 967 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-192-ctr" and nid = 967 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "camellia-192-cmac" and
  nid = 968 and
  normalized = "CAMELLIA192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-gcm" and
  nid = 969 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-gcm" and nid = 969 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "camellia-256-ccm" and
  nid = 970 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-ccm" and nid = 970 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "camellia-256-ctr" and
  nid = 971 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "camellia-256-ctr" and nid = 971 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "camellia-256-cmac" and
  nid = 972 and
  normalized = "CAMELLIA256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-scrypt" and nid = 973 and normalized = "SCRYPT" and algType = "KEY_DERIVATION"
  or
  name = "gost89-cnt-12" and
  nid = 975 and
  normalized = "GOST89" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost-mac-12" and nid = 976 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "md_gost12_256" and nid = 982 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "md_gost12_512" and nid = 983 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-signwithdigest-gost3410-2012-256" and
  nid = 985 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-signwithdigest-gost3410-2012-512" and
  nid = 986 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-hmac-gost-3411-2012-256" and
  nid = 988 and
  normalized = "GOST34112012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-hmac-gost-3411-2012-512" and
  nid = 989 and
  normalized = "GOST34112012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-agreement-gost-3410-2012-256" and
  nid = 992 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-agreement-gost-3410-2012-512" and
  nid = 993 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-3410-2012-512-constants" and
  nid = 996 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-28147-constants" and
  nid = 1002 and
  normalized = "GOST28147" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost89-cbc" and nid = 1009 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "gost89-cbc" and nid = 1009 and normalized = "GOST89" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost89-ecb" and nid = 1010 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "gost89-ecb" and nid = 1010 and normalized = "GOST89" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost89-ctr" and nid = 1011 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "gost89-ctr" and nid = 1011 and normalized = "GOST89" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kuznyechik-ecb" and nid = 1012 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "kuznyechik-ecb" and
  nid = 1012 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kuznyechik-ctr" and nid = 1013 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "kuznyechik-ctr" and
  nid = 1013 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kuznyechik-ofb" and nid = 1014 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "kuznyechik-ofb" and
  nid = 1014 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kuznyechik-cbc" and nid = 1015 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "kuznyechik-cbc" and
  nid = 1015 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kuznyechik-cfb" and nid = 1016 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "kuznyechik-cfb" and
  nid = 1016 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kuznyechik-mac" and
  nid = 1017 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "hkdf" and nid = 1036 and normalized = "HKDF" and algType = "KEY_DERIVATION"
  or
  name = "kx-rsa" and nid = 1037 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "kx-ecdhe" and nid = 1038 and normalized = "ECDH" and algType = "KEY_EXCHANGE"
  or
  name = "kx-ecdhe-psk" and nid = 1040 and normalized = "ECDH" and algType = "KEY_EXCHANGE"
  or
  name = "kx-rsa-psk" and nid = 1042 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "kx-gost" and nid = 1045 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "auth-rsa" and nid = 1046 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "auth-ecdsa" and nid = 1047 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "auth-gost01" and nid = 1050 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "auth-gost12" and nid = 1051 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "poly1305" and nid = 1061 and normalized = "POLY1305" and algType = "HASH"
  or
  name = "hmac-sha3-224" and nid = 1102 and normalized = "SHA3224" and algType = "HASH"
  or
  name = "hmac-sha3-256" and nid = 1103 and normalized = "SHA3256" and algType = "HASH"
  or
  name = "hmac-sha3-384" and nid = 1104 and normalized = "SHA3384" and algType = "HASH"
  or
  name = "hmac-sha3-512" and nid = 1105 and normalized = "SHA3512" and algType = "HASH"
  or
  name = "id-dsa-with-sha384" and nid = 1106 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "id-dsa-with-sha384" and nid = 1106 and normalized = "SHA384" and algType = "HASH"
  or
  name = "id-dsa-with-sha512" and nid = 1107 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "id-dsa-with-sha512" and nid = 1107 and normalized = "SHA512" and algType = "HASH"
  or
  name = "id-dsa-with-sha3-224" and nid = 1108 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "id-dsa-with-sha3-224" and nid = 1108 and normalized = "SHA3224" and algType = "HASH"
  or
  name = "id-dsa-with-sha3-256" and nid = 1109 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "id-dsa-with-sha3-256" and nid = 1109 and normalized = "SHA3256" and algType = "HASH"
  or
  name = "id-dsa-with-sha3-384" and nid = 1110 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "id-dsa-with-sha3-384" and nid = 1110 and normalized = "SHA3384" and algType = "HASH"
  or
  name = "id-dsa-with-sha3-512" and nid = 1111 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "id-dsa-with-sha3-512" and nid = 1111 and normalized = "SHA3512" and algType = "HASH"
  or
  name = "id-ecdsa-with-sha3-224" and nid = 1112 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "id-ecdsa-with-sha3-224" and nid = 1112 and normalized = "SHA3224" and algType = "HASH"
  or
  name = "id-ecdsa-with-sha3-256" and nid = 1113 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "id-ecdsa-with-sha3-256" and nid = 1113 and normalized = "SHA3256" and algType = "HASH"
  or
  name = "id-ecdsa-with-sha3-384" and nid = 1114 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "id-ecdsa-with-sha3-384" and nid = 1114 and normalized = "SHA3384" and algType = "HASH"
  or
  name = "id-ecdsa-with-sha3-512" and nid = 1115 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "id-ecdsa-with-sha3-512" and nid = 1115 and normalized = "SHA3512" and algType = "HASH"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-224" and
  nid = 1116 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-224" and
  nid = 1116 and
  normalized = "PKCS1V15" and
  algType = "ASYMMETRIC_PADDING"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-224" and
  nid = 1116 and
  normalized = "SHA3224" and
  algType = "HASH"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-256" and
  nid = 1117 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-256" and
  nid = 1117 and
  normalized = "PKCS1V15" and
  algType = "ASYMMETRIC_PADDING"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-256" and
  nid = 1117 and
  normalized = "SHA3256" and
  algType = "HASH"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-384" and
  nid = 1118 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-384" and
  nid = 1118 and
  normalized = "PKCS1V15" and
  algType = "ASYMMETRIC_PADDING"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-384" and
  nid = 1118 and
  normalized = "SHA3384" and
  algType = "HASH"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-512" and
  nid = 1119 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-512" and
  nid = 1119 and
  normalized = "PKCS1V15" and
  algType = "ASYMMETRIC_PADDING"
  or
  name = "id-rsassa-pkcs1-v1_5-with-sha3-512" and
  nid = 1119 and
  normalized = "SHA3512" and
  algType = "HASH"
  or
  name = "aria-128-ccm" and nid = 1120 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "aria-128-ccm" and nid = 1120 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-192-ccm" and nid = 1121 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "aria-192-ccm" and nid = 1121 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-256-ccm" and nid = 1122 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "aria-256-ccm" and nid = 1122 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-128-gcm" and nid = 1123 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "aria-128-gcm" and nid = 1123 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-192-gcm" and nid = 1124 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "aria-192-gcm" and nid = 1124 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aria-256-gcm" and nid = 1125 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "aria-256-gcm" and nid = 1125 and normalized = "ARIA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-cfb1" and nid = 1136 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-cfb1" and nid = 1136 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "sm4-cfb8" and nid = 1138 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-cfb8" and nid = 1138 and normalized = "CFB8" and algType = "BLOCK_MODE"
  or
  name = "id-tc26-gost-3410-2012-256-constants" and
  nid = 1147 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "dstu28147-ofb" and nid = 1153 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "dstu28147-cfb" and nid = 1154 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "id-tc26-cipher-gostr3412-2015-magma" and
  nid = 1173 and
  normalized = "MAGMA" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "magma-ctr-acpkm" and nid = 1174 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "magma-ctr-acpkm" and
  nid = 1174 and
  normalized = "MAGMA" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "magma-ctr-acpkm-omac" and nid = 1175 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "magma-ctr-acpkm-omac" and
  nid = 1175 and
  normalized = "MAGMA" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-cipher-gostr3412-2015-kuznyechik" and
  nid = 1176 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kuznyechik-ctr-acpkm" and nid = 1177 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "kuznyechik-ctr-acpkm" and
  nid = 1177 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kuznyechik-ctr-acpkm-omac" and
  nid = 1178 and
  normalized = "CTR" and
  algType = "BLOCK_MODE"
  or
  name = "kuznyechik-ctr-acpkm-omac" and
  nid = 1178 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-wrap-gostr3412-2015-magma" and
  nid = 1180 and
  normalized = "MAGMA" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "magma-kexp15" and nid = 1181 and normalized = "MAGMA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-wrap-gostr3412-2015-kuznyechik" and
  nid = 1182 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kuznyechik-kexp15" and
  nid = 1183 and
  normalized = "KUZNYECHIK" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "magma-ecb" and nid = 1187 and normalized = "ECB" and algType = "BLOCK_MODE"
  or
  name = "magma-ecb" and nid = 1187 and normalized = "MAGMA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "magma-ctr" and nid = 1188 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "magma-ctr" and nid = 1188 and normalized = "MAGMA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "magma-ofb" and nid = 1189 and normalized = "OFB" and algType = "BLOCK_MODE"
  or
  name = "magma-ofb" and nid = 1189 and normalized = "MAGMA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "magma-cbc" and nid = 1190 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "magma-cbc" and nid = 1190 and normalized = "MAGMA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "magma-cfb" and nid = 1191 and normalized = "CFB" and algType = "BLOCK_MODE"
  or
  name = "magma-cfb" and nid = 1191 and normalized = "MAGMA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "magma-mac" and nid = 1192 and normalized = "MAGMA" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-siv" and nid = 1198 and normalized = "AES128" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-128-siv" and nid = 1198 and normalized = "SIV" and algType = "BLOCK_MODE"
  or
  name = "aes-192-siv" and nid = 1199 and normalized = "AES192" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-192-siv" and nid = 1199 and normalized = "SIV" and algType = "BLOCK_MODE"
  or
  name = "aes-256-siv" and nid = 1200 and normalized = "AES256" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "aes-256-siv" and nid = 1200 and normalized = "SIV" and algType = "BLOCK_MODE"
  or
  name = "blake2bmac" and nid = 1201 and normalized = "BLAKE2B" and algType = "HASH"
  or
  name = "blake2smac" and nid = 1202 and normalized = "BLAKE2S" and algType = "HASH"
  or
  name = "sshkdf" and nid = 1203 and normalized = "HKDF" and algType = "KEY_DERIVATION"
  or
  name = "x963kdf" and nid = 1206 and normalized = "X963KDF" and algType = "KEY_DERIVATION"
  or
  name = "kx-gost18" and nid = 1218 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-gcm" and nid = 1248 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-gcm" and nid = 1248 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "sm4-ccm" and nid = 1249 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-ccm" and nid = 1249 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "sm4-xts" and nid = 1290 and normalized = "SM4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "sm4-xts" and nid = 1290 and normalized = "XTS" and algType = "BLOCK_MODE"
  or
  name = "x448" and nid = 1035 and normalized = "X448" and algType = "ELLIPTIC_CURVE"
  or
  name = "x25519" and nid = 1034 and normalized = "X25519" and algType = "ELLIPTIC_CURVE"
  or
  name = "authecdsa" and nid = 1047 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "authgost01" and nid = 1050 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "authgost12" and nid = 1051 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "authrsa" and nid = 1046 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "brainpoolp160r1" and
  nid = 921 and
  normalized = "BRAINPOOLP160R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp160t1" and
  nid = 922 and
  normalized = "BRAINPOOLP160T1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp192r1" and
  nid = 923 and
  normalized = "BRAINPOOLP192R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp192t1" and
  nid = 924 and
  normalized = "BRAINPOOLP192T1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp224r1" and
  nid = 925 and
  normalized = "BRAINPOOLP224R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp224t1" and
  nid = 926 and
  normalized = "BRAINPOOLP224T1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp256r1" and
  nid = 927 and
  normalized = "BRAINPOOLP256R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp256r1tls13" and
  nid = 1285 and
  normalized = "BRAINPOOLP256R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp256t1" and
  nid = 928 and
  normalized = "BRAINPOOLP256T1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp320r1" and
  nid = 929 and
  normalized = "BRAINPOOLP320R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp320t1" and
  nid = 930 and
  normalized = "BRAINPOOLP320T1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp384r1" and
  nid = 931 and
  normalized = "BRAINPOOLP384R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp384r1tls13" and
  nid = 1286 and
  normalized = "BRAINPOOLP384R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp384t1" and
  nid = 932 and
  normalized = "BRAINPOOLP384T1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp512r1" and
  nid = 933 and
  normalized = "BRAINPOOLP512R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp512r1tls13" and
  nid = 1287 and
  normalized = "BRAINPOOLP512R1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "brainpoolp512t1" and
  nid = 934 and
  normalized = "BRAINPOOLP512T1" and
  algType = "ELLIPTIC_CURVE"
  or
  name = "dhsinglepass-cofactordh-sha1kdf-scheme" and
  nid = 941 and
  normalized = "SHA1" and
  algType = "HASH"
  or
  name = "dhsinglepass-cofactordh-sha224kdf-scheme" and
  nid = 942 and
  normalized = "SHA224" and
  algType = "HASH"
  or
  name = "dhsinglepass-cofactordh-sha256kdf-scheme" and
  nid = 943 and
  normalized = "SHA256" and
  algType = "HASH"
  or
  name = "dhsinglepass-cofactordh-sha384kdf-scheme" and
  nid = 944 and
  normalized = "SHA384" and
  algType = "HASH"
  or
  name = "dhsinglepass-cofactordh-sha512kdf-scheme" and
  nid = 945 and
  normalized = "SHA512" and
  algType = "HASH"
  or
  name = "dhsinglepass-stddh-sha1kdf-scheme" and
  nid = 936 and
  normalized = "SHA1" and
  algType = "HASH"
  or
  name = "dhsinglepass-stddh-sha224kdf-scheme" and
  nid = 937 and
  normalized = "SHA224" and
  algType = "HASH"
  or
  name = "dhsinglepass-stddh-sha256kdf-scheme" and
  nid = 938 and
  normalized = "SHA256" and
  algType = "HASH"
  or
  name = "dhsinglepass-stddh-sha384kdf-scheme" and
  nid = 939 and
  normalized = "SHA384" and
  algType = "HASH"
  or
  name = "dhsinglepass-stddh-sha512kdf-scheme" and
  nid = 940 and
  normalized = "SHA512" and
  algType = "HASH"
  or
  name = "dsa-old" and nid = 67 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa-sha" and nid = 66 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa-sha" and nid = 66 and normalized = "SHA" and algType = "HASH"
  or
  name = "dsa-sha1" and nid = 113 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa-sha1" and nid = 113 and normalized = "SHA1" and algType = "HASH"
  or
  name = "dsa-sha1-old" and nid = 70 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa-sha1-old" and nid = 70 and normalized = "SHA1" and algType = "HASH"
  or
  name = "dsa_with_sha224" and nid = 802 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa_with_sha224" and nid = 802 and normalized = "SHA224" and algType = "HASH"
  or
  name = "dsa_with_sha256" and nid = 803 and normalized = "SHA256" and algType = "HASH"
  or
  name = "dsa_with_sha256" and nid = 803 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa_with_sha3-224" and nid = 1108 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa_with_sha3-224" and nid = 1108 and normalized = "SHA3224" and algType = "HASH"
  or
  name = "dsa_with_sha3-256" and nid = 1109 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa_with_sha3-256" and nid = 1109 and normalized = "SHA3256" and algType = "HASH"
  or
  name = "dsa_with_sha3-384" and nid = 1110 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa_with_sha3-384" and nid = 1110 and normalized = "SHA3384" and algType = "HASH"
  or
  name = "dsa_with_sha3-512" and nid = 1111 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa_with_sha3-512" and nid = 1111 and normalized = "SHA3512" and algType = "HASH"
  or
  name = "dsa_with_sha384" and nid = 1106 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa_with_sha384" and nid = 1106 and normalized = "SHA384" and algType = "HASH"
  or
  name = "dsa_with_sha512" and nid = 1107 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsa_with_sha512" and nid = 1107 and normalized = "SHA512" and algType = "HASH"
  or
  name = "dsaencryption" and nid = 116 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsaencryption-old" and nid = 67 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsaquality" and nid = 495 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsawithsha" and nid = 66 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsawithsha" and nid = 66 and normalized = "SHA" and algType = "HASH"
  or
  name = "dsawithsha1" and nid = 113 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsawithsha1" and nid = 113 and normalized = "SHA1" and algType = "HASH"
  or
  name = "dsawithsha1-old" and nid = 70 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "dsawithsha1-old" and nid = 70 and normalized = "SHA1" and algType = "HASH"
  or
  name = "dstu gost 28147-2009 cfb mode" and
  nid = 1154 and
  normalized = "CFB" and
  algType = "BLOCK_MODE"
  or
  name = "dstu gost 28147-2009 cfb mode" and
  nid = 1154 and
  normalized = "GOST28147" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "dstu gost 28147-2009 ofb mode" and
  nid = 1153 and
  normalized = "OFB" and
  algType = "BLOCK_MODE"
  or
  name = "dstu gost 28147-2009 ofb mode" and
  nid = 1153 and
  normalized = "GOST28147" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "ecdsa-with-recommended" and nid = 791 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa-with-sha1" and nid = 416 and normalized = "SHA1" and algType = "HASH"
  or
  name = "ecdsa-with-sha1" and nid = 416 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa-with-sha224" and nid = 793 and normalized = "SHA224" and algType = "HASH"
  or
  name = "ecdsa-with-sha224" and nid = 793 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa-with-sha256" and nid = 794 and normalized = "SHA256" and algType = "HASH"
  or
  name = "ecdsa-with-sha256" and nid = 794 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa-with-sha384" and nid = 795 and normalized = "SHA384" and algType = "HASH"
  or
  name = "ecdsa-with-sha384" and nid = 795 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa-with-sha512" and nid = 796 and normalized = "SHA512" and algType = "HASH"
  or
  name = "ecdsa-with-sha512" and nid = 796 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa-with-specified" and nid = 792 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa_with_sha3-224" and nid = 1112 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa_with_sha3-224" and nid = 1112 and normalized = "SHA3224" and algType = "HASH"
  or
  name = "ecdsa_with_sha3-256" and nid = 1113 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa_with_sha3-256" and nid = 1113 and normalized = "SHA3256" and algType = "HASH"
  or
  name = "ecdsa_with_sha3-384" and nid = 1114 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa_with_sha3-384" and nid = 1114 and normalized = "SHA3384" and algType = "HASH"
  or
  name = "ecdsa_with_sha3-512" and nid = 1115 and normalized = "ECDSA" and algType = "SIGNATURE"
  or
  name = "ecdsa_with_sha3-512" and nid = 1115 and normalized = "SHA3512" and algType = "HASH"
  or
  name = "gost 28147-89" and
  nid = 813 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost 28147-89 cryptocom paramset" and
  nid = 849 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost 28147-89 mac" and
  nid = 815 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost 28147-89 tc26 parameter set" and
  nid = 1003 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost 34.10-2001 cryptocom" and
  nid = 851 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost 34.10-94 cryptocom" and
  nid = 850 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2001" and
  nid = 811 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2001 dh" and
  nid = 817 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 (256 bit) paramset a" and
  nid = 1148 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 (256 bit) paramset b" and
  nid = 1184 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 (256 bit) paramset c" and
  nid = 1185 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 (256 bit) paramset d" and
  nid = 1186 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 (512 bit) paramset a" and
  nid = 998 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 (512 bit) paramset b" and
  nid = 999 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 (512 bit) paramset c" and
  nid = 1149 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 (512 bit) testing parameter set" and
  nid = 997 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 with 256 bit modulus" and
  nid = 979 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 with 512 bit modulus" and
  nid = 980 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 with gost r 34.11-2012 (256 bit)" and
  nid = 985 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-2012 with gost r 34.11-2012 (512 bit)" and
  nid = 986 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-94" and
  nid = 812 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.10-94 dh" and
  nid = 818 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.11-2012 with 256 bit hash" and
  nid = 982 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.11-2012 with 512 bit hash" and
  nid = 983 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.11-94" and
  nid = 809 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.11-94 prf" and
  nid = 816 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.11-94 with gost r 34.10-2001" and
  nid = 807 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.11-94 with gost r 34.10-2001 cryptocom" and
  nid = 853 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.11-94 with gost r 34.10-94" and
  nid = 808 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 34.11-94 with gost r 34.10-94 cryptocom" and
  nid = 852 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "gost r 3410-2001 parameter set cryptocom" and
  nid = 854 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "hmac gost 34.11-2012 256 bit" and
  nid = 988 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "hmac gost 34.11-2012 512 bit" and
  nid = 989 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "hmac gost 34.11-94" and
  nid = 810 and
  normalized = "GOST" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "hmacwithmd5" and nid = 797 and normalized = "MD5" and algType = "HASH"
  or
  name = "hmacwithsha1" and nid = 163 and normalized = "SHA1" and algType = "HASH"
  or
  name = "hmacwithsha224" and nid = 798 and normalized = "SHA224" and algType = "HASH"
  or
  name = "hmacwithsha256" and nid = 799 and normalized = "SHA256" and algType = "HASH"
  or
  name = "hmacwithsha384" and nid = 800 and normalized = "SHA384" and algType = "HASH"
  or
  name = "hmacwithsha512" and nid = 801 and normalized = "SHA512" and algType = "HASH"
  or
  name = "hmacwithsha512-224" and nid = 1193 and normalized = "SHA512224" and algType = "HASH"
  or
  name = "hmacwithsha512-256" and nid = 1194 and normalized = "SHA512256" and algType = "HASH"
  or
  name = "hmacwithsm3" and nid = 1281 and normalized = "SM3" and algType = "HASH"
  or
  name = "id-aes128-ccm" and
  nid = 896 and
  normalized = "AES128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes128-ccm" and nid = 896 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "id-aes128-gcm" and
  nid = 895 and
  normalized = "AES128" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes128-gcm" and nid = 895 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "id-aes192-ccm" and
  nid = 899 and
  normalized = "AES192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes192-ccm" and nid = 899 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "id-aes192-gcm" and
  nid = 898 and
  normalized = "AES192" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes192-gcm" and nid = 898 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "id-aes256-ccm" and
  nid = 902 and
  normalized = "AES256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes256-ccm" and nid = 902 and normalized = "CCM" and algType = "BLOCK_MODE"
  or
  name = "id-aes256-gcm" and
  nid = 901 and
  normalized = "AES256" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-aes256-gcm" and nid = 901 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "id-gost28147-89-cc" and
  nid = 849 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-cryptopro-a-paramset" and
  nid = 824 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-cryptopro-b-paramset" and
  nid = 825 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-cryptopro-c-paramset" and
  nid = 826 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-cryptopro-d-paramset" and
  nid = 827 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-cryptopro-keymeshing" and
  nid = 819 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-cryptopro-oscar-1-0-paramset" and
  nid = 829 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-cryptopro-oscar-1-1-paramset" and
  nid = 828 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-cryptopro-ric-1-paramset" and
  nid = 830 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-none-keymeshing" and
  nid = 820 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gost28147-89-testparamset" and
  nid = 823 and
  normalized = "GOST2814789" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-2001-cryptopro-a-paramset" and
  nid = 840 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-2001-cryptopro-b-paramset" and
  nid = 841 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-2001-cryptopro-c-paramset" and
  nid = 842 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-2001-cryptopro-xcha-paramset" and
  nid = 843 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-2001-cryptopro-xchb-paramset" and
  nid = 844 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-2001-paramset-cc" and
  nid = 854 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-2001-testparamset" and
  nid = 839 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-2001dh" and
  nid = 817 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-a" and
  nid = 845 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-abis" and
  nid = 846 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-b" and
  nid = 847 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-bbis" and
  nid = 848 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-cryptopro-a-paramset" and
  nid = 832 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-cryptopro-b-paramset" and
  nid = 833 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-cryptopro-c-paramset" and
  nid = 834 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-cryptopro-d-paramset" and
  nid = 835 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-cryptopro-xcha-paramset" and
  nid = 836 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-cryptopro-xchb-paramset" and
  nid = 837 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-cryptopro-xchc-paramset" and
  nid = 838 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94-testparamset" and
  nid = 831 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3410-94dh" and
  nid = 818 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3411-94-cryptoproparamset" and
  nid = 822 and
  normalized = "GOSTR341194" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3411-94-testparamset" and
  nid = 821 and
  normalized = "GOSTR341194" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3411-94-with-gostr3410-2001" and
  nid = 807 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3411-94-with-gostr3410-2001-cc" and
  nid = 853 and
  normalized = "GOSTR34102001" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3411-94-with-gostr3410-94" and
  nid = 808 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3411-94-with-gostr3410-94" and
  nid = 808 and
  normalized = "GOSTR341194" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3411-94-with-gostr3410-94-cc" and
  nid = 852 and
  normalized = "GOSTR341094" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-gostr3411-94-with-gostr3410-94-cc" and
  nid = 852 and
  normalized = "GOSTR341194" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-hmacgostr3411-94" and
  nid = 810 and
  normalized = "GOSTR341194" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-hmacwithsha3-224" and nid = 1102 and normalized = "SHA3224" and algType = "HASH"
  or
  name = "id-hmacwithsha3-256" and nid = 1103 and normalized = "SHA3256" and algType = "HASH"
  or
  name = "id-hmacwithsha3-384" and nid = 1104 and normalized = "SHA3384" and algType = "HASH"
  or
  name = "id-hmacwithsha3-512" and nid = 1105 and normalized = "SHA3512" and algType = "HASH"
  or
  name = "id-regctrl" and nid = 313 and normalized = "CTR" and algType = "BLOCK_MODE"
  or
  name = "id-smime-alg-3deswrap" and
  nid = 243 and
  normalized = "3DES" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-smime-alg-cms3deswrap" and nid = 246 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "id-smime-alg-cms3deswrap" and
  nid = 246 and
  normalized = "3DES" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-smime-alg-cmsrc2wrap" and
  nid = 247 and
  normalized = "RC2" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-smime-alg-cmsrc2wrap" and nid = 247 and normalized = "GCM" and algType = "BLOCK_MODE"
  or
  name = "id-smime-alg-esdhwith3des" and
  nid = 241 and
  normalized = "3DES" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-smime-alg-esdhwithrc2" and
  nid = 242 and
  normalized = "RC2" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-smime-alg-rc2wrap" and
  nid = 244 and
  normalized = "RC2" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-28147-param-z" and
  nid = 1003 and
  normalized = "GOST28147" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-3410-2012-256-paramseta" and
  nid = 1148 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-3410-2012-256-paramsetb" and
  nid = 1184 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-3410-2012-256-paramsetc" and
  nid = 1185 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-3410-2012-256-paramsetd" and
  nid = 1186 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-3410-2012-512-paramseta" and
  nid = 998 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-3410-2012-512-paramsetb" and
  nid = 999 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-3410-2012-512-paramsetc" and
  nid = 1149 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "id-tc26-gost-3410-2012-512-paramsettest" and
  nid = 997 and
  normalized = "GOST34102012" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kxecdhe" and nid = 1038 and normalized = "ECDH" and algType = "KEY_EXCHANGE"
  or
  name = "kxecdhe-psk" and nid = 1040 and normalized = "ECDH" and algType = "KEY_EXCHANGE"
  or
  name = "kxgost" and nid = 1045 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kxgost18" and nid = 1218 and normalized = "GOST" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "kxrsa" and nid = 1037 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "kxrsa_psk" and nid = 1042 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "md2withrsaencryption" and
  nid = 7 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "md2withrsaencryption" and nid = 7 and normalized = "MD2" and algType = "HASH"
  or
  name = "md4withrsaencryption" and
  nid = 396 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "md4withrsaencryption" and nid = 396 and normalized = "MD4" and algType = "HASH"
  or
  name = "md5withrsa" and nid = 104 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "md5withrsa" and nid = 104 and normalized = "MD5" and algType = "HASH"
  or
  name = "md5withrsaencryption" and
  nid = 8 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "md5withrsaencryption" and nid = 8 and normalized = "MD5" and algType = "HASH"
  or
  name = "mdc2withrsa" and nid = 96 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "mdc2withrsa" and nid = 96 and normalized = "MDC2" and algType = "HASH"
  or
  name = "pbe-md2-des" and nid = 9 and normalized = "MD2" and algType = "HASH"
  or
  name = "pbe-md2-des" and nid = 9 and normalized = "2DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-md2-rc2-64" and nid = 168 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-md2-rc2-64" and nid = 168 and normalized = "MD2" and algType = "HASH"
  or
  name = "pbe-md5-des" and nid = 10 and normalized = "MD5" and algType = "HASH"
  or
  name = "pbe-md5-des" and nid = 10 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-md5-rc2-64" and nid = 169 and normalized = "MD5" and algType = "HASH"
  or
  name = "pbe-md5-rc2-64" and nid = 169 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-sha1-2des" and nid = 147 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbe-sha1-2des" and nid = 147 and normalized = "2DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-sha1-3des" and nid = 146 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbe-sha1-3des" and nid = 146 and normalized = "3DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-sha1-des" and nid = 170 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbe-sha1-des" and nid = 170 and normalized = "DES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-sha1-rc2-128" and nid = 148 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbe-sha1-rc2-128" and
  nid = 148 and
  normalized = "RC2" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-sha1-rc2-40" and nid = 149 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbe-sha1-rc2-40" and nid = 149 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-sha1-rc2-64" and nid = 68 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbe-sha1-rc2-64" and nid = 68 and normalized = "RC2" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-sha1-rc4-128" and nid = 144 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbe-sha1-rc4-128" and
  nid = 144 and
  normalized = "RC4" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbe-sha1-rc4-40" and nid = 145 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbe-sha1-rc4-40" and nid = 145 and normalized = "RC4" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithmd2anddes-cbc" and
  nid = 9 and
  normalized = "DES" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithmd2anddes-cbc" and nid = 9 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "pbewithmd2anddes-cbc" and nid = 9 and normalized = "MD2" and algType = "HASH"
  or
  name = "pbewithmd2andrc2-cbc" and
  nid = 168 and
  normalized = "RC2" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithmd2andrc2-cbc" and nid = 168 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "pbewithmd2andrc2-cbc" and nid = 168 and normalized = "MD2" and algType = "HASH"
  or
  name = "pbewithmd5andcast5cbc" and nid = 112 and normalized = "MD5" and algType = "HASH"
  or
  name = "pbewithmd5andcast5cbc" and nid = 112 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "pbewithmd5andcast5cbc" and
  nid = 112 and
  normalized = "CAST5" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithmd5anddes-cbc" and nid = 10 and normalized = "MD5" and algType = "HASH"
  or
  name = "pbewithmd5anddes-cbc" and
  nid = 10 and
  normalized = "DES" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithmd5anddes-cbc" and nid = 10 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "pbewithmd5andrc2-cbc" and nid = 169 and normalized = "MD5" and algType = "HASH"
  or
  name = "pbewithmd5andrc2-cbc" and
  nid = 169 and
  normalized = "RC2" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithmd5andrc2-cbc" and nid = 169 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "pbewithsha1and128bitrc2-cbc" and nid = 148 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbewithsha1and128bitrc2-cbc" and
  nid = 148 and
  normalized = "RC2" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithsha1and128bitrc2-cbc" and
  nid = 148 and
  normalized = "CBC" and
  algType = "BLOCK_MODE"
  or
  name = "pbewithsha1and128bitrc4" and nid = 144 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbewithsha1and128bitrc4" and
  nid = 144 and
  normalized = "RC4" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithsha1and2-keytripledes-cbc" and
  nid = 147 and
  normalized = "SHA1" and
  algType = "HASH"
  or
  name = "pbewithsha1and2-keytripledes-cbc" and
  nid = 147 and
  normalized = "CBC" and
  algType = "BLOCK_MODE"
  or
  name = "pbewithsha1and2-keytripledes-cbc" and
  nid = 147 and
  normalized = "TRIPLEDES" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithsha1and3-keytripledes-cbc" and
  nid = 146 and
  normalized = "SHA1" and
  algType = "HASH"
  or
  name = "pbewithsha1and3-keytripledes-cbc" and
  nid = 146 and
  normalized = "CBC" and
  algType = "BLOCK_MODE"
  or
  name = "pbewithsha1and3-keytripledes-cbc" and
  nid = 146 and
  normalized = "TRIPLEDES" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithsha1and40bitrc2-cbc" and nid = 149 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbewithsha1and40bitrc2-cbc" and
  nid = 149 and
  normalized = "RC2" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithsha1and40bitrc2-cbc" and
  nid = 149 and
  normalized = "CBC" and
  algType = "BLOCK_MODE"
  or
  name = "pbewithsha1and40bitrc4" and nid = 145 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbewithsha1and40bitrc4" and
  nid = 145 and
  normalized = "RC4" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithsha1anddes-cbc" and nid = 170 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbewithsha1anddes-cbc" and
  nid = 170 and
  normalized = "DES" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithsha1anddes-cbc" and nid = 170 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "pbewithsha1andrc2-cbc" and nid = 68 and normalized = "SHA1" and algType = "HASH"
  or
  name = "pbewithsha1andrc2-cbc" and
  nid = 68 and
  normalized = "RC2" and
  algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "pbewithsha1andrc2-cbc" and nid = 68 and normalized = "CBC" and algType = "BLOCK_MODE"
  or
  name = "pilotdsa" and nid = 456 and normalized = "DSA" and algType = "SIGNATURE"
  or
  name = "pkcs7-digestdata" and nid = 25 and normalized = "PKCS7" and algType = "SYMMETRIC_PADDING"
  or
  name = "pkcs7-encrypteddata" and
  nid = 26 and
  normalized = "PKCS7" and
  algType = "SYMMETRIC_PADDING"
  or
  name = "pkcs7-envelopeddata" and
  nid = 23 and
  normalized = "PKCS7" and
  algType = "SYMMETRIC_PADDING"
  or
  name = "pkcs7-signedandenvelopeddata" and
  nid = 24 and
  normalized = "PKCS7" and
  algType = "SYMMETRIC_PADDING"
  or
  name = "pkcs7-signeddata" and nid = 22 and normalized = "PKCS7" and algType = "SYMMETRIC_PADDING"
  or
  name = "ripemd160withrsa" and
  nid = 119 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "ripemd160withrsa" and nid = 119 and normalized = "RIPEMD160" and algType = "HASH"
  or
  name = "rsa-md2" and nid = 7 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-md2" and nid = 7 and normalized = "MD2" and algType = "HASH"
  or
  name = "rsa-md4" and nid = 396 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-md4" and nid = 396 and normalized = "MD4" and algType = "HASH"
  or
  name = "rsa-md5" and nid = 8 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-md5" and nid = 8 and normalized = "MD5" and algType = "HASH"
  or
  name = "rsa-mdc2" and nid = 96 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-mdc2" and nid = 96 and normalized = "MDC2" and algType = "HASH"
  or
  name = "rsa-np-md5" and nid = 104 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-np-md5" and nid = 104 and normalized = "MD5" and algType = "HASH"
  or
  name = "rsa-ripemd160" and nid = 119 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-ripemd160" and nid = 119 and normalized = "RIPEMD160" and algType = "HASH"
  or
  name = "rsa-sha" and nid = 42 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha" and nid = 42 and normalized = "SHA" and algType = "HASH"
  or
  name = "rsa-sha1" and nid = 65 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha1" and nid = 65 and normalized = "SHA1" and algType = "HASH"
  or
  name = "rsa-sha1-2" and nid = 115 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha1-2" and nid = 115 and normalized = "SHA1" and algType = "HASH"
  or
  name = "rsa-sha224" and nid = 671 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha224" and nid = 671 and normalized = "SHA224" and algType = "HASH"
  or
  name = "rsa-sha256" and nid = 668 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha256" and nid = 668 and normalized = "SHA256" and algType = "HASH"
  or
  name = "rsa-sha3-224" and nid = 1116 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha3-224" and nid = 1116 and normalized = "SHA3224" and algType = "HASH"
  or
  name = "rsa-sha3-256" and nid = 1117 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha3-256" and nid = 1117 and normalized = "SHA3256" and algType = "HASH"
  or
  name = "rsa-sha3-384" and nid = 1118 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha3-384" and nid = 1118 and normalized = "SHA3384" and algType = "HASH"
  or
  name = "rsa-sha3-512" and nid = 1119 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha3-512" and nid = 1119 and normalized = "SHA3512" and algType = "HASH"
  or
  name = "rsa-sha384" and nid = 669 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha384" and nid = 669 and normalized = "SHA384" and algType = "HASH"
  or
  name = "rsa-sha512" and nid = 670 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha512" and nid = 670 and normalized = "SHA512" and algType = "HASH"
  or
  name = "rsa-sha512/224" and
  nid = 1145 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha512/224" and nid = 1145 and normalized = "SHA512224" and algType = "HASH"
  or
  name = "rsa-sha512/256" and
  nid = 1146 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sha512/256" and nid = 1146 and normalized = "SHA512256" and algType = "HASH"
  or
  name = "rsa-sm3" and nid = 1144 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsa-sm3" and nid = 1144 and normalized = "SM3" and algType = "HASH"
  or
  name = "rsaencryption" and nid = 6 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsaes-oaep" and nid = 919 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsaes-oaep" and nid = 919 and normalized = "AES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rsaes-oaep" and nid = 919 and normalized = "OAEP" and algType = "ASYMMETRIC_PADDING"
  or
  name = "rsaesoaep" and nid = 919 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsaesoaep" and nid = 919 and normalized = "AES" and algType = "SYMMETRIC_ENCRYPTION"
  or
  name = "rsaesoaep" and nid = 919 and normalized = "OAEP" and algType = "ASYMMETRIC_PADDING"
  or
  name = "rsaoaepencryptionset" and
  nid = 644 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsaoaepencryptionset" and
  nid = 644 and
  normalized = "OAEP" and
  algType = "ASYMMETRIC_PADDING"
  or
  name = "rsasignature" and nid = 377 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsassa-pss" and nid = 912 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsassa-pss" and nid = 912 and normalized = "PSS" and algType = "ASYMMETRIC_PADDING"
  or
  name = "rsassapss" and nid = 912 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "rsassapss" and nid = 912 and normalized = "PSS" and algType = "ASYMMETRIC_PADDING"
  or
  name = "sha1withrsa" and nid = 115 and normalized = "RSA" and algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "sha1withrsa" and nid = 115 and normalized = "SHA1" and algType = "HASH"
  or
  name = "sha1withrsaencryption" and
  nid = 65 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "sha1withrsaencryption" and nid = 65 and normalized = "SHA1" and algType = "HASH"
  or
  name = "sha224withrsaencryption" and
  nid = 671 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "sha224withrsaencryption" and nid = 671 and normalized = "SHA224" and algType = "HASH"
  or
  name = "sha256withrsaencryption" and
  nid = 668 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "sha256withrsaencryption" and nid = 668 and normalized = "SHA256" and algType = "HASH"
  or
  name = "sha384withrsaencryption" and
  nid = 669 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "sha384withrsaencryption" and nid = 669 and normalized = "SHA384" and algType = "HASH"
  or
  name = "sha512-224withrsaencryption" and
  nid = 1145 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "sha512-224withrsaencryption" and
  nid = 1145 and
  normalized = "SHA512224" and
  algType = "HASH"
  or
  name = "sha512-256withrsaencryption" and
  nid = 1146 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "sha512-256withrsaencryption" and
  nid = 1146 and
  normalized = "SHA512256" and
  algType = "HASH"
  or
  name = "sha512withrsaencryption" and
  nid = 670 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "sha512withrsaencryption" and nid = 670 and normalized = "SHA512" and algType = "HASH"
  or
  name = "shawithrsaencryption" and
  nid = 42 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "shawithrsaencryption" and nid = 42 and normalized = "SHA" and algType = "HASH"
  or
  name = "sm2" and nid = 1172 and normalized = "SM2" and algType = "ELLIPTIC_CURVE"
  or
  name = "sm2-sm3" and nid = 1204 and normalized = "SM3" and algType = "HASH"
  or
  name = "sm2-sm3" and nid = 1204 and normalized = "SM2" and algType = "ELLIPTIC_CURVE"
  or
  name = "sm2-with-sm3" and nid = 1204 and normalized = "SM3" and algType = "HASH"
  or
  name = "sm2-with-sm3" and nid = 1204 and normalized = "SM2" and algType = "ELLIPTIC_CURVE"
  or
  name = "sm3withrsaencryption" and
  nid = 1144 and
  normalized = "RSA" and
  algType = "ASYMMETRIC_ENCRYPTION"
  or
  name = "sm3withrsaencryption" and nid = 1144 and normalized = "SM3" and algType = "HASH"
}
