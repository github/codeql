import sys
import os
import settings
import difflib

"""
This script compares the generated CSV coverage files with the ones in the codebase.
"""


def check_file_exists(file):
    if not os.path.exists(file):
        print("Expected file '" + file + "' doesn't exist.", file=sys.stderr)
        sys.exit(1)


def ignore_line_ending(ch):
    return difflib.IS_CHARACTER_JUNK(ch, ws=" \r\n")


def compare_files(file1, file2):
    has_differences = False
    diff = difflib.ndiff(open(file1).readlines(),
                         open(file2).readlines(), None, ignore_line_ending)
    for line in diff:
        if line.startswith("+") or line.startswith("-"):
            print(line, end="", file=sys.stderr)
            has_differences = True

    if has_differences:
        print("Error: The generated file doesn't match the one in the codebase. Please check and fix file '" +
              file1 + "'.", file=sys.stderr)
        sys.exit(1)


languages = ['java']

for lang in languages:
    repo_output_rst = settings.repo_output_rst.format(language=lang)
    repo_output_csv = settings.repo_output_csv.format(language=lang)

    generated_output_rst = settings.generated_output_rst.format(language=lang)
    generated_output_csv = settings.generated_output_csv.format(language=lang)

    check_file_exists(repo_output_rst)
    check_file_exists(repo_output_csv)
    check_file_exists(generated_output_rst)
    check_file_exists(generated_output_csv)

    compare_files(repo_output_rst, generated_output_rst)
    compare_files(repo_output_csv, generated_output_csv)

    print("The generated files for '" + lang +
          "' match the ones in the codebase.")
