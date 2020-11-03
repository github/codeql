import base64

# TODO: These tests should be merged with python/ql/test/experimental/dataflow/tainttracking/defaultAdditionalTaintStep-py3/test_string.py
base64.a85decode(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=Ascii85
base64.b85decode(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=Base85
base64.decodebytes(payload)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=Base64
