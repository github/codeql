#!/usr/bin/env python3

# Creates a change note and opens it in VSCode for editing.

# Expects to receive the following arguments:
# - What language the change note is for
# - Whether it's a query or library change (the string `src` or `lib`)
# - The name of the change note (in kebab-case)
# - The category of the change.

# The change note will be created in the `{language}/ql/{subdir}/change-notes` directory, where `subdir` is either `src` or `lib`.

# The format of the change note filename is `{current_date}-{change_note_name}.md` with the date in
# the format `YYYY-MM-DD`.

import sys
import os

# Read the given arguments
language = sys.argv[1]
subdir = sys.argv[2]
change_note_name = sys.argv[3]
change_category = sys.argv[4]

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

# Open the change note file in VSCode, reusing the existing window if possible
os.system(f"code -r {change_note_file}")
