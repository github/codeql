#!/usr/bin/env python3

import os
import subprocess

from create_database_utils import *

os.environ['CODEQL_KOTLIN_INTERNAL_EXCEPTION_WHILE_EXTRACTING_FILE'] = 'B.kt'

subprocess.check_call([get_cmd('kotlinc'), 'A.kt', 'B.kt', 'C.kt', ])
