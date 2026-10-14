import binascii
from binascii import b2a_base32 as encode32, a2b_base85 as decode85

data = TAINTED_BYTES

encoded32 = binascii.b2a_base32(data, padded=False) # $ encodeInput=data encodeOutput=binascii.b2a_base32(..) encodeFormat=Base32
decoded32 = binascii.a2b_base32(encoded32, padded=False, canonical=True) # $ decodeInput=encoded32 decodeOutput=binascii.a2b_base32(..) decodeFormat=Base32

encoded85 = binascii.b2a_base85(data, pad=True) # $ encodeInput=data encodeOutput=binascii.b2a_base85(..) encodeFormat=Base85
decoded85 = binascii.a2b_base85(encoded85, canonical=True) # $ decodeInput=encoded85 decodeOutput=binascii.a2b_base85(..) decodeFormat=Base85

encoded_ascii85 = binascii.b2a_ascii85(data, foldspaces=True, adobe=True) # $ encodeInput=data encodeOutput=binascii.b2a_ascii85(..) encodeFormat=Ascii85
decoded_ascii85 = binascii.a2b_ascii85(encoded_ascii85, foldspaces=True, adobe=True) # $ decodeInput=encoded_ascii85 decodeOutput=binascii.a2b_ascii85(..) decodeFormat=Ascii85

ensure_tainted(
    encoded32, # $ tainted
    decoded32, # $ tainted
    encoded85, # $ tainted
    decoded85, # $ tainted
    encoded_ascii85, # $ tainted
    decoded_ascii85, # $ tainted
)

aliased_encoded = encode32(data) # $ encodeInput=data encodeOutput=encode32(..) encodeFormat=Base32
aliased_decoded = decode85(encoded85) # $ decodeInput=encoded85 decodeOutput=decode85(..) decodeFormat=Base85
ensure_tainted(
    aliased_encoded, # $ tainted
    aliased_decoded, # $ tainted
)


def custom_alphabets():
    alphabet32 = binascii.BASE32HEX_ALPHABET
    alphabet85 = binascii.Z85_ALPHABET
    taint(alphabet32, alphabet85)

    clean = b"abcd"
    clean32 = b"00000000"
    clean85 = b"00000"
    encoded32 = binascii.b2a_base32(clean, alphabet=alphabet32) # $ encodeInput=clean encodeInput=alphabet32 encodeOutput=binascii.b2a_base32(..) encodeFormat=Base32
    decoded32 = binascii.a2b_base32(clean32, alphabet=alphabet32) # $ decodeInput=clean32 decodeInput=alphabet32 decodeOutput=binascii.a2b_base32(..) decodeFormat=Base32
    encoded85 = binascii.b2a_base85(clean, alphabet=alphabet85) # $ encodeInput=clean encodeInput=alphabet85 encodeOutput=binascii.b2a_base85(..) encodeFormat=Base85
    decoded85 = binascii.a2b_base85(clean85, alphabet=alphabet85) # $ decodeInput=clean85 decodeInput=alphabet85 decodeOutput=binascii.a2b_base85(..) decodeFormat=Base85
    ensure_tainted(
        encoded32, # $ tainted
        decoded32, # $ tainted
        encoded85, # $ tainted
        decoded85, # $ tainted
    )


def clean_inputs():
    clean = b"abcd"
    empty = b""
    wrapcol = 80
    ignorechars = b" \n"
    taint(wrapcol, ignorechars)

    encoded32 = binascii.b2a_base32(clean, wrapcol=wrapcol) # $ encodeInput=clean encodeOutput=binascii.b2a_base32(..) encodeFormat=Base32
    encoded85 = binascii.b2a_base85(clean, wrapcol=wrapcol) # $ encodeInput=clean encodeOutput=binascii.b2a_base85(..) encodeFormat=Base85
    encoded_ascii85 = binascii.b2a_ascii85(clean, wrapcol=wrapcol) # $ encodeInput=clean encodeOutput=binascii.b2a_ascii85(..) encodeFormat=Ascii85
    decoded32 = binascii.a2b_base32(empty, ignorechars=ignorechars) # $ decodeInput=empty decodeOutput=binascii.a2b_base32(..) decodeFormat=Base32
    decoded85 = binascii.a2b_base85(empty, ignorechars=ignorechars) # $ decodeInput=empty decodeOutput=binascii.a2b_base85(..) decodeFormat=Base85
    decoded_ascii85 = binascii.a2b_ascii85(empty, ignorechars=ignorechars) # $ decodeInput=empty decodeOutput=binascii.a2b_ascii85(..) decodeFormat=Ascii85
    ensure_not_tainted(
        encoded32,
        encoded85,
        encoded_ascii85,
        decoded32,
        decoded85,
        decoded_ascii85,
    )
