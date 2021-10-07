import pickle
import marshal
import shelve
import base64

pickle.load(file_)  # $ MISSING: decodeInput=file_ decodeOutput=pickle.load(..) decodeFormat=pickle decodeMayExecuteInput
pickle.load(file=file_)  # $ MISSING: decodeInput=file_ decodeOutput=pickle.load(..) decodeFormat=pickle decodeMayExecuteInput
pickle.loads(payload)  # $ decodeInput=payload decodeOutput=pickle.loads(..) decodeFormat=pickle decodeMayExecuteInput
# using this keyword argument is disallowed from Python 3.9
pickle.loads(data=payload)  # $ decodeOutput=pickle.loads(..) decodeFormat=pickle decodeMayExecuteInput MISSING: decodeInput=payload

marshal.load(file_)  # $ MISSING: decodeInput=file_ decodeOutput=marshal.load(..) decodeFormat=marshal decodeMayExecuteInput
marshal.loads(payload)  # $ decodeInput=payload decodeOutput=marshal.loads(..) decodeFormat=marshal decodeMayExecuteInput


# if the file opened has been controlled by an attacker, this can lead to code
# execution. (underlying file format is pickle)
shelve.open(filepath)  # $ MISSING: decodeInput=filepath decodeOutput=shelve.open(..) decodeFormat=pickle decodeMayExecuteInput getAPathArgument=filepath
shelve.open(filename=filepath)  # $ MISSING: decodeInput=filepath decodeOutput=shelve.open(..) decodeFormat=pickle decodeMayExecuteInput getAPathArgument=filepath

# TODO: These tests should be merged with python/ql/test/experimental/dataflow/tainttracking/defaultAdditionalTaintStep/test_string.py
base64.b64decode(payload)  # $ decodeInput=payload decodeOutput=base64.b64decode(..) decodeFormat=Base64
base64.standard_b64decode(payload)  # $ decodeInput=payload decodeOutput=base64.standard_b64decode(..) decodeFormat=Base64
base64.urlsafe_b64decode(payload)  # $ decodeInput=payload decodeOutput=base64.urlsafe_b64decode(..) decodeFormat=Base64
base64.b32decode(payload)  # $ decodeInput=payload decodeOutput=base64.b32decode(..) decodeFormat=Base32
base64.b16decode(payload)  # $ decodeInput=payload decodeOutput=base64.b16decode(..) decodeFormat=Base16
# deprecated since Python 3.1, but still works
base64.decodestring(payload)  # $ decodeInput=payload decodeOutput=base64.decodestring(..) decodeFormat=Base64
