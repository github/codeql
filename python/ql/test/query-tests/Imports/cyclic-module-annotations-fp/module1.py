from __future__ import annotations

import dataclasses
import typing

import module2

@dataclasses.dataclass()
class Foo:
    bars: typing.List[module2.Bar]
