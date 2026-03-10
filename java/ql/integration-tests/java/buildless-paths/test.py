import os
import os.path

def test(codeql, java):
    codeql.database.create(build_mode = "none", codescanning_config = "codescanning-config.yml")
