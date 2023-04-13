#!/usr/bin/env python3

import json
import os
import re
import itertools

def make_groups(blocks):
    groups = {}
    for block in blocks:
        groups.setdefault("".join(block["lines"]), []).append(block)
    return list(groups.values())

def validate_fragments(fragments):
    for header, blocks in fragments.items():
        groups = make_groups(blocks)
        if len(groups) > 1:
            print("Warning: '{}' fragments are different for {}".format(header, ["{}:{}:{}".format(group[0]["file"], group[0]["start"], group[0]["end"]) for group in groups]))

def main():
    script_dir = os.path.dirname(os.path.realpath(__file__))

    with open(os.path.join(script_dir, "dbscheme-fragments.json"), "r") as f:
        config = json.load(f)

    fragment_headers = set(config["fragments"])
    fragments = {}
    for file in config["files"]:
        with open(os.path.join(os.path.dirname(script_dir), file), "r") as dbscheme:
            header = None
            line_number = 1
            block = { "file": file, "start": line_number, "end": None, "lines": [] }
            def end_block():
                nonlocal header, block, line_number, fragments
                block["end"] = line_number - 1
                if len(block["lines"]) > 0:
                    if header is None:
                        if re.match(r'(?m)^//.*$|/\*(\**[^\*])*\*+/', "".join(block["lines"])):
                            # Ignore comments at the beginning of the file
                            pass
                        else:                            
                            print("Warning: fragment without header: {}:{}:{}".format(block["file"], block["start"], block["end"]))
                    else:
                        fragments.setdefault(header, []).append(block)
            for line in dbscheme:
                m = re.match(r"^\/\*-.*-\*\/$", line)
                if m:
                    end_block()
                    header = line.strip()
                    if header not in fragment_headers:
                        print("Warning: unknown fragment header: {}: {}:{}".format(header, file, line_number))
                    block = { "file": file, "start": line_number, "end": None, "lines": [] }
                block["lines"].append(line)
                line_number += 1
            end_block()
    validate_fragments(fragments)

if __name__ == "__main__":
    main()
