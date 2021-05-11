import pickle
import marshal
import base64

pickle.dumps(obj)  # $ MISSING: encodeInput=obj encodeOutput=Attribute() encodeFormat=pickle encodeMayExecuteInput
marshal.dumps(obj)  # $ MISSING: encodeInput=obj encodeOutput=Attribute() encodeFormat=marshal encodeMayExecuteInput

# TODO: These tests should be merged with python/ql/test/experimental/dataflow/tainttracking/defaultAdditionalTaintStep/test_string.py
base64.b64encode(bs)  # $ encodeInput=bs encodeOutput=Attribute() encodeFormat=Base64
base64.standard_b64encode(bs)  # $ encodeInput=bs encodeOutput=Attribute() encodeFormat=Base64
base64.urlsafe_b64encode(bs)  # $ encodeInput=bs encodeOutput=Attribute() encodeFormat=Base64
base64.b32encode(bs)  # $ encodeInput=bs encodeOutput=Attribute() encodeFormat=Base32
base64.b16encode(bs)  # $ encodeInput=bs encodeOutput=Attribute() encodeFormat=Base16
# deprecated since Python 3.1, but still works
base64.encodestring(bs)  # $ encodeInput=bs encodeOutput=Attribute() encodeFormat=Base64
