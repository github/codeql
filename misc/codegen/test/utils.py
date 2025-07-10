import pathlib
from unittest import mock

import pytest

from misc.codegen.lib import render, schema, paths

schema_dir = pathlib.Path("a", "dir")
schema_file = schema_dir / "schema.py"
dbscheme_file = pathlib.Path("another", "dir", "test.dbscheme")


def write(out, contents=""):
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "w") as out:
        out.write(contents)


@pytest.fixture
def renderer():
    return mock.Mock(spec=render.Renderer)


@pytest.fixture
def render_manager(renderer):
    ret = mock.Mock(spec=render.RenderManager)
    ret.__enter__ = mock.Mock(return_value=ret)
    ret.__exit__ = mock.Mock(return_value=None)
    ret.is_customized_stub.return_value = False
    return ret


@pytest.fixture
def opts():
    ret = mock.MagicMock()
    ret.root_dir = paths.root_dir
    return ret


@pytest.fixture(autouse=True)
def override_paths(tmp_path):
    with mock.patch("misc.codegen.lib.paths.root_dir", tmp_path), \
            mock.patch("misc.codegen.lib.paths.exe_file", tmp_path / "exe"):
        yield


@pytest.fixture
def input(opts, tmp_path):
    opts.schema = tmp_path / schema_file
    with mock.patch("misc.codegen.loaders.schemaloader.load_file") as load_mock:
        load_mock.return_value = schema.Schema([])
        yield load_mock.return_value
    assert load_mock.mock_calls == [
        mock.call(opts.schema),
    ], load_mock.mock_calls


@pytest.fixture
def dbscheme_input(opts, tmp_path):
    opts.dbscheme = tmp_path / dbscheme_file
    with mock.patch("misc.codegen.loaders.dbschemeloader.iterload") as load_mock:
        load_mock.entities = []
        load_mock.side_effect = lambda _: load_mock.entities
        yield load_mock
    assert load_mock.mock_calls == [
        mock.call(opts.dbscheme),
    ], load_mock.mock_calls


def run_generation(generate, opts, renderer):
    output = {}

    renderer.render.side_effect = lambda data, out: output.__setitem__(out, data)
    generate(opts, renderer)
    return output


def run_managed_generation(generate, opts, renderer, render_manager):
    output = {}

    renderer.manage.side_effect = (render_manager,)
    render_manager.render.side_effect = lambda data, out: output.__setitem__(out, data)
    generate(opts, renderer)
    return output
