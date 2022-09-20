typealias Hasher = Crypto.SHA512

func checkCertificate(cert: Array[UInt8], hash: Array[UInt8]) -> Bool
  return Hasher.hash(data: cert) == hash  // GOOD
