import io

def buffer_rw_pair_test():

    reader = io.BufferedReader(io.RawIOBase)
    # BAD, uses reader for both parameters
    io.BufferedRWPair(reader, reader)

    writer = io.BufferedWriter(io.RawIOBase)
    # GOOD, uses different reader/writer
    io.BufferedRWPair(reader, writer)