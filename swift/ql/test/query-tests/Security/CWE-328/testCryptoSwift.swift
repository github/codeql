
// --- stubs ---

class Data
{
    init<S>(_ elements: S) {}
}

protocol DigestType {
    func calculate(for bytes: Array<UInt8>) -> Array<UInt8>
}

class MD5 : DigestType {
    public func calculate(for bytes: Array<UInt8>) -> Array<UInt8> {
        return Array<UInt8>()
    }
}

class SHA1 : DigestType {
    public func calculate(for bytes: Array<UInt8>) -> Array<UInt8> {
        return Array<UInt8>()
    }
}

class SHA2 : DigestType {
    public enum Variant {
        case sha512
    }

    public init(variant: SHA2.Variant) {}

    public func calculate(for bytes: Array<UInt8>) -> Array<UInt8> {
        return Array<UInt8>()
    }
}

struct Digest {
    static func md5(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return MD5().calculate(for: bytes)
    }

    static func sha1(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA1().calculate(for: bytes)
    }

    static func sha512(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return self.sha2(bytes, variant: .sha512)
    }

    static func sha2(_ bytes: Array<UInt8>, variant: SHA2.Variant) -> Array<UInt8> {
        return SHA2(variant: variant).calculate(for: bytes)
    }
}

extension Array where Element == UInt8 {
    func toHexString() -> String {
        return ""
    }

    func md5() -> [Element] {
        return Digest.md5(self)
    }

    func sha1() -> [Element] {
        return Digest.sha1(self)
    }

    func sha512() -> [Element] {
        return Digest.sha512(self)
    }
}

extension Data {
    var bytes: Array<UInt8> {
        return Array<UInt8>()
    }

    func md5() -> Data {
        return Data(Digest.md5(bytes))
    }

    func sha1() -> Data {
        return Data(Digest.sha1(bytes))
    }

    func sha512() -> Data {
        return Data(Digest.sha512(bytes))
    }
}

extension String {
    var bytes: Array<UInt8> {
        return Array<UInt8>()
    }

    func md5() -> String {
        return self.bytes.md5().toHexString()
    }

    func sha1() -> String {
        return self.bytes.sha1().toHexString()
    }

    func sha512() -> String {
        return self.bytes.sha512().toHexString()
    }
}

// --- tests ---

func testArrays(harmlessArray: Array<UInt8>, passwdArray: Array<UInt8>) {
    _ = MD5().calculate(for: harmlessArray) // GOOD (not sensitive)
    _ = MD5().calculate(for: passwdArray) // BAD
    _ = SHA1().calculate(for: harmlessArray) // GOOD (not sensitive)
    _ = SHA1().calculate(for: passwdArray) // BAD
    _ = SHA2(variant: .sha512).calculate(for: harmlessArray) // GOOD
    _ = SHA2(variant: .sha512).calculate(for: passwdArray) // GOOD

    _ = Digest.md5(harmlessArray) // GOOD (not sensitive)
    _ = Digest.md5(passwdArray) // BAD
    _ = Digest.sha1(harmlessArray) // GOOD (not sensitive)
    _ = Digest.sha1(passwdArray) // BAD
    _ = Digest.sha512(harmlessArray) // GOOD
    _ = Digest.sha512(passwdArray) // GOOD

    _ = harmlessArray.md5() // GOOD (not sensitive)
    _ = passwdArray.md5() // BAD
    _ = harmlessArray.sha1() // GOOD (not sensitive)
    _ = passwdArray.sha1() // BAD
    _ = harmlessArray.sha512() // GOOD
    _ = passwdArray.sha512() // GOOD
}

func testData(harmlessData: Data, passwdData: Data) {
    _ = harmlessData.md5() // GOOD (not sensitive)
    _ = passwdData.md5() // BAD
    _ = harmlessData.sha1() // GOOD (not sensitive)
    _ = passwdData.sha1() // BAD
    _ = harmlessData.sha512() // GOOD
    _ = passwdData.sha512() // GOOD
}

func testStrings(passwd: String) {
    _ = "harmless".md5() // GOOD (not sensitive)
    _ = passwd.md5() // BAD
    _ = "harmless".sha1() // GOOD (not sensitive)
    _ = passwd.sha1() // BAD
    _ = "harmless".sha512() // GOOD
    _ = passwd.sha512() // GOOD
}
