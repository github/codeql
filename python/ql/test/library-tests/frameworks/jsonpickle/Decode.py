import os

import jsonpickle


class Thing(object):
    def __reduce__(self):
        return os.system, ("curl 127.0.0.1:1234",)


obj = Thing()

pickledObj = jsonpickle.encode(obj)
objUnPickled = jsonpickle.decode(pickledObj, safe=True)  # $ decodeInput=pickledObj decodeOutput=jsonpickle.decode(..) decodeFormat=pickle decodeMayExecuteInput
print(objUnPickled.name)
