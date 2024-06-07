#!/usr/bin/env python3

"""Concerns were raised about performance on Windows with having 2.5 k files for modeling, and it was recommended we join them all together when shipping.

This script does the opposite, so it's easier to work with locally.

Workflow when working on the automatic subclass modeling:
1. split files
2. do your work
3. join files
4. commit your changes
"""

import sys
from collections import defaultdict

from shared_subclass_functions import *

if not joined_file.exists():
    sys.exit(f"File {joined_file} does not exists")

all_data = parse_from_file(joined_file)
package_data = defaultdict(set)
for t in all_data:
    package_data[t[1]].add(t)
write_all_package_data_to_files(package_data)

joined_file.unlink()
