import dill

dill.load(file_)  # $ decodeInput=file_ decodeOutput=dill.load(..) decodeFormat=dill decodeMayExecuteInput
dill.load(file=file_)  # $ decodeInput=file_ decodeOutput=dill.load(..) decodeFormat=dill decodeMayExecuteInput
dill.loads(payload)  # $ decodeInput=payload decodeOutput=dill.loads(..) decodeFormat=dill decodeMayExecuteInput
dill.loads(str=payload)  # $ decodeInput=payload decodeOutput=dill.loads(..) decodeFormat=dill decodeMayExecuteInput
