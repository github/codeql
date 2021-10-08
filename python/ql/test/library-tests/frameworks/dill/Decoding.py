import dill

dill.load(file_)  # $ MISSING: decodeInput=file_ decodeOutput=dill.loads(..) decodeFormat=dill decodeMayExecuteInput
dill.load(file=file_)  # $ MISSING: decodeInput=file_ decodeOutput=dill.loads(..) decodeFormat=dill decodeMayExecuteInput
dill.loads(payload)  # $ decodeInput=payload decodeOutput=dill.loads(..) decodeFormat=dill decodeMayExecuteInput
dill.loads(str=payload)  # $ decodeOutput=dill.loads(..) decodeFormat=dill decodeMayExecuteInput MISSING: decodeInput=payload
