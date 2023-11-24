import CryptoKit
import Foundation

let SECRET_KEY = SymmetricKey(size: .bits256)

func encrypt(plaintext: Data) -> Data {
    return cipher.encrypt(plaintext) // BAD: weak encryption
}

func encrypt(plaintext: Data) -> Data {
    // GOOD: strong encryption
    let sealedData = try! AES.GCM.seal(plaintext, using: SECRET_KEY, nonce: AES.GCM.Nonce())
    let encryptedContent = try! sealedData.combined!
    return encryptedContent
}
