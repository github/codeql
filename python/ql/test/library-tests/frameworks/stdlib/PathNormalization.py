import os.path

path = "un\\normalized/path"

p1 = os.path.normpath(path)  # $pathNormalization
p2 = os.path.normpath(path=path)  # $pathNormalization

np = os.path.normpath

p3 = np(path)  # $pathNormalization
p4 = np(path=path)  # $pathNormalization


def normalize(path):
    return os.path.normpath(path)  # $pathNormalization


p5 = normalize(path)
p6 = normalize(path=path)
