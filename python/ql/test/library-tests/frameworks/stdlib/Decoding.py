import pickle
import marshal
import shelve
import base64

pickle.load(file_)  # $ decodeInput=file_ decodeOutput=pickle.load(..) decodeFormat=pickle decodeMayExecuteInput
pickle.load(file=file_)  # $ decodeInput=file_ decodeOutput=pickle.load(..) decodeFormat=pickle decodeMayExecuteInput
pickle.loads(payload)  # $ decodeInput=payload decodeOutput=pickle.loads(..) decodeFormat=pickle decodeMayExecuteInput
# using this keyword argument is disallowed from Python 3.9
pickle.loads(data=payload)  # $ decodeInput=payload decodeOutput=pickle.loads(..) decodeFormat=pickle decodeMayExecuteInput

# We don't really have a good way to model a decode happening over multiple statements
# like this. Since the important bit for `py/unsafe-deserialization` is the input, that
# is the main focus. We do a best effort to model the output though (but that will only
# work in local scope).
unpickler = pickle.Unpickler(file_) # $ decodeInput=file_ decodeFormat=pickle decodeMayExecuteInput
unpickler.load() # $ decodeOutput=unpickler.load()
unpickler = pickle.Unpickler(file=file_) # $ decodeInput=file_ decodeFormat=pickle decodeMayExecuteInput

marshal.load(file_)  # $ decodeInput=file_ decodeOutput=marshal.load(..) decodeFormat=marshal decodeMayExecuteInput
marshal.loads(payload)  # $ decodeInput=payload decodeOutput=marshal.loads(..) decodeFormat=marshal decodeMayExecuteInput


# if the file opened has been controlled by an attacker, this can lead to code
# execution. (underlying file format is pickle)
shelve.open(filepath)  # $ decodeInput=filepath decodeOutput=shelve.open(..) decodeFormat=pickle decodeMayExecuteInput getAPathArgument=filepath
shelve.open(filename=filepath)  # $ decodeInput=filepath decodeOutput=shelve.open(..) decodeFormat=pickle decodeMayExecuteInput getAPathArgument=filepath

# TODO: These tests should be merged with python/ql/test/library-tests/dataflow/tainttracking/defaultAdditionalTaintStep/test_string.py
base64.b64decode(payload)  # $ decodeInput=payload decodeOutput=base64.b64decode(..) decodeFormat=Base64
base64.standard_b64decode(payload)  # $ decodeInput=payload decodeOutput=base64.standard_b64decode(..) decodeFormat=Base64
base64.urlsafe_b64decode(payload)  # $ decodeInput=payload decodeOutput=base64.urlsafe_b64decode(..) decodeFormat=Base64
base64.b32decode(payload)  # $ decodeInput=payload decodeOutput=base64.b32decode(..) decodeFormat=Base32
base64.b32hexdecode(payload)  # $ decodeInput=payload decodeOutput=base64.b32hexdecode(..) decodeFormat=Base32
base64.b16decode(payload)  # $ decodeInput=payload decodeOutput=base64.b16decode(..) decodeFormat=Base16
# deprecated since Python 3.1, but still works
base64.decodestring(payload)  # $ decodeInput=payload decodeOutput=base64.decodestring(..) decodeFormat=Base64
