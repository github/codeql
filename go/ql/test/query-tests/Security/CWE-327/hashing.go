package main

//go:generate depstubber -vendor golang.org/x/crypto/md4 "" New
//go:generate depstubber -vendor golang.org/x/crypto/ripemd160 "" New

import (
	"crypto/md5"
	"crypto/pbkdf2"
	"crypto/rand"
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
	h.Sum(secretByteSlice)          // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD5. init from 1 lines above."
	h.Write(secretByteSlice)        // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD5. init from 2 lines above."
	io.WriteString(h, secretString) // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD5. init from 3 lines above."
	md5.Sum(secretByteSlice)        // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD5. init from 0 lines above."

	sha1.New().Sum(secretByteSlice) // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="SHA1. init from 0 lines above."
	sha1.Sum(secretByteSlice)       // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="SHA1. init from 0 lines above."

	md4.New().Sum(secretByteSlice)       // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="MD4. init from 0 lines above."
	ripemd160.New().Sum(secretByteSlice) // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="RIPEMD160. init from 0 lines above."

	// Only alert when sensitive data is hashed.
	md5.New().Sum(public)  // $ CryptographicOperation="MD5. init from 0 lines above."
	md5.Sum(public)        // $ CryptographicOperation="MD5. init from 0 lines above."
	sha1.New().Sum(public) // $ CryptographicOperation="SHA1. init from 0 lines above."
	sha1.Sum(public)       // $ CryptographicOperation="SHA1. init from 0 lines above."
}

func StrongHashes() {
	sha256.New224().Sum(secretByteSlice) // $ CryptographicOperation="SHA224. init from 0 lines above."
	sha256.Sum224(secretByteSlice)       // $ CryptographicOperation="SHA224. init from 0 lines above."

	sha256.New().Sum(secretByteSlice) // $ CryptographicOperation="SHA256. init from 0 lines above."
	sha256.Sum256(secretByteSlice)    // $ CryptographicOperation="SHA256. init from 0 lines above."

	sha512.New().Sum(secretByteSlice) // $ CryptographicOperation="SHA512. init from 0 lines above."
	sha512.Sum512(secretByteSlice)    // $ CryptographicOperation="SHA512. init from 0 lines above."

	sha512.New384().Sum(secretByteSlice) // $ CryptographicOperation="SHA384. init from 0 lines above."
	sha512.Sum384(secretByteSlice)       // $ CryptographicOperation="SHA384. init from 0 lines above."

	sha512.New512_224().Sum(secretByteSlice) // $ CryptographicOperation="SHA512224. init from 0 lines above."
	sha512.Sum512_224(secretByteSlice)       // $ CryptographicOperation="SHA512224. init from 0 lines above."

	sha512.New512_256().Sum(secretByteSlice) // $ CryptographicOperation="SHA512256. init from 0 lines above."
	sha512.Sum512_256(secretByteSlice)       // $ CryptographicOperation="SHA512256. init from 0 lines above."

	sha3.New224().Sum(secretByteSlice) // $ CryptographicOperation="SHA3224. init from 0 lines above."
	sha3.Sum224(secretByteSlice)       // $ CryptographicOperation="SHA3224. init from 0 lines above."

	sha3.New256().Sum(secretByteSlice) // $ CryptographicOperation="SHA3256. init from 0 lines above."
	sha3.Sum256(secretByteSlice)       // $ CryptographicOperation="SHA3256. init from 0 lines above."

	sha3.New384().Sum(secretByteSlice) // $ CryptographicOperation="SHA3384. init from 0 lines above."
	sha3.Sum384(secretByteSlice)       // $ CryptographicOperation="SHA3384. init from 0 lines above."

	sha3.New512().Sum(secretByteSlice) // $ CryptographicOperation="SHA3512. init from 0 lines above."
	sha3.Sum512(secretByteSlice)       // $ CryptographicOperation="SHA3512. init from 0 lines above."

	sha3.NewSHAKE128().Write(secretByteSlice)          // $ CryptographicOperation="SHAKE128. init from 0 lines above."
	sha3.NewCSHAKE128(nil, nil).Write(secretByteSlice) // $ CryptographicOperation="SHAKE128. init from 0 lines above."
	sha3.SumSHAKE128(secretByteSlice, 100)             // $ CryptographicOperation="SHAKE128. init from 0 lines above."

	sha3.NewSHAKE256().Write(secretByteSlice)          // $ CryptographicOperation="SHAKE256. init from 0 lines above."
	sha3.NewCSHAKE256(nil, nil).Write(secretByteSlice) // $ CryptographicOperation="SHAKE256. init from 0 lines above."
	sha3.SumSHAKE256(secretByteSlice, 100)             // $ CryptographicOperation="SHAKE256. init from 0 lines above."
}

func GetPasswordHashBad(password string) [32]byte {
	// BAD, SHA256 is a strong hashing algorithm but it is not computationally expensive
	return sha256.Sum256([]byte(password)) // $ Alert[go/weak-sensitive-data-hashing] CryptographicOperation="SHA256. init from 0 lines above."
}

func GetPasswordHashGood(password string) []byte {
	// GOOD, PBKDF2 is a strong hashing algorithm and it is computationally expensive
	salt := make([]byte, 16)
	rand.Read(salt)
	key, _ := pbkdf2.Key(sha512.New, password, salt, 4096, 32)
	return key
}
