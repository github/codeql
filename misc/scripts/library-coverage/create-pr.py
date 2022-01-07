import sys
import settings
import utils
import shutil
import json
import os

"""
This script compares the generated CSV coverage files with the ones in the codebase. And if they are different, it
creates a PR with the changes. If a PR already exists, then it will be updated to reflect the latest changes.
"""

# Name of the branch that's used to push the updated coverage files, also the head of the PR
branch_name = "workflow/coverage/update"
# Name of the remote where the new commit is pushed
remote = "origin"
# Name of the branch that provides the base for the new branch, and the base of the PR
main = "main"

repo = sys.argv[2]
owner = repo.split('/')[0]


def overwrite_files():
    for lang in settings.languages:
        repo_output_rst = settings.repo_output_rst.format(language=lang)
        repo_output_csv = settings.repo_output_csv.format(language=lang)

        generated_output_rst = settings.generated_output_rst.format(
            language=lang)
        generated_output_csv = settings.generated_output_csv.format(
            language=lang)

        exists = utils.check_file_exists(generated_output_rst)
        if not exists:
            print(
                f"Generated RST file {generated_output_rst} is missing", file=sys.stderr)
            sys.exit(1)

        exists = utils.check_file_exists(generated_output_csv)
        if not exists:
            print(
                f"Generated RST file {generated_output_csv} is missing", file=sys.stderr)
            sys.exit(1)

        shutil.move(generated_output_rst, repo_output_rst)
        shutil.move(generated_output_csv, repo_output_csv)


def get_pr_number(repo, owner, from_branch, to_branch):
    ids = utils.subprocess_check_output(["gh", "api", "-X", "GET", f"repos/{repo}/pulls", "-f",
                                        f"name={to_branch}", "-f", f"head={owner}:{from_branch}", "--jq", "[.[].number]"])

    ids = json.loads(ids)

    if len(ids) > 1:
        print(
            f"Found more than one PR that matches the branches. {ids}", file=sys.stderr)
        sys.exit(1)

    if len(ids) == 1:
        print(f"Matching PR found: {ids[0]}")
        return ids[0]

    return 0


def create_pr(repo, from_branch, to_branch):
    print(f"Creating PR for {from_branch}")
    utils.subprocess_check_output(["gh", "pr", "create", "-R", repo, "--base", to_branch,
                                   "--head", from_branch, "--title", "Update CSV framework coverage reports",
                                   "--body", "This PR changes the CSV framework coverage reports."])


working_dir = ""
if len(sys.argv) > 1:
    working_dir = sys.argv[1]
else:
    print("Working directory is not specified")
    exit(1)

found_diff = False
overwrite_files()

os.chdir(working_dir)

already_open_pr = get_pr_number(repo, owner, branch_name, main)
try:
    utils.subprocess_check_output(["git", "diff", "--exit-code"])
    print("No differences found")
    found_diff = False
except:
    print("Differences found")
    found_diff = True

if not found_diff:
    if already_open_pr != 0:
        # close the PR
        utils.subprocess_run(
            ["gh", "pr", "close", str(already_open_pr), "-R", repo])
else:
    utils.subprocess_run(["git", "config", "user.name",
                         "github-actions[bot]"])
    utils.subprocess_run(["git", "config", "user.email",
                         "41898282+github-actions[bot]@users.noreply.github.com"])
    utils.subprocess_run(["git", "add", "."])
    utils.subprocess_run(
        ["git", "commit", "-m", "Add changed framework coverage reports"])
    utils.subprocess_run(["git", "branch", "-f", branch_name, main])
    utils.subprocess_run(["git", "push", "-f", remote, branch_name])
    if already_open_pr == 0:
        create_pr(repo, branch_name, main)
