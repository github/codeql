#!/usr/bin/env python
import os
import re

def get_requirements(file_path):
    if not file_path:
        return []
    with open(file_path, "r") as requirements_file:
        lines = requirements_file.read().splitlines()
    for line_no, line in enumerate(lines):
        match = re.search("^\\s*-r\\s+([^#]+)", line)
        if match:
            include_file_path = os.path.join(os.path.dirname(file_path), match.group(1).strip())
            include_requirements = get_requirements(include_file_path)
            lines[line_no:line_no+1] = include_requirements
    return lines

def deduplicate(requirements):
    result = []
    seen = set()
    for req in requirements:
        if req in seen:
            continue
        result.append(req)
        seen.add(req)
    return result

def gather(requirement_files):
    requirements = []
    for file in requirement_files:
        requirements += get_requirements(file)
    requirements = deduplicate(requirements)
    print("Requirements:")
    for r in requirements:
        print("    {}".format(r))
    return requirements
