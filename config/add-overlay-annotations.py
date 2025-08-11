# This script is used to annotate .qll files without any existing overlay annotations
# with overlay[local?] and overlay[caller?] annotations. Maintenance of overlay annotations
# in annotated files will be handled by QL-for-QL queries.

# It will walk the directory tree and annotate most .qll files, skipping only
# some specific cases (e.g., empty files, files that configure dataflow for queries).

# The script takes a list of languages and processes the corresponding directories.
# If the optional --check argument is provided, the script checks for missing annotations,
# but does not modify any files.

# Usage: python3 add-overlay-annotations.py [--check] <language1> <language2> ...

# The script will modify the files in place and print the changes made.
# The script is designed to be run from the root of the repository.

#!/usr/bin/python3
import sys
import os
import re
from difflib import context_diff

OVERLAY_PATTERN = re.compile(r'overlay\[[a-zA-Z?_-]+\]')

def has_overlay_annotations(lines):
    '''
    Check whether the given lines contain any overlay[...] annotations.
    '''
    return any(OVERLAY_PATTERN.search(line) for line in lines)


def is_line_comment(line):
    return line.startswith("//") or (line.startswith("/*") and line.endswith("*/"))


def find_file_level_module_declaration(lines):
    '''
    Returns the index of the existing file-level module declaration if one
    exists. Returns None otherwise.
    '''
    comment = False
    for i, line in enumerate(lines):
        trimmed = line.strip()

        if is_line_comment(trimmed):
            continue
        elif trimmed.startswith("/*"):
            comment = True
        elif comment and trimmed.endswith("*/"):
            comment = False
        elif not comment and trimmed.endswith("module;"):
            return i

    return None


def is_file_module_qldoc(i, lines):
    '''
    Assuming a qldoc ended on line i, determine if it belongs to the implicit
    file-level module. If it is followed by another qldoc or imports, then it
    does and if it is followed by any other non-empty, non-comment lines, then
    we assume that is a declaration of some kind and the qldoc is attached to
    that declaration.
    '''
    comment = False

    for line in lines[i+1:]:
        trimmed = line.strip()

        if trimmed.startswith("import ") or trimmed.startswith("private import ") or trimmed.startswith("/**"):
             return True
        elif is_line_comment(trimmed) or not trimmed:
             continue
        elif trimmed.startswith("/*"):
             comment = True
        elif comment and trimmed.endswith("*/"):
             comment = False
        elif not comment and trimmed:
             return False

    return True


def find_file_module_qldoc_declaration(lines):
    '''
    Returns the index of last line of the implicit file module qldoc if one
    exists. Returns None otherwise.
    '''

    qldoc = False
    comment = False
    for i, line in enumerate(lines):
        trimmed = line.strip()

        if trimmed.startswith("//"):
            continue
        elif (qldoc or trimmed.startswith("/**")) and trimmed.endswith("*/"):
            # a qldoc just ended; determine if it belongs to the implicit file module
            if is_file_module_qldoc(i, lines):
                return i
            else:
                return None
        elif trimmed.startswith("/**"):
            qldoc = True
        elif trimmed.startswith("/*"):
            comment = True
        elif comment and trimmed.endswith("*/"):
            comment = False
        elif (not qldoc and not comment) and trimmed:
            return None

    return None


def only_comments(lines):
    '''
    Returns true if the lines contain only comments and empty lines.
    '''
    comment = False

    for line in lines:
        trimmed = line.strip()

        if not trimmed or is_line_comment(trimmed):
            continue
        elif trimmed.startswith("/*"):
            comment = True
        elif comment and trimmed.endswith("*/"):
            comment = False
        elif comment:
            continue
        elif trimmed:
            return False

    return True


def insert_toplevel_maybe_local_annotation(filename, lines):
    '''
    Find a suitable place to insert an overlay[local?] annotation at the top of the file.
    Returns a pair consisting of description and the modified lines or None if no overlay
    annotation is necessary (e.g., for files that only contain comments).
    '''
    if only_comments(lines):
        return None

    i = find_file_level_module_declaration(lines)
    if not i == None:
        out_lines = lines[:i]
        out_lines.append("overlay[local?]\n")
        out_lines.extend(lines[i:])
        return (f"Annotating \"{filename}\" via existing file-level module statement", out_lines)

    i = find_file_module_qldoc_declaration(lines)
    if not i == None:
        out_lines = lines[:i+1]
        out_lines.append("overlay[local?]\n")
        out_lines.append("module;\n")
        out_lines.extend(lines[i+1:])
        return (f"Annotating \"{filename}\" which has a file-level module qldoc", out_lines)

    out_lines = ["overlay[local?]\n", "module;\n", "\n"] + lines
    return (f"Annotating \"{filename}\" without file-level module qldoc", out_lines)


def insert_overlay_caller_annotations(lines):
    '''
    Mark pragma[inline] predicates as overlay[caller?] if they are not declared private.
    '''
    out_lines = []
    for i, line in enumerate(lines):
        trimmed = line.strip()
        if trimmed == "pragma[inline]":
            if i + 1 < len(lines) and not "private" in lines[i+1]:
                whitespace = line[0: line.find(trimmed)]
                out_lines.append(f"{whitespace}overlay[caller?]\n")
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


def process_single_file(write, filename):
    '''
    Process a single file, annotating it as appropriate.
    If write is set, the changes are written back to the file.
    Returns True if the file requires changes.
    '''
    with open(filename) as f:
        old = [line for line in f]

    annotate_result = annotate_as_appropriate(filename, old)
    if annotate_result is None:
        return False

    if not write:
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

    return True


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
                res = process_single_file(not check, path)
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
    exit(1)
