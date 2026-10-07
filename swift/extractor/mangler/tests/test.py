import os
import pathlib
import subprocess
import sys
import tempfile
import unittest
import zipfile

from python.runfiles import runfiles


files = runfiles.Create()
binary, resource_archive = (files.Rlocation(path) for path in sys.argv[1:3])
del sys.argv[1:3]


class ManglerTests(unittest.TestCase):
    def run_fixture(
        self,
        late=False,
        other_type=False,
        private_values=False,
        reverse=False,
        global_members=False,
        same_category=False,
        unused=200,
    ):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            resources = root / "resources"
            with zipfile.ZipFile(resource_archive) as archive:
                archive.extractall(resources)
            modules = root / "modules"
            modules.mkdir()
            (modules / "root.h").write_text(
                "__attribute__((objc_root_class)) @interface Item @end\n"
                "__attribute__((objc_root_class)) @interface OtherItem @end\n"
                + "\n".join(f"struct Unused{i} {{ int value; }};" for i in range(unused))
            )
            (modules / "first.h").write_text(
                '#include "root.h"\n@interface Item (First)\n-(void)first;\n@end\n'
                'extern const int firstValue __attribute__((swift_name("Item.firstValue")));\n'
            )
            (modules / "second.h").write_text(
                '#include "root.h"\n@interface Item ('
                + ("First" if same_category else "Second")
                + ')\n-(void)second;\n@end\n'
                '@interface OtherItem (First)\n-(void)other;\n@end\n'
                'extern const int secondValue __attribute__((swift_name("Item.secondValue")));\n'
            )
            (modules / "late.h").write_text(
                '#include "root.h"\n@interface Item (Late)\n-(void)late;\n@end\n'
                'extern const int lateValue __attribute__((swift_name("Item.lateValue")));\n'
            )
            (modules / "module.modulemap").write_text(
                'module Fixture { header "root.h" export *\n'
                '  module First { header "first.h" export * }\n'
                '  module Nested { module Second { header "second.h" export * } }\n'
                '  explicit module Late { header "late.h" export * }\n'
                '}\n'
            )
            source = root / "test.swift"
            source.write_text(
                "import Fixture\n"
                + (
                    (
                        "func use() { _ = Item.secondValue; _ = Item.firstValue }\n"
                        if reverse
                        else "func use() { _ = Item.firstValue; _ = Item.secondValue }\n"
                    )
                    if global_members
                    else (
                        "func use(_ item: Item) { item.second(); item.first(); item.second() }\n"
                        if reverse
                        else "func use(_ item: Item) { item.first(); item.second(); item.first() }\n"
                    )
                )
                + ("func useOther(_ item: OtherItem) { item.other() }\n" if other_type else "")
                + ("fileprivate func duplicated(_ value: Int) {}\n" if private_values else "")
            )
            sources = [str(source)]
            if private_values:
                other_source = root / "other.swift"
                other_source.write_text("fileprivate func duplicated(_ value: Int) {}\n")
                sources.append(str(other_source))
            library = next(
                pathlib.Path(".").glob("_solib_*/*/lib_CompilerSwiftBasicFormat.dylib")
            ).resolve()
            result = subprocess.run(
                [
                    binary,
                    *(
                        ["--late-global-import" if global_members else "--late-import"]
                        if late
                        else []
                    ),
                    "-typecheck",
                    *sources,
                    "-I",
                    str(modules),
                    "-resource-dir",
                    str(resources),
                    "-module-cache-path",
                    str(root / "cache"),
                    "-stats-output-dir",
                    str(root / "stats"),
                ],
                env={
                    **os.environ,
                    "DYLD_LIBRARY_PATH": str(library.parent),
                },
                text=True,
                capture_output=True,
                timeout=30,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            return [line.split("\t") for line in result.stdout.splitlines()]

    def test_imported_categories_do_not_materialize_unrelated_declarations(self):
        small = self.run_fixture(unused=0)
        large = self.run_fixture(unused=200)
        small_bytes = int(next(row[1] for row in small if row[0] == "additional-ast-bytes"))
        large_bytes = int(next(row[1] for row in large if row[0] == "additional-ast-bytes"))
        self.assertEqual(
            large_bytes,
            small_bytes,
            "Mangling imported categories materialized unrelated module declarations",
        )

    def test_nested_categories_have_distinct_stable_extension_keys(self):
        rows = [row for row in self.run_fixture() if len(row) == 4]
        self.assertEqual({row[0] for row in rows}, {"first", "second"})
        self.assertEqual(len({row[2] for row in rows}), 2)
        self.assertTrue(all(row[3] == "1" for row in rows))

    def test_same_category_name_on_different_nominal_types_has_distinct_keys(self):
        rows = [row for row in self.run_fixture(other_type=True) if len(row) == 4]
        self.assertEqual({row[0] for row in rows}, {"first", "second", "other"})
        self.assertEqual(len({row[2] for row in rows}), 3)

    def test_same_category_name_on_same_type_in_distinct_submodules_has_distinct_keys(self):
        rows = [row for row in self.run_fixture(same_category=True) if len(row) == 4]
        self.assertEqual({row[0] for row in rows}, {"first", "second"})
        self.assertEqual(len({row[2] for row in rows}), 2)

    def test_late_import_preserves_existing_keys_and_gets_a_distinct_extension(self):
        rows = self.run_fixture(late=True)
        declarations = [row for row in rows if len(row) == 4]
        self.assertEqual({row[0] for row in declarations}, {"first", "second", "late"})
        self.assertEqual(len({row[2] for row in declarations}), 3)
        self.assertEqual(
            [row[1] for row in rows if row[0] == "late-import-stable"], ["1", "1"]
        )

    def test_fileprivate_overloads_in_different_source_files_remain_distinct(self):
        rows = self.run_fixture(private_values=True)
        keys = [row[1] for row in rows if row[0] == "fileprivate"]
        self.assertEqual(len(keys), 2)
        self.assertEqual(len(set(keys)), 2)

    def test_reordered_references_preserve_category_and_member_keys(self):
        forward = {row[0]: row[1:3] for row in self.run_fixture() if len(row) == 4}
        reverse = {row[0]: row[1:3] for row in self.run_fixture(reverse=True) if len(row) == 4}
        self.assertEqual(forward, reverse)

    def test_global_members_do_not_materialize_unrelated_declarations(self):
        small = self.run_fixture(global_members=True, unused=0)
        large = self.run_fixture(global_members=True, unused=200)
        small_bytes = int(next(row[1] for row in small if row[0] == "additional-ast-bytes"))
        large_bytes = int(next(row[1] for row in large if row[0] == "additional-ast-bytes"))
        self.assertEqual(large_bytes, small_bytes)

    def test_global_member_extensions_from_different_submodules_remain_distinct(self):
        rows = [row for row in self.run_fixture(global_members=True) if len(row) == 4]
        self.assertEqual({row[0] for row in rows}, {"firstValue", "secondValue"})
        self.assertEqual(len({row[2] for row in rows}), 2)

    def test_reordered_global_references_preserve_extension_and_member_keys(self):
        forward = {
            row[0]: row[1:3]
            for row in self.run_fixture(global_members=True)
            if len(row) == 4
        }
        reverse = {
            row[0]: row[1:3]
            for row in self.run_fixture(global_members=True, reverse=True)
            if len(row) == 4
        }
        self.assertEqual(forward, reverse)

    def test_late_global_import_preserves_existing_keys_and_gets_a_distinct_extension(self):
        rows = self.run_fixture(global_members=True, late=True)
        declarations = [row for row in rows if len(row) == 4]
        self.assertEqual(
            {row[0] for row in declarations}, {"firstValue", "secondValue", "lateValue"}
        )
        self.assertEqual(len({row[2] for row in declarations}), 3)
        self.assertEqual(
            [row[1] for row in rows if row[0] == "late-import-stable"], ["1", "1"]
        )


if __name__ == "__main__":
    unittest.main()
