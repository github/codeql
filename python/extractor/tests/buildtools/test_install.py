import pytest

import buildtools.install
from tests.buildtools.helper import in_fresh_temp_dir

def test_basic(monkeypatch, mocker):
    mocker.patch('subprocess.call')
    mocker.patch('subprocess.check_call')

    with in_fresh_temp_dir() as path:
        monkeypatch.setenv('LGTM_WORKSPACE', path)
        monkeypatch.setenv('SEMMLE_DIST', '<none>')

        with pytest.raises(SystemExit) as exc_info:
            buildtools.install.main(3, '.', [])
        assert exc_info.value.code == 0
