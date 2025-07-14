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
            "--max_idle_secs=1",
            "build",
            "@codeql//java/ql/integration-tests/kotlin/linux/custom_plugin/plugin",
        ],
        _cwd=semmle_code_dir,
        _env={"CODEQL_BAZEL_REMOTE_CACHE": "false"},
    )
    shutil.copy(
        f"{semmle_code_dir}/bazel-bin/external/ql+/java/ql/integration-tests/kotlin/linux/custom_plugin/plugin/plugin.jar",
        "plugin.jar",
    )
    codeql.database.create(
        command=[
            "kotlinc -J-Xmx2G -language-version 1.9 -Xplugin=plugin.jar a.kt b.kt c.kt d.kt e.kt"
        ]
    )
