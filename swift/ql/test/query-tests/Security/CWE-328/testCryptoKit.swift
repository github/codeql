//codeql-extractor-options: -module-name Crypto

struct SHA256 {
    static func hash<D>(data: D) -> [UInt8] {
        return []
    }

    func update<D>(data: D) {}
    func update(bufferPointer: UnsafeRawBufferPointer) {}
    func finalize() -> [UInt8] { return [] }
}

struct SHA384 {
    static func hash<D>(data: D) -> [UInt8] {
        return []
    }

    func update<D>(data: D) {}
    func update(bufferPointer: UnsafeRawBufferPointer) {}
    func finalize() -> [UInt8] { return [] }
}

struct SHA512 {
    static func hash<D>(data: D) -> [UInt8] {
        return []
    }

    func update<D>(data: D) {}
    func update(bufferPointer: UnsafeRawBufferPointer) {}
    func finalize() -> [UInt8] { return [] }
}


enum Insecure {
    struct MD5 {
        static func hash<D>(data: D) -> [UInt8] {
            return []
        }

        func update<D>(data: D) {}
        func update(bufferPointer: UnsafeRawBufferPointer) {}
        func finalize() -> [UInt8] { return [] }
    }
    struct SHA1 {
        static func hash<D>(data: D) -> [UInt8] {
            return []
        }

        func update<D>(data: D) {}
        func update(bufferPointer: UnsafeRawBufferPointer) {}
        func finalize() -> [UInt8] { return [] }
    }
}

func testHashMethods(passwd : UnsafeRawBufferPointer, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.MD5.hash(data: passwd)  // BAD
    hash = Crypto.Insecure.MD5.hash(data: cert)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.MD5.hash(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash = Crypto.Insecure.MD5.hash(data: account_no)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.MD5.hash(data: credit_card_no)   // BAD
    hash = Crypto.Insecure.MD5.hash(data: credit_card_no)   // BAD

    hash = Crypto.Insecure.SHA1.hash(data: passwd)  // BAD
    hash = Crypto.Insecure.SHA1.hash(data: cert)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.SHA1.hash(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash = Crypto.Insecure.SHA1.hash(data: account_no)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.SHA1.hash(data: credit_card_no)   // BAD

    hash = Crypto.SHA256.hash(data: passwd)   // BAD [NOT DETECTED] not a computationally expensive hash
    hash = Crypto.SHA256.hash(data: cert)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA256.hash(data: account_no)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA256.hash(data: credit_card_no)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA256.hash(data: credit_card_no)   // GOOD, computationally expensive hash not required

    hash = Crypto.SHA384.hash(data: passwd)   // BAD [NOT DETECTED] not a computationally expensive hash
    hash = Crypto.SHA384.hash(data: cert)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA384.hash(data: account_no)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA384.hash(data: credit_card_no)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA384.hash(data: credit_card_no)   // GOOD, computationally expensive hash not required

    hash = Crypto.SHA512.hash(data: passwd)   // BAD [NOT DETECTED] not a computationally expensive hash
    hash = Crypto.SHA512.hash(data: cert)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA512.hash(data: account_no)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA512.hash(data: credit_card_no)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA512.hash(data: credit_card_no)   // GOOD, computationally expensive hash not required
}

func testMD5UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.MD5()
    hash.update(data: passwd)  // BAD
    hash.update(data: cert)  // BAD [NOT DETECTED]
    hash.update(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(data: account_no)   // BAD [NOT DETECTED]
    hash.update(data: credit_card_no)   // BAD
}

func testSHA1UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.SHA1()
    hash.update(data: passwd)  // BAD
    hash.update(data: cert)  // BAD [NOT DETECTED]
    hash.update(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(data: account_no)   // BAD [NOT DETECTED]
    hash.update(data: credit_card_no)   // BAD
}

func testSHA256UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.SHA256()
    hash.update(data: passwd)  // BAD [NOT DETECTED] not a computationally expensive hash
    hash.update(data: cert)  // GOOD
    hash.update(data: account_no)   // GOOD
    hash.update(data: credit_card_no)   // GOOD
}

func testSHA384UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.SHA384()
    hash.update(data: passwd)  // BAD [NOT DETECTED] not a computationally expensive hash
    hash.update(data: cert)  // GOOD
    hash.update(data: account_no)   // GOOD
    hash.update(data: credit_card_no)   // GOOD
}

func testSHA512UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.SHA512()
    hash.update(data: passwd)  // BAD [NOT DETECTED] not a computationally expensive hash
    hash.update(data: cert)  // GOOD
    hash.update(data: account_no)   // GOOD
    hash.update(data: credit_card_no)   // GOOD
}

func testMD5UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.Insecure.MD5()
    hash.update(bufferPointer: passwd)  // BAD
    hash.update(bufferPointer: cert)  // BAD [NOT DETECTED]
    hash.update(bufferPointer: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(bufferPointer: account_no)   // BAD [NOT DETECTED]
    hash.update(bufferPointer: credit_card_no)   // BAD
}

func testSHA1UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.Insecure.SHA1()
    hash.update(bufferPointer: passwd)  // BAD
    hash.update(bufferPointer: cert)  // BAD [NOT DETECTED]
    hash.update(bufferPointer: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(bufferPointer: account_no)   // BAD [NOT DETECTED]
    hash.update(bufferPointer: credit_card_no)   // BAD
}

func testSHA256UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.SHA256()
    hash.update(bufferPointer: passwd)  // BAD [NOT DETECTED] not a computationally expensive hash
    hash.update(bufferPointer: cert)  // GOOD
    hash.update(bufferPointer: account_no)   // GOOD
    hash.update(bufferPointer: credit_card_no)   // GOOD
}

func testSHA384UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.SHA384()
    hash.update(bufferPointer: passwd)  // BAD [NOT DETECTED] not a computationally expensive hash
    hash.update(bufferPointer: cert)  // GOOD
    hash.update(bufferPointer: account_no)   // GOOD
    hash.update(bufferPointer: credit_card_no)   // GOOD
}

func testSHA512UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.SHA512()
    hash.update(bufferPointer: passwd)  // BAD [NOT DETECTED] not a computationally expensive hash
    hash.update(bufferPointer: cert)  // GOOD
    hash.update(bufferPointer: account_no)   // GOOD
    hash.update(bufferPointer: credit_card_no)   // GOOD
}
