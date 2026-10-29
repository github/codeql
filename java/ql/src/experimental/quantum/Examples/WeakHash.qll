import experimental.quantum.Language

predicate isUnapprovedHash(Crypto::HashAlgorithmNode alg, Crypto::HashType htype, string msg) {
  htype = alg.getHashType() and
  (
    (htype != Crypto::SHA2() and htype != Crypto::SHA3()) and
    msg = "Use of unapproved hash algorithm or API: " + htype.toString() + "."
    or
    (htype = Crypto::SHA2() or htype = Crypto::SHA3()) and
    not exists(alg.getDigestLength()) and
    msg =
      "Use of approved hash algorithm or API type " + htype.toString() + " but unknown digest size."
    or
    exists(int digestLength |
      digestLength = alg.getDigestLength() and
      (htype = Crypto::SHA2() or htype = Crypto::SHA3()) and
      digestLength < 256 and
      msg =
        "Use of approved hash algorithm or API type " + htype.toString() + " but weak digest size ("
          + digestLength + ")."
    )
  )
}
