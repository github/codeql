#!/usr/bin/env python3
r"""
This script can be used to go over `codeql test run` expected/actual log output from
github actions, and apply patches locally to make the tests pass.

It works by forming individual patches for each test-failure, and then applying them one
by one. Since Python runs some tests twice (for both Python2 and Python3), we try to do
some simple duplicate patch detection, to avoid failing to apply the same patch twice.

Use it by checking out an up to date version of your branch, and just run the script (it
will use `gh` cli to figure out what the PR number is). You must have the `gh` cli tool
installed.

The parsing of logs is somewhat tolerant of output being interleaved with other parallel
execution, but it might fail in some cases ¯\_(ツ)_/¯

Code written to hack things together until they work, so don't expect much :D
"""

import argparse
import sys
import re
import tempfile
from typing import List, Dict, Set, Optional, Any
from pathlib import Path
import subprocess
import logging
import json
from dataclasses import dataclass, field
from datetime import datetime
import os.path
import itertools

LOGGER = logging.getLogger(Path(__file__).name)

DEBUG_SAVE_PATCHES = False
DEBUG_LOG_FILE = None


def _get_codeql_repo_dir() -> Path:
    return Path(__file__).parent.parent.parent.resolve()


CODEQL_REPO_DIR = _get_codeql_repo_dir()

def _get_semmle_code_dir() -> Optional[Path]:
    guess = CODEQL_REPO_DIR.parent.resolve()
    try:
        out = subprocess.check_output(
            ["git", "remote", "-v"],
            cwd=guess,
        ).decode("utf-8")
        if "github/semmle-code" in out:
            return guess
        else:
            return None
    except subprocess.CalledProcessError:
        return None


SEMMLE_CODE_DIR = _get_semmle_code_dir()
if SEMMLE_CODE_DIR is None:
    LOGGER.warning("Could not find semmle-code repo, will not be able to apply patches for it")


@dataclass(frozen=True, eq=True, order=True)
class Patch:
    filename: Path
    dir: Optional[str]
    patch_first_line: str
    patch: List[str] = field(hash=False)

    def format_as_patch(self) -> str:
        return (f"--- a/{self.filename}\n" +
            f"+++ b/{self.filename}\n" +
            "\n".join(self.patch) +
            "\n"
        )


def parse_log_line(log_line: str) -> str:
    if '\t' in log_line:
        m = re.fullmatch(r"^(?:[^\t]+\t){2}\S+ ?(.*)$", log_line.strip())
    else:
        m = re.fullmatch(r"^(?:[^ ]+ )(.*)$", log_line.strip())

    if not m:
        return ""

    return m.group(1)


def make_patches_from_log_file(log_file_lines) -> List[Patch]:
    # TODO: If the expected output contains `Password=123` this will be masked as `***`
    # in the actions logs. We _could_ try to detect this and replace the line with the
    # actual content from file (but it would require parsing the @@ lines, to understand
    # what the old linenumber to read is)
    patches = []

    lines = iter(log_file_lines)

    for raw_line in lines:
        line = parse_log_line(raw_line)

        if line == "--- expected":
            while True:
                next_line = parse_log_line(next(lines))
                if next_line == "+++ actual":
                    break

            lines_changed = []

            while True:
                next_line = parse_log_line(next(lines))
                # it can be the case that
                if next_line and next_line[0] in (" ", "-", "+", "@"):
                    lines_changed.append(next_line)
                if "FAILED" in next_line:
                    break

            # error line _should_ be next, but sometimes the output gets interleaved...
            # so we just skip until we find the error line
            error_line = next_line
            while True:
                # internal
                filename_match = re.fullmatch(r"^##\[error\].*FAILED\(RESULT\) (.*)$", error_line)
                if not filename_match:
                    # codeql action
                    filename_match = re.fullmatch(r"^.*FAILED\(RESULT\) (.*)$", error_line)
                if filename_match:
                    break
                error_line = parse_log_line(next(lines))

            full_path = filename_match.group(1)

            known_start_paths = {
                # internal CI runs
                "/home/runner/work/semmle-code/semmle-code/ql/": CODEQL_REPO_DIR,
                "/home/runner/work/semmle-code/semmle-code/target/codeql-java-integration-tests/ql/": CODEQL_REPO_DIR,
                "/home/runner/work/semmle-code/semmle-code/" : SEMMLE_CODE_DIR,
                # github actions on codeql repo
                "/home/runner/work/codeql/codeql/": CODEQL_REPO_DIR,
                "/Users/runner/work/codeql/codeql/" : CODEQL_REPO_DIR, # MacOS
            }
            for known_start_path, dir in known_start_paths.items():
                if full_path.startswith(known_start_path):
                    filename = Path(full_path[len(known_start_path):])
                    break
            else:
                raise Exception(f"Unknown path {full_path}, skipping")

            expected_filename = filename.with_suffix(".expected")

            # if the .expected file used to be empty, `codeql test run` outputs a diff
            # that uses `@@ -1,1 ` but git wants it to be `@@ -0,0 ` (and not include
            # the removal of the empty line)
            if lines_changed[0].startswith("@@ -1,1 ") and lines_changed[1] == "-":
                lines_changed[0] = lines_changed[0].replace("@@ -1,1 ", "@@ -0,0 ")
                del lines_changed[1]

            patch = Patch(
                filename=expected_filename,
                dir=dir,
                patch_first_line=lines_changed[0],
                patch=lines_changed,
            )
            patches.append(patch)

    return patches

def make_github_api_list_request(path: str) -> Any:
    """Handles the way paginate currently works, which is to return multiple lists of
    results, instead of merging them :(
    """

    s = subprocess.check_output(
        ["gh", "api", "--paginate", path],
    ).decode("utf-8")

    try:
        return json.loads(s)
    except json.JSONDecodeError:
        assert "][" in s
        parts = s.split("][")
        parts[0] = parts[0] + "]"
        parts[-1] = "[" + parts[-1]
        for i in range(1, len(parts) - 1):
            parts[i] = "[" + parts[i] + "]"
        return itertools.chain(*[json.loads(x) for x in parts])


@dataclass
class GithubStatus():
    state: str
    context: str
    target_url: str
    created_at: datetime
    nwo: str
    job_ids: set = None


def get_log_content(status: GithubStatus) -> str:
    LOGGER.debug(f"'{status.context}': Getting logs")
    if status.job_ids:
        contents = [subprocess.check_output(
            ["gh", "api", f"/repos/{status.nwo}/actions/jobs/{job_id}/logs"],
        ).decode("utf-8") for job_id in status.job_ids]
        content = "\n".join(contents)
    else:
        m = re.fullmatch(r"^https://github\.com/([^/]+/[^/]+)/actions/runs/(\d+)(?:/jobs/(\d+))?$", status.target_url)
        nwo = m.group(1)
        run_id = m.group(2)
        content = subprocess.check_output(
            ["gh", "run", "view", "--repo", nwo, run_id, "--log-failed"],
        ).decode("utf-8")

    if DEBUG_SAVE_PATCHES:
        tmp = tempfile.NamedTemporaryFile(delete=False)
        tmp.write(content.encode(encoding="utf-8"))
        print(tmp.name)
    return content


def main(pr_number: Optional[int], sha_override: Optional[str] = None, force=False, wait_for_ci=True):
    if not pr_number and not sha_override:
        raise Exception("Must specify either a PR number or a SHA")

    if sha_override:
        github_sha = sha_override
    else:
        LOGGER.info(f"Getting status URL for codeql PR #{pr_number}")
        github_sha = subprocess.check_output(
            ["gh", "api", f"repos/github/codeql/pulls/{pr_number}", "--jq", ".head.sha"]
        ).decode("utf-8").strip()

    local_sha = subprocess.check_output(
        ["git", "rev-parse", "HEAD"]
    ).decode("utf-8").strip()

    if local_sha != github_sha and not force:
        LOGGER.error(f"GitHub SHA ({github_sha}) different from your local SHA ({local_sha}), sync your changes first!")
        sys.exit(1)
    sha = github_sha

    status_url = f"https://api.github.com/repos/github/codeql/commits/{sha}/statuses"
    LOGGER.info(f"Getting status details ({status_url})")
    statuses = make_github_api_list_request(status_url)
    newest_status: Dict[str, GithubStatus] = dict()

    for status in statuses:
        created_at = datetime.fromisoformat(status["created_at"][:-1])
        key = status["context"]
        if key not in newest_status or created_at > newest_status[key].created_at:
            m = re.fullmatch(r"^https://github\.com/([^/]+/[^/]+)/actions/runs/(\d+)(?:/jobs/(\d+))?$", status["target_url"])

            newest_status[key] = GithubStatus(
                state=status["state"],
                context=status["context"],
                target_url=status["target_url"],
                created_at=created_at,
                nwo=m.group(1),
            )

    supported_internal_status_language_test_names = [
        "Java Integration Tests Linux",
        # "codeql-coding-standards Unit Tests Linux",
        # TODO: Currently disabled, would just require support for figuring out where
        # https://github.com/github/codeql-coding-standards/ is checked out locally
    ]

    lang_test_failures: List[GithubStatus] = list()
    for status in newest_status.values():
        if " Language Tests" in status.context or status.context in supported_internal_status_language_test_names:
            if status.state == "failure":
                lang_test_failures.append(status)
            elif status.state == "pending":
                if wait_for_ci:
                    LOGGER.error(f"Language tests ({status.context}) are still running, please wait for them to finish before running this script again (or run with --dont-wait)")
                    sys.exit(1)

    job_failure_urls = set()
    for lang_test_failure in lang_test_failures:
        job_failure_urls.add(lang_test_failure.target_url)

    for job_failure_url in job_failure_urls:
        # fixup URL. On the status, the target URL is the run, and it's really hard to
        # change this to link to the full `/runs/<run_id>/jobs/<numeric_job_id>` URL, since
        # the `<numeric_job_id>` is not available in a context: https://github.com/community/community/discussions/40291
        m = re.fullmatch(r"^https://github\.com/([^/]+/[^/]+)/actions/runs/(\d+)$", job_failure_url)
        nwo = m.group(1)
        run_id = m.group(2)
        jobs_url = f"https://api.github.com/repos/{nwo}/actions/runs/{run_id}/jobs"
        LOGGER.info(f"Fixing up target url from looking at {jobs_url}")
        jobs = json.loads(subprocess.check_output(["gh", "api", "--paginate", jobs_url]).decode("utf-8"))
        for lang_test_failure in lang_test_failures:
            workflow_translation = {
                "codeql-coding-standards Unit Tests Linux": "Start codeql-coding-standards"
            }
            expected_workflow_name = workflow_translation.get(lang_test_failure.context, lang_test_failure.context)

            for job in jobs["jobs"]:
                api_name: str = job["name"]

                if api_name.lower().startswith(expected_workflow_name.lower()):
                    if lang_test_failure.job_ids is None:
                        lang_test_failure.job_ids = set()
                    lang_test_failure.job_ids.add(job["id"])
                    continue

                if " / " not in api_name:
                    continue

                workflow_name, job_name = api_name.split(" / ")
                # The job names we're looking for looks like "Python2 Language Tests / Python2 Language Tests" or "Java Language Tests / Java Language Tests Linux"
                # for "Java Integration Tests Linux / Java Integration tests Linux" we need to ignore case :|
                if workflow_name == expected_workflow_name and job_name.lower().startswith(lang_test_failure.context.lower()):
                    lang_test_failure.job_ids.add(job["id"])
                    continue

    for lang_test_failure in lang_test_failures:
        if lang_test_failure.job_ids is None:
            LOGGER.error(f"Could not find job for {lang_test_failure.context!r}")
            sys.exit(1)

    # Ruby/Swift/C#/Go use github actions, and not internal CI. These are not reported
    # from the /statuses API, but from the /check-suites API
    check_suites_url = f"https://api.github.com/repos/github/codeql/commits/{sha}/check-suites"
    LOGGER.info(f"Getting check suites ({check_suites_url})")
    check_suites = json.loads(subprocess.check_output(["gh", "api", "--paginate", check_suites_url]).decode("utf-8"))

    check_failure_urls = []
    for check in check_suites["check_suites"]:
        if check["status"] != "completed":
            if wait_for_ci:
                print(check)
                LOGGER.error("At least one check not completed yet!")
                sys.exit(1)

        if check["conclusion"] == "failure":
            check_failure_urls.append(check["check_runs_url"])

    for check_failure_url in check_failure_urls:
        # run information: https://docs.github.com/en/rest/actions/workflow-jobs?apiVersion=2022-11-28#get-a-job-for-a-workflow-run
        check_runs = json.loads(subprocess.check_output(["gh", "api", "--paginate", check_failure_url]).decode("utf-8"))
        for check_run in check_runs["check_runs"]:
            if check_run["conclusion"] == "failure":
                m = re.fullmatch(r"^https://github\.com/([^/]+/[^/]+)/actions/runs/(\d+)(?:/job/(\d+))?$", check_run["details_url"])
                if not m:
                    LOGGER.error(f"Could not parse details URL for {check_run['name']}: '{check_run['details_url']}'")
                    continue
                nwo = m.group(1)
                run_id = m.group(2)
                jobs_url = f"https://api.github.com/repos/{nwo}/actions/runs/{run_id}/jobs"
                LOGGER.debug(f"Looking into failure at {jobs_url}")
                jobs = json.loads(subprocess.check_output(["gh", "api", "--paginate", jobs_url]).decode("utf-8"))

                for job in jobs["jobs"]:
                    OK_WORKFLOW_NAMES = ["C#: Run QL Tests", "Go: Run Tests", "Ruby: Run QL Tests", "Swift"]
                    def ok_job_name(job_name: str) -> bool:
                        if job_name.startswith("qltest"):
                            return True
                        if job_name.startswith("Test Linux"):
                            return True
                        if job_name.startswith("integration-tests"):
                            return True
                        return False

                    if job["name"] == check_run['name'] and job["workflow_name"] in OK_WORKFLOW_NAMES and ok_job_name(job["name"]):
                        # print(check_run['name'], 'matched to', f"{job['workflow_name']} / {job['name']}")
                        lang_test_failures.append(GithubStatus(
                            state="failure",
                            context=f"{job['workflow_name']} / {job['name']}",
                            target_url=job["html_url"],
                            created_at=check_run["completed_at"],
                            nwo=nwo,
                            job_ids={job["id"]},
                        ))
                        break
                else:
                    LOGGER.debug(f"Ignoring actions failure for '{check_run['name']}' ({check_run['details_url']})")

    if not lang_test_failures:
        LOGGER.info("No language test failures found")
        return

    patches_to_apply: Set[Patch] = set()

    for failure in lang_test_failures:
        log_content = get_log_content(failure)
        LOGGER.info(f"'{failure.context}': Making patches")
        patches = make_patches_from_log_file(log_content.splitlines())

        if not patches:
            LOGGER.warning(f"No patches generated for job {failure}")
            continue

        for patch in patches:
            if patch in patches_to_apply:
                LOGGER.debug(f"Skipping duplicate patch for {patch.filename}")
                continue
            patches_to_apply.add(patch)

    if DEBUG_SAVE_PATCHES:
        sys.exit("debug save patches")

    if not patches_to_apply:
        print("No patches to apply")
        return

    semmle_code_changed = False

    for patch in patches_to_apply:
        with tempfile.NamedTemporaryFile(prefix=f"patches-", suffix=".patch") as temp:
            temp.write(patch.format_as_patch().encode(encoding="utf-8"))
            temp.flush()
            LOGGER.info(f"Applying patch for '{patch.filename}'")
            try:
                if patch.dir is None:
                    LOGGER.warning(f"Did not find local semmle-code directory, so skipping patch for '{patch.filename}'")
                    continue

                subprocess.check_call(["git", "apply", temp.name], cwd=patch.dir)

                if "CONSISTENCY" in patch.filename.parts and patch.filename.exists():
                    # delete if empty
                    if os.path.getsize(patch.filename) == 1 and patch.filename.read_text() == "\n":
                        os.remove(patch.filename)
                        LOGGER.info(f"Deleted empty CONSISTENCY file '{patch.filename}'")

                if patch.dir == SEMMLE_CODE_DIR:
                    semmle_code_changed = True
            except subprocess.CalledProcessError:
                LOGGER.error(f"Could not apply patches for '{patch.filename}' '{patch.patch[0]}', skipping")
                tmp_keep = tempfile.NamedTemporaryFile(delete=False)
                tmp_keep.write(patch.format_as_patch().encode(encoding="utf-8"))
                LOGGER.error(f"Patch saved to {tmp_keep.name}")

    if semmle_code_changed:
        print("Expected output in semmle-code changed!")


def printHelp():
    print("""Usage:
python3 accept-expected-changes-from-ci.py [PR-number|SHA]

Example invocations:
$ python3 accept-expected-changes-from-ci.py 1234
$ python3 accept-expected-changes-from-ci.py d88a8130386b720de6cac747d1bd2dd527769467

Requirements:
- The 'gh' command line tool must be installed and authenticated.
- The CI check must have finished.
""")

if __name__ == "__main__":

    level = logging.INFO

    try:
        import coloredlogs
        coloredlogs.install(level, fmt="%(levelname)s: %(message)s")
    except ImportError:
        logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")

    # parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--force", action="store_true", help="Apply patches even if the local SHA is different from the GitHub PR SHA")
    parser.add_argument("--dont-wait", dest="wait_for_ci", action="store_false", help="Do not wait for all CI jobs to finish")
    parser.add_argument("posarg", nargs="?", default=None)

    if DEBUG_LOG_FILE:
        patches = make_patches_from_log_file(open(DEBUG_LOG_FILE, "r").readlines())
        for patch in patches:
            if True:
                tmp_keep = tempfile.NamedTemporaryFile(delete=False)
                tmp_keep.write(patch.format_as_patch().encode(encoding="utf-8"))
                LOGGER.info(f"Patch for {patch.filename} saved to {tmp_keep.name}")
        sys.exit(1)

    os.chdir(CODEQL_REPO_DIR)

    pr_number = None
    override_sha = None
    args = parser.parse_args()

    if args.posarg is None:
        try:
            pr_number_response = subprocess.check_output([
                "gh", "pr", "view", "--json", "number"
            ]).decode("utf-8")
            pr_number = json.loads(pr_number_response)["number"]
        except:
            print("Could not auto detect PR number.")
            print("")
            printHelp()
            sys.exit(1)
    else:
        if len(args.posarg) > 10:
            override_sha = args.posarg
        else:
            pr_number = int(args.posarg)

    main(pr_number, override_sha, force=args.force, wait_for_ci=args.wait_for_ci)
