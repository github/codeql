import base64
import os
import re
import sys
import time

import requests


def handle_rate_limit(response, wait_time=60):
    return False


def search_branches(repo_nwo, file_path, regex_pattern):
    # GitHub API base URL
    base_url = "https://api.github.com"

    # Get GitHub token from environment variable
    github_token = os.environ.get("GITHUB_TOKEN")
    if not github_token:
        print("Error: GITHUB_TOKEN environment variable not set")
        sys.exit(1)

    # Set up headers for authenticated requests
    headers = {
        "Authorization": f"token {github_token}",
        "Accept": "application/vnd.github.v3+json",
    }

    # Get all branches (with pagination)
    branches_url = f"{base_url}/repos/{repo_nwo}/branches"
    branches = []
    while branches_url:
        branches_response = requests.get(branches_url, headers=headers)
        if handle_rate_limit(branches_response):
            continue
        branches_response.raise_for_status()
        branches.extend(branches_response.json())
        branches_url = branches_response.links.get("next", {}).get("url")

    # Compile the regex pattern
    pattern = re.compile(regex_pattern)

    # Search file contents in each branch
    for branch in branches:
        branch_name = branch["name"]
        file_url = f"{base_url}/repos/{repo_nwo}/contents/{file_path}?ref={branch_name}"

        while True:
            file_response = requests.get(file_url, headers=headers)

            if file_response.status_code == 200:
                file_content = file_response.json()["content"]

                decoded_content = base64.b64decode(file_content).decode("utf-8")

                if pattern.search(decoded_content):
                    print(f"Match found in branch: {branch_name}!!!!!")
                else:
                    print(f"No match found in branch: {branch_name}")
                break
            elif file_response.status_code == 404:
                print(f"File not found in branch: {branch_name}")
                break
            elif (
                file_response.status_code == 403
                and "X-RateLimit-Remaining" in file_response.headers
            ):
                if int(file_response.headers["X-RateLimit-Remaining"]) == 0:
                    reset_time = int(file_response.headers["X-RateLimit-Reset"])
                    sleep_time = reset_time - int(time.time()) + 1
                    print(f"Rate limit exceeded. Waiting for {sleep_time} seconds.")
                    time.sleep(sleep_time)


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python search_branches.py <repo_nwo> <file_path> <regex_pattern>")
        sys.exit(1)

    repo_nwo = sys.argv[1]
    file_path = sys.argv[2]
    regex_pattern = sys.argv[3]

    print(
        f"Searching branches in {repo_nwo} for {file_path} with pattern {regex_pattern}"
    )
    search_branches(repo_nwo, file_path, regex_pattern)
