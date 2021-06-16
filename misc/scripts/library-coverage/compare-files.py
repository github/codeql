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


def compare_files(file1, file2, path_to_report):
    has_differences = False
    diff = difflib.ndiff(open(file1).readlines(),
                         open(file2).readlines(), None, ignore_line_ending)
    for line in diff:
        if line.startswith("+") or line.startswith("-"):
            print(line, end="", file=sys.stderr)
            has_differences = True

    if has_differences:
        print("The generated file doesn't match the one in the codebase. Please check and fix file '" +
              path_to_report + "'.", file=sys.stderr)
        return False
    return True


languages = ['java']

all_ok = True

for lang in languages:
    repo_output_rst = settings.repo_output_rst.format(language=lang)
    repo_output_csv = settings.repo_output_csv.format(language=lang)

    generated_output_rst = settings.generated_output_rst.format(language=lang)
    generated_output_csv = settings.generated_output_csv.format(language=lang)

    check_file_exists(repo_output_rst)
    check_file_exists(repo_output_csv)
    check_file_exists(generated_output_rst)
    check_file_exists(generated_output_csv)

    docs_folder = settings.documentation_folder_no_prefix.format(language=lang)

    rst_ok = compare_files(repo_output_rst, generated_output_rst,
                           docs_folder + settings.output_rst_file_name)
    csv_ok = compare_files(repo_output_csv, generated_output_csv,
                           docs_folder + settings.output_csv_file_name)

    if not rst_ok or not csv_ok:
        print("The generated CSV coverage report files for '" + lang + "' don't match the ones in the codebase. Please update the files in '" +
              docs_folder + "'. The new files can be downloaded from the artifacts of this job.", file=sys.stderr)
        all_ok = False
    else:
        print("The generated files for '" + lang +
              "' match the ones in the codebase.")

if not all_ok:
    sys.exit(1)
