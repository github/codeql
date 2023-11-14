import os

from create_database_utils import *
from diagnostics_test_utils import *

def is_running_on_apple_silicon():
   arch = subprocess.Popen(['sysctl', 'machdep.cpu.brand_string'], stdout=subprocess.PIPE)
   output, errors = arch.communicate()
   if b'apple' in output.lower():
       return True
   return False

# if on ARM runners, remove Mono from the path, so we're using
# dotnet restore instead of nuget.exe restore - on ARM machines
# we run dotnet msbuild (instead of the mono-provided msbuild.exe)
# so we need to match the restore command, too.

platform_name = sys.platform.lower()
if platform_name.startswith("darwin") and is_running_on_apple_silicon():
    os.environ["PATH"] = os.environ["PATH"].replace("/Library/Frameworks/Mono.framework/Versions/Current/Commands:", "")

# force CodeQL to use MSBuild by setting `LGTM_INDEX_MSBUILD_TARGET`
run_codeql_database_create([], db=None, lang="csharp", extra_env={ 'LGTM_INDEX_MSBUILD_TARGET': 'Build' })
check_diagnostics()
