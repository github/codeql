import os
import pytest
import shutil
import glob

import buildtools.index
from tests.buildtools.helper import in_fresh_temp_dir

# we use `monkeypatch.setenv` instead of setting `os.environ` directly, since that produces
# cross-talk between tests. (using mock.patch.dict is only available for Python 3)


class TestIncludeOptions:
    @staticmethod
    def test_LGTM_SRC(monkeypatch):
        monkeypatch.setenv("LGTM_SRC", "path/src")
        assert buildtools.index.get_include_options() == ["-R", "path/src"]

    @staticmethod
    def test_LGTM_INDEX_INCLUDE(monkeypatch):
        monkeypatch.setenv("LGTM_INDEX_INCLUDE", "/foo\n/bar")
        assert buildtools.index.get_include_options() == ["-R", "/foo", "-R", "/bar"]


class TestPip21_3:
    @staticmethod
    def test_no_build_dir(monkeypatch):
        with in_fresh_temp_dir() as path:
            os.makedirs(os.path.join(path, "src"))
            monkeypatch.setenv("LGTM_SRC", path)
            assert buildtools.index.exclude_pip_21_3_build_dir_options() == []

    @staticmethod
    def test_faked_build_dir(monkeypatch):
        # since I don't want to introduce specific pip version on our
        # testing infrastructure, I'm just going to fake that `pip install .` had
        # been called.
        with in_fresh_temp_dir() as path:
            os.makedirs(os.path.join(path, "build", "lib"))
            monkeypatch.setenv("LGTM_SRC", path)
            expected = ["-Y", os.path.join(path, "build")]
            assert buildtools.index.exclude_pip_21_3_build_dir_options() == expected

    @staticmethod
    def test_disable_environment_variable(monkeypatch):
        monkeypatch.setenv(
            "CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_PIP_BUILD_DIR_EXCLUDE", "1"
        )
        with in_fresh_temp_dir() as path:
            os.makedirs(os.path.join(path, "build", "lib"))
            monkeypatch.setenv("LGTM_SRC", path)
            assert buildtools.index.exclude_pip_21_3_build_dir_options() == []

    @staticmethod
    def test_code_build_dir(monkeypatch):
        # simulating that you have the module `mypkg.build.lib.foo`
        with in_fresh_temp_dir() as path:
            os.makedirs(os.path.join(path, "mypkg", "build", "lib"))
            open(os.path.join(path, "mypkg", "build", "lib", "foo.py"), "wt").write("print(42)")
            open(os.path.join(path, "mypkg", "build", "lib", "__init__.py"), "wt").write("")
            open(os.path.join(path, "mypkg", "build", "__init__.py"), "wt").write("")
            open(os.path.join(path, "mypkg", "__init__.py"), "wt").write("")

            monkeypatch.setenv("LGTM_SRC", path)
            assert buildtools.index.exclude_pip_21_3_build_dir_options() == []


def create_fake_venv(path, is_unix):
    os.makedirs(path)
    open(os.path.join(path, "pyvenv.cfg"), "wt").write("")
    if is_unix:
        os.mkdir(os.path.join(path, "bin"))
        open(os.path.join(path, "bin", "activate"), "wt").write("")
        os.makedirs(os.path.join(path, "lib", "python3.10", "site-packages"))
    else:
        os.mkdir(os.path.join(path, "Scripts"))
        open(os.path.join(path, "Scripts", "activate.bat"), "wt").write("")
        os.makedirs(os.path.join(path, "Lib", "site-packages"))

class TestVenvIgnore:
    @staticmethod
    def test_no_venv(monkeypatch):
        with in_fresh_temp_dir() as path:
            monkeypatch.setenv("LGTM_SRC", path)
            assert buildtools.index.exclude_venvs_options() == []

    @staticmethod
    @pytest.mark.parametrize("is_unix", [True,False])
    def test_faked_venv_dir(monkeypatch, is_unix):
        with in_fresh_temp_dir() as path:
            create_fake_venv(os.path.join(path, "venv"), is_unix=is_unix)
            monkeypatch.setenv("LGTM_SRC", path)
            assert buildtools.index.exclude_venvs_options() == ["-Y", os.path.join(path, "venv")]

    @staticmethod
    @pytest.mark.parametrize("is_unix", [True,False])
    def test_multiple_faked_venv_dirs(monkeypatch, is_unix):
        with in_fresh_temp_dir() as path:
            create_fake_venv(os.path.join(path, "venv"), is_unix=is_unix)
            create_fake_venv(os.path.join(path, "venv2"), is_unix=is_unix)

            monkeypatch.setenv("LGTM_SRC", path)

            expected = [
                "-Y", os.path.join(path, "venv"),
                "-Y", os.path.join(path, "venv2"),
            ]

            actual = buildtools.index.exclude_venvs_options()
            assert sorted(actual) == sorted(expected)

    @staticmethod
    def test_faked_venv_dir_no_pyvenv_cfg(monkeypatch):
        """
        Some times, the `pyvenv.cfg` file is not included when a virtual environment is
        added to a git-repo, but we should be able to ignore the venv anyway.

        See
        - https://github.com/FiacreT/M-moire/tree/4089755191ffc848614247e98bbb641c1933450d/osintplatform/testNeo/venv
        - https://github.com/Lynchie/KCM/tree/ea9eeed07e0c9eec41f9fc7480ce90390ee09876/VENV
        """
        with in_fresh_temp_dir() as path:
            create_fake_venv(os.path.join(path, "venv"), is_unix=True)
            monkeypatch.setenv("LGTM_SRC", path)
            os.remove(os.path.join(path, "venv", "pyvenv.cfg"))
            assert buildtools.index.exclude_venvs_options() == ["-Y", os.path.join(path, "venv")]

    @staticmethod
    def test_faked_venv_no_bin_dir(monkeypatch):
        """
        Some times, the activate script is not included when a virtual environment is
        added to a git-repo, but we should be able to ignore the venv anyway.
        """

        with in_fresh_temp_dir() as path:
            create_fake_venv(os.path.join(path, "venv"), is_unix=True)
            monkeypatch.setenv("LGTM_SRC", path)
            bin_dir = os.path.join(path, "venv", "bin")
            assert os.path.isdir(bin_dir)
            shutil.rmtree(bin_dir)
            assert buildtools.index.exclude_venvs_options() == ["-Y", os.path.join(path, "venv")]

    @staticmethod
    def test_faked_venv_dir_no_lib_python(monkeypatch):
        """
        If there are no `lib/pyhton*` dirs within a unix venv, then it doesn't
        constitute a functional virtual environment, and we don't exclude it. That's not
        going to hurt, since it won't contain any installed packages.
        """

        with in_fresh_temp_dir() as path:
            create_fake_venv(os.path.join(path, "venv"), is_unix=True)
            monkeypatch.setenv("LGTM_SRC", path)
            glob_res = glob.glob(os.path.join(path, "venv", "lib", "python*"))
            assert glob_res
            for d in glob_res:
                shutil.rmtree(d)
            assert buildtools.index.exclude_venvs_options() == []

    @staticmethod
    @pytest.mark.parametrize("is_unix", [True,False])
    def test_disable_environment_variable(monkeypatch, is_unix):
        monkeypatch.setenv(
            "CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE", "1"
        )
        with in_fresh_temp_dir() as path:
            create_fake_venv(os.path.join(path, "venv"), is_unix=is_unix)
            monkeypatch.setenv("LGTM_SRC", path)
            assert buildtools.index.exclude_venvs_options() == []
