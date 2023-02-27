"""
QL files generation

`generate(opts, renderer)` will generate QL classes and manage stub files out of a `yml` schema file.

Each class (for example, `Foo`) in the schema triggers:
* generation of a `FooBase` class implementation translating all properties into appropriate getters
* if not created or already customized, generation of a stub file which defines `Foo` as extending `FooBase`. This can
  be used to add hand-written code to `Foo`, which requires removal of the `// generated` header comment in that file.
  All generated base classes actually import these customizations when referencing other classes.
Generated files that do not correspond any more to any class in the schema are deleted. Customized stubs are however
left behind and must be dealt with by hand.
"""

import pathlib
from dataclasses import dataclass, field
import itertools
from typing import List, ClassVar, Union, Optional

import inflection


@dataclass
class Param:
    param: str
    first: bool = False


@dataclass
class Property:
    singular: str
    type: Optional[str] = None
    tablename: Optional[str] = None
    tableparams: List[Param] = field(default_factory=list)
    plural: Optional[str] = None
    first: bool = False
    is_optional: bool = False
    is_predicate: bool = False
    prev_child: Optional[str] = None
    qltest_skip: bool = False
    description: List[str] = field(default_factory=list)
    doc: Optional[str] = None
    doc_plural: Optional[str] = None

    def __post_init__(self):
        if self.tableparams:
            self.tableparams = [Param(x) for x in self.tableparams]
            self.tableparams[0].first = True

    @property
    def getter(self):
        return f"get{self.singular}" if not self.is_predicate else self.singular

    @property
    def indefinite_getter(self):
        if self.plural:
            article = "An" if self.singular[0] in "AEIO" else "A"
            return f"get{article}{self.singular}"

    @property
    def type_is_class(self):
        return bool(self.type) and self.type[0].isupper()

    @property
    def is_repeated(self):
        return bool(self.plural)

    @property
    def is_single(self):
        return not (self.is_optional or self.is_repeated or self.is_predicate)

    @property
    def is_child(self):
        return self.prev_child is not None

    @property
    def has_description(self) -> bool:
        return bool(self.description)


@dataclass
class Base:
    base: str
    prev: str = ""

    def __str__(self):
        return self.base


@dataclass
class Class:
    template: ClassVar = 'ql_class'

    name: str
    bases: List[Base] = field(default_factory=list)
    final: bool = False
    properties: List[Property] = field(default_factory=list)
    dir: pathlib.Path = pathlib.Path()
    imports: List[str] = field(default_factory=list)
    import_prefix: Optional[str] = None
    qltest_skip: bool = False
    qltest_collapse_hierarchy: bool = False
    qltest_uncollapse_hierarchy: bool = False
    ql_internal: bool = False
    ipa: bool = False
    doc: List[str] = field(default_factory=list)

    def __post_init__(self):
        self.bases = [Base(str(b), str(prev)) for b, prev in zip(self.bases, itertools.chain([""], self.bases))]
        if self.properties:
            self.properties[0].first = True

    @property
    def root(self) -> bool:
        return not self.bases

    @property
    def path(self) -> pathlib.Path:
        return self.dir / self.name

    @property
    def db_id(self) -> str:
        return "@" + inflection.underscore(self.name)

    @property
    def has_children(self) -> bool:
        return any(p.is_child for p in self.properties)

    @property
    def last_base(self) -> str:
        return self.bases[-1].base if self.bases else ""

    @property
    def has_doc(self) -> bool:
        return bool(self.doc) or self.ql_internal


@dataclass
class IpaUnderlyingAccessor:
    argument: str
    type: str
    constructorparams: List[Param]

    def __post_init__(self):
        if self.constructorparams:
            self.constructorparams = [Param(x) for x in self.constructorparams]
            self.constructorparams[0].first = True


@dataclass
class Stub:
    template: ClassVar = 'ql_stub'

    name: str
    base_import: str
    import_prefix: str
    ipa_accessors: List[IpaUnderlyingAccessor] = field(default_factory=list)

    @property
    def has_ipa_accessors(self) -> bool:
        return bool(self.ipa_accessors)


@dataclass
class DbClasses:
    template: ClassVar = 'ql_db'

    classes: List[Class] = field(default_factory=list)


@dataclass
class ImportList:
    template: ClassVar = 'ql_imports'

    imports: List[str] = field(default_factory=list)


@dataclass
class GetParentImplementation:
    template: ClassVar = 'ql_parent'

    classes: List[Class] = field(default_factory=list)
    imports: List[str] = field(default_factory=list)


@dataclass
class PropertyForTest:
    getter: str
    is_total: bool = True
    type: Optional[str] = None
    is_repeated: bool = False


@dataclass
class TesterBase:
    class_name: str
    elements_module: str


@dataclass
class ClassTester(TesterBase):
    template: ClassVar = 'ql_test_class'

    properties: List[PropertyForTest] = field(default_factory=list)
    show_ql_class: bool = False


@dataclass
class PropertyTester(TesterBase):
    template: ClassVar = 'ql_test_property'

    property: PropertyForTest


@dataclass
class MissingTestInstructions:
    template: ClassVar = 'ql_test_missing'


class Synth:
    @dataclass
    class Class:
        is_final: ClassVar = False

        name: str
        first: bool = False

    @dataclass
    class Param:
        param: str
        type: str
        first: bool = False

    @dataclass
    class FinalClass(Class):
        is_final: ClassVar = True
        is_derived_ipa: ClassVar = False
        is_fresh_ipa: ClassVar = False
        is_db: ClassVar = False

        params: List["Synth.Param"] = field(default_factory=list)

        def __post_init__(self):
            if self.params:
                self.params[0].first = True

        @property
        def is_ipa(self):
            return self.is_fresh_ipa or self.is_derived_ipa

        @property
        def has_params(self) -> bool:
            return bool(self.params)

    @dataclass
    class FinalClassIpa(FinalClass):
        pass

    @dataclass
    class FinalClassDerivedIpa(FinalClassIpa):
        is_derived_ipa: ClassVar = True

    @dataclass
    class FinalClassFreshIpa(FinalClassIpa):
        is_fresh_ipa: ClassVar = True

    @dataclass
    class FinalClassDb(FinalClass):
        is_db: ClassVar = True

        subtracted_ipa_types: List["Synth.Class"] = field(default_factory=list)

        def subtract_type(self, type: str):
            self.subtracted_ipa_types.append(Synth.Class(type, first=not self.subtracted_ipa_types))

        @property
        def has_subtracted_ipa_types(self) -> bool:
            return bool(self.subtracted_ipa_types)

        @property
        def db_id(self) -> str:
            return "@" + inflection.underscore(self.name)

    @dataclass
    class NonFinalClass(Class):
        derived: List["Synth.Class"] = field(default_factory=list)
        root: bool = False

        def __post_init__(self):
            self.derived = [Synth.Class(c) for c in self.derived]
            if self.derived:
                self.derived[0].first = True

    @dataclass
    class Types:
        template: ClassVar = "ql_ipa_types"

        root: str
        import_prefix: str
        final_classes: List["Synth.FinalClass"] = field(default_factory=list)
        non_final_classes: List["Synth.NonFinalClass"] = field(default_factory=list)

        def __post_init__(self):
            if self.final_classes:
                self.final_classes[0].first = True

    @dataclass
    class ConstructorStub:
        template: ClassVar = "ql_ipa_constructor_stub"

        cls: "Synth.FinalClass"
        import_prefix: str
