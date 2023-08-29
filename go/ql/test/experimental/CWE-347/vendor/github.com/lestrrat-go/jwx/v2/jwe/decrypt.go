package jwe

import (
	"crypto/aes"
	cryptocipher "crypto/cipher"
	"crypto/ecdsa"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/sha512"
	"fmt"
	"hash"

	"golang.org/x/crypto/pbkdf2"

	"github.com/lestrrat-go/jwx/v2/internal/keyconv"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwe/internal/cipher"
	"github.com/lestrrat-go/jwx/v2/jwe/internal/content_crypt"
	"github.com/lestrrat-go/jwx/v2/jwe/internal/keyenc"
	"github.com/lestrrat-go/jwx/v2/x25519"
)

// decrypter is responsible for taking various components to decrypt a message.
// its operation is not concurrency safe. You must provide locking yourself
//
//nolint:govet
type decrypter struct {
	aad         []byte
	apu         []byte
	apv         []byte
	computedAad []byte
	iv          []byte
	keyiv       []byte
	keysalt     []byte
	keytag      []byte
	tag         []byte
	privkey     interface{}
	pubkey      interface{}
	ctalg       jwa.ContentEncryptionAlgorithm
	keyalg      jwa.KeyEncryptionAlgorithm
	cipher      content_crypt.Cipher
	keycount    int
}

// newDecrypter Creates a new Decrypter instance. You must supply the
// rest of parameters via their respective setter methods before
// calling Decrypt().
//
// privkey must be a private key in its "raw" format (i.e. something like
// *rsa.PrivateKey, instead of jwk.Key)
//
// You should consider this object immutable once you assign values to it.
func newDecrypter(keyalg jwa.KeyEncryptionAlgorithm, ctalg jwa.ContentEncryptionAlgorithm, privkey interface{}) *decrypter {
	return &decrypter{
		ctalg:   ctalg,
		keyalg:  keyalg,
		privkey: privkey,
	}
}

func (d *decrypter) AgreementPartyUInfo(apu []byte) *decrypter {
	d.apu = apu
	return d
}

func (d *decrypter) AgreementPartyVInfo(apv []byte) *decrypter {
	d.apv = apv
	return d
}

func (d *decrypter) AuthenticatedData(aad []byte) *decrypter {
	d.aad = aad
	return d
}

func (d *decrypter) ComputedAuthenticatedData(aad []byte) *decrypter {
	d.computedAad = aad
	return d
}

func (d *decrypter) ContentEncryptionAlgorithm(ctalg jwa.ContentEncryptionAlgorithm) *decrypter {
	d.ctalg = ctalg
	return d
}

func (d *decrypter) InitializationVector(iv []byte) *decrypter {
	d.iv = iv
	return d
}

func (d *decrypter) KeyCount(keycount int) *decrypter {
	d.keycount = keycount
	return d
}

func (d *decrypter) KeyInitializationVector(keyiv []byte) *decrypter {
	d.keyiv = keyiv
	return d
}

func (d *decrypter) KeySalt(keysalt []byte) *decrypter {
	d.keysalt = keysalt
	return d
}

func (d *decrypter) KeyTag(keytag []byte) *decrypter {
	d.keytag = keytag
	return d
}

// PublicKey sets the public key to be used in decoding EC based encryptions.
// The key must be in its "raw" format (i.e. *ecdsa.PublicKey, instead of jwk.Key)
func (d *decrypter) PublicKey(pubkey interface{}) *decrypter {
	d.pubkey = pubkey
	return d
}

func (d *decrypter) Tag(tag []byte) *decrypter {
	d.tag = tag
	return d
}

func (d *decrypter) ContentCipher() (content_crypt.Cipher, error) {
	if d.cipher == nil {
		switch d.ctalg {
		case jwa.A128GCM, jwa.A192GCM, jwa.A256GCM, jwa.A128CBC_HS256, jwa.A192CBC_HS384, jwa.A256CBC_HS512:
			cipher, err := cipher.NewAES(d.ctalg)
			if err != nil {
				return nil, fmt.Errorf(`failed to build content cipher for %s: %w`, d.ctalg, err)
			}
			d.cipher = cipher
		default:
			return nil, fmt.Errorf(`invalid content cipher algorithm (%s)`, d.ctalg)
		}
	}

	return d.cipher, nil
}

func (d *decrypter) Decrypt(recipient Recipient, ciphertext []byte, msg *Message) (plaintext []byte, err error) {
	cek, keyerr := d.DecryptKey(recipient, msg)
	if keyerr != nil {
		err = fmt.Errorf(`failed to decrypt key: %w`, keyerr)
		return
	}

	cipher, ciphererr := d.ContentCipher()
	if ciphererr != nil {
		err = fmt.Errorf(`failed to fetch content crypt cipher: %w`, ciphererr)
		return
	}

	computedAad := d.computedAad
	if d.aad != nil {
		computedAad = append(append(computedAad, '.'), d.aad...)
	}

	plaintext, err = cipher.Decrypt(cek, d.iv, ciphertext, d.tag, computedAad)
	if err != nil {
		err = fmt.Errorf(`failed to decrypt payload: %w`, err)
		return
	}

	return plaintext, nil
}

func (d *decrypter) decryptSymmetricKey(recipientKey, cek []byte) ([]byte, error) {
	switch d.keyalg {
	case jwa.DIRECT:
		return cek, nil
	case jwa.PBES2_HS256_A128KW, jwa.PBES2_HS384_A192KW, jwa.PBES2_HS512_A256KW:
		var hashFunc func() hash.Hash
		var keylen int
		switch d.keyalg {
		case jwa.PBES2_HS256_A128KW:
			hashFunc = sha256.New
			keylen = 16
		case jwa.PBES2_HS384_A192KW:
			hashFunc = sha512.New384
			keylen = 24
		case jwa.PBES2_HS512_A256KW:
			hashFunc = sha512.New
			keylen = 32
		}
		salt := []byte(d.keyalg)
		salt = append(salt, byte(0))
		salt = append(salt, d.keysalt...)
		cek = pbkdf2.Key(cek, salt, d.keycount, keylen, hashFunc)
		fallthrough
	case jwa.A128KW, jwa.A192KW, jwa.A256KW:
		block, err := aes.NewCipher(cek)
		if err != nil {
			return nil, fmt.Errorf(`failed to create new AES cipher: %w`, err)
		}

		jek, err := keyenc.Unwrap(block, recipientKey)
		if err != nil {
			return nil, fmt.Errorf(`failed to unwrap key: %w`, err)
		}

		return jek, nil
	case jwa.A128GCMKW, jwa.A192GCMKW, jwa.A256GCMKW:
		if len(d.keyiv) != 12 {
			return nil, fmt.Errorf("GCM requires 96-bit iv, got %d", len(d.keyiv)*8)
		}
		if len(d.keytag) != 16 {
			return nil, fmt.Errorf("GCM requires 128-bit tag, got %d", len(d.keytag)*8)
		}
		block, err := aes.NewCipher(cek)
		if err != nil {
			return nil, fmt.Errorf(`failed to create new AES cipher: %w`, err)
		}
		aesgcm, err := cryptocipher.NewGCM(block)
		if err != nil {
			return nil, fmt.Errorf(`failed to create new GCM wrap: %w`, err)
		}
		ciphertext := recipientKey[:]
		ciphertext = append(ciphertext, d.keytag...)
		jek, err := aesgcm.Open(nil, d.keyiv, ciphertext, nil)
		if err != nil {
			return nil, fmt.Errorf(`failed to decode key: %w`, err)
		}
		return jek, nil
	default:
		return nil, fmt.Errorf("decrypt key: unsupported algorithm %s", d.keyalg)
	}
}

func (d *decrypter) DecryptKey(recipient Recipient, msg *Message) (cek []byte, err error) {
	recipientKey := recipient.EncryptedKey()
	if kd, ok := d.privkey.(KeyDecrypter); ok {
		return kd.DecryptKey(d.keyalg, recipientKey, recipient, msg)
	}

	if d.keyalg.IsSymmetric() {
		var ok bool
		cek, ok = d.privkey.([]byte)
		if !ok {
			return nil, fmt.Errorf("decrypt key: []byte is required as the key to build %s key decrypter (got %T)", d.keyalg, d.privkey)
		}

		return d.decryptSymmetricKey(recipientKey, cek)
	}

	k, err := d.BuildKeyDecrypter()
	if err != nil {
		return nil, fmt.Errorf(`failed to build key decrypter: %w`, err)
	}

	cek, err = k.Decrypt(recipientKey)
	if err != nil {
		return nil, fmt.Errorf(`failed to decrypt key: %w`, err)
	}

	return cek, nil
}

func (d *decrypter) BuildKeyDecrypter() (keyenc.Decrypter, error) {
	cipher, err := d.ContentCipher()
	if err != nil {
		return nil, fmt.Errorf(`failed to fetch content crypt cipher: %w`, err)
	}

	switch alg := d.keyalg; alg {
	case jwa.RSA1_5:
		var privkey rsa.PrivateKey
		if err := keyconv.RSAPrivateKey(&privkey, d.privkey); err != nil {
			return nil, fmt.Errorf(`*rsa.PrivateKey is required as the key to build %s key decrypter: %w`, alg, err)
		}

		return keyenc.NewRSAPKCS15Decrypt(alg, &privkey, cipher.KeySize()/2), nil
	case jwa.RSA_OAEP, jwa.RSA_OAEP_256:
		var privkey rsa.PrivateKey
		if err := keyconv.RSAPrivateKey(&privkey, d.privkey); err != nil {
			return nil, fmt.Errorf(`*rsa.PrivateKey is required as the key to build %s key decrypter: %w`, alg, err)
		}

		return keyenc.NewRSAOAEPDecrypt(alg, &privkey)
	case jwa.A128KW, jwa.A192KW, jwa.A256KW:
		sharedkey, ok := d.privkey.([]byte)
		if !ok {
			return nil, fmt.Errorf("[]byte is required as the key to build %s key decrypter", alg)
		}

		return keyenc.NewAES(alg, sharedkey)
	case jwa.ECDH_ES, jwa.ECDH_ES_A128KW, jwa.ECDH_ES_A192KW, jwa.ECDH_ES_A256KW:
		switch d.pubkey.(type) {
		case x25519.PublicKey:
			return keyenc.NewECDHESDecrypt(alg, d.ctalg, d.pubkey, d.apu, d.apv, d.privkey), nil
		default:
			var pubkey ecdsa.PublicKey
			if err := keyconv.ECDSAPublicKey(&pubkey, d.pubkey); err != nil {
				return nil, fmt.Errorf(`*ecdsa.PublicKey is required as the key to build %s key decrypter: %w`, alg, err)
			}

			var privkey ecdsa.PrivateKey
			if err := keyconv.ECDSAPrivateKey(&privkey, d.privkey); err != nil {
				return nil, fmt.Errorf(`*ecdsa.PrivateKey is required as the key to build %s key decrypter: %w`, alg, err)
			}

			return keyenc.NewECDHESDecrypt(alg, d.ctalg, &pubkey, d.apu, d.apv, &privkey), nil
		}
	default:
		return nil, fmt.Errorf(`unsupported algorithm for key decryption (%s)`, alg)
	}
}
