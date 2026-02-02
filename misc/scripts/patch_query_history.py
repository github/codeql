#!/usr/bin/env python3
"""Duplicate the last CodeQL query history entry, pointing it at a given evaluator log.

Behavior:
1. Locate the most relevant ``workspace-query-history.json`` (supports local & remote VS Code).
2. Duplicate the final object in ``queries``.
3. Generate a fresh random ID and a new timestamp.
4. Set ``jsonEvalLogSummaryLocation`` to the provided summary file path.
5. Set ``initialInfo.userSpecifiedLabel`` to ``Evaluator log at <dir>/<filename>`` (last 2 path parts).
6. Write back atomically.

Usage: python3 misc/scripts/patch_query_history.py /path/to/evaluator-log.summary.jsonl
"""
from __future__ import annotations
import argparse
import json, os, random, string, tempfile, sys
from pathlib import Path
from typing import List
from datetime import datetime, timezone
import copy


# Extension folder segment for CodeQL extension query history
EXT_SEGMENT = "GitHub.vscode-codeql"
HISTORY_FILENAME = "workspace-query-history.json"
WORKSPACE_JSON = "workspace.json"

def candidate_user_data_dirs() -> List[Path]:
    """Return plausible VS Code user data dirs (ordered, deduped)."""
    home = Path.home()
    env = os.environ
    override = env.get("VSCODE_USER_DATA_DIR")
    bases: List[Path] = []
    if override:
        bases.append(Path(override).expanduser())
    if os.name == "nt":
        appdata = env.get("APPDATA")
        if appdata:
            bases.append(Path(appdata) / "Code" / "User")
    elif sys.platform == "darwin":  # macOS inline check
        bases.append(home / "Library" / "Application Support" / "Code" / "User")
    else:
        bases.append(home / ".config" / "Code" / "User")
    # Remote / server variants
    bases.extend([
        home / ".vscode-remote" / "data" / "User",
        home / ".vscode-server" / "data" / "User",
        home / ".vscode" / "data" / "User",
    ])
    seen: set[Path] = set()
    ordered: List[Path] = []
    for b in bases:
        if b not in seen:
            seen.add(b)
            ordered.append(b)
    return ordered


def find_history_files() -> List[Path]:
    """Return all candidate history files sorted by descending modification time.
    """
    candidates: List[Path] = []
    for base in candidate_user_data_dirs():
        storage_root = base / "workspaceStorage"
        if not storage_root.is_dir():
            continue
        for ws_entry in storage_root.iterdir():
            if not ws_entry.is_dir():
                continue
            history_file = ws_entry / EXT_SEGMENT / HISTORY_FILENAME
            if history_file.is_file():
                candidates.append(history_file)
    candidates.sort(key=lambda p: p.stat().st_mtime, reverse=True)
    return candidates

def _generate_new_id() -> str:
    """Return a new random id (24 chars from allowed set, prefixed with 'evaluator-log-' for stability)."""
    alphabet = string.ascii_letters + string.digits + "_-"
    return "evaluator-log-" + "".join(random.choice(alphabet) for _ in range(23))

def atomic_write_json(target: Path, obj) -> None:
    fd, tmp = tempfile.mkstemp(dir=str(target.parent), prefix="history.", suffix=".json")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as out:
            json.dump(obj, out, ensure_ascii=False, indent=2)
            out.write("\n")
        os.replace(tmp, target)
    finally:
        if os.path.exists(tmp):
            try:
                os.remove(tmp)
            except OSError:
                pass

def _duplicate_last_entry(path: Path, summary_path: Path) -> dict:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        raise SystemExit(f"History file JSON is corrupt: {e}")
    if not isinstance(data, dict) or not isinstance(data.get("queries"), list):
        raise SystemExit("Unexpected history file structure: missing 'queries' list")
    queries = data["queries"]
    if not queries:
        raise SystemExit("History file contains no queries to duplicate. Please run a query in VSCode and try again.")
    last = queries[-1]
    if not isinstance(last, dict):
        raise SystemExit("Last query entry malformed")
    payload = copy.deepcopy(last)
    initial = payload.setdefault("initialInfo", {})
    if not isinstance(initial, dict):
        initial = {}
        payload["initialInfo"] = initial
    new_id = _generate_new_id()
    initial["id"] = new_id
    initial["start"] = datetime.now(timezone.utc).isoformat(timespec="milliseconds").replace("+00:00", "Z")
    payload["jsonEvalLogSummaryLocation"] = str(summary_path)
    parts = list(summary_path.parts)
    last_two = "/".join(parts[-2:]) if len(parts) >= 2 else parts[-1]
    new_label = f"Evaluator log at {last_two}"
    initial["userSpecifiedLabel"] = new_label
    queries.append(payload)
    atomic_write_json(path, data)
    return {"new_id": new_id, "new_label": new_label, "count": len(queries)}

def main() -> int:
    parser = argparse.ArgumentParser(description="Duplicate last CodeQL query history entry, patching summary location and label.")
    parser.add_argument("summary_path", type=Path, help="Path to evaluator-log.summary.jsonl file (required).")
    args = parser.parse_args()

    summary_path: Path = args.summary_path
    if not summary_path.is_file():
        raise SystemExit(f"Summary file does not exist: {summary_path}")

    candidates = find_history_files()
    if not candidates:
        raise SystemExit("No workspace-query-history.json files found.")
    best = candidates[0]

    result = _duplicate_last_entry(best, summary_path)

    print(f"Patched history: {best}")
    print(f"Evaluator log summary: {summary_path}")
    print(f"New ID: {result['new_id']}")
    print(f"Label: {result['new_label']}")
    print(f"Total entries: {result['count']}")

if __name__ == "__main__":
    raise SystemExit(main())
