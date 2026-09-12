"""Small TRAP escaping and writing interface for Lua extractor facts."""

from __future__ import annotations

from pathlib import Path
from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class TrapLabel:
    value: str

    def __str__(self) -> str:
        return self.value


class TrapWriter:
    def __init__(self):
        self.lines: list[str] = []
        self.next_id = 1000

    def label(self, text: str | None = None) -> TrapLabel:
        self.next_id += 1
        label = f"#{self.next_id}"
        if text is None:
            self.lines.append(f"{label}=*")
        else:
            self.lines.append(f"{label}=@{self.q(text)}")
        return TrapLabel(label)

    def tuple(self, relation: str, *args: Any) -> None:
        self.lines.append(f"{relation}({','.join(self.arg(a) for a in args)})")

    def arg(self, value: Any) -> str:
        if isinstance(value, int):
            return str(value)
        if isinstance(value, TrapLabel):
            return value.value
        return self.q(str(value))

    def q(self, value: str) -> str:
        escaped = value.replace('"', '""').replace("\n", "\\n")
        return f'"{escaped}"'

    def write(self, path: Path) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text("\n".join(self.lines) + "\n", encoding="utf-8")
