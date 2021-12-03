import sys
import os
import utils
import shutil
import json
import filecmp

"""
This script compares the generated CSV coverage files with the ones in the codebase.
"""

artifacts_workflow_name = "Check framework coverage changes"
comparison_artifact_name = "comparison"
comparison_artifact_file_name = "comparison.md"


comment_first_line = ":warning: The head of this PR and the base branch were compared for differences in the framework coverage reports. "


def get_comment_text(output_file, repo, run_id):
    size = os.path.getsize(output_file)
    if size == 0:
        print("No difference in the coverage reports")
        return

    comment = comment_first_line + \
        f"The generated reports are available in the [artifacts of this workflow run](https://github.com/{repo}/actions/runs/{run_id}). " + \
        "The differences will be picked up by the nightly job after the PR gets merged.\n\n"

    comment += "<details><summary>Click to show differences in coverage</summary>\n\n"
    with open(output_file, 'r') as file:
        comment += file.read()

    comment += "</details>\n"

    return comment


def comment_pr(repo, run_id):
    """
    Generates coverage diff produced by the changes in the current PR. If the diff is not empty, then post it as a comment.
    If a workflow run produces the same diff as the directly preceeding one, then don't post a comment.
    """

    # Store diff for current run
    current_diff_folder = "current_diff"
    utils.download_artifact(repo, comparison_artifact_name,
                            current_diff_folder, run_id)

    utils.download_artifact(repo, "pr", "pr", run_id)

    try:
        with open("pr/NR") as file:
            pr_number = int(file.read())
    finally:
        if os.path.isdir("pr"):
            shutil.rmtree("pr")

    # Try storing diff for previous run:
    prev_run_id = 0
    prev_diff_exists = False
    try:
        prev_run_id = get_previous_run_id(repo, run_id, pr_number)
        prev_diff_folder = "prev_diff"
        utils.download_artifact(repo, comparison_artifact_name,
                                prev_diff_folder, prev_run_id)

        prev_diff_exists = True

        if filecmp.cmp(f"{current_diff_folder}/{comparison_artifact_file_name}", f"{prev_diff_folder}/{comparison_artifact_file_name}", shallow=False):
            print(
                f"Previous run {prev_run_id} resulted in the same diff, so not commenting again.")
            return
        else:
            print(f"Diff of previous run {prev_run_id} differs, commenting.")
    except Exception:
        # this is not necessarily a failure, it can also mean that there was no previous run yet.
        print("Couldn't generate diff for previous run:", sys.exc_info()[1])

    comment = get_comment_text(
        f"{current_diff_folder}/{comparison_artifact_file_name}", repo, run_id)

    if comment == None:
        if prev_run_id == 0:
            print(
                "Nothing to comment. There's no previous run, and there's no coverage change.")
            return

        print("Previous run found, and current run removes coverage change.")

        if not prev_diff_exists:
            print(
                "Couldn't get the comparison artifact from previous run. Not commenting.")
            return

        comment = comment_first_line + \
            "A recent commit removed the previously reported differences."
    post_comment(comment, repo, pr_number)


def post_comment(comment, repo, pr_number):
    print(f"Posting comment to PR #{pr_number}")
    utils.subprocess_run(["gh", "pr", "comment", str(pr_number),
                         "--repo", repo, "--body", comment])


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
    output = utils.subprocess_check_output(["gh", "api", "-X", "GET", f"repos/{repo}/actions/runs", "-f", "event=pull_request", "-f", "status=success", "-f", f"branch='{pr_branch}'", "--paginate",
                                            "--jq", f'[.workflow_runs.[] | select(.head_repository.full_name=="{pr_repo}" and .name=="{artifacts_workflow_name}")] | sort_by(.id) | reverse | [.[].id]'])

    ids = []
    for l in [json.loads(l) for l in output.splitlines()]:
        for id in l:
            ids.append(id)

    if ids[0] != int(run_id):
        raise Exception(
            f"Expected to find {run_id} in the list of matching runs.")

    for previous_run_id in ids[1:]:
        utils.download_artifact(repo, "pr", "prev_run_pr", previous_run_id)

        try:
            with open("prev_run_pr/NR") as file:
                prev_pr_number = int(file.read())
                print(f"PR number: {prev_pr_number}")
        finally:
            if os.path.isdir("prev_run_pr"):
                shutil.rmtree("prev_run_pr")

        # the previous run needs to be coming from the same PR:
        if pr_number == prev_pr_number:
            return int(previous_run_id)

    raise Exception("Couldn't find previous run.")


repo = sys.argv[1]
run_id = sys.argv[2]

comment_pr(repo, run_id)
