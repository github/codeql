import toml
from io import StringIO

encoded = 'title = "example"\n'
decoded = {"title" : "example"}

# LOADING
assert decoded == toml.loads(encoded) # $ decodeInput=encoded decodeFormat=TOML decodeOutput=toml.loads(..)
assert decoded == toml.loads(s=encoded) # $ decodeInput=encoded decodeFormat=TOML decodeOutput=toml.loads(..)

# this is not the official way to do things, but it works
assert decoded == toml.decoder.loads(encoded) # $ decodeInput=encoded decodeFormat=TOML decodeOutput=toml.decoder.loads(..)

f_encoded = StringIO(encoded)
assert decoded == toml.load(f_encoded) # $ decodeInput=f_encoded decodeFormat=TOML decodeOutput=toml.load(..)

f_encoded = StringIO(encoded)
assert decoded == toml.load(f=f_encoded) # $ decodeInput=f_encoded decodeFormat=TOML decodeOutput=toml.load(..)

f_encoded = StringIO(encoded)
assert decoded == toml.decoder.load(f_encoded) # $ decodeInput=f_encoded decodeFormat=TOML decodeOutput=toml.decoder.load(..)

# DUMPING
assert encoded == toml.dumps(decoded) # $ encodeInput=decoded encodeFormat=TOML encodeOutput=toml.dumps(..)
assert encoded == toml.dumps(o=decoded) # $ encodeInput=decoded encodeFormat=TOML encodeOutput=toml.dumps(..)
assert encoded == toml.encoder.dumps(decoded) # $ encodeInput=decoded encodeFormat=TOML encodeOutput=toml.encoder.dumps(..)

f_encoded = StringIO()
toml.dump(decoded, f_encoded) # $ encodeInput=decoded encodeFormat=TOML encodeOutput=f_encoded
assert encoded == f_encoded.getvalue()

f_encoded = StringIO()
toml.dump(o=decoded, f=f_encoded) # $ encodeInput=decoded encodeFormat=TOML encodeOutput=f_encoded
assert encoded == f_encoded.getvalue()

f_encoded = StringIO()
toml.encoder.dump(decoded, f_encoded) # $ encodeInput=decoded encodeFormat=TOML encodeOutput=f_encoded
assert encoded == f_encoded.getvalue()
