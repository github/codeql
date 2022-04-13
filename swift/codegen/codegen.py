#!/usr/bin/env python3

from lib import generator
import dbschemegen

if __name__ == "__main__":
    generator.run(dbschemegen.generate)
