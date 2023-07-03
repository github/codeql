import CryptoKit
import Foundation

let SECRET_KEY = SymmetricKey(size: .bits256)

func sendEncrypted(plaintext: Data, to channel: Channel) {
    channel.send(cipher.encrypt(plaintext)) // BAD: weak encryption
}

func sendEncrypted(plaintext: Data, to channel: Channel) {
    // GOOD: strong encryption
    let sealedData = try! AES.GCM.seal(plaintext, using: SECRET_KEY, nonce: AES.GCM.Nonce())
    let encryptedContent = try! sealedData.combined!
    channel.send(encryptedContent)
}
