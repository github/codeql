let passwordData = Data(passwordString.utf8)
let passwordHash = Crypto.SHA512.hash(data: passwordData) // BAD: SHA-512 is not suitable for password hashing.

// ...

if Crypto.SHA512.hash(data: Data(passwordString.utf8)) == passwordHash {
    // ...
}
