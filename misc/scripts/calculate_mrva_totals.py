import os
import subprocess
import tempfile
import argparse
from collections import defaultdict

help_text = """
To use this script, pass the URL of a GitHub Gist as an argument. The Gist should contain the
exported MarkDown output of a MRVA run.

The script expects the query to produce an output table of the form
```
| header0  | header1  | header2  | header3  | ...
|----------|----------|----------|----------|----
| message1 | value11  | value12  | value13  | ...
| message2 | value21  | value22  | value23  | ...
...
```
The script will calculate the totals for each message and header, and put a table containing these
totals in the `_summary.md` file in the Gist. By default it will then commit and push these changes
to the Gist (having first displayed a diff of the changes).
"""

first_header = ""

def split_line(line):
    return [item.strip() for item in line.strip('|').split('|')]

def parse_markdown_table(stream):
    global first_header
    iterator = (line.strip() for line in stream)

    # Skip irrelevant lines until we find the header line
    for line in iterator:
        if line.startswith('|'):
            first_header, *headers = split_line(line)
            break

    # Skip the separator line
    next(iterator)

    data_dict = {}

    # Process the remaining lines
    for line in iterator:
        if line.startswith('|'):
            message, *values = [value.strip('`') for value in split_line(line)]
            data_dict[message] = {
                headers[i]: int(value) if value.isdigit() else value
                for i, value in enumerate(values)
            }

    return data_dict

def clone_gist(gist_url, repo_dir):
    try:
        subprocess.run(["gh", "gist", "clone", gist_url, repo_dir], check=True)
    except subprocess.CalledProcessError:
        print(f"Failed to clone the gist from {gist_url}")
        subprocess.run(["rm", "-rf", repo_dir])
        exit(1)

def process_gist_files(repo_dir):
    total_data = defaultdict(lambda: defaultdict(int))

    for filename in os.listdir(repo_dir):
        if filename.endswith(".md") and filename != "_summary.md":
            with open(os.path.join(repo_dir, filename), "r") as file:
                data_dict = parse_markdown_table(file)

                for message, values in data_dict.items():
                    for header, value in values.items():
                        if isinstance(value, int):
                            total_data[message][header] += value

    return total_data

def append_totals_to_summary(total_data, repo_dir):
    global first_header
    summary_path = os.path.join(repo_dir, "_summary.md")
    with open(summary_path, "r") as summary_file:
        content = summary_file.read()

    totals_table = "\n\n### Totals\n\n"
    headers = [first_header] + list(next(iter(total_data.values())).keys())
    totals_table += "| " + " | ".join(headers) + " |\n"
    totals_table += "| " + "|".join(["---"] + ["---:"] * (len(headers) - 1)) + " |\n"  # Right align all but the first column
    for message, values in total_data.items():
        row = [message] + [f"{values[header]:,}" for header in headers[1:]]
        totals_table += "| " + " | ".join(row) + " |\n"

    new_content = content.replace("### Summary", totals_table + "\n### Summary")

    with open(summary_path, "w") as summary_file:
        summary_file.write(new_content)

def commit_and_push_changes(repo_dir):
    subprocess.run(["git", "add", "_summary.md"], cwd=repo_dir, check=True)
    subprocess.run(["git", "commit", "-m", "Update summary with totals"], cwd=repo_dir, check=True)
    subprocess.run(["git", "push"], cwd=repo_dir, check=True)

def show_git_diff(repo_dir):
    subprocess.run(["git", "diff", "_summary.md"], cwd=repo_dir, check=True)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calculate MRVA totals from a GitHub Gist", epilog=help_text, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("gist_url", nargs='?', help="URL of the GitHub Gist")
    parser.add_argument("--keep-dir", action="store_true", help="Keep the temporary directory")

    args = parser.parse_args()

    if not args.gist_url:
        parser.print_help()
        exit(1)

    repo_dir = tempfile.mkdtemp(dir=".")
    clone_gist(args.gist_url, repo_dir)

    total_data = process_gist_files(repo_dir)

    append_totals_to_summary(total_data, repo_dir)

    show_git_diff(repo_dir)

    if input("Do you want to push the changes to the gist? (Y/n): ").strip().lower() in ['y', '']:
        commit_and_push_changes(repo_dir)

    if args.keep_dir:
        print(f"Temporary directory retained at: {repo_dir}")
    else:
        subprocess.run(["rm", "-rf", repo_dir])
