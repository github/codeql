from __future__ import annotations

import dataclasses
import typing

import module1

@dataclasses.dataclass()
class Bar:
    def is_in_foo(self, foo: module1.Foo):
        return self in foo.bars
