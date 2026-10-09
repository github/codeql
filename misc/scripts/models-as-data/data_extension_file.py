import json


# Simple class for representing a data extension file and writing it to disk in a pretty-printed YAML or JSON format.
class DataExtensionFile:
    def __init__(self, pack):
        self.pack = pack
        self.predicates = {}

    def add_rows(self, predicate, rows):
        if predicate not in self.predicates:
            self.predicates[predicate] = []
        self.predicates[predicate].extend(rows)

    def yaml_for_value(self, value):
        # if is boolean:
        if isinstance(value, bool):
            # json.dumps would produce lower-case "true" or "false". Even though that's valid YAML,
            # we have historically used the upper-case variants.
            return "True" if value else "False"
        return json.dumps(value)

    def yaml_for_row(self, row):
        return f"[{', '.join(self.yaml_for_value(value) for value in row)}]"

    def yaml_for_predicate(self, predicate):
        return f"""  - addsTo:
      pack: {self.pack}
      extensible: {predicate}
    data:
      - {'\n      - '.join(self.yaml_for_row(row) for row in self.predicates[predicate])}
"""

    def write_yaml(self, f):
        # It would be preferable to use a YAML serialization library, but this lets us control the
        # formatting e.g. to produce one line per tuple.
        f.write("# THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.\n")
        f.write("extensions:\n")
        for predicate in sorted(self.predicates.keys()):
            f.write(self.yaml_for_predicate(predicate))

    def json_for_row(self, row):
        return "[" + ", ".join(json.dumps(value) for value in row) + "]"

    def json_for_predicate(self, predicate):
        return f"""    {{
      "addsTo": {{
        "pack": "{self.pack}",
        "extensible": "{predicate}"
      }},
      "data": [
        {',\n        '.join(self.json_for_row(row) for row in self.predicates[predicate])}
      ]
    }}"""

    def write_json(self, f):
        # It would be preferable to use a serializer like Python's json.dumps, but it can't
        # pretty-print with one line per tuple.
        f.write("// THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.\n")
        f.write("{\n")
        f.write('  "extensions": [\n')
        for i, predicate in enumerate(self.predicates):
            if i > 0:
                f.write(",\n")
            f.write(self.json_for_predicate(predicate))
        f.write("\n")
        f.write("  ]\n")
        f.write("}")
