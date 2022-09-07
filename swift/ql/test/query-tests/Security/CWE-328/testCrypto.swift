//codeql-extractor-options: -module-name Crypto

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

func test1(passwd : UnsafeRawBufferPointer, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.MD5.hash(data: passwd)  // BAD
    hash = Crypto.Insecure.MD5.hash(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash = Crypto.Insecure.MD5.hash(data: account_no)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.MD5.hash(data: credit_card_no)   // BAD
}

func test2(passwd : String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.SHA1.hash(data: passwd)  // BAD
    hash = Crypto.Insecure.SHA1.hash(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash = Crypto.Insecure.SHA1.hash(data: account_no)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.SHA1.hash(data: credit_card_no)   // BAD
}

func test3(passwd : String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.MD5()
    hash.update(data: passwd)  // BAD
    hash.update(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(data: account_no)   // BAD [NOT DETECTED]
    hash.update(data: credit_card_no)   // BAD
}

func test4(passwd : String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.SHA1()
    hash.update(data: passwd)  // BAD
    hash.update(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(data: account_no)   // BAD [NOT DETECTED]
    hash.update(data: credit_card_no)   // BAD
}

func test5(passwd : UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.Insecure.MD5()
    hash.update(bufferPointer: passwd)  // BAD
    hash.update(bufferPointer: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(bufferPointer: account_no)   // BAD [NOT DETECTED]
    hash.update(bufferPointer: credit_card_no)   // BAD
}

func test6(passwd : UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.Insecure.SHA1()
    hash.update(bufferPointer: passwd)  // BAD
    hash.update(bufferPointer: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(bufferPointer: account_no)   // BAD [NOT DETECTED]
    hash.update(bufferPointer: credit_card_no)   // BAD
}
