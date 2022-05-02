import pathlib
from unittest import mock

import pytest

from swift.codegen.lib import render, schema

schema_dir = pathlib.Path("a", "dir")
schema_file = schema_dir / "schema.yml"


def write(out, contents=""):
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "w") as out:
        out.write(contents)


@pytest.fixture
def renderer():
    return mock.Mock(spec=render.Renderer())


@pytest.fixture
def opts():
    return mock.MagicMock()


@pytest.fixture(autouse=True)
def override_paths(tmp_path):
    with mock.patch("swift.codegen.lib.paths.swift_dir", tmp_path):
        yield


@pytest.fixture
def input(opts, tmp_path):
    opts.schema = tmp_path / schema_file
    with mock.patch("swift.codegen.lib.schema.load") as load_mock:
        load_mock.return_value = schema.Schema([])
        yield load_mock.return_value
    assert load_mock.mock_calls == [
        mock.call(opts.schema)
    ], load_mock.mock_calls


def run_generation(generate, opts, renderer):
    output = {}

    renderer.render.side_effect = lambda data, out: output.__setitem__(out, data)
    generate(opts, renderer)
    return output
