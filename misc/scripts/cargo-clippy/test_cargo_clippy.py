import unittest
from pathlib import Path

from cargo_clippy import select, workspace


ROOT = Path(__file__).resolve().parents[3]


class SelectionTests(unittest.TestCase):
    def test_unrelated_changes_select_nothing(self):
        self.assertEqual(select(ROOT, [
            "README.md",
            "rust/ql/test/example/test.rs",
            "python/extractor/tsg-python/src/main.rs",
        ]), [])

    def test_nested_member_and_reverse_dependencies(self):
        self.assertEqual(select(ROOT, ["rust/extractor/src/main.rs"]), ["codeql-rust"])
        self.assertEqual(
            select(ROOT, ["rust/extractor/macros/src/lib.rs"]),
            ["codeql-rust", "rust-extractor-macros"],
        )
        self.assertTrue(
            {"extractor-common", "codeql-extractor"}
            <= set(select(ROOT, ["shared/extractor-common/src/lib.rs"]))
        )

    def test_external_inputs(self):
        self.assertIn(
            "yeast-python",
            select(ROOT, ["python/extractor/tsg-python/tsp/src/parser.c"]),
        )
        self.assertEqual(select(ROOT, ["MODULE.bazel"]), ["ast-generator"])

    def test_global_inputs_select_everything(self):
        packages, _ = workspace(ROOT)
        self.assertEqual(
            select(ROOT, ["Cargo.lock"]),
            sorted(package["package"]["name"] for package in packages.values()),
        )


if __name__ == "__main__":
    unittest.main()
