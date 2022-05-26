#!/usr/bin/python3

import sys
import os.path
import subprocess

# Add Model as Data script directory to sys.path.
gitroot = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
madpath = os.path.join(gitroot, "misc/scripts/models-as-data/") # Note that this has been changed.
sys.path.append(madpath)

import generate_flow_model as model

language = "csharp"
model.Generator.make(language).run()