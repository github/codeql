import numpy

numpy.load(file_)  # $ decodeInput=file_ decodeOutput=numpy.load(..) decodeFormat=numpy
numpy.load(filename=file_)  # $ decodeInput=file_ decodeOutput=numpy.load(..) decodeFormat=numpy
numpy.load(file_, allow_pickle=True)  # $ decodeInput=file_ decodeOutput=numpy.load(..) decodeFormat=numpy decodeFormat=pickle decodeMayExecuteInput
numpy.load(file_, None, True)  # $ decodeInput=file_ decodeOutput=numpy.load(..) decodeFormat=numpy decodeFormat=pickle decodeMayExecuteInput
