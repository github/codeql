#!/usr/bin/env python3

import argparse
import json
import os
import pathlib
import re


def make_groups(blocks):
    groups = {}
    for block in blocks:
        groups.setdefault("".join(block["lines"]), []).append(block)
    return list(groups.values())


def validate_fragments(fragments):
    ok = True
    for header, blocks in fragments.items():
        groups = make_groups(blocks)
        if len(groups) > 1:
            ok = False
            print("Warning: dbscheme fragments with header '{}' are different for {}".format(header, ["{}:{}:{}".format(
                group[0]["file"], group[0]["start"], group[0]["end"]) for group in groups]))
    return ok


def main():
    script_path = os.path.realpath(__file__)
    script_dir = os.path.dirname(script_path)
    parser = argparse.ArgumentParser(
        prog=os.path.basename(script_path),
        description='Sync dbscheme fragments across files.'
    )
    parser.add_argument('files', metavar='dbscheme_file', type=pathlib.Path, nargs='*', default=[],
                        help='dbscheme files to check')
    args = parser.parse_args()

    with open(os.path.join(script_dir, "dbscheme-fragments.json"), "r") as f:
        config = json.load(f)

    fragment_headers = set(config["fragments"])
    fragments = {}
    ok = True
    for file in args.files + config["files"]:
        with open(os.path.join(os.path.dirname(script_dir), file), "r") as dbscheme:
            header = None
            line_number = 1
            block = {"file": file, "start": line_number,
                     "end": None, "lines": []}

            def end_block():
                block["end"] = line_number - 1
                if len(block["lines"]) > 0:
                    if header is None:
                        if re.match(r'(?m)\A(\s|//.*$|/\*(\**[^\*])*\*+/)*\Z', "".join(block["lines"])):
                            # Ignore comments at the beginning of the file
                            pass
                        else:
                            ok = False
                            print("Warning: dbscheme fragment without header: {}:{}:{}".format(
                                block["file"], block["start"], block["end"]))
                    else:
                        fragments.setdefault(header, []).append(block)
            for line in dbscheme:
                m = re.match(r"^\/\*-.*-\*\/$", line)
                if m:
                    end_block()
                    header = line.strip()
                    if header not in fragment_headers:
                        ok = False
                        print("Warning: unknown header for dbscheme fragment: '{}': {}:{}".format(
                            header, file, line_number))
                    block = {"file": file, "start": line_number,
                             "end": None, "lines": []}
                block["lines"].append(line)
                line_number += 1
            block["lines"].append('\n')
            line_number += 1
            end_block()
    if not ok or not validate_fragments(fragments):
        exit(1)


if __name__ == "__main__":
    main()
