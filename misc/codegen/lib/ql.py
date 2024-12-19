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
    is_unordered: bool = False
    prev_child: Optional[str] = None
    qltest_skip: bool = False
    description: List[str] = field(default_factory=list)
    doc: Optional[str] = None
    doc_plural: Optional[str] = None
    synth: bool = False
    type_is_hideable: bool = False
    type_is_codegen_class: bool = False
    internal: bool = False
    cfg: bool = False

    def __post_init__(self):
        if self.tableparams:
            self.tableparams = [Param(x) for x in self.tableparams]
            self.tableparams[0].first = True

    @property
    def getter(self):
        if self.is_predicate:
            return self.singular
        if self.is_unordered:
            return self.indefinite_getter
        return f"get{self.singular}"

    @property
    def indefinite_getter(self):
        if self.plural:
            article = "An" if self.singular[0] in "AEIO" else "A"
            return f"get{article}{self.singular}"

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
    def is_indexed(self) -> bool:
        return self.is_repeated and not self.is_unordered


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
    bases_impl: List[Base] = field(default_factory=list)
    final: bool = False
    properties: List[Property] = field(default_factory=list)
    dir: pathlib.Path = pathlib.Path()
    imports: List[str] = field(default_factory=list)
    import_prefix: Optional[str] = None
    internal: bool = False
    doc: List[str] = field(default_factory=list)
    hideable: bool = False
    cfg: bool = False

    def __post_init__(self):
        def get_bases(bases): return [Base(str(b), str(prev)) for b, prev in zip(bases, itertools.chain([""], bases))]
        self.bases = get_bases(self.bases)
        self.bases_impl = get_bases(self.bases_impl)
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


@dataclass
class SynthUnderlyingAccessor:
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
    synth_accessors: List[SynthUnderlyingAccessor] = field(default_factory=list)
    doc: List[str] = field(default_factory=list)

    @property
    def has_synth_accessors(self) -> bool:
        return bool(self.synth_accessors)

    @property
    def has_qldoc(self) -> bool:
        return bool(self.doc)


@dataclass
class ClassPublic:
    template: ClassVar = 'ql_class_public'

    name: str
    imports: List[str] = field(default_factory=list)
    internal: bool = False
    doc: List[str] = field(default_factory=list)

    @property
    def has_qldoc(self) -> bool:
        return bool(self.doc) or self.internal


@dataclass
class DbClasses:
    template: ClassVar = 'ql_db'

    classes: List[Class] = field(default_factory=list)
    imports: List[str] = field(default_factory=list)


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
    is_indexed: bool = False


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
        is_derived_synth: ClassVar = False
        is_fresh_synth: ClassVar = False
        is_db: ClassVar = False

        params: List["Synth.Param"] = field(default_factory=list)

        def __post_init__(self):
            if self.params:
                self.params[0].first = True

        @property
        def is_synth(self):
            return self.is_fresh_synth or self.is_derived_synth

        @property
        def has_params(self) -> bool:
            return bool(self.params)

    @dataclass
    class FinalClassSynth(FinalClass):
        pass

    @dataclass
    class FinalClassDerivedSynth(FinalClassSynth):
        is_derived_synth: ClassVar = True

    @dataclass
    class FinalClassFreshSynth(FinalClassSynth):
        is_fresh_synth: ClassVar = True

    @dataclass
    class FinalClassDb(FinalClass):
        is_db: ClassVar = True

        subtracted_synth_types: List["Synth.Class"] = field(default_factory=list)

        def subtract_type(self, type: str):
            self.subtracted_synth_types.append(Synth.Class(type, first=not self.subtracted_synth_types))

        @property
        def has_subtracted_synth_types(self) -> bool:
            return bool(self.subtracted_synth_types)

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
        template: ClassVar = "ql_synth_types"

        root: str
        import_prefix: str
        final_classes: List["Synth.FinalClass"] = field(default_factory=list)
        non_final_classes: List["Synth.NonFinalClass"] = field(default_factory=list)

        def __post_init__(self):
            if self.final_classes:
                self.final_classes[0].first = True

    @dataclass
    class ConstructorStub:
        template: ClassVar = "ql_synth_constructor_stub"

        cls: "Synth.FinalClass"
        import_prefix: str


@dataclass
class CfgClass:
    name: str
    bases: List[Base] = field(default_factory=list)
    properties: List[Property] = field(default_factory=list)
    doc: List[str] = field(default_factory=list)


@dataclass
class CfgClasses:
    template: ClassVar = 'ql_cfg_nodes'
    include_file_import: Optional[str] = None
    classes: List[CfgClass] = field(default_factory=list)
