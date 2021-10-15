
f = open("filename")
try:                         # Method of ensuring file closure
    f.write(...)
finally:
    f.close()


with open("filename") as f:  # Simpler method of ensuring file closure
    f.write(...)