typealias Hasher = Crypto.Insecure.MD5

func checkCertificate(cert: Array[UInt8], hash: Array[UInt8]) -> Bool
  return Hasher.hash(data: cert) == hash  // BAD
}
