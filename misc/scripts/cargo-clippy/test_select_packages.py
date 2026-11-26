import tempfile
import subprocess
import unittest
from pathlib import Path

from select_packages import changed_files, select, workspace


ROOT = Path(__file__).resolve().parents[3]


class SelectionTests(unittest.TestCase):
    def test_unrelated_and_excluded_workspaces(self):
        self.assertEqual(select(ROOT, [
            "README.md",
            "java/ql/lib/example.qll",
            "rust/ql/test/example/test.rs",
            "python/extractor/tsg-python/src/main.rs",
        ]), [])

    def test_leaf_and_non_rust_input(self):
        self.assertEqual(
            select(ROOT, ["rust/extractor/src/main.rs"]), ["codeql-rust"]
        )
        self.assertEqual(
            select(ROOT, ["ql/buramu/tree-sitter-blame/src/parser.c"]),
            ["codeql-extractor-ql", "tree-sitter-blame"],
        )

    def test_nested_member_and_reverse_dependencies(self):
        self.assertEqual(
            select(ROOT, ["rust/extractor/macros/src/lib.rs"]),
            ["codeql-rust", "rust-extractor-macros"],
        )
        selected = select(ROOT, ["shared/yeast-schema/src/lib.rs"])
        self.assertIn("codeql-rust", selected)
        self.assertIn("yeast-python", selected)
        self.assertIn("yeast-macros", selected)
        self.assertNotIn("bmn", selected)
        self.assertNotIn("ast-generator", selected)
        self.assertNotIn("swift-syntax-rs", selected)

    def test_external_parser_input(self):
        self.assertEqual(
            select(ROOT, ["python/extractor/tsg-python/tsp/src/scanner.cc"]),
            ["yeast-python"],
        )

    def test_ast_generator_source_injection_inputs(self):
        for path in ["MODULE.bazel", ".bazelversion", "misc/bazel/runfiles.sh"]:
            with self.subTest(path=path):
                self.assertEqual(select(ROOT, [path]), ["ast-generator"])

    def test_global_configuration_and_selector(self):
        packages, _ = workspace(ROOT)
        expected = sorted(p["package"]["name"] for p in packages.values())
        for path in [
            "Cargo.toml", "Cargo.lock", "rust-toolchain.toml", "clippy.toml",
            ".clippy.toml", ".cargo/config.toml",
            ".github/workflows/cargo-clippy.yml",
            "misc/scripts/cargo-clippy/select_packages.py",
        ]:
            with self.subTest(path=path):
                self.assertEqual(select(ROOT, [path]), expected)

    def test_inherited_renamed_target_and_build_dependencies(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Cargo.toml").write_text("""
[workspace]
members = ["a", "b", "c"]
[workspace.dependencies]
renamed = { package = "a", path = "a" }
""")
            for member, extra in [
                ("a", ""),
                ("b", '[target.\'cfg(unix)\'.build-dependencies]\nrenamed.workspace = true'),
                ("c", '[dev-dependencies]\nb = { path = "../b" }'),
            ]:
                (root / member).mkdir()
                (root / member / "Cargo.toml").write_text(
                    f'[package]\nname = "{member}"\nversion = "0.1.0"\n{extra}\n'
                )
            # Deleted files and rename sources use the same path-based ownership.
            self.assertEqual(select(root, ["a/deleted.rs"]), ["a", "b", "c"])
            self.assertEqual(select(root, ["b/renamed.rs", "c/new.rs"]), ["b", "c"])

    def test_shallow_merge_uses_actual_base_parent(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "repo"
            root.mkdir()

            def git(*args, cwd=root):
                return subprocess.check_output(
                    ["git", "-c", "user.name=Test", "-c", "user.email=test@example.com",
                     *args], cwd=cwd, stderr=subprocess.DEVNULL,
                )

            git("init", "-b", "base")
            (root / "Cargo.toml").write_text('[workspace]\nmembers = ["a", "b"]\n')
            for name in ["a", "b"]:
                (root / name).mkdir()
                (root / name / "Cargo.toml").write_text(
                    f'[package]\nname = "{name}"\nversion = "0.1.0"\n'
                )
            git("add", ".")
            git("commit", "-m", "Initial")
            git("checkout", "-b", "topic")
            (root / "a/source.rs").write_text("// Changed on the PR\n")
            git("add", ".")
            git("commit", "-m", "Topic")
            git("checkout", "base")
            (root / "b/source.rs").write_text("// Changed only on the base\n")
            git("add", ".")
            git("commit", "-m", "Advance base")
            git("merge", "--no-ff", "topic", "-m", "PR merge")
            clone = Path(directory) / "shallow"
            git("clone", "--depth=2", root.as_uri(), str(clone))
            self.assertEqual(select(clone, changed_files(clone, "HEAD^1")), ["a"])


if __name__ == "__main__":
    unittest.main()
