import sys
import os
import helpers

print('Script to generate stub file from a nuget package')
print(' Usage: python3 ' + sys.argv[0] +
      ' TEMPLATE NUGET_PACKAGE_NAME [VERSION=latest] [WORK_DIR=tempDir]')
print(' The script uses the dotnet cli, codeql cli, and dotnet format global tool')
print(' TEMPLATE should be either classlib or webapp, depending on the nuget package. For example, `Swashbuckle.AspNetCore.Swagger` should use `webapp` while `newtonsoft.json` should use `classlib`.')

if len(sys.argv) < 2:
    print("\nPlease supply a template name.")
    exit(1)

if len(sys.argv) < 3:
    print("\nPlease supply a nuget package name.")
    exit(1)

thisScript = sys.argv[0]
template = sys.argv[1]
nuget = sys.argv[2]
version = helpers.get_argv(3, "latest")
relativeWorkDir = helpers.get_argv(4, "tempDir")


generator = helpers.Generator(thisScript, relativeWorkDir, template)
generator.add_nuget(nuget, version)
generator.make_stubs()

exit(0)
