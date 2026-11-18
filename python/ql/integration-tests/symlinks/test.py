import pytest
import runs_on


@runs_on.posix
@pytest.mark.timeout(30)
def test(codeql, python, cwd):
    # Create two symlink loops:
    # - repo_dir/subdir/symlink_to_top -> repo_dir
    # - repo_dir/symlink_to_top -> repo_dir
    # Such a setup was seen in https://github.com/PowerDNS/weakforced.
    repo_dir = cwd / "repo_dir"
    (repo_dir / "subdir").mkdir()
    (repo_dir / "subdir" / "symlink_to_top").symlink_to("..", target_is_directory=True)
    (repo_dir / "symlink_to_top").symlink_to(".", target_is_directory=True)
    codeql.database.create(source_root="repo_dir")
