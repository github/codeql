import io

def buffer_rw_pair_test():

    reader = io.BufferedReader(io.RawIOBase)
    # BAD, uses reader for both parameters
    pair1 = io.BufferedRWPair(reader, reader)

    writer = io.BufferedWriter(io.RawIOBase)
    # GOOD, uses different reader/writer
    pair2 = io.BufferedRWPair(reader, writer)

    # GOOD, uses reader variable as both reader and writer for random access
    random = io.BufferedRandom(reader)

    return (pair1, pair2, random)