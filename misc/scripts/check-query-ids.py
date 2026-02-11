#!/usr/bin/env python3

from pathlib import Path
import re
import sys
from typing import Dict, List, Optional

ID = re.compile(r" +\* +@id\s*(.*)")

def get_query_id(query_path: Path) -> Optional[str]:
    with open(query_path) as f:
        for line in f:
            m = ID.match(line)
            if m:
                return m.group(1)
        return None

def main():
    # Map query IDs to paths of queries with those IDs. We want to check that this is a 1:1 map.
    query_ids: Dict[str, List[str]] = {}

    # Just check src folders for now to avoid churn
    for query_path in Path().glob("**/src/**/*.ql"):
        # Skip compiled query packs
        if any(p == ".codeql" for p in query_path.parts):
            continue
        query_id = get_query_id(query_path)
        if query_id is not None:
            query_ids.setdefault(query_id, []).append(str(query_path))

    fail = False
    for query_id, query_paths in query_ids.items():
        if len(query_paths) > 1:
            fail = True
            print(f"Query ID {query_id} is used in multiple queries:")
            for query_path in query_paths:
                print(f" - {query_path}")

    if fail:
        print("FAIL: duplicate query IDs found in src folders. Please assign these queries unique IDs.")
        sys.exit(1)
    else:
        print("PASS: no duplicate query IDs found in src folders.")

if __name__ == "__main__":
    main()
