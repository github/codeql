# This script is used to annotate .qll files without any existing overlay annotations
# with overlay[local?] and overlay[caller] annotations. Maintenance of overlay annotations
# in annotated files will be handled by QL-for-QL queries.

# It will walk the directory tree and annotate most .qll files, skipping only
# some specific cases (e.g., empty files, files that configure dataflow for queries).

# The script takes a list of languages and processes the corresponding directories.

# Usage: python3 add-overlay-annotations.py <language1> <language2> ...

# The script will modify the files in place and print the changes made.
# The script is designed to be run from the root of the repository.

#!/usr/bin/python3
import sys
import os
from difflib import *


def has_overlay_annotations(lines):
    '''
    Check whether the given lines contain any overlay[...] annotations.
    '''
    overlays = ["local", "local?", "global", "caller"]
    annotations = [f"overlay[{t}]" for t in overlays]
    return any(ann in line for ann in annotations for line in lines)


def insert_toplevel_maybe_local_annotation(filename, lines):
    '''
    Find a suitable place to insert an overlay[local?] annotation at the top of the file.
    Return a pair: (string describing action taken, modified content as list of lines).
    '''
    out_lines = []
    status = 0

    for line in lines:
        if status == 0 and line.rstrip().endswith("module;"):
            out_lines.append("overlay[local?]\n")
            status = 1
        out_lines.append(line)

    if status == 1:
        return (f"Annotating \"{filename}\" via existing file-level module statement", out_lines)

    out_lines = []
    empty_line_buffer = []
    status = 0
    for line in lines:
        trimmed = line.strip()
        if not trimmed:
            empty_line_buffer.append(line)
            continue
        if status <= 1 and trimmed.endswith("*/"):
            status = 2
        elif status == 0 and trimmed.startswith("/**"):
            status = 1
        elif status == 0 and not trimmed.startswith("/*"):
            out_lines.append("overlay[local?]\n")
            out_lines.append("module;\n")
            out_lines.append("\n")
            status = 3
        elif status == 2 and (trimmed.startswith("import ") or trimmed.startswith("private import ")):
            out_lines.append("overlay[local?]\n")
            out_lines.append("module;\n")
            status = 3
        elif status == 2 and (trimmed.startswith("class ") or trimmed.startswith("predicate ")
                              or trimmed.startswith("module ") or trimmed.startswith("signature ")):
            out_lines = ["overlay[local?]\n", "module;\n", "\n"] + out_lines
            status = 3
        elif status == 2 and trimmed.startswith("/*"):
            out_lines.append("overlay[local?]\n")
            out_lines.append("module;\n")
            status = 3
        elif status == 2:
            status = 4
        if empty_line_buffer:
            out_lines += empty_line_buffer
            empty_line_buffer = []
        out_lines.append(line)
    if status == 3:
        out_lines += empty_line_buffer

    if status == 3:
        return (f"Annotating \"{filename}\" after file-level module qldoc", out_lines)

    raise Exception(f"Failed to annotate \"{filename}\" as overlay[local?].")


def insert_overlay_caller_annotations(lines):
    '''
    Mark pragma[inline] predicates as overlay[caller] if they are not declared private.
    '''
    out_lines = []
    for i, line in enumerate(lines):
        trimmed = line.strip()
        if trimmed == "pragma[inline]":
            if i + 1 < len(lines) and not "private" in lines[i+1]:
                whitespace = line[0: line.find(trimmed)]
                out_lines.append(f"{whitespace}overlay[caller]\n")
        out_lines.append(line)
    return out_lines


def annotate_as_appropriate(filename, lines):
    '''
    Insert new overlay[...] annotations according to heuristics in files without existing
    overlay annotations.

    Returns None if no annotations are needed. Otherwise, returns a pair consisting of a
    string describing the action taken and the modified content as a list of lines.
    '''
    if has_overlay_annotations(lines):
        return None

    # These simple heuristics filter out those .qll files that we no _not_ want to annotate
    # as overlay[local?].  It is not clear that these heuristics are exactly what we want,
    # but they seem to work well enough for now (as determined by speed and accuracy numbers).
    if (filename.endswith("Test.qll") or
        ((filename.endswith("Query.qll") or filename.endswith("Config.qll")) and
         any("implements DataFlow::ConfigSig" in line for line in lines))):
        return None
    elif not any(line for line in lines if line.strip()):
        return None

    lines = insert_overlay_caller_annotations(lines)
    return insert_toplevel_maybe_local_annotation(filename, lines)


def process_single_file(check, filename):
    '''
    Process a single file, annotating it as appropriate and writing the changes back to the file.
    '''
    old = [line for line in open(filename)]

    annotate_result = annotate_as_appropriate(filename, old)
    if annotate_result is None:
        return False

    if check:
       return True

    new = annotate_result[1]

    diff = context_diff(old, new, fromfile=filename, tofile=filename)
    diff = [line for line in diff]
    if diff:
        print(annotate_result[0])
        for line in diff:
            print(line.rstrip())
        with open(filename, "w") as out_file:
            for line in new:
                out_file.write(line)


if len(sys.argv) > 1 and sys.argv[1] == "--check":
  check = True
  langs = sys.argv[2:]
else:
  check = False
  langs = sys.argv[1:]

dirs = []
for lang in langs:
    if lang in ["cpp", "go", "csharp", "java", "javascript", "python", "ruby", "rust", "swift"]:
        dirs.append(f"{lang}/ql/lib")
    else:
        raise Exception(f"Unknown language \"{lang}\".")

if dirs:
    dirs.append("shared")

missingAnnotations = []

for roots in dirs:
    for dirpath, dirnames, filenames in os.walk(roots):
        for filename in filenames:
            if filename.endswith(".qll") and not dirpath.endswith("tutorial"):
                path = os.path.join(dirpath, filename)
                res = process_single_file(check, path)
                if check and res:
                    missingAnnotations.append(path)


if len(missingAnnotations) > 0:
    print("The following files have no overlay annotations:")
    for path in missingAnnotations[:10]:
      print("- " + path)
    if len(missingAnnotations) > 10:
      print("and " + str(len(missingAnnotations) - 10) + " additional files.")
    print()
    print("Please manually add overlay annotations or use the config/add-overlay-annotations.py script to automatically add sensible default overlay annotations.")
    exit(-1)
