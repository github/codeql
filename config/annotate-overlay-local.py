# This script is used to annotate .qll files with overlay[local?] annotations.
# It will walk the directory tree and annotate most .qll files, skipping only
# some specific cases (e.g., empty files, files that configure dataflow for queries).
# It will also add overlay[caller] annotations to predicates that are pragma[inline]
# and either not private or in a hardcoded list of predicates.

# The script takes a list of languages and processes the corresponding directories.

# Usage: python3 annotate-overlay-local.py <language1> <language2> ...

# The script will modify the files in place and print the changes made.
# The script is designed to be run from the root of the repository.

#!/usr/bin/python3
import sys
import os
from difflib import *

# These are the only two predicates that are pragma[inline], private, and must be
# overlay[caller] in order to successfully compile our internal java queries.
hardcoded_overlay_caller_preds = [
    "fwdFlowInCand", "fwdFlowInCandTypeFlowDisabled"]


def filter_out_annotations(filename):
    '''
    Read the file and strip all existing overlay[...] annotations from the contents.
    Return the file modified file content as a list of lines.
    '''
    overlays = ["local?", "caller"]
    annotations = [f"overlay[{t}]" for t in overlays]
    with open(filename, 'r') as file_in:
        lines = [l for l in file_in if not l.strip() in annotations]
    for ann in annotations:
        if any(line for line in lines if ann in line):
            raise Exception(f"Failed to filter out {ann} from {filename}.")
    return lines


def insert_toplevel_maybe_local_anntotation(filename, lines):
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
    Mark pragma[inline] predicates as overlay[caller] if they are not declared private
    or if they are private but are in the list of hardcoded_overlay_caller_preds.
    '''
    out_lines = []
    for i, line in enumerate(lines):
        trimmed = line.strip()
        if trimmed == "pragma[inline]":
            if (not "private" in lines[i+1] or
                    any(pred in lines[i+1] for pred in hardcoded_overlay_caller_preds)):
                whitespace = line[0: line.find(trimmed)]
                out_lines.append(f"{whitespace}overlay[caller]\n")
        out_lines.append(line)
    return out_lines


def annotate_as_appropriate(filename):
    '''
    Read file and strip all existing overlay[...] annotations from the contents;
    then insert new overlay[...] annotations according to heuristics.
    Return a pair: (string describing action taken, modified content as list of lines).
    '''
    lines = filter_out_annotations(filename)
    lines = insert_overlay_caller_annotations(lines)

    # These simple heuristics filter out those .qll files that we no _not_ want to annotate
    # as overlay[local?].  It is not clear that these heuristics are exactly what we want,
    # but they seem to work well enough for now (as determined by speed and accuracy numbers).
    if (filename.endswith("Test.qll") or
        ((filename.endswith("Query.qll") or filename.endswith("Config.qll")) and
         any("implements DataFlow::ConfigSig" in line for line in lines))):
        return (f"Keeping \"{filename}\" global because it configures dataflow for a query", lines)
    elif not any(line for line in lines if line.strip()):
        return (f"Keeping \"{filename}\" global because it is empty", lines)

    return insert_toplevel_maybe_local_anntotation(filename, lines)


def process_single_file(filename):
    '''
    Process a single file, annotating it as appropriate and writing the changes back to the file.
    '''
    annotate_result = annotate_as_appropriate(filename)

    old = [line for line in open(filename)]
    new = annotate_result[1]

    if old != new:
        diff = context_diff(old, new, fromfile=filename, tofile=filename)
        diff = [line for line in diff]
        if diff:
            print(annotate_result[0])
            for line in diff:
                print(line.rstrip())
            with open(filename, "w") as out_file:
                for line in new:
                    out_file.write(line)


dirs = []
for lang in sys.argv[1:]:
    if lang in ["cpp", "go", "csharp", "java", "javascript", "python", "ruby", "rust", "swift"]:
        dirs.append(f"{lang}/ql/lib")
    else:
        raise Exception(f"Unknown language \"{lang}\".")

if dirs:
    dirs.append("shared")

for roots in dirs:
    for dirpath, dirnames, filenames in os.walk(roots):
        for filename in filenames:
            if filename.endswith(".qll") and not dirpath.endswith("tutorial"):
                process_single_file(os.path.join(dirpath, filename))
