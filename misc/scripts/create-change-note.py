#!/usr/bin/env python3

# Creates a change note and opens it in $EDITOR (or VSCode if the environment
# variable is not set) for editing.

# Expects to receive the following arguments:
# - What language the change note is for
# - Whether it's a query or library change (the string `src` or `lib`)
# - The name of the change note (in kebab-case)
# - The category of the change (see https://github.com/github/codeql/blob/main/docs/change-notes.md#change-categories).

# Alternatively, run without arguments for interactive mode.

# The change note will be created in the `{language}/ql/{subdir}/change-notes` directory, where `subdir` is either `src` or `lib`.

# The format of the change note filename is `{current_date}-{change_note_name}.md` with the date in
# the format `YYYY-MM-DD`.

import sys
import os

LANGUAGES = [
    "actions",
    "cpp",
    "csharp",
    "go",
    "java",
    "javascript",
    "python",
    "ruby",
    "rust",
    "swift",
]

SUBDIRS = {
    "src": "query",
    "lib": "library",
}

CATEGORIES_QUERY = [
    "breaking",
    "deprecated",
    "newQuery",
    "queryMetadata",
    "majorAnalysis",
    "minorAnalysis",
    "fix",
]

CATEGORIES_LIBRARY = [
    "breaking",
    "deprecated",
    "feature",
    "majorAnalysis",
    "minorAnalysis",
    "fix",
]


def is_subsequence(needle: str, haystack: str) -> bool:
    """Check if needle is a subsequence of haystack (case-insensitive)."""
    it = iter(haystack.lower())
    return all(c in it for c in needle.lower())


def pick_option(prompt: str, options: list[str]) -> str:
    """Display options and let the user pick by subsequence match."""
    print(f"\n{prompt}")
    print(f"  Options: {', '.join(options)}")
    while True:
        choice = input("Choice: ").strip()
        if not choice:
            continue
        # Try exact match first
        for o in options:
            if o.lower() == choice.lower():
                return o
        # Try subsequence match
        matches = [o for o in options if is_subsequence(choice, o)]
        if len(matches) == 1:
            return matches[0]
        if len(matches) > 1:
            print(f"  Ambiguous: {', '.join(matches)}")
            continue
        print(f"  No match for '{choice}'. Try again.")


def prompt_string(prompt: str) -> str:
    """Prompt the user for a string value."""
    while True:
        value = input(f"\n{prompt}: ").strip()
        if value:
            return value
        print("Value cannot be empty.")


def interactive_mode() -> tuple[str, str, str, str]:
    """Run interactive mode to gather all required inputs."""
    print("=== Create Change Note (Interactive Mode) ===")

    language = pick_option("Select language:", LANGUAGES)
    subdir = pick_option("Change type:", list(SUBDIRS.keys()))

    change_note_name = prompt_string("Short name (kebab-case)")

    if subdir == "src":
        categories = CATEGORIES_QUERY
    else:
        categories = CATEGORIES_LIBRARY
    change_category = pick_option("Select category:", categories)

    return language, subdir, change_note_name, change_category


# Check if running in interactive mode (no arguments) or with arguments
if len(sys.argv) == 1:
    language, subdir, change_note_name, change_category = interactive_mode()
elif len(sys.argv) == 5:
    language = sys.argv[1]
    subdir = sys.argv[2]
    change_note_name = sys.argv[3]
    change_category = sys.argv[4]
else:
    print("Usage: create-change-note.py [language subdir name category]")
    print("       Run without arguments for interactive mode.")
    sys.exit(1)

# Find the root of the repository. The current script should be located in `misc/scripts`.
root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Go to the repo root
os.chdir(root)

output_dir = f"{language}/ql/{subdir}/change-notes"

# Abort if the output directory doesn't exist
if not os.path.exists(output_dir):
    print(f"Output directory {output_dir} does not exist")
    sys.exit(1)

# Get the current date
import datetime
current_date = datetime.datetime.now().strftime("%Y-%m-%d")

# Create the change note file
change_note_file = f"{output_dir}/{current_date}-{change_note_name}.md"

change_note = f"""
---
category: {change_category}
---
* """.lstrip()

with open(change_note_file, "w") as f:
    f.write(change_note)

editor = os.environ.get('EDITOR', 'code -r')

os.system(f"{editor} {change_note_file}")
