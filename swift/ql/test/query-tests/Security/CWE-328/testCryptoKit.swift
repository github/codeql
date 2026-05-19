//codeql-extractor-options: -module-name Crypto

// --- stubs ---

class Data
{
    init<S>(_ elements: S) {}
}

public protocol HashFunction {
    associatedtype Digest

    init()
    mutating func update(bufferPointer: UnsafeRawBufferPointer)
    func finalize() -> Digest
}

extension HashFunction {
    @inlinable
    public static func hash(bufferPointer: UnsafeRawBufferPointer) -> Digest {
        var hasher = Self()
        hasher.update(bufferPointer: bufferPointer)
        return hasher.finalize()
    }

    @inlinable
    public static func hash<D>(data: D) -> Self.Digest {
        var hasher = Self()
        hasher.update(data: data)
        return hasher.finalize()
    }

    @inlinable
    public mutating func update<D>(data: D) {
        // ...
    }
}

public struct SHA256: HashFunction {
    public typealias Digest = [UInt8]

    public init() {}
    public mutating func update(bufferPointer: UnsafeRawBufferPointer) {}
    public func finalize() -> Digest { return [] }
}

public struct SHA384: HashFunction {
    public typealias Digest = [UInt8]

    public init() {}
    public mutating func update(bufferPointer: UnsafeRawBufferPointer) {}
    public func finalize() -> Digest { return [] }
}

public struct SHA512: HashFunction {
    public typealias Digest = [UInt8]

    public init() {}
    public mutating func update(bufferPointer: UnsafeRawBufferPointer) {}
    public func finalize() -> Digest { return [] }
}

enum Insecure {
    public struct MD5: HashFunction {
        public typealias Digest = [UInt8]

        public init() {}
        public mutating func update(bufferPointer: UnsafeRawBufferPointer) {}
        public func finalize() -> Digest { return [] }
    }

    public struct SHA1: HashFunction {
        public typealias Digest = [UInt8]

        public init() {}
        public mutating func update(bufferPointer: UnsafeRawBufferPointer) {}
        public func finalize() -> Digest { return [] }
    }
}

// --- tests ---

func testHashMethods(passwd : UnsafeRawBufferPointer, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.MD5.hash(data: passwd)  // BAD [NOT DETECTED]
    hash = Crypto.Insecure.MD5.hash(data: cert)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.MD5.hash(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash = Crypto.Insecure.MD5.hash(data: account_no)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.MD5.hash(data: credit_card_no)   // BAD [NOT DETECTED]

    hash = Insecure.MD5.hash(data: passwd)  // BAD [NOT DETECTED]
    hash = Insecure.MD5.hash(data: cert)   // BAD [NOT DETECTED]
    hash = Insecure.MD5.hash(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash = Insecure.MD5.hash(data: account_no)   // BAD [NOT DETECTED]
    hash = Insecure.MD5.hash(data: credit_card_no)   // BAD [NOT DETECTED]

    hash = Crypto.Insecure.SHA1.hash(data: passwd)  // BAD [NOT DETECTED]
    hash = Crypto.Insecure.SHA1.hash(data: cert)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.SHA1.hash(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash = Crypto.Insecure.SHA1.hash(data: account_no)   // BAD [NOT DETECTED]
    hash = Crypto.Insecure.SHA1.hash(data: credit_card_no)   // BAD [NOT DETECTED]

    hash = Crypto.SHA256.hash(data: passwd)   // BAD, not a computationally expensive hash [NOT DETECTED]
    hash = Crypto.SHA256.hash(data: cert)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA256.hash(data: encrypted_passwd)   // GOOD, not sensitive
    hash = Crypto.SHA256.hash(data: account_no)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA256.hash(data: credit_card_no)   // GOOD, computationally expensive hash not required

    hash = Crypto.SHA384.hash(data: passwd)   // BAD, not a computationally expensive hash [NOT DETECTED]
    hash = Crypto.SHA384.hash(data: cert)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA384.hash(data: encrypted_passwd)   // GOOD, not sensitive
    hash = Crypto.SHA384.hash(data: account_no)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA384.hash(data: credit_card_no)   // GOOD, computationally expensive hash not required

    hash = Crypto.SHA512.hash(data: passwd)   // BAD, not a computationally expensive hash [NOT DETECTED]
    hash = Crypto.SHA512.hash(data: cert)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA512.hash(data: encrypted_passwd)   // GOOD, not sensitive
    hash = Crypto.SHA512.hash(data: account_no)   // GOOD, computationally expensive hash not required
    hash = Crypto.SHA512.hash(data: credit_card_no)   // GOOD, computationally expensive hash not required
}

func testMD5UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.MD5()
    hash.update(data: passwd)  // BAD [NOT DETECTED]
    hash.update(data: cert)  // BAD [NOT DETECTED]
    hash.update(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(data: account_no)   // BAD [NOT DETECTED]
    hash.update(data: credit_card_no)   // BAD [NOT DETECTED]
}

func testSHA1UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.Insecure.SHA1()
    hash.update(data: passwd)  // BAD [NOT DETECTED]
    hash.update(data: cert)  // BAD [NOT DETECTED]
    hash.update(data: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(data: account_no)   // BAD [NOT DETECTED]
    hash.update(data: credit_card_no)   // BAD [NOT DETECTED]
}

func testSHA256UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.SHA256()
    hash.update(data: passwd)  // BAD, not a computationally expensive hash [NOT DETECTED]
    hash.update(data: cert)  // GOOD
    hash.update(data: encrypted_passwd)   // GOOD  (not sensitive)
    hash.update(data: account_no)   // GOOD
    hash.update(data: credit_card_no)   // GOOD
}

func testSHA384UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.SHA384()
    hash.update(data: passwd)  // BAD, not a computationally expensive hash [NOT DETECTED]
    hash.update(data: cert)  // GOOD
    hash.update(data: encrypted_passwd)   // GOOD  (not sensitive)
    hash.update(data: account_no)   // GOOD
    hash.update(data: credit_card_no)   // GOOD
}

func testSHA512UpdateWithData(passwd : String, cert: String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
    var hash = Crypto.SHA512()
    hash.update(data: passwd)  // BAD, not a computationally expensive hash [NOT DETECTED]
    hash.update(data: cert)  // GOOD
    hash.update(data: encrypted_passwd)   // GOOD  (not sensitive)
    hash.update(data: account_no)   // GOOD
    hash.update(data: credit_card_no)   // GOOD
}

func testMD5UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.Insecure.MD5()
    hash.update(bufferPointer: passwd)  // BAD
    hash.update(bufferPointer: cert)  // BAD
    hash.update(bufferPointer: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(bufferPointer: account_no)   // BAD
    hash.update(bufferPointer: credit_card_no)   // BAD
}

func testSHA1UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.Insecure.SHA1()
    hash.update(bufferPointer: passwd)  // BAD
    hash.update(bufferPointer: cert)  // BAD
    hash.update(bufferPointer: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(bufferPointer: account_no)   // BAD
    hash.update(bufferPointer: credit_card_no)   // BAD
}

func testSHA256UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.SHA256()
    hash.update(bufferPointer: passwd)  // BAD, not a computationally expensive hash
    hash.update(bufferPointer: cert)  // GOOD
    hash.update(bufferPointer: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(bufferPointer: account_no)   // GOOD
    hash.update(bufferPointer: credit_card_no)   // GOOD
}

func testSHA384UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.SHA384()
    hash.update(bufferPointer: passwd)  // BAD, not a computationally expensive hash
    hash.update(bufferPointer: cert)  // GOOD
    hash.update(bufferPointer: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(bufferPointer: account_no)   // GOOD
    hash.update(bufferPointer: credit_card_no)   // GOOD
}

func testSHA512UpdateWithUnsafeRawBufferPointer(passwd : UnsafeRawBufferPointer, cert: UnsafeRawBufferPointer, encrypted_passwd : UnsafeRawBufferPointer, account_no : UnsafeRawBufferPointer, credit_card_no : UnsafeRawBufferPointer) {
    var hash = Crypto.SHA512()
    hash.update(bufferPointer: passwd)  // BAD, not a computationally expensive hash
    hash.update(bufferPointer: cert)  // GOOD
    hash.update(bufferPointer: encrypted_passwd)  // GOOD  (not sensitive)
    hash.update(bufferPointer: account_no)   // GOOD
    hash.update(bufferPointer: credit_card_no)   // GOOD
}

func testBadExample(passwordString: String) {
    // this is the "bad" example from the .qhelp
    let passwordData = Data(passwordString.utf8)
    let passwordHash = Crypto.SHA512.hash(data: passwordData) // BAD, not a computationally expensive hash [NOT DETECTED]

    // ...

    if Crypto.SHA512.hash(data: Data(passwordString.utf8)) == passwordHash { // BAD, not a computationally expensive hash [NOT DETECTED]
	    // ...
    }
}
