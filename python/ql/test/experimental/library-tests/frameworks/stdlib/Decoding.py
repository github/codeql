import pickle
import marshal

pickle.loads(payload)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=pickle $decodeUnsafe
marshal.loads(payload)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=marshal $decodeUnsafe
