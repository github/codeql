import json

# Simple class for representing a data extension file and writing it to disk in a pretty-printed format.
class DataExtensionFile:
    def __init__(self, pack):
         self.pack = pack
         self.predicates = {}

    def add_rows(self, predicate, rows):
        if predicate not in self.predicates:
            self.predicates[predicate] = []
        self.predicates[predicate].extend(rows)

    def json_for_row(self, row):
        return "[" + ", ".join(json.dumps(value) for value in row) +"]"

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
        f.write('// THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.\n')
        f.write('{\n')
        f.write('  "extensions": [\n')
        for i, predicate in enumerate(self.predicates):
            if i > 0:
                f.write(',\n')
            f.write(self.json_for_predicate(predicate))
        f.write('\n')
        f.write('  ]\n')
        f.write('}')