package jwt

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"errors"
	"io"
)

// ErrDecrypt indicates a failure on payload decryption.
var ErrDecrypt = errors.New("jwt: decrypt: payload authentication failed")

// GCM sets the `Encrypt` and `Decrypt` package-level functions
// to provide encryption over the token's payload on Sign and decryption on Verify
// using the Galois Counter mode of operation with AES cipher symmetric-key cryptographic.
// It should be called once on initialization of the program and before any Sign/Verify operation.
//
// The key argument should be the AES key,
// either 16, 24, or 32 bytes to select
// AES-128, AES-192, or AES-256.
//
// The additionalData argument is optional.
// Can be set to nil to ignore.
//
// Usage:
//  var encKey = MustGenerateRandom(32)
//  var sigKey = MustGenerateRandom(32)
//
//  encrypt, decrypt, err := GCM(encKey, nil)
//  if err != nil { ... }
//  token, err := SignEncrypted(jwt.HS256, sigKey, encrypt, claims, jwt.MaxAge(15 * time.Minute))
//  verifiedToken, err := VerifyEncrypted(jwt.HS256, sigKey, decrypt, token)
func GCM(key, additionalData []byte) (encrypt, decrypt InjectFunc, err error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, nil, err
	}

	encrypt = func(payload []byte) ([]byte, error) {
		nonce := make([]byte, gcm.NonceSize())
		if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
			return nil, err
		}

		ciphertext := gcm.Seal(nonce, nonce, payload, additionalData)
		return ciphertext, nil
	}

	decrypt = func(ciphertext []byte) ([]byte, error) {
		nonce := ciphertext[:gcm.NonceSize()]
		ciphertext = ciphertext[gcm.NonceSize():]

		plainPayload, err := gcm.Open(nil, nonce, ciphertext, additionalData)
		if err != nil {
			return nil, ErrDecrypt
		}

		return plainPayload, nil
	}

	return
}
