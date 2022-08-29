#!/usr/bin/env python3
# TODO this should probably be split in different generators now: ql, qltest, maybe qlipa

import logging
import pathlib
import re
import subprocess
import typing
import itertools

import inflection
from toposort import toposort_flatten

from swift.codegen.lib import schema, ql

log = logging.getLogger(__name__)


class Error(Exception):
    def __str__(self):
        return self.args[0]


class FormatError(Error):
    pass


class ModifiedStubMarkedAsGeneratedError(Error):
    pass


def get_ql_property(cls: schema.Class, prop: schema.Property) -> ql.Property:
    args = dict(
        type=prop.type if not prop.is_predicate else "predicate",
        qltest_skip="qltest_skip" in prop.pragmas,
        is_child=prop.is_child,
        is_optional=prop.is_optional,
        is_predicate=prop.is_predicate,
    )
    if prop.is_single:
        args.update(
            singular=inflection.camelize(prop.name),
            tablename=inflection.tableize(cls.name),
            tableparams=["this"] + ["result" if p is prop else "_" for p in cls.properties if p.is_single],
        )
    elif prop.is_repeated:
        args.update(
            singular=inflection.singularize(inflection.camelize(prop.name)),
            plural=inflection.pluralize(inflection.camelize(prop.name)),
            tablename=inflection.tableize(f"{cls.name}_{prop.name}"),
            tableparams=["this", "index", "result"],
        )
    elif prop.is_optional:
        args.update(
            singular=inflection.camelize(prop.name),
            tablename=inflection.tableize(f"{cls.name}_{prop.name}"),
            tableparams=["this", "result"],
        )
    elif prop.is_predicate:
        args.update(
            singular=inflection.camelize(prop.name, uppercase_first_letter=False),
            tablename=inflection.underscore(f"{cls.name}_{prop.name}"),
            tableparams=["this"],
        )
    else:
        raise ValueError(f"unknown property kind for {prop.name} from {cls.name}")
    return ql.Property(**args)


def get_ql_class(cls: schema.Class, lookup: typing.Dict[str, schema.Class]):
    pragmas = {k: True for k in cls.pragmas if k.startswith("ql")}
    return ql.Class(
        name=cls.name,
        bases=cls.bases,
        final=not cls.derived,
        properties=[get_ql_property(cls, p) for p in cls.properties],
        dir=cls.dir,
        ipa=bool(cls.ipa),
        **pragmas,
    )


def _to_db_type(x: str) -> str:
    if x[0].isupper():
        return "Raw::" + x
    return x


_final_db_class_lookup = {}


def get_ql_ipa_class_db(name: str) -> ql.Synth.FinalClassDb:
    return _final_db_class_lookup.setdefault(name, ql.Synth.FinalClassDb(name=name,
                                                                         params=[
                                                                             ql.Synth.Param("id", _to_db_type(name))]))


def get_ql_ipa_class(cls: schema.Class):
    if cls.derived:
        return ql.Synth.NonFinalClass(name=cls.name, derived=sorted(cls.derived),
                                      root=(cls.name == schema.root_class_name))
    if cls.ipa and cls.ipa.from_class is not None:
        source = cls.ipa.from_class
        get_ql_ipa_class_db(source).subtract_type(cls.name)
        return ql.Synth.FinalClassDerivedIpa(name=cls.name,
                                             params=[ql.Synth.Param("id", _to_db_type(source))])
    if cls.ipa and cls.ipa.on_arguments is not None:
        return ql.Synth.FinalClassFreshIpa(name=cls.name,
                                           params=[ql.Synth.Param(k, _to_db_type(v))
                                                   for k, v in cls.ipa.on_arguments.items()])
    return get_ql_ipa_class_db(cls.name)


def get_import(file: pathlib.Path, swift_dir: pathlib.Path):
    stem = file.relative_to(swift_dir / "ql/lib").with_suffix("")
    return str(stem).replace("/", ".")


def get_types_used_by(cls: ql.Class):
    for b in cls.bases:
        yield b
    for p in cls.properties:
        yield p.type


def get_classes_used_by(cls: ql.Class):
    return sorted(set(t for t in get_types_used_by(cls) if t[0].isupper()))


_generated_stub_re = re.compile(r"\n*private import .*\n+class \w+ extends \w+ \{[ \n]?\}", re.MULTILINE)


def _is_generated_stub(file: pathlib.Path) -> bool:
    with open(file) as contents:
        for line in contents:
            if not line.startswith("// generated"):
                return False
            break
        else:
            # no lines
            return False
        # we still do not detect modified synth constructors
        if not file.name.endswith("Constructor.qll"):
            # one line already read, if we can read 5 other we are past the normal stub generation
            line_threshold = 5
            first_lines = list(itertools.islice(contents, line_threshold))
            if len(first_lines) == line_threshold or not _generated_stub_re.match("".join(first_lines)):
                raise ModifiedStubMarkedAsGeneratedError(
                    f"{file.name} stub was modified but is still marked as generated")
        return True


def format(codeql, files):
    format_cmd = [codeql, "query", "format", "--in-place", "--"]
    format_cmd.extend(str(f) for f in files if f.suffix in (".qll", ".ql"))
    res = subprocess.run(format_cmd, stderr=subprocess.PIPE, text=True)
    if res.returncode:
        for line in res.stderr.splitlines():
            log.error(line.strip())
        raise FormatError("QL format failed")
    for line in res.stderr.splitlines():
        log.debug(line.strip())


def _get_all_properties(cls: schema.Class, lookup: typing.Dict[str, schema.Class],
                        already_seen: typing.Optional[typing.Set[int]] = None) -> \
        typing.Iterable[typing.Tuple[schema.Class, schema.Property]]:
    # deduplicate using ids
    if already_seen is None:
        already_seen = set()
    for b in sorted(cls.bases):
        base = lookup[b]
        for item in _get_all_properties(base, lookup, already_seen):
            yield item
    for p in cls.properties:
        if id(p) not in already_seen:
            already_seen.add(id(p))
            yield cls, p


def _get_all_properties_to_be_tested(cls: schema.Class, lookup: typing.Dict[str, schema.Class]) -> \
        typing.Iterable[ql.PropertyForTest]:
    for c, p in _get_all_properties(cls, lookup):
        if not ("qltest_skip" in c.pragmas or "qltest_skip" in p.pragmas):
            # TODO here operations are duplicated, but should be better if we split ql and qltest generation
            p = get_ql_property(c, p)
            yield ql.PropertyForTest(p.getter, p.type, p.is_single, p.is_predicate, p.is_repeated)


def _partition_iter(x, pred):
    x1, x2 = itertools.tee(x)
    return filter(pred, x1), itertools.filterfalse(pred, x2)


def _partition(l, pred):
    """ partitions a list according to boolean predicate """
    return map(list, _partition_iter(l, pred))


def _is_in_qltest_collapsed_hierachy(cls: schema.Class, lookup: typing.Dict[str, schema.Class]):
    return "qltest_collapse_hierarchy" in cls.pragmas or _is_under_qltest_collapsed_hierachy(cls, lookup)


def _is_under_qltest_collapsed_hierachy(cls: schema.Class, lookup: typing.Dict[str, schema.Class]):
    return "qltest_uncollapse_hierarchy" not in cls.pragmas and any(
        _is_in_qltest_collapsed_hierachy(lookup[b], lookup) for b in cls.bases)


def _should_skip_qltest(cls: schema.Class, lookup: typing.Dict[str, schema.Class]):
    return "qltest_skip" in cls.pragmas or not (
        cls.final or "qltest_collapse_hierarchy" in cls.pragmas) or _is_under_qltest_collapsed_hierachy(
        cls, lookup)


def generate(opts, renderer):
    input = opts.schema
    out = opts.ql_output
    stub_out = opts.ql_stub_output
    test_out = opts.ql_test_output
    missing_test_source_filename = "MISSING_SOURCE.txt"

    existing = {q for q in out.rglob("*.qll")}
    existing |= {q for q in stub_out.rglob("*.qll") if _is_generated_stub(q)}
    existing |= {q for q in test_out.rglob("*.ql")}
    existing |= {q for q in test_out.rglob(missing_test_source_filename)}

    data = schema.load(input)

    classes = {name: get_ql_class(cls, data.classes) for name, cls in data.classes.items()}
    imports = {}

    inheritance_graph = {name: cls.bases for name, cls in data.classes.items()}
    db_classes = [classes[name] for name in toposort_flatten(inheritance_graph) if not classes[name].ipa]
    renderer.render(ql.DbClasses(db_classes), out / "Raw.qll")

    classes_by_dir_and_name = sorted(classes.values(), key=lambda cls: (cls.dir, cls.name))
    for c in classes_by_dir_and_name:
        imports[c.name] = get_import(stub_out / c.path, opts.swift_dir)

    for c in classes.values():
        qll = out / c.path.with_suffix(".qll")
        c.imports = [imports[t] for t in get_classes_used_by(c)]
        renderer.render(c, qll)
        stub_file = stub_out / c.path.with_suffix(".qll")
        if not stub_file.is_file() or _is_generated_stub(stub_file):
            stub = ql.Stub(
                name=c.name, base_import=get_import(qll, opts.swift_dir))
            renderer.render(stub, stub_file)

    # for example path/to/elements -> path/to/elements.qll
    include_file = stub_out.with_suffix(".qll")
    renderer.render(ql.ImportList(list(imports.values())), include_file)

    renderer.render(ql.GetParentImplementation(classes_by_dir_and_name), out / 'GetImmediateParent.qll')

    for c in data.classes.values():
        if _should_skip_qltest(c, data.classes):
            continue
        test_dir = test_out / c.dir / c.name
        test_dir.mkdir(parents=True, exist_ok=True)
        if not any(test_dir.glob("*.swift")):
            log.warning(f"no test source in {c.dir / c.name}")
            renderer.render(ql.MissingTestInstructions(),
                            test_dir / missing_test_source_filename)
            continue
        total_props, partial_props = _partition(_get_all_properties_to_be_tested(c, data.classes),
                                                lambda p: p.is_single or p.is_predicate)
        renderer.render(ql.ClassTester(class_name=c.name,
                                       properties=total_props), test_dir / f"{c.name}.ql")
        for p in partial_props:
            renderer.render(ql.PropertyTester(class_name=c.name,
                                              property=p), test_dir / f"{c.name}_{p.getter}.ql")

    final_ipa_types = []
    non_final_ipa_types = []
    constructor_imports = []
    ipa_constructor_imports = []
    stubs = {}
    for cls in sorted(data.classes.values(), key=lambda cls: (cls.dir, cls.name)):
        ipa_type = get_ql_ipa_class(cls)
        if ipa_type.is_final:
            final_ipa_types.append(ipa_type)
            if ipa_type.has_params:
                stub_file = stub_out / cls.dir / f"{cls.name}Constructor.qll"
                if not stub_file.is_file() or _is_generated_stub(stub_file):
                    # stub rendering must be postponed as we might not have yet all subtracted ipa types in `ipa_type`
                    stubs[stub_file] = ql.Synth.ConstructorStub(ipa_type)
                constructor_import = get_import(stub_file, opts.swift_dir)
                constructor_imports.append(constructor_import)
                if ipa_type.is_ipa:
                    ipa_constructor_imports.append(constructor_import)
        else:
            non_final_ipa_types.append(ipa_type)

    for stub_file, data in stubs.items():
        renderer.render(data, stub_file)
    renderer.render(ql.Synth.Types(schema.root_class_name, final_ipa_types, non_final_ipa_types), out / "Synth.qll")
    renderer.render(ql.ImportList(constructor_imports), out / "SynthConstructors.qll")
    renderer.render(ql.ImportList(ipa_constructor_imports), out / "PureSynthConstructors.qll")

    renderer.cleanup(existing)
    if opts.ql_format:
        format(opts.codeql_binary, renderer.written)
