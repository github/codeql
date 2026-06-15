from io import BytesIO

import torch


def someSafeMethod():
    pass


PicklePayload = BytesIO(b"payload") 
torch.load(PicklePayload) # $ decodeInput=PicklePayload decodeOutput=torch.load(..) decodeFormat=pickle decodeMayExecuteInput
torch.load(PicklePayload, pickle_module=None) # $ decodeInput=PicklePayload decodeOutput=torch.load(..) decodeFormat=pickle decodeMayExecuteInput
torch.load(PicklePayload, pickle_module=someSafeMethod()) # $ decodeInput=PicklePayload decodeOutput=torch.load(..) decodeFormat=pickle

from torch.package import PackageImporter

importer = PackageImporter(PicklePayload) # $ decodeInput=PicklePayload PackageImporter(..) decodeFormat=pickle decodeMayExecuteInput
my_tensor = importer.load_pickle("my_resources", "tensor.pkl") # $ decodeOutput=importer.load_pickle(..)

importer = PackageImporter(PicklePayload)


from torch import jit

jit.load(PicklePayload)  # $ decodeInput=PicklePayload decodeOutput=jit.load(..) decodeFormat=pickle decodeMayExecuteInput