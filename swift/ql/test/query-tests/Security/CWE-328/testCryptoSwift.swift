
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

class SHA3 : DigestType {
    public enum Variant {
        case sha512
    }

    public init(variant: SHA3.Variant) {}

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

    static func sha3(_ bytes: Array<UInt8>, variant: SHA3.Variant) -> Array<UInt8> {
        return SHA3(variant: variant).calculate(for: bytes)
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

    func sha2(_ variant: SHA2.Variant) -> [Element] {
        return Digest.sha2(self, variant: variant)
    }

    func sha3(_ variant: SHA3.Variant) -> [Element] {
        return Digest.sha3(self, variant: variant)
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

    func sha2(_ variant: SHA2.Variant) -> Data {
        return Data(Digest.sha2(bytes, variant: variant))
    }

    func sha3(_ variant: SHA3.Variant) -> Data {
        return Data(Digest.sha3(bytes, variant: variant))
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

    func sha2(_ variant: SHA2.Variant) -> String {
        return self.bytes.sha2(variant).toHexString()
    }

    func sha3(_ variant: SHA3.Variant) -> String {
        return self.bytes.sha3(variant).toHexString()
    }
}

// --- tests ---

func testArrays(harmlessArray: Array<UInt8>, phoneNumberArray: Array<UInt8>, passwdArray: Array<UInt8>) {
    _ = MD5().calculate(for: harmlessArray) // GOOD (not sensitive)
    _ = MD5().calculate(for: phoneNumberArray) // BAD
    _ = MD5().calculate(for: passwdArray) // BAD
    _ = SHA1().calculate(for: harmlessArray) // GOOD (not sensitive)
    _ = SHA1().calculate(for: phoneNumberArray) // BAD
    _ = SHA1().calculate(for: passwdArray) // BAD
    _ = SHA2(variant: .sha512).calculate(for: harmlessArray) // GOOD
    _ = SHA2(variant: .sha512).calculate(for: phoneNumberArray) // GOOD
    _ = SHA2(variant: .sha512).calculate(for: passwdArray) // BAD
    _ = SHA3(variant: .sha512).calculate(for: harmlessArray) // GOOD
    _ = SHA3(variant: .sha512).calculate(for: phoneNumberArray) // GOOD
    _ = SHA3(variant: .sha512).calculate(for: passwdArray) // BAD

    _ = Digest.md5(harmlessArray) // GOOD (not sensitive)
    _ = Digest.md5(phoneNumberArray) // BAD
    _ = Digest.md5(passwdArray) // BAD
    _ = Digest.sha1(harmlessArray) // GOOD (not sensitive)
    _ = Digest.sha1(phoneNumberArray) // BAD
    _ = Digest.sha1(passwdArray) // BAD
    _ = Digest.sha512(harmlessArray) // GOOD (not sensitive)
    _ = Digest.sha512(phoneNumberArray) // GOOD
    _ = Digest.sha512(passwdArray) // BAD
    _ = Digest.sha2(harmlessArray, variant: .sha512) // GOOD (not sensitive)
    _ = Digest.sha2(phoneNumberArray, variant: .sha512) // GOOD
    _ = Digest.sha2(passwdArray, variant: .sha512) // BAD
    _ = Digest.sha3(harmlessArray, variant: .sha512) // GOOD (not sensitive)
    _ = Digest.sha3(phoneNumberArray, variant: .sha512) // GOOD
    _ = Digest.sha3(passwdArray, variant: .sha512) // BAD

    _ = harmlessArray.md5() // GOOD (not sensitive)
    _ = phoneNumberArray.md5() // BAD
    _ = passwdArray.md5() // BAD
    _ = harmlessArray.sha1() // GOOD (not sensitive)
    _ = phoneNumberArray.sha1() // BAD
    _ = passwdArray.sha1() // BAD
    _ = harmlessArray.sha512() // GOOD
    _ = phoneNumberArray.sha512() // GOOD
    _ = passwdArray.sha512() // BAD
    _ = harmlessArray.sha2(.sha512) // GOOD
    _ = phoneNumberArray.sha2(.sha512) // GOOD
    _ = passwdArray.sha2(.sha512) // BAD
    _ = harmlessArray.sha3(.sha512) // GOOD
    _ = phoneNumberArray.sha3(.sha512) // GOOD
    _ = passwdArray.sha3(.sha512) // BAD
}

func testData(harmlessData: Data, medicalData: Data, passwdData: Data) {
    _ = harmlessData.md5() // GOOD (not sensitive)
    _ = medicalData.md5() // BAD
    _ = passwdData.md5() // BAD
    _ = harmlessData.sha1() // GOOD (not sensitive)
    _ = medicalData.sha1() // BAD
    _ = passwdData.sha1() // BAD
    _ = harmlessData.sha512() // GOOD
    _ = medicalData.sha512() // GOOD
    _ = passwdData.sha512() // BAD
    _ = harmlessData.sha2(.sha512) // GOOD
    _ = medicalData.sha2(.sha512) // GOOD
    _ = passwdData.sha2(.sha512) // BAD
    _ = harmlessData.sha3(.sha512) // GOOD
    _ = medicalData.sha3(.sha512) // GOOD
    _ = passwdData.sha3(.sha512) // BAD
}

func testStrings(creditCardNumber: String, passwd: String) {
    _ = "harmless".md5() // GOOD (not sensitive)
    _ = creditCardNumber.md5() // BAD
    _ = passwd.md5() // BAD
    _ = "harmless".sha1() // GOOD (not sensitive)
    _ = creditCardNumber.sha1() // BAD
    _ = passwd.sha1() // BAD
    _ = "harmless".sha512() // GOOD
    _ = creditCardNumber.sha512() // GOOD
    _ = passwd.sha512() // BAD
    _ = "harmless".sha2(.sha512) // GOOD
    _ = creditCardNumber.sha2(.sha512) // GOOD
    _ = passwd.sha2(.sha512) // BAD
    _ = "harmless".sha3(.sha512) // GOOD
    _ = creditCardNumber.sha3(.sha512) // GOOD
    _ = passwd.sha3(.sha512) // BAD
}
