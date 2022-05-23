#!/usr/bin/env python3
""" Driver script to run all cpp code generation """

from swift.codegen.generators import generator, dbschemegen, trapgen, cppgen

if __name__ == "__main__":
    generator.run(dbschemegen, trapgen, cppgen)
