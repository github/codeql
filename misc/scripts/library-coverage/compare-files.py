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

    filecmp.clear_cache()
    if not filecmp.cmp(repo_output_rst, generated_output_rst, shallow=False) or not filecmp.cmp(repo_output_csv, generated_output_csv, shallow=False):
        print("Error: The generated files for '" + lang +
              "' do not match the ones in the codebase. Please check and fix.", file=sys.stderr)
        sys.exit(1)

    print("The generated files for '" + lang +
          "' match the ones in the codebase.")
