package main

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/des"
	"crypto/md5"
	"crypto/rc4"
	"crypto/sha1"
	"crypto/sha256"
	"crypto/sha3"
	"crypto/sha512"
	"io"
	"os"
)

var dst []byte = make([]byte, 16)
var password []byte = []byte("123456")

const passwordString string = "correct horse battery staple"

var public []byte = []byte("hello")

func getPassword() []byte {
	return []byte("123456")
}

// Note that we do not alert on decryption as we may need to decrypt legacy formats

func BlockCipherDes() {
	// BAD, des is a weak crypto algorithm
	block, _ := des.NewCipher(nil)

	block.Encrypt(dst, public)   // $ CryptographicOperation="DES. init from line 33."
	block.Encrypt(dst, password) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. init from line 33."
	block.Decrypt(dst, password)

	gcm1, _ := cipher.NewGCM(block)
	gcm1.Seal(nil, nil, public, nil)   // $ CryptographicOperation="DES. init from line 33."
	gcm1.Seal(nil, nil, password, nil) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. init from line 33."
	gcm1.Open(nil, nil, password, nil)

	gcm2, _ := cipher.NewGCMWithNonceSize(block, 12)
	gcm2.Seal(nil, nil, public, nil)   // $ CryptographicOperation="DES. init from line 33."
	gcm2.Seal(nil, nil, password, nil) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. init from line 33."
	gcm2.Open(nil, nil, password, nil)

	gcm3, _ := cipher.NewGCMWithRandomNonce(block)
	gcm3.Seal(nil, nil, public, nil)   // $ CryptographicOperation="DES. init from line 33."
	gcm3.Seal(nil, nil, password, nil) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. init from line 33."
	gcm3.Open(nil, nil, password, nil)

	gcm4, _ := cipher.NewGCMWithTagSize(block, 12)
	gcm4.Seal(nil, nil, public, nil)   // $ CryptographicOperation="DES. init from line 33."
	gcm4.Seal(nil, nil, password, nil) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. init from line 33."
	gcm4.Open(nil, nil, password, nil)

	cbcEncrypter := cipher.NewCBCEncrypter(block, nil)
	cbcEncrypter.CryptBlocks(dst, public)   // $ CryptographicOperation="DES. blockMode: CBC. init from lines 33,59."
	cbcEncrypter.CryptBlocks(dst, password) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. blockMode: CBC. init from lines 33,59."
	cipher.NewCBCDecrypter(block, nil).CryptBlocks(dst, password)

	ctrStream := cipher.NewCTR(block, nil)
	ctrStream.XORKeyStream(dst, public)   // $ CryptographicOperation="DES. blockMode: CTR. init from lines 33,64."
	ctrStream.XORKeyStream(dst, password) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. blockMode: CTR. init from lines 33,64."

	ctrStreamReader := &cipher.StreamReader{S: ctrStream, R: bytes.NewReader(password)} // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. blockMode: CTR. init from lines 33,64."
	io.Copy(os.Stdout, ctrStreamReader)

	ctrStreamWriter := &cipher.StreamWriter{S: ctrStream, W: os.Stdout} // $ CryptographicOperation="DES. blockMode: CTR. init from lines 33,64."
	io.Copy(ctrStreamWriter, bytes.NewReader(password))                 // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. blockMode: CTR. init from lines 33,64."

	// deprecated

	cfbStream := cipher.NewCFBEncrypter(block, nil)
	cfbStream.XORKeyStream(dst, public)   // $ CryptographicOperation="DES. blockMode: CFB. init from lines 33,76."
	cfbStream.XORKeyStream(dst, password) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. blockMode: CFB. init from lines 33,76."
	cipher.NewCFBDecrypter(block, nil).XORKeyStream(dst, password)

	ofbStream := cipher.NewOFB(block, nil)
	ofbStream.XORKeyStream(dst, public)   // $ CryptographicOperation="DES. blockMode: OFB. init from lines 33,81."
	ofbStream.XORKeyStream(dst, password) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="DES. blockMode: OFB. init from lines 33,81."
}

func BlockCipherTripleDes() {
	// BAD, triple des is a weak crypto algorithm and password is sensitive data
	block, _ := des.NewTripleDESCipher(nil)

	block.Encrypt(dst, public)        // $ CryptographicOperation="TRIPLEDES. init from line 88."
	block.Encrypt(dst, getPassword()) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. init from line 88."
	block.Decrypt(dst, getPassword())

	gcm1, _ := cipher.NewGCM(block)
	gcm1.Seal(nil, nil, public, nil)        // $ CryptographicOperation="TRIPLEDES. init from line 88."
	gcm1.Seal(nil, nil, getPassword(), nil) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. init from line 88."
	gcm1.Open(nil, nil, getPassword(), nil)

	gcm2, _ := cipher.NewGCMWithNonceSize(block, 12)
	gcm2.Seal(nil, nil, public, nil)        // $ CryptographicOperation="TRIPLEDES. init from line 88."
	gcm2.Seal(nil, nil, getPassword(), nil) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. init from line 88."
	gcm2.Open(nil, nil, getPassword(), nil)

	gcm3, _ := cipher.NewGCMWithRandomNonce(block)
	gcm3.Seal(nil, nil, public, nil)   // $ CryptographicOperation="TRIPLEDES. init from line 88."
	gcm3.Seal(nil, nil, password, nil) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. init from line 88."
	gcm3.Open(nil, nil, password, nil)

	gcm4, _ := cipher.NewGCMWithTagSize(block, 12)
	gcm4.Seal(nil, nil, public, nil)   // $ CryptographicOperation="TRIPLEDES. init from line 88."
	gcm4.Seal(nil, nil, password, nil) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. init from line 88."
	gcm4.Open(nil, nil, password, nil)

	cbcEncrypter := cipher.NewCBCEncrypter(block, nil)
	cbcEncrypter.CryptBlocks(dst, public)        // $ CryptographicOperation="TRIPLEDES. blockMode: CBC. init from lines 114,88."
	cbcEncrypter.CryptBlocks(dst, getPassword()) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CBC. init from lines 114,88."
	cipher.NewCBCDecrypter(block, nil).CryptBlocks(dst, getPassword())

	ctrStream := cipher.NewCTR(block, nil)
	ctrStream.XORKeyStream(dst, public)        // $ CryptographicOperation="TRIPLEDES. blockMode: CTR. init from lines 119,88."
	ctrStream.XORKeyStream(dst, getPassword()) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CTR. init from lines 119,88."

	ctrStreamReader := &cipher.StreamReader{S: ctrStream, R: bytes.NewReader(getPassword())} // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CTR. init from lines 119,88."
	io.Copy(os.Stdout, ctrStreamReader)

	ctrStreamWriter := &cipher.StreamWriter{S: ctrStream, W: os.Stdout} // $ CryptographicOperation="TRIPLEDES. blockMode: CTR. init from lines 119,88."
	io.Copy(ctrStreamWriter, bytes.NewReader(getPassword()))            // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CTR. init from lines 119,88."

	// deprecated

	cfbStream := cipher.NewCFBEncrypter(block, nil)
	cfbStream.XORKeyStream(dst, public)   // $ CryptographicOperation="TRIPLEDES. blockMode: CFB. init from lines 131,88."
	cfbStream.XORKeyStream(dst, password) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CFB. init from lines 131,88."
	cipher.NewCFBDecrypter(block, nil).XORKeyStream(dst, password)

	ofbStream := cipher.NewOFB(block, nil)
	ofbStream.XORKeyStream(dst, public)   // $ CryptographicOperation="TRIPLEDES. blockMode: OFB. init from lines 136,88."
	ofbStream.XORKeyStream(dst, password) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="TRIPLEDES. blockMode: OFB. init from lines 136,88."
}

func BlockCipherAes() {
	// GOOD, aes is a strong crypto algorithm
	block, _ := aes.NewCipher(nil)

	block.Encrypt(dst, public)   // $ CryptographicOperation="AES. init from line 143."
	block.Encrypt(dst, password) // $ CryptographicOperation="AES. init from line 143."
	block.Decrypt(dst, password)

	gcm1, _ := cipher.NewGCM(block)
	gcm1.Seal(nil, nil, public, nil)   // $ CryptographicOperation="AES. init from line 143."
	gcm1.Seal(nil, nil, password, nil) // $ CryptographicOperation="AES. init from line 143."
	gcm1.Open(nil, nil, password, nil)

	gcm2, _ := cipher.NewGCMWithNonceSize(block, 12)
	gcm2.Seal(nil, nil, public, nil)   // $ CryptographicOperation="AES. init from line 143."
	gcm2.Seal(nil, nil, password, nil) // $ CryptographicOperation="AES. init from line 143."
	gcm2.Open(nil, nil, password, nil)

	gcm3, _ := cipher.NewGCMWithRandomNonce(block)
	gcm3.Seal(nil, nil, public, nil)   // $ CryptographicOperation="AES. init from line 143."
	gcm3.Seal(nil, nil, password, nil) // $ CryptographicOperation="AES. init from line 143."
	gcm3.Open(nil, nil, password, nil)

	gcm4, _ := cipher.NewGCMWithTagSize(block, 12)
	gcm4.Seal(nil, nil, public, nil)   // $ CryptographicOperation="AES. init from line 143."
	gcm4.Seal(nil, nil, password, nil) // $ CryptographicOperation="AES. init from line 143."
	gcm4.Open(nil, nil, password, nil)

	cbcEncrypter := cipher.NewCBCEncrypter(block, nil)
	cbcEncrypter.CryptBlocks(dst, public)   // $ CryptographicOperation="AES. blockMode: CBC. init from lines 143,169."
	cbcEncrypter.CryptBlocks(dst, password) // $ CryptographicOperation="AES. blockMode: CBC. init from lines 143,169."
	cipher.NewCBCDecrypter(block, nil).CryptBlocks(dst, password)

	ctrStream := cipher.NewCTR(block, nil)
	ctrStream.XORKeyStream(dst, public)   // $ CryptographicOperation="AES. blockMode: CTR. init from lines 143,174."
	ctrStream.XORKeyStream(dst, password) // $ CryptographicOperation="AES. blockMode: CTR. init from lines 143,174."

	ctrStreamReader := &cipher.StreamReader{S: ctrStream, R: bytes.NewReader(password)} // $ CryptographicOperation="AES. blockMode: CTR. init from lines 143,174."
	io.Copy(os.Stdout, ctrStreamReader)

	ctrStreamWriter := &cipher.StreamWriter{S: ctrStream, W: os.Stdout} // $ CryptographicOperation="AES. blockMode: CTR. init from lines 143,174."
	io.Copy(ctrStreamWriter, bytes.NewReader(password))                 // $ CryptographicOperation="AES. blockMode: CTR. init from lines 143,174."

	// deprecated

	cfbStream := cipher.NewCFBEncrypter(block, nil)
	cfbStream.XORKeyStream(dst, public)   // $ CryptographicOperation="AES. blockMode: CFB. init from lines 143,186."
	cfbStream.XORKeyStream(dst, password) // $ CryptographicOperation="AES. blockMode: CFB. init from lines 143,186."
	cipher.NewCFBDecrypter(block, nil).XORKeyStream(dst, password)

	ofbStream := cipher.NewOFB(block, nil)
	ofbStream.XORKeyStream(dst, public)   // $ CryptographicOperation="AES. blockMode: OFB. init from lines 143,191."
	ofbStream.XORKeyStream(dst, password) // $ CryptographicOperation="AES. blockMode: OFB. init from lines 143,191."
}

func CipherRc4() {
	c, _ := rc4.NewCipher(nil)
	c.XORKeyStream(dst, getPassword()) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="RC4. init from line 198."
}

func WeakHashes() {
	buf := password // $ Source

	h := md5.New()
	h.Sum(buf)                        // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="MD5. init from line 204."
	h.Write(buf)                      // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="MD5. init from line 204."
	io.WriteString(h, passwordString) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="MD5. init from line 204."
	md5.Sum(buf)                      // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="MD5. init from line 208."

	sha1.New().Sum(buf) // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="SHA1. init from line 210."
	sha1.Sum(buf)       // $ Alert[go/weak-crypto-algorithm] CryptographicOperation="SHA1. init from line 211."
}

func StrongHashes() {
	buf := password

	sha256.New224().Sum(buf) // $ CryptographicOperation="SHA224. init from line 217."
	sha256.Sum224(buf)       // $ CryptographicOperation="SHA224. init from line 218."

	sha256.New().Sum(buf) // $ CryptographicOperation="SHA256. init from line 220."
	sha256.Sum256(buf)    // $ CryptographicOperation="SHA256. init from line 221."

	sha512.New().Sum(buf) // $ CryptographicOperation="SHA512. init from line 223."
	sha512.Sum512(buf)    // $ CryptographicOperation="SHA512. init from line 224."

	sha512.New384().Sum(buf) // $ CryptographicOperation="SHA384. init from line 226."
	sha512.Sum384(buf)       // $ CryptographicOperation="SHA384. init from line 227."

	sha512.New512_224().Sum(buf) // $ CryptographicOperation="SHA512224. init from line 229."
	sha512.Sum512_224(buf)       // $ CryptographicOperation="SHA512224. init from line 230."

	sha512.New512_256().Sum(buf) // $ CryptographicOperation="SHA512256. init from line 232."
	sha512.Sum512_256(buf)       // $ CryptographicOperation="SHA512256. init from line 233."

	sha3.New224().Sum(buf) // $ CryptographicOperation="SHA3224. init from line 235."
	sha3.Sum224(buf)       // $ CryptographicOperation="SHA3224. init from line 236."

	sha3.New256().Sum(buf) // $ CryptographicOperation="SHA3256. init from line 238."
	sha3.Sum256(buf)       // $ CryptographicOperation="SHA3256. init from line 239."

	sha3.New384().Sum(buf) // $ CryptographicOperation="SHA3384. init from line 241."
	sha3.Sum384(buf)       // $ CryptographicOperation="SHA3384. init from line 242."

	sha3.New512().Sum(buf) // $ CryptographicOperation="SHA3512. init from line 244."
	sha3.Sum512(buf)       // $ CryptographicOperation="SHA3512. init from line 245."

	sha3.NewSHAKE128().Write(buf)          // $ CryptographicOperation="SHAKE128. init from line 247."
	sha3.NewCSHAKE128(nil, nil).Write(buf) // $ CryptographicOperation="SHAKE128. init from line 248."
	sha3.SumSHAKE128(buf, 100)             // $ CryptographicOperation="SHAKE128. init from line 249."

	sha3.NewSHAKE256().Write(buf)          // $ CryptographicOperation="SHAKE256. init from line 251."
	sha3.NewCSHAKE256(nil, nil).Write(buf) // $ CryptographicOperation="SHAKE256. init from line 252."
	sha3.SumSHAKE256(buf, 100)             // $ CryptographicOperation="SHAKE256. init from line 253."
}
