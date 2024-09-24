import shutil
import runs_on
import commands


@runs_on.linux
def test(codeql, java_full, cwd, semmle_code_dir, test_dir):
    build_dir = cwd / "build"
    build_dir.mkdir(exist_ok=True)
    commands.run(
        [
            f"{semmle_code_dir}/tools/bazel",
            f"--output_user_root={build_dir}",
            "--max_idle_secs=1",
            "build",
            "//java/ql/integration-tests/kotlin/linux/custom_plugin/plugin",
            "--spawn_strategy=local",
            "--nouse_action_cache",
            "--noremote_accept_cached",
            "--noremote_upload_local_results",
            f'--symlink_prefix={cwd / "bazel-"}',
        ],
        _cwd=test_dir,
    )
    shutil.copy(
        "bazel-bin/java/ql/integration-tests/kotlin/linux/custom_plugin/plugin/plugin.jar",
        "plugin.jar",
    )
    codeql.database.create(
        command=[
            "kotlinc -J-Xmx2G -language-version 1.9 -Xplugin=plugin.jar a.kt b.kt c.kt d.kt e.kt"
        ]
    )
