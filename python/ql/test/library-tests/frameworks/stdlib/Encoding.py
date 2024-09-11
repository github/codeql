import pickle
import marshal
import base64

pickle.dumps(obj)  # $ MISSING: encodeInput=obj encodeOutput=pickle.dumps(..) encodeFormat=pickle encodeMayExecuteInput
marshal.dumps(obj)  # $ MISSING: encodeInput=obj encodeOutput=marshal.dumps(..) encodeFormat=marshal encodeMayExecuteInput

# TODO: These tests should be merged with python/ql/test/library-tests/dataflow/tainttracking/defaultAdditionalTaintStep/test_string.py
base64.b64encode(bs)  # $ encodeInput=bs encodeOutput=base64.b64encode(..) encodeFormat=Base64
base64.standard_b64encode(bs)  # $ encodeInput=bs encodeOutput=base64.standard_b64encode(..) encodeFormat=Base64
base64.urlsafe_b64encode(bs)  # $ encodeInput=bs encodeOutput=base64.urlsafe_b64encode(..) encodeFormat=Base64
base64.b32encode(bs)  # $ encodeInput=bs encodeOutput=base64.b32encode(..) encodeFormat=Base32
base64.b32hexencode(bs)  # $ encodeInput=bs encodeOutput=base64.b32hexencode(..) encodeFormat=Base32
base64.b16encode(bs)  # $ encodeInput=bs encodeOutput=base64.b16encode(..) encodeFormat=Base16
# deprecated since Python 3.1, but still works
base64.encodestring(bs)  # $ encodeInput=bs encodeOutput=base64.encodestring(..) encodeFormat=Base64
