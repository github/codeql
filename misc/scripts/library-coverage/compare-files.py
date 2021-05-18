import sys
import os
import settings
import filecmp

"""
This script compares the generated CSV coverage files with the ones in the codebase.
"""


def check_file_exists(file):
    if not os.path.exists(file):
        print("Expected file '" + file + "' doesn't exist.", file=sys.stderr)
        sys.exit(1)


def compare_files(file1, file2):
    filecmp.clear_cache()
    if not filecmp.cmp(file1, file2):
        print("Error: The generated files do not match the ones in the codebase. Please check and fix file '" +
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
