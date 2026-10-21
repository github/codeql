import json
import os
from pathlib import Path
import stat
import subprocess
import tempfile
import unittest
import zipfile

from python.runfiles import runfiles


PLATFORMS = {
    "linux64": ["linux-x64"],
    "linux-arm64": ["linux-arm64"],
    "osx64": ["darwin-arm64", "darwin-x64"],
    "win64": ["win32-x64"],
}


class PackageTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        files = runfiles.Create()
        cls.node = files.Rlocation(os.environ["NODE_BIN"])
        cls.ripunzip = files.Rlocation(os.environ["RIPUNZIP"])
        cls.script = files.Rlocation(os.environ["PACKAGE_RUNTIME"])
        cls.wrapper_zip = files.Rlocation(os.environ["TS_WRAPPER_ZIP"])
        cls.native_zip = files.Rlocation(os.environ["TS_NATIVE_ZIP"])
        cls.common_zip = files.Rlocation(os.environ["TS_COMMON_ZIP"])
        cls.arch_zip = files.Rlocation(os.environ["TS_ARCH_ZIP"])
        with zipfile.ZipFile(cls.wrapper_zip) as archive:
            cls.version = json.loads(
                archive.read("typescript-parser-wrapper/package.json")
            )["dependencies"]["typescript"]

    def stage(self, directory, distribution, mismatch=False):
        modules = directory / "node_modules"
        typescript = modules / "typescript"
        typescript.mkdir(parents=True)
        dependencies = {}
        for platform in {p for ps in PLATFORMS.values() for p in ps}:
            name = "typescript-" + platform
            package = modules / "@typescript" / name
            (package / "lib").mkdir(parents=True)
            manifest = {
                "name": "@typescript/" + name,
                "version": "invalid" if mismatch else self.version,
            }
            (package / "package.json").write_text(json.dumps(manifest))
            executable = package / "lib" / (
                "tsc.exe" if platform.startswith("win32-") else "tsc"
            )
            executable.write_text("native executable fixture")
            executable.chmod(0o644)
            dependencies[manifest["name"]] = self.version
        (typescript / "package.json").write_text(
            json.dumps({"version": self.version, "optionalDependencies": dependencies})
        )
        packages = subprocess.run(
            [self.node, self.script, "--packages", distribution],
            cwd=directory,
            capture_output=True,
            text=True,
            timeout=30,
        )
        if distribution in PLATFORMS:
            self.assertEqual(packages.returncode, 0, packages.stderr)
            self.assertEqual(
                packages.stdout.split(),
                [
                    "@typescript/typescript-" + platform + "@" + self.version
                    for platform in PLATFORMS[distribution]
                ],
            )
        else:
            self.assertNotEqual(packages.returncode, 0)
            self.assertIn("Unsupported CodeQL distribution", packages.stderr)
        return subprocess.run(
            [self.node, self.script, distribution],
            cwd=directory,
            capture_output=True,
            text=True,
            timeout=30,
        )

    def test_distribution_selection_is_independent_of_host(self):
        for distribution, platforms in PLATFORMS.items():
            with (
                self.subTest(distribution=distribution),
                tempfile.TemporaryDirectory() as temp,
            ):
                directory = Path(temp)
                result = self.stage(directory, distribution)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout, "")
                self.assertEqual(
                    sorted(p.name for p in (directory / "native").iterdir()),
                    sorted("typescript-" + p for p in platforms),
                )
                self.assertFalse((directory / "node_modules/@typescript").exists())
                if os.name != "nt":
                    for executable in (directory / "native").glob("*/lib/tsc"):
                        self.assertEqual(stat.S_IMODE(executable.stat().st_mode), 0o755)

    def test_invalid_distribution_and_mismatched_runtime_fail(self):
        for distribution, mismatch, message in [
            ("unsupported", False, "Unsupported CodeQL distribution"),
            ("osx64", True, "Native runtime does not match TypeScript"),
        ]:
            with (
                self.subTest(distribution=distribution),
                tempfile.TemporaryDirectory() as temp,
            ):
                result = self.stage(Path(temp), distribution, mismatch)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")
                self.assertIn(message, result.stderr)

    def extract(self, filename, destination):
        destination.mkdir(parents=True, exist_ok=True)
        result = subprocess.run(
            [self.ripunzip, "unzip-file", filename, "-d", str(destination)],
            capture_output=True,
            text=True,
            timeout=60,
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_installed_archives_parse_without_external_typescript(self):
        host = subprocess.check_output(
            [self.node, "-p", "process.platform + '-' + process.arch"], text=True
        ).strip()
        platforms = next(ps for ps in PLATFORMS.values() if host in ps)
        with zipfile.ZipFile(self.wrapper_zip) as archive:
            self.assertFalse(any("/@typescript/" in n for n in archive.namelist()))
        with zipfile.ZipFile(self.native_zip) as archive:
            names = archive.namelist()
            self.assertEqual(
                sorted({n.removeprefix("./").split("/")[0] for n in names}),
                sorted("typescript-" + p for p in platforms),
            )
            for platform in platforms:
                prefix = "typescript-" + platform
                manifest = json.loads(archive.read(prefix + "/package.json"))
                self.assertEqual(manifest["version"], self.version)
                binary = prefix + "/lib/" + (
                    "tsc.exe" if platform.startswith("win32-") else "tsc"
                )
                self.assertGreater(archive.getinfo(binary).file_size, 0)
                if not platform.startswith("win32-"):
                    self.assertEqual(
                        archive.getinfo(binary).external_attr >> 16 & 0o777, 0o755
                    )

        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp)
            with zipfile.ZipFile(self.common_zip) as archive:
                self.assertFalse(any("/@typescript/" in n for n in archive.namelist()))
                self.assertIn(
                    "tools/typescript-parser-wrapper/main.js", archive.namelist()
                )
            with zipfile.ZipFile(self.arch_zip) as archive:
                self.assertEqual(
                    sorted(n for n in archive.namelist() if not n.endswith("/")),
                    sorted(
                        "tools/typescript-parser-wrapper/node_modules/@typescript/" + n
                        for n in names
                        if not n.endswith("/")
                    ),
                )
            self.extract(self.common_zip, directory)
            self.extract(self.arch_zip, directory)
            wrapper = directory / "tools/typescript-parser-wrapper"
            environment = dict(os.environ)
            environment.pop("NODE_PATH", None)
            commands = []
            for name, source in [
                ("valid.ts", "const value: number = 1;"),
                ("valid.tsx", "const value = <div>Hello</div>;"),
                ("invalid.ts", "const value = ;"),
            ]:
                filename = directory / name
                filename.write_text(source)
                commands.extend(
                    [
                        {"command": "parse", "filename": str(filename)},
                        {"command": "reset"},
                    ]
                )
            commands.append({"command": "quit"})
            result = subprocess.run(
                [self.node, str(wrapper / "main.js")],
                input="".join(json.dumps(command) + "\n" for command in commands),
                cwd=directory,
                env=environment,
                capture_output=True,
                text=True,
                timeout=60,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(result.stderr, "")
            responses = [json.loads(line) for line in result.stdout.splitlines()]
            self.assertEqual(len(responses), 6)
            for response in responses[::2]:
                self.assertEqual(response["type"], "ast")
            for response in responses[1::2]:
                self.assertEqual(response, {"type": "reset-done"})
            self.assertEqual(responses[0]["ast"]["parseDiagnostics"], [])
            self.assertEqual(responses[2]["ast"]["parseDiagnostics"], [])
            self.assertTrue(responses[4]["ast"]["parseDiagnostics"])


if __name__ == "__main__":
    unittest.main()
