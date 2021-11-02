import toml
from io import StringIO

encoded = 'title = "example"\n'
decoded = {"title" : "example"}

# LOADING
assert decoded == toml.loads(encoded) # $ MISSING: decodeInput=encoded
assert decoded == toml.loads(s=encoded) # $ MISSING: decodeInput=encoded

# this is not the official way to do things, but it works
assert decoded == toml.decoder.loads(encoded) # $ MISSING: decodeInput=encoded

f_encoded = StringIO(encoded)
assert decoded == toml.load(f_encoded) # $ MISSING: decodeInput=f_encoded

f_encoded = StringIO(encoded)
assert decoded == toml.load(f=f_encoded) # $ MISSING: decodeInput=f_encoded

f_encoded = StringIO(encoded)
assert decoded == toml.decoder.load(f_encoded) # $ MISSING: decodeInput=f_encoded

# DUMPING
assert encoded == toml.dumps(decoded) # $ MISSING: encodeInput=decoded
assert encoded == toml.dumps(o=decoded) # $ MISSING: encodeInput=decoded
assert encoded == toml.encoder.dumps(decoded) # $ MISSING: encodeInput=decoded

f_encoded = StringIO()
toml.dump(decoded, f_encoded) # $ MISSING: encodeInput=decoded
assert encoded == f_encoded.getvalue()

f_encoded = StringIO()
toml.dump(o=decoded, f=f_encoded) # $ MISSING: encodeInput=decoded
assert encoded == f_encoded.getvalue()

f_encoded = StringIO()
toml.encoder.dump(decoded, f_encoded) # $ MISSING: encodeInput=decoded
assert encoded == f_encoded.getvalue()
