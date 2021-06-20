import sys
import os
import settings
import difflib
import utils

"""
This script compares the generated CSV coverage files with the ones in the codebase.
"""


def check_file_exists(file):
    if not os.path.exists(file):
        print("Expected file '" + file + "' doesn't exist.", file=sys.stderr)
        return False
    return True


def ignore_line_ending(ch):
    return difflib.IS_CHARACTER_JUNK(ch, ws=" \r\n")


def compare_files(file1, file2):
    messages = compare_files_str(file1, file2)
    if messages == "":
        return True

    print(messages, end="", file=sys.stderr)

    return False


def compare_files_str(file1, file2):
    diff = difflib.ndiff(open(file1).readlines(),
                         open(file2).readlines(), None, ignore_line_ending)
    ret = ""
    for line in diff:
        if line.startswith("+") or line.startswith("-"):
            ret += line

    return ret


def comment_pr(output_file, repo, run_id):
    folder1 = "out_base"
    folder2 = "out_merge"
    utils.subprocess_run(["gh", "run", "download", "--repo", repo, "--name",
                         "csv-framework-coverage-base", "--dir", folder1, str(run_id)])
    utils.subprocess_run(["gh", "run", "download", "--repo", repo, "--name",
                         "csv-framework-coverage-merge", "--dir", folder2, str(run_id)])
    utils.subprocess_run(["gh", "run", "download", "--repo", repo, "--name",
                         "pr", "--dir", "pr", str(run_id)])

    with open("pr/NR") as file:
        pr_number = int(file.read())

    compare_folders(folder1, folder2, output_file)
    size = os.path.getsize(output_file)
    if size == 0:
        print("No difference in the coverage reports")
        return

    comment = ":warning: The head of this PR and the base branch were compared for differences in the framework coverage reports. " + \
        "The generated reports are available in the [artifacts of this workflow run](https://github.com/" + repo + "/actions/runs/" + str(run_id) + "). " + \
        "The differences will be picked up by the nightly job after the PR gets merged. "

    if size < 2000:
        print("There's a small change in the CSV framework coverage reports")
        comment += "The following differences were found: \n\n"
        with open(output_file, 'r') as file:
            comment += file.read()
    else:
        print("There's a large change in the CSV framework coverage reports")
        comment += "The differences can be found in the " + \
            output_file + " artifact of this job."

    # post_comment(comment, repo, pr_number)


def post_comment(comment, repo, pr_number):
    print("Posting comment to PR #" + str(pr_number))
    utils.subprocess_run(["gh", "pr", "comment", pr_number,
                         "--repo", repo, "--body", comment])


def compare_folders(folder1, folder2, output_file):
    languages = ['java']

    return_md = ""

    for lang in languages:
        expected_files = ""

        generated_output_rst = settings.generated_output_rst.format(
            language=lang)
        generated_output_csv = settings.generated_output_csv.format(
            language=lang)

        # check if files exist in both folder1 and folder 2
        if not check_file_exists(folder1 + "/" + generated_output_rst):
            expected_files += "- " + generated_output_rst + \
                " doesn't exist in folder " + folder1 + "\n"
        if not check_file_exists(folder2 + "/" + generated_output_rst):
            expected_files += "- " + generated_output_rst + \
                " doesn't exist in folder " + folder2 + "\n"
        if not check_file_exists(folder1 + "/" + generated_output_csv):
            expected_files += "- " + generated_output_csv + \
                " doesn't exist in folder " + folder1 + "\n"
        if not check_file_exists(folder2 + "/" + generated_output_csv):
            expected_files += "- " + generated_output_csv + \
                " doesn't exist in folder " + folder2 + "\n"

        if expected_files != "":
            print("Expected files are missing", file=sys.stderr)
            return_md += "\n### " + lang + "\n\n#### Expected files are missing for " + \
                lang + "\n" + expected_files + "\n"
            continue

        # compare contents of files
        cmp1 = compare_files_str(
            folder1 + "/" + generated_output_rst, folder2 + "/" + generated_output_rst)
        cmp2 = compare_files_str(
            folder1 + "/" + generated_output_csv, folder2 + "/" + generated_output_csv)

        if cmp1 != "" or cmp2 != "":
            print("Generated file contents are not matching", file=sys.stderr)
            return_md += "\n### " + lang + "\n\n#### Generated file changes for " + \
                lang + "\n\n"
            if cmp1 != "":
                return_md += "- Changes to " + generated_output_rst + \
                    ":\n```diff\n" + cmp1 + "```\n\n"
            if cmp2 != "":
                return_md += "- Changes to " + generated_output_csv + \
                    ":\n```diff\n" + cmp2 + "```\n\n"

    with open(output_file, 'w', newline='') as out:
        out.write(return_md)


# comment_pr(sys.argv[1], sys.argv[2], sys.argv[3])
comment_pr("x.md", "dsp-testing/codeql-csv-coverage-pr-commenter", 938931471)
