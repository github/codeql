import pathlib
import re
from dataclasses import dataclass, field
from typing import List, ClassVar

# taken from https://en.cppreference.com/w/cpp/keyword
cpp_keywords = {"alignas", "alignof", "and", "and_eq", "asm", "atomic_cancel", "atomic_commit", "atomic_noexcept",
                "auto", "bitand", "bitor", "bool", "break", "case", "catch", "char", "char8_t", "char16_t", "char32_t",
                "class", "compl", "concept", "const", "consteval", "constexpr", "constinit", "const_cast", "continue",
                "co_await", "co_return", "co_yield", "decltype", "default", "delete", "do", "double", "dynamic_cast",
                "else", "enum", "explicit", "export", "extern", "false", "float", "for", "friend", "goto", "if",
                "inline", "int", "long", "mutable", "namespace", "new", "noexcept", "not", "not_eq", "nullptr",
                "operator", "or", "or_eq", "private", "protected", "public", "reflexpr", "register", "reinterpret_cast",
                "requires", "return", "short", "signed", "sizeof", "static", "static_assert", "static_cast", "struct",
                "switch", "synchronized", "template", "this", "thread_local", "throw", "true", "try", "typedef",
                "typeid", "typename", "union", "unsigned", "using", "virtual", "void", "volatile", "wchar_t", "while",
                "xor", "xor_eq"}

_field_overrides = [
    (re.compile(r"(start|end)_(line|column)|(.*_)?index|width|num_.*"), {"base_type": "unsigned"}),
    (re.compile(r"(.*)_"), lambda m: {"field_name": m[1]}),
]


def get_field_override(field: str):
    for r, o in _field_overrides:
        m = r.fullmatch(field)
        if m:
            return o(m) if callable(o) else o
    return {}


@dataclass
class Field:
    field_name: str
    base_type: str
    is_optional: bool = False
    is_repeated: bool = False
    is_unordered: bool = False
    is_predicate: bool = False
    trap_name: str = None
    first: bool = False

    def __post_init__(self):
        if self.field_name in cpp_keywords:
            self.field_name += "_"

    @property
    def type(self) -> str:
        type = self.base_type
        if self.is_optional:
            type = f"std::optional<{type}>"
        if self.is_repeated:
            type = f"std::vector<{type}>"
        return type

    # using @property breaks pystache internals here
    def get_streamer(self):
        if self.type == "std::string":
            return lambda x: f"trapQuoted({x})"
        elif self.type == "bool":
            return lambda x: f'({x} ? "true" : "false")'
        else:
            return lambda x: x

    @property
    def is_single(self):
        return not (self.is_optional or self.is_repeated or self.is_predicate)

    @property
    def is_label(self):
        return self.base_type.startswith("TrapLabel<")


@dataclass
class Trap:
    table_name: str
    name: str
    fields: List[Field]
    id: Field = None

    def __post_init__(self):
        assert self.fields
        self.fields[0].first = True


@dataclass
class TagBase:
    base: str
    first: bool = False


@dataclass
class Tag:
    name: str
    bases: List[TagBase]
    id: str

    def __post_init__(self):
        if self.bases:
            self.bases = [TagBase(b) for b in self.bases]
            self.bases[0].first = True

    @property
    def has_bases(self):
        return bool(self.bases)


@dataclass
class TrapList:
    template: ClassVar = 'trap_traps'
    extensions = ["h", "cpp"]
    traps: List[Trap]
    source: str
    trap_library_dir: pathlib.Path
    gen_dir: pathlib.Path


@dataclass
class TagList:
    template: ClassVar = 'trap_tags'
    extensions = ["h"]

    tags: List[Tag]
    source: str


@dataclass
class ClassBase:
    ref: 'Class'
    first: bool = False


@dataclass
class Class:
    name: str
    bases: List[ClassBase] = field(default_factory=list)
    final: bool = False
    fields: List[Field] = field(default_factory=list)
    trap_name: str = None

    def __post_init__(self):
        self.bases = [ClassBase(c) for c in sorted(self.bases, key=lambda cls: cls.name)]
        if self.bases:
            self.bases[0].first = True

    @property
    def has_bases(self):
        return bool(self.bases)

    @property
    def single_fields(self):
        return [f for f in self.fields if f.is_single]


@dataclass
class ClassList:
    template: ClassVar = "cpp_classes"
    extensions: ClassVar = ["h", "cpp"]

    classes: List[Class]
    source: str
    trap_library: str
    include_parent: bool = False
