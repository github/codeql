import sys
import os
import helpers
import json
import shutil

print('Script to generate stub files for all C# packages relevant for tests.')
print('Please extend the `packages` list in this script to add more packages when relevant.')
print(' Usage: python3 ' + sys.argv[0] + ' ' + '[WORK_DIR=tempDir]')

# List of packages to create stubs for.
packages = [
    "Amazon.Lambda.Core",
    "Amazon.Lambda.APIGatewayEvents",
    "Dapper",
    "EntityFramework",
    "Newtonsoft.Json",
    "NHibernate",
    "ServiceStack",
    "ServiceStack.OrmLite.SqlServer",
    "System.Data.OleDb",
    "System.Data.SqlClient",
    "System.Data.SQLite",
    ]

thisScript = sys.argv[0]
template = "webapp"
relativeWorkDir = helpers.get_argv(1, "tempDir")


generator = helpers.Generator(thisScript, relativeWorkDir, template)

for package in packages:
    generator.add_nuget(package)

generator.make_stubs()

exit(0)
