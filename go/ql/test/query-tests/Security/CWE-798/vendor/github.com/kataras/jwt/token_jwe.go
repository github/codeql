package jwt

/* TODO? Add support for JWS and JWE.
Currently, Out of this package's scope, more complexity will be added to the package (see gcm.go file instead).
If and only if it's requested by many users: add support for protected and encrypted tokens.
https://tools.ietf.org/html/rfc7516#section-3
Chapters 4 and 5 of the official JWT handbook (v0.14.1)

Let's think in terms of producers and consumers. The producer
either signs or encrypts the data, so consumers can either validate it or decrypt it. In the case of
JWT signatures, the private-key is used to sign JWTs, while the public-key can be used to validate
it. The producer holds the private-key and the consumers hold the public-key. Data can only flow
from private-key holders to public-key holders. In contrast, for JWT encryption, the public-key is
used to encrypt the data and the private-key to decrypt it. In this case, the data can only flow from
public-key holders to private-key holders - public-key holders are the producers and private-key
holders are the consumers:
          | JWS         | JWE
 Producer | Private-key | Public-key
 Consumer | Public-key  | Private-key
*/

/*
5.1.3 The Header
Just like the header for JWS and unsecured JWTs, the header carries all the necessary information
for the JWT to be correctly processed by libraries. The JWE specification adapts the meanings of
the registered claims defined in JWS to its own use, and adds a few claims of its own. These are
the new and modified claims:
• alg: identical to JWS, except it defines the algorithm to be used to encrypt and decrypt the
Content Encryption Key (CEK). In other words, this algorithm is used to encrypt the actual
key that is later used to encrypt the content.
• enc: the name of the algorithm used to encrypt the content using the CEK.
• zip: a compression algorithm to be applied to the encrypted data before encryption. This
parameter is optional. When it is absent, no compression is performed. A usual value for this
is DEF, the common deflate algorithm2
.
• jku: identical to JWS, except in this case the claim points to the public-key used to encrypt
the CEK.
• jkw: identical to JWS, except in this case the claim points to the public-key used to encrypt
the CEK.
• kid: identical to JWS, except in this case the claim points to the public-key used to encrypt
the CEK.
• x5u: identical to JWS, except in this case the claim points to the public-key used to encrypt
the CEK.
• x5c: identical to JWS, except in this case the claim points to the public-key used to encrypt
the CEK.

func createProtectedHeader(alg, kid string, extraHeaders ...json.RawMessage) ([]byte, error) {
	if kid == "" && len(extraHeaders) == 0 {
		return createHeader(alg), nil
	}

	var header bytes.Buffer
	if kid != "" {
		header.WriteString(`{"alg":"` + alg + `","kid":"` + kid + `","typ":"JWT"}`)
	} else {
		header.WriteString(`{"alg":"` + alg + `","typ":"JWT"}`)
	}

	// Add any extra headers as separated JSON objects.
	for _, v := range extraHeaders {
		header.WriteByte(',')
		err := json.Compact(&header, v) // validate minify and JSON.
		if err != nil {
			return nil, err
		}
	}

	return Base64Encode(header.Bytes()), nil
}
*/
