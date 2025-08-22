#!/usr/bin/env python
"""Run the thrift extractor locally for debugging.
"""
import sys
import python_tracer

if __name__ == "__main__":
    python_tracer.load_library()
    import semmle.thrift
    import semmle.files
    if len(sys.argv) != 3:
        print("Usage %s INPUT_FOLDER TRAP_FOLDER" % sys.argv[0])
        sys.exit(1)
    trap_folder = semmle.files.TrapFolder(sys.argv[2])
    extractor = semmle.thrift.Extractor(trap_folder)
    extractor.extract_folder(sys.argv[1])
