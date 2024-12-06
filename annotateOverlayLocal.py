#!/usr/bin/python

import os


def process_single_file(filename):
    if not filename.endswith(".qll"):
        return

    with open(filename, 'r') as file_in:
        lines = [line for line in file_in]

    configuresDataflow = any(
        "implements DataFlow::ConfigSig" in line for line in lines)

    moduleAnnotations = ""
    if any(line for line in lines if line.rstrip().endswith("module;")):
        for line in lines:
            moduleAnnotations += line
            if line.rstrip().endswith("module;"):
                break

    moduleAnnotations = strip_comments(moduleAnnotations)

    isFileLevelAnnotated = ("overlay[local]" in moduleAnnotations or
                            "overlay[local?]" in moduleAnnotations)

    if configuresDataflow or isFileLevelAnnotated or filename.endswith("Query.qll"):
        if isFileLevelAnnotated and configuresDataflow:
            print("WARNING: file \""+filename +
                  "\" configures dataflow, but is annotated local")
        elif configuresDataflow and not filename.endswith("Query.qll"):
            print("WARNING: file \""+filename +
                  "\" configures dataflow but is not a [...]Query.qll file")
        elif filename.endswith("Query.qll") and not configuresDataflow:
            print("WARNING: file \""+filename +
                  "\" is a [...]Query.qll file that does not configure dataflow")
        elif isFileLevelAnnotated and filename.endswith("Query.qll"):
            print("WARNING: file \""+filename +
                  "\" is a [...]Query.qll file, but is annotated local")
    elif any(line for line in lines if line.rstrip().endswith("module;")):
        print("file \""+filename +
              " was annotated using an existing file-level module statment")
        with open(filename, "w") as file_out:
            for line in lines:
                if line.rstrip().endswith("module;"):
                    file_out.write("overlay[local?]\n")
                file_out.write(line)
    elif (lines[0].startswith("import ") or lines[0].startswith("private ") or
          lines[0].startswith("newtype ") or lines[0].startswith("module ") or
          lines[0].startswith("signature ")):
        print("file \""+filename+" was annotated at the very start of the file")
        with open(filename, "w") as file_out:
            file_out.write("overlay[local?]\nmodule;\n\n")
            for line in lines:
                file_out.write(line)
    elif (strip_comments("".join(lines)).lstrip().startswith("import") or
          strip_comments("".join(lines)).lstrip().startswith("private import")):
        print("file \""+filename+" was annotated at the first import statement")
        with open(filename, "w") as file_out:
            firstImport = True
            addEmptyLine = ""
            for line in lines:
                if not line.strip():
                    if addEmptyLine:
                        file_out.write(addEmptyLine)
                    addEmptyLine = line
                else:
                    if firstImport and (line.startswith("import") or line.startswith("private")):
                        file_out.write("overlay[local?]\nmodule;\n")
                        firstImport = False

                    if addEmptyLine:
                        file_out.write(addEmptyLine)
                        addEmptyLine = ""
                    file_out.write(line)
    elif (len(lines) > 2 and lines[0].startswith("/** ") and lines[0].endswith(" */\n") and
          not lines[1].strip() and lines[2].startswith("/**")):
        print("file \""+filename+" was annotated after single-line file module qldoc")
        with open(filename, "w") as file_out:
            file_out.write(lines[0])
            file_out.write("overlay[local?]\nmodule;\n")
            for line in lines[1:]:
                file_out.write(line)
    else:
        print("ERROR: failure to annotate file \""+filename+"\"")


def strip_comments(str):
    prev = ""
    in_multiline = False
    in_singleline = False

    result = ""
    for c in str:
        if c == '*' and prev == '/':
            in_multiline = True
            prev = ""
        elif c == '/' and prev == '/':
            in_singleline = True
            prev = ""
        elif in_multiline and c == '/' and prev == '*':
            in_multiline = False
            prev = ""
        elif in_singleline and c == '\n':
            in_singleline = False
            result += '\n'
            prev = ""
        else:
            if not in_multiline and not in_singleline:
                if prev == '/':
                    result += '/'
                if c != '/':
                    result += c
            prev = c
    return result


for roots in ["java/ql/lib/semmle/code", "shared"]:
    for dirpath, dirnames, filenames in os.walk(roots):
        for filename in filenames:
            if filename.endswith(".qll"):
                process_single_file(os.path.join(dirpath, filename))
