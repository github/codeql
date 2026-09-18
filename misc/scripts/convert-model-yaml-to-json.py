#!/usr/bin/env python3

"""Convert YAML data extension files to JSON."""

import argparse
import json
from collections import defaultdict
from pathlib import Path
from typing import Any

from ruamel.yaml import YAML

YAML_PARSER = YAML(typ="rt")
YAML_PARSER.allow_duplicate_keys = False
YAML_PARSER.width = 4096


def load_yaml(path: Path) -> tuple[Any, str]:
    text = path.read_text(encoding="utf-8")
    return YAML_PARSER.load(text), text


def encode_scalar(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, separators=(",", ":"))


def yaml_comment_start(line: str) -> int | None:
    single_quoted = False
    double_quoted = False
    escaped = False
    index = 0
    while index < len(line):
        character = line[index]
        if double_quoted:
            if escaped:
                escaped = False
            elif character == "\\":
                escaped = True
            elif character == '"':
                double_quoted = False
        elif single_quoted:
            if character == "'" and index + 1 < len(line) and line[index + 1] == "'":
                index += 1
            elif character == "'":
                single_quoted = False
        elif character == '"':
            double_quoted = True
        elif character == "'":
            single_quoted = True
        elif character == "#" and (index == 0 or line[index - 1].isspace()):
            return index
        index += 1
    return None


def node_anchors(
    value: Any, path: tuple[Any, ...] = ()
) -> list[tuple[int, tuple[Any, ...]]]:
    anchors = []
    if path == () and hasattr(value, "lc"):
        anchors.append((value.lc.line, path))
    if isinstance(value, dict):
        for key, child in value.items():
            child_path = path + (key,)
            anchors.append((value.lc.key(key)[0], child_path))
            anchors.extend(node_anchors(child, child_path))
    elif isinstance(value, list):
        for index, child in enumerate(value):
            child_path = path + (index,)
            anchors.append((value.lc.item(index)[0], child_path))
            if not path or path[-1] != "data":
                anchors.extend(node_anchors(child, child_path))
    return anchors


def associate_comments(
    value: Any, source: str
) -> tuple[
    dict[tuple[Any, ...], list[str]],
    dict[tuple[Any, ...], str],
    list[str],
]:
    anchors_by_line: dict[int, set[tuple[Any, ...]]] = defaultdict(set)
    for line, path in node_anchors(value):
        anchors_by_line[line].add(path)

    pre_comments: dict[tuple[Any, ...], list[str]] = defaultdict(list)
    inline_comments: dict[tuple[Any, ...], str] = {}
    trailing_comments: list[str] = []
    pending: list[str] = []

    for line_number, line in enumerate(source.splitlines()):
        comment_start = yaml_comment_start(line)
        if comment_start is None:
            continue
        comment = line[comment_start + 1 :].strip()
        if line[:comment_start].strip():
            candidates = anchors_by_line.get(line_number)
            if candidates:
                path = min(
                    candidates, key=lambda candidate: (len(candidate), repr(candidate))
                )
                inline_comments[path] = comment
        else:
            pending.append(comment)
            later_lines = [
                anchor_line
                for anchor_line in anchors_by_line
                if anchor_line > line_number
            ]
            if later_lines:
                next_line = min(later_lines)
                path = min(
                    anchors_by_line[next_line],
                    key=lambda candidate: (len(candidate), repr(candidate)),
                )
                pre_comments[path].extend(pending)
                pending = []

    trailing_comments.extend(pending)
    return pre_comments, inline_comments, trailing_comments


def format_json(
    value: Any,
    pre_comments: dict[tuple[Any, ...], list[str]],
    inline_comments: dict[tuple[Any, ...], str],
    level: int = 0,
    inline_rows: bool = False,
    path: tuple[Any, ...] = (),
) -> str:
    indent = "  " * level
    child_indent = "  " * (level + 1)

    if not isinstance(value, (dict, list)):
        return encode_scalar(value)

    if isinstance(value, dict):
        if not value:
            return "{}"
        entries = []
        items = list(value.items())
        for index, (key, child) in enumerate(items):
            child_path = path + (key,)
            encoded_key = json.dumps(key, ensure_ascii=False)
            encoded_child = format_json(
                child,
                pre_comments,
                inline_comments,
                level + 1,
                inline_rows=(key == "data"),
                path=child_path,
            )
            entry = f"{child_indent}{encoded_key}: {encoded_child}"
            if index + 1 < len(items):
                entry += ","
            if comment := inline_comments.get(child_path):
                entry += f" // {comment}"
            comment_lines = [
                f"{child_indent}// {comment}".rstrip()
                for comment in pre_comments.get(child_path, [])
            ]
            entries.append("\n".join(comment_lines + [entry]))
        return "{\n" + "\n".join(entries) + f"\n{indent}}}"

    if not value:
        return "[]"
    if inline_rows:
        entries = []
        for index, row in enumerate(value):
            child_path = path + (index,)
            entry = (
                f"{child_indent}"
                f"{json.dumps(row, ensure_ascii=False, separators=(', ', ': '))}"
            )
            if index + 1 < len(value):
                entry += ","
            if comment := inline_comments.get(child_path):
                entry += f" // {comment}"
            comment_lines = [
                f"{child_indent}// {comment}".rstrip()
                for comment in pre_comments.get(child_path, [])
            ]
            entries.append("\n".join(comment_lines + [entry]))
        return "[\n" + "\n".join(entries) + f"\n{indent}]"

    entries = []
    for index, child in enumerate(value):
        child_path = path + (index,)
        entry = (
            f"{child_indent}"
            f"{format_json(child, pre_comments, inline_comments, level + 1, path=child_path)}"
        )
        if index + 1 < len(value):
            entry += ","
        if comment := inline_comments.get(child_path):
            entry += f" // {comment}"
        comment_lines = [
            f"{child_indent}// {comment}".rstrip()
            for comment in pre_comments.get(child_path, [])
        ]
        entries.append("\n".join(comment_lines + [entry]))
    return "[\n" + "\n".join(entries) + f"\n{indent}]"


def format_json_with_comments(value: Any, source: str) -> str:
    pre_comments, inline_comments, trailing_comments = associate_comments(value, source)
    lines = [f"// {comment}".rstrip() for comment in pre_comments.pop((), [])]
    lines.append(format_json(value, pre_comments, inline_comments))
    lines.extend(f"// {comment}".rstrip() for comment in trailing_comments)
    return "\n".join(lines)


def write_text_atomically(path: Path, contents: str) -> None:
    temporary = path.with_name(f".{path.name}.tmp")
    try:
        temporary.write_text(contents, encoding="utf-8")
        temporary.replace(path)
    finally:
        temporary.unlink(missing_ok=True)


def convert_data_extension(source: Path) -> Path:
    target = source.with_suffix(".json")
    model, source_text = load_yaml(source)
    write_text_atomically(target, format_json_with_comments(model, source_text) + "\n")
    source.unlink()
    return target


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "files",
        metavar="YAML_FILE",
        nargs="+",
        type=Path,
        help="YAML data extension file to convert",
    )
    args = parser.parse_args()

    for file in args.files:
        file = file.expanduser().resolve()
        if not file.is_file():
            raise ValueError(f"YAML file does not exist: {file}")
        if file.suffix not in {".yml", ".yaml"}:
            raise ValueError(f"not a YAML file: {file}")
        convert_data_extension(file)

    print(f"Converted {len(args.files)} data extensions.", flush=True)


if __name__ == "__main__":
    main()
