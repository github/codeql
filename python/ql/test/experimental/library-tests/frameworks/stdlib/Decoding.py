import pickle
import marshal

pickle.loads(payload)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=pickle $decodeMayExecuteInput
marshal.loads(payload)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=marshal $decodeMayExecuteInput
