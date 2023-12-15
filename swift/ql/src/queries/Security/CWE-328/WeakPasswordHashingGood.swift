import Argon2Swift

let salt = Salt.newSalt()
let result = try! Argon2Swift.hashPasswordString(password: passwordString, salt: salt)
let passwordHash = result.encodedString()

// ...

if try! Argon2Swift.verifyHashString(password: passwordString, hash: passwordHash) {
    // ...
}
