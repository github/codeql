package main

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/des"
	"crypto/rc4"
	"io"
	"os"
)

var dst []byte = make([]byte, 16)
var secretByteSlice []byte = []byte("")

const secretString string = ""

var public []byte = []byte("")

func getUserID() []byte {
	return []byte("")
}

// Note that we do not alert on decryption as we may need to decrypt legacy formats

func BlockCipherDes() {
	// BAD, des is a weak crypto algorithm
	block, _ := des.NewCipher(nil)

	block.Encrypt(dst, secretByteSlice) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. init from 2 lines above."
	block.Decrypt(dst, secretByteSlice)

	gcm1, _ := cipher.NewGCM(block)
	gcm1.Seal(nil, nil, secretByteSlice, nil) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. init from 6 lines above."
	gcm1.Open(nil, nil, secretByteSlice, nil)

	gcm2, _ := cipher.NewGCMWithNonceSize(block, 12)
	gcm2.Seal(nil, nil, secretByteSlice, nil) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. init from 10 lines above."
	gcm2.Open(nil, nil, secretByteSlice, nil)

	gcm3, _ := cipher.NewGCMWithRandomNonce(block)
	gcm3.Seal(nil, nil, secretByteSlice, nil) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. init from 14 lines above."
	gcm3.Open(nil, nil, secretByteSlice, nil)

	gcm4, _ := cipher.NewGCMWithTagSize(block, 12)
	gcm4.Seal(nil, nil, secretByteSlice, nil) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. init from 18 lines above."
	gcm4.Open(nil, nil, secretByteSlice, nil)

	cbcEncrypter := cipher.NewCBCEncrypter(block, nil)
	cbcEncrypter.CryptBlocks(dst, secretByteSlice) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. blockMode: CBC. init from 1,22 lines above."
	cipher.NewCBCDecrypter(block, nil).CryptBlocks(dst, secretByteSlice)

	ctrStream := cipher.NewCTR(block, nil)
	ctrStream.XORKeyStream(dst, secretByteSlice) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. blockMode: CTR. init from 1,26 lines above."

	ctrStreamReader := &cipher.StreamReader{S: ctrStream, R: bytes.NewReader(secretByteSlice)} // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. blockMode: CTR. init from 28,3 lines above."
	io.Copy(os.Stdout, ctrStreamReader)

	ctrStreamWriter := &cipher.StreamWriter{S: ctrStream, W: os.Stdout} // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. blockMode: CTR. init from 31,6 lines above."
	io.Copy(ctrStreamWriter, bytes.NewReader(secretByteSlice))          // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. blockMode: CTR. init from 32,7 lines above."

	// deprecated

	cfbStream := cipher.NewCFBEncrypter(block, nil)
	cfbStream.XORKeyStream(dst, secretByteSlice) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. blockMode: CFB. init from 1,37 lines above."
	cipher.NewCFBDecrypter(block, nil).XORKeyStream(dst, secretByteSlice)

	ofbStream := cipher.NewOFB(block, nil)
	ofbStream.XORKeyStream(dst, secretByteSlice) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="DES. blockMode: OFB. init from 1,41 lines above."
}

func BlockCipherTripleDes() {
	// BAD, triple des is a weak crypto algorithm and secretByteSlice is sensitive data
	block, _ := des.NewTripleDESCipher(nil)

	block.Encrypt(dst, getUserID()) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. init from 2 lines above."
	block.Decrypt(dst, getUserID())

	gcm1, _ := cipher.NewGCM(block)
	gcm1.Seal(nil, nil, getUserID(), nil) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. init from 6 lines above."
	gcm1.Open(nil, nil, getUserID(), nil)

	gcm2, _ := cipher.NewGCMWithNonceSize(block, 12)
	gcm2.Seal(nil, nil, getUserID(), nil) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. init from 10 lines above."
	gcm2.Open(nil, nil, getUserID(), nil)

	gcm3, _ := cipher.NewGCMWithRandomNonce(block)
	gcm3.Seal(nil, nil, secretByteSlice, nil) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. init from 14 lines above."
	gcm3.Open(nil, nil, secretByteSlice, nil)

	gcm4, _ := cipher.NewGCMWithTagSize(block, 12)
	gcm4.Seal(nil, nil, secretByteSlice, nil) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. init from 18 lines above."
	gcm4.Open(nil, nil, secretByteSlice, nil)

	cbcEncrypter := cipher.NewCBCEncrypter(block, nil)
	cbcEncrypter.CryptBlocks(dst, getUserID()) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CBC. init from 1,22 lines above."
	cipher.NewCBCDecrypter(block, nil).CryptBlocks(dst, getUserID())

	ctrStream := cipher.NewCTR(block, nil)
	ctrStream.XORKeyStream(dst, getUserID()) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CTR. init from 1,26 lines above."

	ctrStreamReader := &cipher.StreamReader{S: ctrStream, R: bytes.NewReader(getUserID())} // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CTR. init from 28,3 lines above."
	io.Copy(os.Stdout, ctrStreamReader)

	ctrStreamWriter := &cipher.StreamWriter{S: ctrStream, W: os.Stdout} // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CTR. init from 31,6 lines above."
	io.Copy(ctrStreamWriter, bytes.NewReader(getUserID()))              // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CTR. init from 32,7 lines above."

	// deprecated

	cfbStream := cipher.NewCFBEncrypter(block, nil)
	cfbStream.XORKeyStream(dst, secretByteSlice) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. blockMode: CFB. init from 1,37 lines above."
	cipher.NewCFBDecrypter(block, nil).XORKeyStream(dst, secretByteSlice)

	ofbStream := cipher.NewOFB(block, nil)
	ofbStream.XORKeyStream(dst, secretByteSlice) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="TRIPLEDES. blockMode: OFB. init from 1,41 lines above."
}

func BlockCipherAes() {
	// GOOD, aes is a strong crypto algorithm
	block, _ := aes.NewCipher(nil)

	block.Encrypt(dst, secretByteSlice) // $ CryptographicOperation="AES. init from 2 lines above."
	block.Decrypt(dst, secretByteSlice)

	gcm1, _ := cipher.NewGCM(block)
	gcm1.Seal(nil, nil, secretByteSlice, nil) // $ CryptographicOperation="AES. init from 6 lines above."
	gcm1.Open(nil, nil, secretByteSlice, nil)

	gcm2, _ := cipher.NewGCMWithNonceSize(block, 12)
	gcm2.Seal(nil, nil, secretByteSlice, nil) // $ CryptographicOperation="AES. init from 10 lines above."
	gcm2.Open(nil, nil, secretByteSlice, nil)

	gcm3, _ := cipher.NewGCMWithRandomNonce(block)
	gcm3.Seal(nil, nil, secretByteSlice, nil) // $ CryptographicOperation="AES. init from 14 lines above."
	gcm3.Open(nil, nil, secretByteSlice, nil)

	gcm4, _ := cipher.NewGCMWithTagSize(block, 12)
	gcm4.Seal(nil, nil, secretByteSlice, nil) // $ CryptographicOperation="AES. init from 18 lines above."
	gcm4.Open(nil, nil, secretByteSlice, nil)

	cbcEncrypter := cipher.NewCBCEncrypter(block, nil)
	cbcEncrypter.CryptBlocks(dst, secretByteSlice) // $ CryptographicOperation="AES. blockMode: CBC. init from 1,22 lines above."
	cipher.NewCBCDecrypter(block, nil).CryptBlocks(dst, secretByteSlice)

	ctrStream := cipher.NewCTR(block, nil)
	ctrStream.XORKeyStream(dst, secretByteSlice) // $ CryptographicOperation="AES. blockMode: CTR. init from 1,26 lines above."

	ctrStreamReader := &cipher.StreamReader{S: ctrStream, R: bytes.NewReader(secretByteSlice)} // $ CryptographicOperation="AES. blockMode: CTR. init from 28,3 lines above."
	io.Copy(os.Stdout, ctrStreamReader)

	ctrStreamWriter := &cipher.StreamWriter{S: ctrStream, W: os.Stdout} // $ CryptographicOperation="AES. blockMode: CTR. init from 31,6 lines above."
	io.Copy(ctrStreamWriter, bytes.NewReader(secretByteSlice))          // $ CryptographicOperation="AES. blockMode: CTR. init from 32,7 lines above."

	// deprecated

	cfbStream := cipher.NewCFBEncrypter(block, nil)
	cfbStream.XORKeyStream(dst, secretByteSlice) // $ CryptographicOperation="AES. blockMode: CFB. init from 1,37 lines above."
	cipher.NewCFBDecrypter(block, nil).XORKeyStream(dst, secretByteSlice)

	ofbStream := cipher.NewOFB(block, nil)
	ofbStream.XORKeyStream(dst, secretByteSlice) // $ CryptographicOperation="AES. blockMode: OFB. init from 1,41 lines above."
}

func CipherRc4() {
	c, _ := rc4.NewCipher(nil)
	c.XORKeyStream(dst, getUserID()) // $ Alert[go/weak-cryptographic-algorithm] CryptographicOperation="RC4. init from 0 lines above."
}
