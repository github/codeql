import dataclasses
import typing

import module4

@dataclasses.dataclass()
class Foo:
    bars: typing.List[module4.Bar]
