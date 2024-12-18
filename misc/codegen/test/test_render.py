import sys

import pytest

from misc.codegen.test.utils import *

import hashlib

generator = "foo"


@pytest.fixture
def pystache_renderer_cls():
    with mock.patch("pystache.Renderer") as ret:
        yield ret


@pytest.fixture
def pystache_renderer(pystache_renderer_cls):
    ret = mock.Mock()
    pystache_renderer_cls.return_value = ret
    return ret


@pytest.fixture
def sut(pystache_renderer):
    return render.Renderer(generator)


def assert_file(file, text):
    assert file.is_file()
    with open(file) as inp:
        assert inp.read() == text


def create_registry(files_and_hashes):
    if not files_and_hashes:
        return ""
    return "\n".join(" ".join(data) for data in files_and_hashes) + "\n"


def write_registry(file, *files_and_hashes):
    write(file, create_registry(files_and_hashes))


def assert_registry(file, *files_and_hashes):
    assert_file(file, create_registry(files_and_hashes))
    files = [file.name, ".gitattributes"] + [f for f, _, _ in files_and_hashes]
    assert_file(file.parent / ".gitattributes", "\n".join(f"/{f} linguist-generated" for f in files) + "\n")


def hash(text):
    h = hashlib.sha256()
    h.update(text.encode())
    return h.hexdigest()


def test_constructor(pystache_renderer_cls, sut):
    pystache_init, = pystache_renderer_cls.mock_calls
    assert set(pystache_init.kwargs) == {'search_dirs', 'escape'}
    assert pystache_init.kwargs['search_dirs'] == str(paths.templates_dir)
    an_object = object()
    assert pystache_init.kwargs['escape'](an_object) is an_object


def test_render(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    text = "some text"
    pystache_renderer.render_name.side_effect = (text,)
    output = paths.root_dir / "a/some/output.txt"
    sut.render(data, output)

    assert_file(output, text)
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]


def test_render_provided_template(pystache_renderer, sut):
    data = mock.Mock(spec=())
    custom_template = object()
    text = "some text"
    pystache_renderer.render_name.side_effect = (text,)
    output = paths.root_dir / "a/some/output.txt"
    sut.render(data, output, template=custom_template)

    assert_file(output, text)
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(custom_template, data, generator=generator),
    ]


def test_render_to_string(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    text = "some text"
    pystache_renderer.render_name.side_effect = (text,)
    result = sut.render_str(data)

    assert result == text
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]


def test_render_to_string_with_provided_template(pystache_renderer, sut):
    data = mock.Mock(spec=())
    custom_template = object()
    text = "some text"
    pystache_renderer.render_name.side_effect = (text,)
    result = sut.render_str(data, custom_template)

    assert result == text
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(custom_template, data, generator=generator),
    ]


def test_managed_render(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    text = "some text"
    pystache_renderer.render_name.side_effect = (text,)
    output = paths.root_dir / "a/some/output.txt"
    registry = paths.root_dir / "a/registry.list"
    write_registry(registry)

    with sut.manage(generated=(), stubs=(), registry=registry) as renderer:
        renderer.render(data, output)
        assert renderer.written == {output}
        assert_file(output, text)

    assert_registry(registry, ("some/output.txt", hash(text), hash(text)))
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]


def test_managed_render_with_no_registry(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    text = "some text"
    pystache_renderer.render_name.side_effect = (text,)
    output = paths.root_dir / "a/some/output.txt"
    registry = paths.root_dir / "a/registry.list"

    with sut.manage(generated=(), stubs=(), registry=registry) as renderer:
        renderer.render(data, output)
        assert renderer.written == {output}
        assert_file(output, text)

    assert_registry(registry, ("some/output.txt", hash(text), hash(text)))
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]


def test_managed_render_with_post_processing(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    text = "some text"
    postprocessed_text = "some other text"
    pystache_renderer.render_name.side_effect = (text,)
    output = paths.root_dir / "a/some/output.txt"
    registry = paths.root_dir / "a/registry.list"
    write_registry(registry)

    with sut.manage(generated=(), stubs=(), registry=registry) as renderer:
        renderer.render(data, output)
        assert renderer.written == {output}
        assert_file(output, text)
        write(output, postprocessed_text)

    assert_registry(registry, ("some/output.txt", hash(text), hash(postprocessed_text)))
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]


def test_managed_render_with_erasing(pystache_renderer, sut):
    output = paths.root_dir / "a/some/output.txt"
    stub = paths.root_dir / "a/some/stub.txt"
    registry = paths.root_dir / "a/registry.list"
    write(output)
    write(stub, "// generated bla bla")
    write_registry(registry)

    with sut.manage(generated=(output,), stubs=(stub,), registry=registry) as renderer:
        pass

    assert not output.is_file()
    assert not stub.is_file()
    assert_registry(registry)
    assert pystache_renderer.mock_calls == []


def test_managed_render_with_skipping_of_generated_file(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    output = paths.root_dir / "a/some/output.txt"
    some_output = "some output"
    registry = paths.root_dir / "a/registry.list"
    write(output, some_output)
    write_registry(registry, ("some/output.txt", hash(some_output), hash(some_output)))

    pystache_renderer.render_name.side_effect = (some_output,)

    with sut.manage(generated=(output,), stubs=(), registry=registry) as renderer:
        renderer.render(data, output)
        assert renderer.written == set()
        assert_file(output, some_output)

    assert_registry(registry, ("some/output.txt", hash(some_output), hash(some_output)))
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]


def test_managed_render_with_skipping_of_stub_file(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    stub = paths.root_dir / "a/some/stub.txt"
    some_output = "// generated some output"
    some_processed_output = "// generated some processed output"
    registry = paths.root_dir / "a/registry.list"
    write(stub, some_processed_output)
    write_registry(registry, ("some/stub.txt", hash(some_output), hash(some_processed_output)))

    pystache_renderer.render_name.side_effect = (some_output,)

    with sut.manage(generated=(), stubs=(stub,), registry=registry) as renderer:
        renderer.render(data, stub)
        assert renderer.written == set()
        assert_file(stub, some_processed_output)

    assert_registry(registry, ("some/stub.txt", hash(some_output), hash(some_processed_output)))
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]


def test_managed_render_with_modified_generated_file(pystache_renderer, sut):
    output = paths.root_dir / "a/some/output.txt"
    some_processed_output = "// some processed output"
    registry = paths.root_dir / "a/registry.list"
    write(output, "// something else")
    write_registry(registry, ("some/output.txt", "whatever", hash(some_processed_output)))

    with pytest.raises(render.Error):
        sut.manage(generated=(output,), stubs=(), registry=registry)


def test_managed_render_with_modified_stub_file_still_marked_as_generated(pystache_renderer, sut):
    stub = paths.root_dir / "a/some/stub.txt"
    some_processed_output = "// generated some processed output"
    registry = paths.root_dir / "a/registry.list"
    write(stub, "// generated something else")
    write_registry(registry, ("some/stub.txt", "whatever", hash(some_processed_output)))

    with pytest.raises(render.Error):
        sut.manage(generated=(), stubs=(stub,), registry=registry)


def test_managed_render_with_modified_stub_file_not_marked_as_generated(pystache_renderer, sut):
    stub = paths.root_dir / "a/some/stub.txt"
    some_processed_output = "// generated some processed output"
    registry = paths.root_dir / "a/registry.list"
    write(stub, "// no more generated")
    write_registry(registry, ("some/stub.txt", "whatever", hash(some_processed_output)))

    with sut.manage(generated=(), stubs=(stub,), registry=registry) as renderer:
        pass

    assert_registry(registry)


class MyError(Exception):
    pass


def test_managed_render_exception_drops_written_and_inexsistent_from_registry(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    text = "some text"
    pystache_renderer.render_name.side_effect = (text,)
    output = paths.root_dir / "a/some/output.txt"
    registry = paths.root_dir / "a/registry.list"
    write(output, text)
    write(paths.root_dir / "a/a")
    write(paths.root_dir / "a/c")
    write_registry(registry,
                   "aaa",
                   ("some/output.txt", "whatever", hash(text)),
                   "bbb",
                   "ccc")

    with pytest.raises(MyError):
        with sut.manage(generated=(), stubs=(), registry=registry) as renderer:
            renderer.render(data, output)
            raise MyError

    assert_registry(registry, "aaa", "ccc")


def test_managed_render_drops_inexsistent_from_registry(pystache_renderer, sut):
    registry = paths.root_dir / "a/registry.list"
    write(paths.root_dir / "a/a")
    write(paths.root_dir / "a/c")
    write_registry(registry,
                   ("a", hash(''), hash('')),
                   "bbb",
                   ("c", hash(''), hash('')))

    with sut.manage(generated=(), stubs=(), registry=registry):
        pass

    assert_registry(registry,
                    ("a", hash(''), hash('')),
                    ("c", hash(''), hash('')))


def test_managed_render_exception_does_not_erase(pystache_renderer, sut):
    output = paths.root_dir / "a/some/output.txt"
    stub = paths.root_dir / "a/some/stub.txt"
    registry = paths.root_dir / "a/registry.list"
    write(output)
    write(stub, "// generated bla bla")
    write_registry(registry)

    with pytest.raises(MyError):
        with sut.manage(generated=(output,), stubs=(stub,), registry=registry) as renderer:
            raise MyError

    assert output.is_file()
    assert stub.is_file()


def test_render_with_extensions(pystache_renderer, sut):
    data = mock.Mock(spec=("template", "extensions"))
    data.template = "test_template"
    data.extensions = ["foo", "bar", "baz"]
    output = pathlib.Path("my", "test", "file")
    expected_outputs = [pathlib.Path("my", "test", p) for p in ("file.foo", "file.bar", "file.baz")]
    rendered = [f"text{i}" for i in range(len(expected_outputs))]
    pystache_renderer.render_name.side_effect = rendered
    sut.render(data, output)
    expected_templates = ["test_template_foo", "test_template_bar", "test_template_baz"]
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(t, data, generator=generator)
        for t in expected_templates
    ]
    for expected_output, expected_contents in zip(expected_outputs, rendered):
        assert_file(expected_output, expected_contents)


def test_managed_render_with_force_not_skipping_generated_file(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    output = paths.root_dir / "a/some/output.txt"
    some_output = "some output"
    registry = paths.root_dir / "a/registry.list"
    write(output, some_output)
    write_registry(registry, ("some/output.txt", hash(some_output), hash(some_output)))

    pystache_renderer.render_name.side_effect = (some_output,)

    with sut.manage(generated=(output,), stubs=(), registry=registry, force=True) as renderer:
        renderer.render(data, output)
        assert renderer.written == {output}
        assert_file(output, some_output)

    assert_registry(registry, ("some/output.txt", hash(some_output), hash(some_output)))
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]


def test_managed_render_with_force_not_skipping_stub_file(pystache_renderer, sut):
    data = mock.Mock(spec=("template",))
    stub = paths.root_dir / "a/some/stub.txt"
    some_output = "// generated some output"
    some_processed_output = "// generated some processed output"
    registry = paths.root_dir / "a/registry.list"
    write(stub, some_processed_output)
    write_registry(registry, ("some/stub.txt", hash(some_output), hash(some_processed_output)))

    pystache_renderer.render_name.side_effect = (some_output,)

    with sut.manage(generated=(), stubs=(stub,), registry=registry, force=True) as renderer:
        renderer.render(data, stub)
        assert renderer.written == {stub}
        assert_file(stub, some_output)

    assert_registry(registry, ("some/stub.txt", hash(some_output), hash(some_output)))
    assert pystache_renderer.mock_calls == [
        mock.call.render_name(data.template, data, generator=generator),
    ]


def test_managed_render_with_force_ignores_modified_generated_file(sut):
    output = paths.root_dir / "a/some/output.txt"
    some_processed_output = "// some processed output"
    registry = paths.root_dir / "a/registry.list"
    write(output, "// something else")
    write_registry(registry, ("some/output.txt", "whatever", hash(some_processed_output)))

    with sut.manage(generated=(output,), stubs=(), registry=registry, force=True):
        pass


def test_managed_render_with_force_ignores_modified_stub_file_still_marked_as_generated(sut):
    stub = paths.root_dir / "a/some/stub.txt"
    some_processed_output = "// generated some processed output"
    registry = paths.root_dir / "a/registry.list"
    write(stub, "// generated something else")
    write_registry(registry, ("some/stub.txt", "whatever", hash(some_processed_output)))

    with sut.manage(generated=(), stubs=(stub,), registry=registry, force=True):
        pass


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
