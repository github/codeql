import pytest


@pytest.mark.parametrize(("compression", "suffix"), [
    pytest.param("none", [], id="none"),
    pytest.param("gzip", [".gz"], id="gzip"),
    pytest.param("zstd", [".zst"], id="zstd"),
])
def test(codeql, ruby, compression, suffix, cwd):
    codeql.database.create(
        _env={
            "CODEQL_EXTRACTOR_RUBY_OPTION_TRAP_COMPRESSION": compression,
        }
    )
    trap_files = [*(cwd / "test-db" / "trap").rglob("*.trap*")]
    assert trap_files, "No trap files found"
    expected_suffixes = [".trap"] + suffix

    def is_of_expected_format(file):
        return file.name == "metadata.trap.gz" or \
            file.suffixes[-len(expected_suffixes):] == expected_suffixes

    files_with_wrong_format = [
        f for f in trap_files if not is_of_expected_format(f)
    ]
    assert not files_with_wrong_format, f"Found trap files with wrong format"
