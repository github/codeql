import sys
from unittest import mock
import pathlib

import pytest

from swift.codegen.lib import paths
from swift.codegen.lib import render


generator = "test/foogen"


@pytest.fixture
def pystache_renderer_cls():
    with mock.patch("pystache.Renderer") as ret:
        yield ret


@pytest.fixture
def pystache_renderer(pystache_renderer_cls):
    ret = mock.Mock()
    pystache_renderer_cls.side_effect = (ret,)
    return ret


@pytest.fixture
def sut(pystache_renderer):
    return render.Renderer(generator)


def test_constructor(pystache_renderer_cls, sut):
    pystache_init, = pystache_renderer_cls.mock_calls
    assert set(pystache_init.kwargs) == {'search_dirs', 'escape'}
    assert pystache_init.kwargs['search_dirs'] == str(paths.templates_dir)
    an_object = object()
    assert pystache_init.kwargs['escape'](an_object) is an_object
    assert sut.written == set()


def test_render(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    output = mock.Mock()
    with mock.patch("builtins.open", mock.mock_open()) as output_stream:
        sut.render(data, output)
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]
    assert output_stream.mock_calls == [
        mock.call(output, 'w'),
        mock.call().__enter__(),
        mock.call().write(pystache_renderer.render_name.return_value),
        mock.call().__exit__(None, None, None),
    ]
    assert sut.written == {output}


def test_render_with_extensions(pystache_renderer, sut):
    data = mock.Mock(spec=("template", "extensions"))
    data.template = "test_template"
    data.extensions = ["foo", "bar", "baz"]
    output = pathlib.Path("my", "test", "file")
    expected_outputs = [pathlib.Path("my", "test", p) for p in ("file.foo", "file.bar", "file.baz")]
    rendered = [object() for _ in expected_outputs]
    pystache_renderer.render_name.side_effect = rendered
    with mock.patch("builtins.open", mock.mock_open()) as output_stream:
        sut.render(data, output)
    expected_templates = ["test_template_foo", "test_template_bar", "test_template_baz"]
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(t, data, generator=generator) for t in expected_templates
    ]
    expected_calls = []
    for contents, out in zip(rendered, expected_outputs):
        expected_calls.extend((
            mock.call(out, 'w'),
            mock.call().__enter__(),
            mock.call().write(contents),
            mock.call().__exit__(None, None, None),
        ))
    assert sut.written == set(expected_outputs)


def test_written(sut):
    data = [mock.Mock(spec=("template",)) for _ in range(4)]
    output = [mock.Mock() for _ in data]
    with mock.patch("builtins.open", mock.mock_open()) as output_stream:
        for d, o in zip(data, output):
            sut.render(d, o)
    assert sut.written == set(output)


def test_cleanup(sut):
    data = [mock.Mock(spec=("template",)) for _ in range(4)]
    output = [mock.Mock() for _ in data]
    with mock.patch("builtins.open", mock.mock_open()) as output_stream:
        for d, o in zip(data, output):
            sut.render(d, o)
    expected_erased = [mock.Mock() for _ in range(3)]
    existing = set(expected_erased + output[2:])
    sut.cleanup(existing)
    for f in expected_erased:
        assert f.mock_calls == [mock.call.unlink(missing_ok=True)]
    for f in output:
        assert f.unlink.mock_calls == []


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
