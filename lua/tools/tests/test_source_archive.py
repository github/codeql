from pathlib import Path
import shutil
import subprocess
import sys
from tempfile import TemporaryDirectory
import unittest


TOOLS_ROOT = Path(__file__).resolve().parents[1]
LUA_ROOT = TOOLS_ROOT.parent


class SourceArchiveTests(unittest.TestCase):
    def test_extractor_cli_uses_codeql_source_archive_namespace(self) -> None:
        fixture = (
            LUA_ROOT
            / "ql/test/library-tests/bytecode-model/bc-constants-call/input.luac"
        )

        with TemporaryDirectory() as directory:
            temporary_root = Path(directory).resolve()
            input_root = temporary_root / "input"
            source_archive = temporary_root / "source-archive"
            trap_output = temporary_root / "trap"
            lua_source = input_root / "app/source.lua"
            lua_bytecode = input_root / "lib/input.luac"
            lua_source.parent.mkdir(parents=True)
            lua_bytecode.parent.mkdir(parents=True)
            lua_source.write_text("return 'source archive test'\n", encoding="utf-8")
            shutil.copyfile(fixture, lua_bytecode)

            subprocess.run(
                [
                    sys.executable,
                    str(TOOLS_ROOT / "index_lua_files.py"),
                    "--source-root",
                    str(input_root),
                    "--source-archive-dir",
                    str(source_archive),
                    "--output-dir",
                    str(trap_output),
                ],
                cwd=input_root,
                check=True,
            )

            for source in (lua_source, lua_bytecode):
                archive_path = str(source.resolve()).replace(":", "_").lstrip("/\\")
                archived = source_archive / archive_path
                self.assertTrue(archived.is_file(), archived)
                self.assertEqual(source.read_bytes(), archived.read_bytes())


if __name__ == "__main__":
    unittest.main()
