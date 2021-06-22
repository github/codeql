import sys
import os
import settings
import difflib
import utils
import shutil
import json
import filecmp

"""
This script compares the generated CSV coverage files with the ones in the codebase.
"""

artifacts_workflow_name = "Check framework coverage changes"


def check_file_exists(file):
    if not os.path.exists(file):
        print(f"Expected file '{file}' doesn't exist.", file=sys.stderr)
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


def download_artifact(repo, name, dir, run_id):
    utils.subprocess_run(["gh", "run", "download", "--repo",
                         repo, "--name", name, "--dir", dir, str(run_id)])


def write_diff_for_run(output_file, repo, run_id):
    folder1 = "out_base"
    folder2 = "out_merge"
    try:
        download_artifact(repo, "csv-framework-coverage-base", folder1, run_id)
        download_artifact(
            repo, "csv-framework-coverage-merge", folder2, run_id)

        compare_folders(folder1, folder2, output_file)
    finally:
        for folder in [folder1, folder2]:
            if os.path.isdir(folder):
                shutil.rmtree(folder)


def get_comment_text(output_file, repo, run_id):
    size = os.path.getsize(output_file)
    if size == 0:
        print("No difference in the coverage reports")
        return

    comment = ":warning: The head of this PR and the base branch were compared for differences in the framework coverage reports. " + \
        f"The generated reports are available in the [artifacts of this workflow run](https://github.com/{repo}/actions/runs/{run_id}). " + \
        "The differences will be picked up by the nightly job after the PR gets merged. "

    if size < 2000:
        print("There's a small change in the CSV framework coverage reports")
        comment += "The following differences were found: \n\n"
        with open(output_file, 'r') as file:
            comment += file.read()
    else:
        print("There's a large change in the CSV framework coverage reports")
        comment += f"The differences can be found in the {output_file} artifact of this job."

    return comment


def comment_pr(output_file, repo, run_id):
    """
    Generates coverage diff produced by the changes in the current PR. If the diff is not empty, then post it as a comment.
    If a workflow run produces the same diff as the directly preceeding one, then don't post a comment.
    """

    # Store diff for current run
    write_diff_for_run(output_file, repo, run_id)

    download_artifact(repo, "pr", "pr", run_id)

    try:
        with open("pr/NR") as file:
            pr_number = int(file.read())
    finally:
        if os.path.isdir("pr"):
            shutil.rmtree("pr")

    # Try storing diff for previous run:
    prev_output_file = "prev_" + output_file
    try:
        prev_run_id = get_previous_run_id(repo, run_id, pr_number)
        write_diff_for_run(prev_output_file, repo, prev_run_id)

        if filecmp.cmp(output_file, prev_output_file, shallow=False):
            print(
                f"Previous run {prev_run_id} resulted in the same diff, so not commenting again.")
            return
        else:
            print(f"Diff of previous run {prev_run_id} differs, commenting.")
    except Exception:
        # this is not mecessarily a failure, it can also mean that there was no previous run yet.
        print("Couldn't generate diff for previous run:", sys.exc_info()[1])
    finally:
        if os.path.isfile(prev_output_file):
            os.remove(prev_output_file)

    comment = get_comment_text(output_file, repo, run_id)
    post_comment(comment, repo, pr_number)


def post_comment(comment, repo, pr_number):
    print(f"Posting comment to PR #{pr_number}")
    utils.subprocess_run(["gh", "pr", "comment", str(pr_number),
                         "--repo", repo, "--body", comment])


def compare_folders(folder1, folder2, output_file):
    """
    Compares the contents of two folders and writes the differences to the output file.
    """

    languages = ['java']

    return_md = ""

    for lang in languages:
        expected_files = ""

        generated_output_rst = settings.generated_output_rst.format(
            language=lang)
        generated_output_csv = settings.generated_output_csv.format(
            language=lang)

        # check if files exist in both folder1 and folder 2
        if not check_file_exists(f"{folder1}/{generated_output_rst}"):
            expected_files += f"- {generated_output_rst} doesn't exist in folder {folder1}\n"
        if not check_file_exists(f"{folder2}/{generated_output_rst}"):
            expected_files += f"- {generated_output_rst} doesn't exist in folder {folder2}\n"
        if not check_file_exists(f"{folder1}/{generated_output_csv}"):
            expected_files += f"- {generated_output_csv} doesn't exist in folder {folder1}\n"
        if not check_file_exists(f"{folder2}/{generated_output_csv}"):
            expected_files += f"- {generated_output_csv} doesn't exist in folder {folder2}\n"

        if expected_files != "":
            print("Expected files are missing", file=sys.stderr)
            return_md += f"\n### {lang}\n\n#### Expected files are missing for {lang}\n{expected_files}\n"
            continue

        # compare contents of files
        cmp1 = compare_files_str(
            f"{folder1}/{generated_output_rst}", f"{folder2}/{generated_output_rst}")
        cmp2 = compare_files_str(
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


def get_previous_run_id(repo, run_id, pr_number):
    """
    Gets the previous run id for a given workflow run, considering that the previous workflow run needs to come from the same PR.
    """

    # Get branch and repo from run:
    this_run = utils.subprocess_check_output(
        ["gh", "api", "-X", "GET", f"repos/{repo}/actions/runs/{run_id}", "--jq", "{ head_branch: .head_branch, head_repository: .head_repository.full_name }"])

    this_run = json.loads(this_run)
    pr_branch = this_run["head_branch"]
    pr_repo = this_run["head_repository"]

    # Get all previous runs that match branch, repo and workflow name:
    ids = utils.subprocess_check_output(["gh", "api", "-X", "GET", f"repos/{repo}/actions/runs", "-f", "event=pull_request", "-f", "status=success", "-f", "name=\"" + artifacts_workflow_name + "\"", "--jq",
                                        f"[.workflow_runs.[] | select(.head_branch==\"{pr_branch}\" and .head_repository.full_name==\"{pr_repo}\") | {{ created_at: .created_at, run_id: .id}}] | sort_by(.created_at) | reverse | [.[].run_id]"])

    ids = json.loads(ids)
    if ids[0] != int(run_id):
        raise Exception(
            f"Expected to find {run_id} in the list of matching runs.")

    for previous_run_id in ids[1:]:
        download_artifact(repo, "pr", "prev_run_pr", previous_run_id)

        try:
            with open("prev_run_pr/NR") as file:
                prev_pr_number = int(file.read())
                print(f"PR number: {prev_pr_number}")
        finally:
            if os.path.isdir("prev_run_pr"):
                shutil.rmtree("prev_run_pr")

        # the previous run needs to be coming from the same PR:
        if pr_number == prev_pr_number:
            return previous_run_id

    raise Exception("Couldn't find previous run.")


output_file = sys.argv[1]
repo = sys.argv[2]
run_id = sys.argv[3]

comment_pr(output_file, repo, run_id)
