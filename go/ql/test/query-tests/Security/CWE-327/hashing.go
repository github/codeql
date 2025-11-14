package main

//go:generate depstubber -vendor golang.org/x/crypto/md4 "" New
//go:generate depstubber -vendor golang.org/x/crypto/ripemd160 "" New

import (
	"crypto/md5"
	"crypto/sha1"
	"crypto/sha256"
	"crypto/sha3"
	"crypto/sha512"
	"io"

	"golang.org/x/crypto/md4"
	"golang.org/x/crypto/ripemd160"
)

func WeakHashes() {
	h := md5.New()
	h.Sum(secretByteSlice)          // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD5. init from line 19."
	h.Write(secretByteSlice)        // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD5. init from line 19."
	io.WriteString(h, secretString) // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD5. init from line 19."
	md5.Sum(secretByteSlice)        // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD5. init from line 23."

	sha1.New().Sum(secretByteSlice) // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="SHA1. init from line 25."
	sha1.Sum(secretByteSlice)       // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="SHA1. init from line 26."

	md4.New().Sum(secretByteSlice)       // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD4. init from line 28."
	ripemd160.New().Sum(secretByteSlice) // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="RIPEMD160. init from line 29."

	// Only alert when sensitive data is hashed.
	md5.New().Sum(public)  // $ CryptographicOperation="MD5. init from line 32."
	md5.Sum(public)        // $ CryptographicOperation="MD5. init from line 33."
	sha1.New().Sum(public) // $ CryptographicOperation="SHA1. init from line 34."
	sha1.Sum(public)       // $ CryptographicOperation="SHA1. init from line 35."
}

func StrongHashes() {
	sha256.New224().Sum(secretByteSlice) // $ CryptographicOperation="SHA224. init from line 39."
	sha256.Sum224(secretByteSlice)       // $ CryptographicOperation="SHA224. init from line 40."

	sha256.New().Sum(secretByteSlice) // $ CryptographicOperation="SHA256. init from line 42."
	sha256.Sum256(secretByteSlice)    // $ CryptographicOperation="SHA256. init from line 43."

	sha512.New().Sum(secretByteSlice) // $ CryptographicOperation="SHA512. init from line 45."
	sha512.Sum512(secretByteSlice)    // $ CryptographicOperation="SHA512. init from line 46."

	sha512.New384().Sum(secretByteSlice) // $ CryptographicOperation="SHA384. init from line 48."
	sha512.Sum384(secretByteSlice)       // $ CryptographicOperation="SHA384. init from line 49."

	sha512.New512_224().Sum(secretByteSlice) // $ CryptographicOperation="SHA512224. init from line 51."
	sha512.Sum512_224(secretByteSlice)       // $ CryptographicOperation="SHA512224. init from line 52."

	sha512.New512_256().Sum(secretByteSlice) // $ CryptographicOperation="SHA512256. init from line 54."
	sha512.Sum512_256(secretByteSlice)       // $ CryptographicOperation="SHA512256. init from line 55."

	sha3.New224().Sum(secretByteSlice) // $ CryptographicOperation="SHA3224. init from line 57."
	sha3.Sum224(secretByteSlice)       // $ CryptographicOperation="SHA3224. init from line 58."

	sha3.New256().Sum(secretByteSlice) // $ CryptographicOperation="SHA3256. init from line 60."
	sha3.Sum256(secretByteSlice)       // $ CryptographicOperation="SHA3256. init from line 61."

	sha3.New384().Sum(secretByteSlice) // $ CryptographicOperation="SHA3384. init from line 63."
	sha3.Sum384(secretByteSlice)       // $ CryptographicOperation="SHA3384. init from line 64."

	sha3.New512().Sum(secretByteSlice) // $ CryptographicOperation="SHA3512. init from line 66."
	sha3.Sum512(secretByteSlice)       // $ CryptographicOperation="SHA3512. init from line 67."

	sha3.NewSHAKE128().Write(secretByteSlice)          // $ CryptographicOperation="SHAKE128. init from line 69."
	sha3.NewCSHAKE128(nil, nil).Write(secretByteSlice) // $ CryptographicOperation="SHAKE128. init from line 70."
	sha3.SumSHAKE128(secretByteSlice, 100)             // $ CryptographicOperation="SHAKE128. init from line 71."

	sha3.NewSHAKE256().Write(secretByteSlice)          // $ CryptographicOperation="SHAKE256. init from line 73."
	sha3.NewCSHAKE256(nil, nil).Write(secretByteSlice) // $ CryptographicOperation="SHAKE256. init from line 74."
	sha3.SumSHAKE256(secretByteSlice, 100)             // $ CryptographicOperation="SHAKE256. init from line 75."
}

func PasswordHashing() {
	password := []byte("")
	sha256.Sum256(password) // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="SHA256. init from line 80."
}
