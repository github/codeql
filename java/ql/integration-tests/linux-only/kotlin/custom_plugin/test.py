from create_database_utils import *
import subprocess

subprocess.call("./build_plugin", shell=True)
run_codeql_database_create(
    ["kotlinc -J-Xmx2G -Xplugin=plugin.jar a.kt b.kt c.kt d.kt e.kt"], lang="java")
