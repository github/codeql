import dataclasses
import re
import typing
import inflection

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


def avoid_keywords(s: str) -> str:
    return s + "_" if s in keywords else s


_field_overrides = [
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
    table_name: str
    is_optional: bool = False
    is_repeated: bool = False
    is_unordered: bool = False
    is_predicate: bool = False
    first: bool = False

    def __post_init__(self):
        self.field_name = avoid_keywords(self.field_name)

    @property
    def type(self) -> str:
        type = self.base_type
        if self.is_optional:
            type = f"Option<{type}>"
        if self.is_repeated:
            type = f"Vec<{type}>"
        return type

    @property
    def is_single(self):
        return not (self.is_optional or self.is_repeated or self.is_predicate)

    @property
    def is_label(self):
        return self.base_type == "trap::Label"

    @property
    def singular_field_name(self) -> str:
        return inflection.singularize(self.field_name.rstrip("_"))


@dataclasses.dataclass
class Class:
    name: str
    entry_table: str | None = None
    fields: list[Field] = dataclasses.field(default_factory=list)
    detached_fields: list[Field] = dataclasses.field(default_factory=list)
    ancestors: list[str] = dataclasses.field(default_factory=list)

    @property
    def is_entry(self) -> bool:
        return bool(self.entry_table)

    @property
    def single_field_entries(self) -> dict[str, list[dict]]:
        ret = {}
        if self.is_entry:
            ret[self.entry_table] = []
        for f in self.fields:
            if f.is_single:
                ret.setdefault(f.table_name, []).append(f)
        return [{"table_name": k, "fields": v} for k, v in ret.items()]

    @property
    def has_detached_fields(self) -> bool:
        return bool(self.detached_fields)


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
