from create_database_utils import *

import pathlib
import shutil

this_dir = pathlib.Path(__file__).resolve().parent
cwd = pathlib.Path.cwd()
builddir = cwd / 'build'

builddir.mkdir(exist_ok=True)

try:
    runSuccessfully(
        [f'{get_semmle_code_path()}/tools/bazel', f'--output_user_root={builddir}', '--max_idle_secs=1', 'build',
         '//java/ql/integration-tests/linux-only/kotlin/custom_plugin/plugin', '--spawn_strategy=local',
         '--nouse_action_cache', '--noremote_accept_cached', '--noremote_upload_local_results',
         f'--symlink_prefix={cwd / "bazel-"}'], cwd=this_dir)
finally:
    # rules_python creates a read-only directory in bazel's output, this allows cleanup to succeed
    runSuccessfully(['chmod', '-R', '+w', builddir])

shutil.copy(
    'bazel-bin/java/ql/integration-tests/linux-only/kotlin/custom_plugin/plugin/plugin.jar', 'plugin.jar')

run_codeql_database_create(
    ["kotlinc -J-Xmx2G -language-version 1.9 -Xplugin=plugin.jar a.kt b.kt c.kt d.kt e.kt"], lang="java")
