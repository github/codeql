from tempfile import mktemp
import os

def write_results1(results):
    filename = mktemp()
    with open(filename, "w+") as f:
        f.write(results)
    print("Results written to", filename)

def write_results2(results):
    filename = os.tempnam()
    with open(filename, "w+") as f:
        f.write(results)
    print("Results written to", filename)

def write_results3(results):
    filename = os.tmpnam()
    with open(filename, "w+") as f:
        f.write(results)
    print("Results written to", filename)
