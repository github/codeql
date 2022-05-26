#!/usr/bin/env python3
""" Driver script to run all checked in code generation """

from swift.codegen.generators import generator, dbschemegen, qlgen

if __name__ == "__main__":
    generator.run(dbschemegen, qlgen)
