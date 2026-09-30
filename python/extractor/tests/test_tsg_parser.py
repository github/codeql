import unittest
import unittest.mock
import json

from semmle.logging import format_message
from semmle.python.parser.tsg_parser import Node, evaluate_string, read_tsg_python_output


class JsonOutputTest(unittest.TestCase):
    def test_decodes_nodes_edges_and_attribute_values(self):
        output = json.dumps(
            [
                {
                    "id": 0,
                    "edges": [
                        {
                            "sink": 1,
                            "attrs": {"body": {"type": "int", "int": 0}},
                        }
                    ],
                    "attrs": {
                        "_kind": {"type": "string", "string": "Module"},
                        "_location": {
                            "type": "list",
                            "values": [
                                {"type": "int", "int": 0},
                                {"type": "int", "int": 0},
                                {"type": "int", "int": 1},
                                {"type": "int", "int": 0},
                            ],
                        },
                    },
                },
                {
                    "id": 1,
                    "edges": [],
                    "attrs": {
                        "_kind": {"type": "string", "string": "Name"},
                        "variable": {
                            "type": "string",
                            "string": "caf\u00e9 \u26a0\ufe0f \U0001f4be",
                        },
                        "s": {
                            "type": "string",
                            "string": '"\u26a0\ufe0f  problem %s: %s"',
                        },
                        "is_async": {"type": "bool", "bool": True},
                        "optional": {"type": "null"},
                        "_skip_to": {"type": "graphNode", "id": 0},
                    },
                },
            ]
        ).encode("utf-8")

        process = unittest.mock.Mock()
        process.communicate.return_value = (output, None)
        process.returncode = 0
        with unittest.mock.patch(
            "semmle.python.parser.tsg_parser.subprocess.Popen", return_value=process
        ):
            node_attr, edge_attr = read_tsg_python_output(
                "test.py", unittest.mock.Mock()
            )

        self.assertEqual(node_attr[1]["variable"], "caf\u00e9 \u26a0\ufe0f \U0001f4be")
        self.assertEqual(node_attr[1]["s"], "\u26a0\ufe0f  problem %s: %s")
        self.assertIs(node_attr[1]["is_async"], True)
        self.assertIsNone(node_attr[1]["optional"])
        self.assertIsInstance(node_attr[1]["_skip_to"], Node)
        self.assertEqual(node_attr[1]["_skip_to"].id, 0)
        self.assertEqual(edge_attr, {0: {"body": [(0, 1)]}})

    def test_evaluate_string_on_reported_value(self):
        value = '"\u26a0\ufe0f  problem %s: %s"'
        self.assertEqual(evaluate_string(value), "\u26a0\ufe0f  problem %s: %s")


class FormatMessageTest(unittest.TestCase):
    """A pre-formatted log message may contain `%` directives coming from the analysed source, and
    must not be `%`-formatted again."""

    def test_no_arguments(self):
        message = "Error while parsing value '%s: %s'"
        self.assertEqual(format_message(message, ()), message)

    def test_with_arguments(self):
        self.assertEqual(format_message("%s and %s", ("a", "b")), "a and b")
