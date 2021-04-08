import pickle
import marshal
import base64

pickle.loads(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=pickle decodeMayExecuteInput
marshal.loads(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=marshal decodeMayExecuteInput

# TODO: These tests should be merged with python/ql/test/experimental/dataflow/tainttracking/defaultAdditionalTaintStep/test_string.py
base64.b64decode(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=Base64
base64.standard_b64decode(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=Base64
base64.urlsafe_b64decode(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=Base64
base64.b32decode(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=Base32
base64.b16decode(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=Base16
# deprecated since Python 3.1, but still works
base64.decodestring(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=Base64
