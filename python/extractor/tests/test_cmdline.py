from semmle import cmdline


def test_records_flags_without_values():
    options, args = cmdline.parse(
        [
            "--verbosity=3",
            "-zall",
            "-R",
            "/src",
            "-vv",
            "--path",
            "/lib",
            "-p",
            "/other-lib",
            "module",
        ]
    )

    assert options.extractor_flags == ["p"]
    assert args == ["module"]


def test_records_flags_from_option_file(tmp_path):
    options_file = tmp_path / "extractor-options"
    options_file.write_text("--colorize --max-import-depth 2")

    options, _ = cmdline.parse(["-f", str(options_file)])

    assert options.extractor_flags == [
        "colorize",
        "f",
        "max-import-depth",
    ]
