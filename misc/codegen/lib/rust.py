import dataclasses
import re
import typing

# taken from https://doc.rust-lang.org/reference/keywords.html
keywords = {
    "as",
    "break",
    "const",
    "continue",
    "crate",
    "else",
    "enum",
    "extern",
    "false",
    "fn",
    "for",
    "if",
    "impl",
    "in",
    "let",
    "loop",
    "match",
    "mod",
    "move",
    "mut",
    "pub",
    "ref",
    "return",
    "self",
    "Self",
    "static",
    "struct",
    "super",
    "trait",
    "true",
    "type",
    "unsafe",
    "use",
    "where",
    "while",
    "async",
    "await",
    "dyn",
    "abstract",
    "become",
    "box",
    "do",
    "final",
    "macro",
    "override",
    "priv",
    "typeof",
    "unsized",
    "virtual",
    "yield",
    "try",
}

_field_overrides = [
    (
        re.compile(r"(start|end)_(line|column)|(.*_)?index|width|num_.*"),
        {"base_type": "usize"},
    ),
    (re.compile(r"(.*)_"), lambda m: {"field_name": m[1]}),
]


def get_field_override(field: str):
    for r, o in _field_overrides:
        m = r.fullmatch(field)
        if m:
            return o(m) if callable(o) else o
    return {}


@dataclasses.dataclass
class Field:
    field_name: str
    base_type: str
    table_name: str = None
    is_optional: bool = False
    is_repeated: bool = False
    is_unordered: bool = False
    is_predicate: bool = False
    first: bool = False

    def __post_init__(self):
        if self.field_name in keywords:
            self.field_name += "_"

    @property
    def type(self) -> str:
        type = self.base_type
        if self.is_optional:
            type = f"Option<{type}>"
        if self.is_repeated:
            type = f"Vec<{type}>"
        return type

    # using @property breaks pystache internals here
    def emitter(self):
        if self.type == "String":
            return lambda x: f"quoted(&{x})"
        else:
            return lambda x: x

    @property
    def is_single(self):
        return not (self.is_optional or self.is_repeated or self.is_predicate)

    @property
    def is_label(self):
        return self.base_type == "TrapLabel"


@dataclasses.dataclass
class Class:
    name: str
    table_name: str
    fields: list[Field] = dataclasses.field(default_factory=list)

    @property
    def single_fields(self):
        return [f for f in self.fields if f.is_single]


@dataclasses.dataclass
class ClassList:
    template: typing.ClassVar[str] = "rust_classes"

    classes: list[Class]
    source: str


@dataclasses.dataclass
class ModuleList:
    template: typing.ClassVar[str] = "rust_module"

    modules: list[str]
    source: str
