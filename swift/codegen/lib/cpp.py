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


@dataclass
class Field:
    name: str
    type: str
    first: bool = False

    @property
    def cpp_name(self):
        if self.name in cpp_keywords:
            return self.name + "_"
        return self.name

    # using @property breaks pystache internals here
    def get_streamer(self):
        if self.type == "std::string":
            return lambda x: f"trapQuoted({x})"
        elif self.type == "bool":
            return lambda x: f'({x} ? "true" : "false")'
        else:
            return lambda x: x


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
    index: int
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
    template: ClassVar = 'cpp_traps'

    traps: List[Trap] = field(default_factory=list)


@dataclass
class TagList:
    template: ClassVar = 'cpp_tags'

    tags: List[Tag] = field(default_factory=list)
