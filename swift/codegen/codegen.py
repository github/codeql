#!/usr/bin/env python3
""" Driver script to run all checked in code generation """

from lib import generator
import dbschemegen
import qlgen

if __name__ == "__main__":
    generator.run(dbschemegen.generate, qlgen.generate)
