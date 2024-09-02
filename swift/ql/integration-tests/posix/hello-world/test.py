import runs_on
import subprocess


@runs_on.posix
def test(codeql, swift):
    try:
        codeql.database.create(command="swift build")
    except Exception:
        if runs_on.macos:
            subprocess.run("sudo du -h /System/Volumes/Data > dirs_unsorted.list", shell=True)
            subprocess.run("sort -h dirs_unsorted.list > dirs.log", shell=True)
            subprocess.run("rm -f dirs_unsorted.list", shell=True)
        raise
