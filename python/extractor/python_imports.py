#!/usr/bin/env python
'''This module sets up sys.path from the environment
and runs the .import file generation.'''

import python_tracer

if __name__ == "__main__":
    python_tracer.load_library()
    import semmle.imports
    semmle.imports.main()
