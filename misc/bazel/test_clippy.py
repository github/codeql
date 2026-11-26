import unittest
import xml.etree.ElementTree as ET

from clippy import NULL_SHA, lint_flags, resolve_base, select_targets


def graph():
    result = ET.Element("query")
    for name, kind, deps in [
        ("//shared/yeast:yeast", "rust_library", ["//shared/yeast:src/lib.rs"]),
        ("//rust/extractor:single_arch/extractor", "rust_binary", ["//shared/yeast:yeast"]),
        ("//rust/extractor:extractor", "universal_binary", ["//rust/extractor:single_arch/extractor"]),
        ("//cpp/extractor/bmn:single_arch/bmn", "rust_binary", []),
        ("//unified/swift-syntax-rs:swift_syntax_rs", "rust_library", ["//native:generated"]),
        ("//native:generated", "genrule", ["//native:schema.json"]),
        ("//ql/extractor:extractor", "rust_binary", []),
    ]:
        rule = ET.SubElement(result, "rule", name=name, **{"class": kind})
        for dep in deps:
            ET.SubElement(rule, "rule-input", name=dep)
    build = ET.SubElement(result, "source-file", name="//unified/swift-syntax-rs:BUILD.bazel")
    ET.SubElement(build, "load", name="//unified:platforms.bzl")
    return result


class SelectionTest(unittest.TestCase):
    members = {
        "shared/yeast", "rust/extractor", "cpp/extractor/bmn", "unified/swift-syntax-rs",
    }

    def select(self, *paths):
        return select_targets(graph(), self.members, paths)

    def test_unrelated_change(self):
        self.assertEqual(self.select("javascript/ql/lib/example.qll"), [])
        self.assertEqual(self.select("misc/bazel/clippy.md"), [])

    def test_shared_dependency(self):
        self.assertEqual(self.select("shared/yeast/src/lib.rs"), [
            "//rust/extractor:single_arch/extractor", "//shared/yeast:yeast",
        ])

    def test_extractor_only_and_not_wrapper(self):
        self.assertEqual(self.select("rust/extractor/src/main.rs"), [
            "//rust/extractor:single_arch/extractor",
        ])

    def test_deleted_source_and_build_and_manifest(self):
        for path in ("src/deleted.rs", "BUILD.bazel", "Cargo.toml"):
            with self.subTest(path=path):
                self.assertEqual(self.select("shared/yeast/" + path), [
                    "//rust/extractor:single_arch/extractor", "//shared/yeast:yeast",
                ])

    def test_native_generated_input(self):
        self.assertEqual(self.select("native/schema.json"), [
            "//unified/swift-syntax-rs:swift_syntax_rs",
        ])

    def test_loaded_build_extension(self):
        self.assertEqual(self.select("unified/platforms.bzl"), [
            "//unified/swift-syntax-rs:swift_syntax_rs",
        ])

    def test_root_configuration(self):
        for path in ("Cargo.lock", "Cargo.toml", "clippy.toml", "MODULE.bazel", ".bazelrc", "misc/bazel/rust.bzl"):
            with self.subTest(path=path):
                self.assertEqual(len(self.select(path)), 4)

    def test_push_base(self):
        exists = lambda revision: revision in {"before", "origin/main"}
        self.assertEqual(resolve_base("before", "origin/main", exists), "before")
        self.assertEqual(resolve_base(NULL_SHA, "origin/main", exists), "origin/main")
        self.assertEqual(resolve_base("", "origin/main", exists), "origin/main")
        self.assertIsNone(resolve_base("force-pushed", "origin/main", exists))
        self.assertIsNone(resolve_base(NULL_SHA, None, exists))

    def test_lint_priorities(self):
        flags = lint_flags({"workspace": {"lints": {
            "rust": {"redundant_imports": "warn"},
            "clippy": {"all": {"level": "warn", "priority": -1}, "match_same_arms": "allow"},
        }}})
        self.assertLess(
            flags.index("--@rules_rust//rust/settings:clippy_flag=--warn=clippy::all"),
            flags.index("--@rules_rust//rust/settings:clippy_flag=--allow=clippy::match_same_arms"),
        )
        self.assertEqual(flags[-1], "--@rules_rust//rust/settings:clippy_flag=-Dwarnings")


if __name__ == "__main__":
    unittest.main()
