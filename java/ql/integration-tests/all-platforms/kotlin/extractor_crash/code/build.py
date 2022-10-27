#!/usr/bin/env python3

import os
import subprocess

os.environ['CODEQL_KOTLIN_INTERNAL_EXCEPTION_WHILE_EXTRACTING_FILE'] = 'B.kt'

subprocess.check_call(['kotlinc', 'A.kt', 'B.kt', 'C.kt', ])
