#!/usr/bin/env python3

from create_database_utils import *

runSuccessfully([get_cmd("kotlinc"), "FileA.kt", "FileB.kt"])

