import base64

# TODO: These tests should be merged with python/ql/test/library-tests/dataflow/tainttracking/defaultAdditionalTaintStep-py3/test_string.py
base64.a85encode(bs) # $ encodeInput=bs encodeOutput=base64.a85encode(..) encodeFormat=Ascii85
base64.b85encode(bs)# $ encodeInput=bs encodeOutput=base64.b85encode(..) encodeFormat=Base85
base64.encodebytes(bs)# $ encodeInput=bs encodeOutput=base64.encodebytes(..) encodeFormat=Base64
