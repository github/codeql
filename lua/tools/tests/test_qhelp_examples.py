from pathlib import Path
import unittest


LUA_ROOT = Path(__file__).resolve().parents[2]
TEST_ROOT = LUA_ROOT / "ql/test/experimental/query-tests/qhelp-examples"


class QhelpExampleContractTests(unittest.TestCase):
    def test_query_inputs_are_the_documented_examples(self) -> None:
        pairs = (
            (
                LUA_ROOT
                / "ql/src/experimental/Security/CWE-078/examples/CommandInjection.lua",
                TEST_ROOT / "CommandInjection.lua",
            ),
            (
                LUA_ROOT
                / "ql/src/experimental/Diagnostics/examples/SanitizedCommandFlow.lua",
                TEST_ROOT / "SanitizedCommandFlow.lua",
            ),
        )

        for documented, tested in pairs:
            with self.subTest(example=documented.name):
                self.assertEqual(documented.read_bytes(), tested.read_bytes())


if __name__ == "__main__":
    unittest.main()
