import dataclasses
import typing

import module3

@dataclasses.dataclass()
class Bar:
    def is_in_foo(self, foo: module3.Foo):
        return self in foo.bars
