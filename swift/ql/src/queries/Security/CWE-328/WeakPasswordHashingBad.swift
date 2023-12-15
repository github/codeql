let passwordData = Data(passwordString.utf8)
let passwordHash = Crypto.SHA512.hash(data: passwordData)

// ...

if Crypto.SHA512.hash(data: Data(passwordString.utf8)) == passwordHash {
    // ...
}
