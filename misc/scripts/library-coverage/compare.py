import sys
import settings
import utils
import difflib


def ignore_line_ending(ch):
    return difflib.IS_CHARACTER_JUNK(ch, ws=" \r\n")


def compare_files(file1, file2):
    diff = difflib.ndiff(open(file1).readlines(),
                         open(file2).readlines(), None, ignore_line_ending)
    ret = ""
    for line in diff:
        if line.startswith("+") or line.startswith("-"):
            ret += line

    return ret


def compare_folders(folder1, folder2, output_file):
    """
    Compares the contents of two folders and writes the differences to the output file.
    """

    return_md = ""

    for lang in settings.languages:
        expected_files = ""

        generated_output_rst = settings.generated_output_rst.format(
            language=lang)
        generated_output_csv = settings.generated_output_csv.format(
            language=lang)

        # check if files exist in both folder1 and folder 2
        if not utils.check_file_exists(f"{folder1}/{generated_output_rst}"):
            expected_files += f"- {generated_output_rst} doesn't exist in folder {folder1}\n"
        if not utils.check_file_exists(f"{folder2}/{generated_output_rst}"):
            expected_files += f"- {generated_output_rst} doesn't exist in folder {folder2}\n"
        if not utils.check_file_exists(f"{folder1}/{generated_output_csv}"):
            expected_files += f"- {generated_output_csv} doesn't exist in folder {folder1}\n"
        if not utils.check_file_exists(f"{folder2}/{generated_output_csv}"):
            expected_files += f"- {generated_output_csv} doesn't exist in folder {folder2}\n"

        if expected_files != "":
            print("Expected files are missing", file=sys.stderr)
            return_md += f"\n### {lang}\n\n#### Expected files are missing for {lang}\n{expected_files}\n"
            continue

        # compare contents of files
        cmp1 = compare_files(
            f"{folder1}/{generated_output_rst}", f"{folder2}/{generated_output_rst}")
        cmp2 = compare_files(
            f"{folder1}/{generated_output_csv}", f"{folder2}/{generated_output_csv}")

        if cmp1 != "" or cmp2 != "":
            print("Generated file contents are not matching", file=sys.stderr)
            return_md += f"\n### {lang}\n\n#### Generated file changes for {lang}\n\n"
            if cmp1 != "":
                return_md += f"- Changes to {generated_output_rst}:\n```diff\n{cmp1}```\n\n"
            if cmp2 != "":
                return_md += f"- Changes to {generated_output_csv}:\n```diff\n{cmp2}```\n\n"

    with open(output_file, 'w', newline='') as out:
        out.write(return_md)
