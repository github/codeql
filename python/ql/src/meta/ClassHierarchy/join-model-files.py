#!/usr/bin/env python3

"""Concerns were raised about performance on Windows with having 2.5 k files for modeling, and it was recommended we join them all together when shipping.

This script does that.

Workflow when working on the automatic subclass modeling:
1. split files
2. do your work
3. join files
4. commit your changes
"""

import sys
import glob
import os

from shared_subclass_functions import *

if joined_file.exists():
    sys.exit(f"File {joined_file} already exists")

package_data = gather_from_existing()
as_lists = list()
for data in package_data.values():
    as_lists.extend(list(t) for t in data)
as_lists.sort()


write_data_extension(as_lists, VERSION, joined_file)

print("Joined all files into", joined_file)

for f in glob.glob(f"{subclass_capture_path}/auto-*.model.json", recursive=True):
    os.unlink(f)
