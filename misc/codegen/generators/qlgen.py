"""
QL code generation

`generate(opts, renderer)` will generate in the library directory:
 * generated/Raw.qll with thin class wrappers around DB types
 * generated/Synth.qll with the base algebraic datatypes for AST entities
 * generated/<group>/<Class>.qll with generated properties for each class
 * if not already modified, a elements/<group>/<Class>.qll stub to customize the above classes
 * elements.qll importing all the above stubs
 * if not already modified, a elements/<group>/<Class>Constructor.qll stub to customize the algebraic datatype
   characteristic predicate
 * generated/SynthConstructors.qll importing all the above constructor stubs
 * generated/PureSynthConstructors.qll importing constructor stubs for pure synthesized types (that is, not
   corresponding to raw types)
Moreover in the test directory for each <Class> in <group> it will generate beneath the
extractor-tests/generated/<group>/<Class> directory either
 * a `MISSING_SOURCE.txt` explanation file if no source is present, or
 * one `<Class>.ql` test query for all single properties and on `<Class>_<property>.ql` test query for each optional or
   repeated property
"""
# TODO this should probably be split in different generators now: ql, qltest, maybe qlsynth

import logging
import pathlib
import re
import subprocess
import typing
import itertools

import inflection

from misc.codegen.lib import schema, ql
from misc.codegen.loaders import schemaloader

log = logging.getLogger(__name__)


class Error(Exception):
    def __str__(self):
        return self.args[0]


class FormatError(Error):
    pass


class RootElementHasChildren(Error):
    pass


class NoClasses(Error):
    pass


abbreviations = {
    "expr": "expression",
    "arg": "argument",
    "stmt": "statement",
    "decl": "declaration",
    "repr": "representation",
    "param": "parameter",
    "int": "integer",
    "var": "variable",
    "ref": "reference",
}

abbreviations.update({f"{k}s": f"{v}s" for k, v in abbreviations.items()})

_abbreviations_re = re.compile("|".join(fr"\b{abbr}\b" for abbr in abbreviations))


def _humanize(s: str) -> str:
    ret = inflection.humanize(s)
    ret = ret[0].lower() + ret[1:]
    ret = _abbreviations_re.sub(lambda m: abbreviations[m[0]], ret)
    return ret


_format_re = re.compile(r"\{(\w+)\}")


def _get_doc(cls: schema.Class, prop: schema.Property, plural=None):
    if prop.doc:
        if plural is None:
            # for consistency, ignore format in non repeated properties
            return _format_re.sub(lambda m: m[1], prop.doc)
        format = prop.doc
        nouns = [m[1] for m in _format_re.finditer(prop.doc)]
        if not nouns:
            noun, _, rest = prop.doc.partition(" ")
            format = f"{{{noun}}} {rest}"
            nouns = [noun]
        transform = inflection.pluralize if plural else inflection.singularize
        return format.format(**{noun: transform(noun) for noun in nouns})

    prop_name = _humanize(prop.name)
    class_name = cls.default_doc_name or _humanize(inflection.underscore(cls.name))
    if prop.is_predicate:
        return f"this {class_name} {prop_name}"
    if plural is not None:
        prop_name = inflection.pluralize(prop_name) if plural else inflection.singularize(prop_name)
    return f"{prop_name} of this {class_name}"


def get_ql_property(cls: schema.Class, prop: schema.Property, lookup: typing.Dict[str, schema.Class], prev_child: str = "") -> ql.Property:
    args = dict(
        type=prop.type if not prop.is_predicate else "predicate",
        qltest_skip="qltest_skip" in prop.pragmas,
        prev_child=prev_child if prop.is_child else None,
        is_optional=prop.is_optional,
        is_predicate=prop.is_predicate,
        is_unordered=prop.is_unordered,
        description=prop.description,
        synth=bool(cls.synth) or prop.synth,
        type_is_hideable=lookup[prop.type].hideable if prop.type in lookup else False,
    )
    if prop.is_single:
        args.update(
            singular=inflection.camelize(prop.name),
            tablename=inflection.tableize(cls.name),
            tableparams=["this"] + ["result" if p is prop else "_" for p in cls.properties if p.is_single],
            doc=_get_doc(cls, prop),
        )
    elif prop.is_repeated:
        args.update(
            singular=inflection.singularize(inflection.camelize(prop.name)),
            plural=inflection.pluralize(inflection.camelize(prop.name)),
            tablename=inflection.tableize(f"{cls.name}_{prop.name}"),
            tableparams=["this", "index", "result"] if not prop.is_unordered else ["this", "result"],
            doc=_get_doc(cls, prop, plural=False),
            doc_plural=_get_doc(cls, prop, plural=True),
        )
    elif prop.is_optional:
        args.update(
            singular=inflection.camelize(prop.name),
            tablename=inflection.tableize(f"{cls.name}_{prop.name}"),
            tableparams=["this", "result"],
            doc=_get_doc(cls, prop),
        )
    elif prop.is_predicate:
        args.update(
            singular=inflection.camelize(prop.name, uppercase_first_letter=False),
            tablename=inflection.underscore(f"{cls.name}_{prop.name}"),
            tableparams=["this"],
            doc=_get_doc(cls, prop),
        )
    else:
        raise ValueError(f"unknown property kind for {prop.name} from {cls.name}")
    return ql.Property(**args)


def get_ql_class(cls: schema.Class, lookup: typing.Dict[str, schema.Class]) -> ql.Class:
    pragmas = {k: True for k in cls.pragmas if k.startswith("ql")}
    prev_child = ""
    properties = []
    for p in cls.properties:
        prop = get_ql_property(cls, p, lookup, prev_child)
        if prop.is_child:
            prev_child = prop.singular
        properties.append(prop)
    return ql.Class(
        name=cls.name,
        bases=cls.bases,
        final=not cls.derived,
        properties=properties,
        dir=pathlib.Path(cls.group or ""),
        doc=cls.doc,
        hideable=cls.hideable,
        **pragmas,
    )


def _to_db_type(x: str) -> str:
    if x[0].isupper():
        return "Raw::" + x
    return x


_final_db_class_lookup = {}


def get_ql_synth_class_db(name: str) -> ql.Synth.FinalClassDb:
    return _final_db_class_lookup.setdefault(name, ql.Synth.FinalClassDb(name=name,
                                                                         params=[
                                                                             ql.Synth.Param("id", _to_db_type(name))]))


def get_ql_synth_class(cls: schema.Class):
    if cls.derived:
        return ql.Synth.NonFinalClass(name=cls.name, derived=sorted(cls.derived),
                                      root=not cls.bases)
    if cls.synth and cls.synth.from_class is not None:
        source = cls.synth.from_class
        get_ql_synth_class_db(source).subtract_type(cls.name)
        return ql.Synth.FinalClassDerivedSynth(name=cls.name,
                                               params=[ql.Synth.Param("id", _to_db_type(source))])
    if cls.synth and cls.synth.on_arguments is not None:
        return ql.Synth.FinalClassFreshSynth(name=cls.name,
                                             params=[ql.Synth.Param(k, _to_db_type(v))
                                                     for k, v in cls.synth.on_arguments.items()])
    return get_ql_synth_class_db(cls.name)


def get_import(file: pathlib.Path, root_dir: pathlib.Path):
    stem = file.relative_to(root_dir / "ql/lib").with_suffix("")
    return str(stem).replace("/", ".")


def get_types_used_by(cls: ql.Class) -> typing.Iterable[str]:
    for b in cls.bases:
        yield b.base
    for p in cls.properties:
        yield p.type


def get_classes_used_by(cls: ql.Class) -> typing.List[str]:
    return sorted(set(t for t in get_types_used_by(cls) if t[0].isupper() and t != cls.name))


def format(codeql, files):
    ql_files = [str(f) for f in files if f.suffix in (".qll", ".ql")]
    if not ql_files:
        return
    format_cmd = [codeql, "query", "format", "--in-place", "--"] + ql_files
    res = subprocess.run(format_cmd, stderr=subprocess.PIPE, text=True)
    if res.returncode:
        for line in res.stderr.splitlines():
            log.error(line.strip())
        raise FormatError("QL format failed")
    for line in res.stderr.splitlines():
        log.debug(line.strip())


def _get_path(cls: schema.Class) -> pathlib.Path:
    return pathlib.Path(cls.group or "", cls.name).with_suffix(".qll")


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
            p = get_ql_property(c, p, lookup)
            yield ql.PropertyForTest(p.getter, is_total=p.is_single or p.is_predicate,
                                     type=p.type if not p.is_predicate else None, is_indexed=p.is_indexed)
            if p.is_repeated and not p.is_optional:
                yield ql.PropertyForTest(f"getNumberOf{p.plural}", type="int")
            elif p.is_optional and not p.is_repeated:
                yield ql.PropertyForTest(f"has{p.singular}")


def _partition_iter(x, pred):
    x1, x2 = itertools.tee(x)
    return filter(pred, x1), itertools.filterfalse(pred, x2)


def _partition(l, pred):
    """ partitions a list according to boolean predicate """
    return map(list, _partition_iter(l, pred))


def _is_in_qltest_collapsed_hierarchy(cls: schema.Class, lookup: typing.Dict[str, schema.Class]):
    return "qltest_collapse_hierarchy" in cls.pragmas or _is_under_qltest_collapsed_hierarchy(cls, lookup)


def _is_under_qltest_collapsed_hierarchy(cls: schema.Class, lookup: typing.Dict[str, schema.Class]):
    return "qltest_uncollapse_hierarchy" not in cls.pragmas and any(
        _is_in_qltest_collapsed_hierarchy(lookup[b], lookup) for b in cls.bases)


def _should_skip_qltest(cls: schema.Class, lookup: typing.Dict[str, schema.Class]):
    return "qltest_skip" in cls.pragmas or not (
        cls.final or "qltest_collapse_hierarchy" in cls.pragmas) or _is_under_qltest_collapsed_hierarchy(
        cls, lookup)


def _get_stub(cls: schema.Class, base_import: str, generated_import_prefix: str) -> ql.Stub:
    if isinstance(cls.synth, schema.SynthInfo):
        if cls.synth.from_class is not None:
            accessors = [
                ql.SynthUnderlyingAccessor(
                    argument="Entity",
                    type=_to_db_type(cls.synth.from_class),
                    constructorparams=["result"]
                )
            ]
        elif cls.synth.on_arguments is not None:
            accessors = [
                ql.SynthUnderlyingAccessor(
                    argument=inflection.camelize(arg),
                    type=_to_db_type(type),
                    constructorparams=["result" if a == arg else "_" for a in cls.synth.on_arguments]
                ) for arg, type in cls.synth.on_arguments.items()
            ]
    else:
        accessors = []
    return ql.Stub(name=cls.name, base_import=base_import, import_prefix=generated_import_prefix, synth_accessors=accessors)


def generate(opts, renderer):
    input = opts.schema
    out = opts.ql_output
    stub_out = opts.ql_stub_output
    test_out = opts.ql_test_output
    missing_test_source_filename = "MISSING_SOURCE.txt"
    include_file = stub_out.with_suffix(".qll")

    generated = {q for q in out.rglob("*.qll")}
    generated.add(include_file)
    if test_out:
        generated.update(q for q in test_out.rglob("*.ql"))
        generated.update(q for q in test_out.rglob(missing_test_source_filename))

    stubs = {q for q in stub_out.rglob("*.qll")}

    data = schemaloader.load_file(input)

    classes = {name: get_ql_class(cls, data.classes) for name, cls in data.classes.items()}
    if not classes:
        raise NoClasses
    root = next(iter(classes.values()))
    if root.has_children:
        raise RootElementHasChildren(root)

    imports = {}
    generated_import_prefix = get_import(out, opts.root_dir)

    with renderer.manage(generated=generated, stubs=stubs, registry=opts.generated_registry,
                         force=opts.force) as renderer:

        db_classes = [cls for name, cls in classes.items() if not data.classes[name].synth]
        renderer.render(ql.DbClasses(db_classes), out / "Raw.qll")

        classes_by_dir_and_name = sorted(classes.values(), key=lambda cls: (cls.dir, cls.name))
        for c in classes_by_dir_and_name:
            imports[c.name] = get_import(stub_out / c.path, opts.root_dir)

        for c in classes.values():
            qll = out / c.path.with_suffix(".qll")
            c.imports = [imports[t] for t in get_classes_used_by(c)]
            c.import_prefix = generated_import_prefix
            renderer.render(c, qll)

        for c in data.classes.values():
            path = _get_path(c)
            stub_file = stub_out / path
            if not renderer.is_customized_stub(stub_file):
                base_import = get_import(out / path, opts.root_dir)
                renderer.render(_get_stub(c, base_import, generated_import_prefix), stub_file)

        # for example path/to/elements -> path/to/elements.qll
        renderer.render(ql.ImportList([i for name, i in imports.items() if not classes[name].ql_internal]),
                        include_file)

        elements_module = get_import(include_file, opts.root_dir)

        renderer.render(
            ql.GetParentImplementation(
                classes=list(classes.values()),
                imports=[elements_module] + [i for name, i in imports.items() if classes[name].ql_internal],
            ),
            out / 'ParentChild.qll')

        if test_out:
            for c in data.classes.values():
                if _should_skip_qltest(c, data.classes):
                    continue
                test_with = data.classes[c.test_with] if c.test_with else c
                test_dir = test_out / test_with.group / test_with.name
                test_dir.mkdir(parents=True, exist_ok=True)
                if all(f.suffix in (".txt", ".ql", ".actual", ".expected") for f in test_dir.glob("*.*")):
                    log.warning(f"no test source in {test_dir.relative_to(test_out)}")
                    renderer.render(ql.MissingTestInstructions(),
                                    test_dir / missing_test_source_filename)
                    continue
                total_props, partial_props = _partition(_get_all_properties_to_be_tested(c, data.classes),
                                                        lambda p: p.is_total)
                renderer.render(ql.ClassTester(class_name=c.name,
                                               properties=total_props,
                                               elements_module=elements_module,
                                               # in case of collapsed hierarchies we want to see the actual QL class in results
                                               show_ql_class="qltest_collapse_hierarchy" in c.pragmas),
                                test_dir / f"{c.name}.ql")
                for p in partial_props:
                    renderer.render(ql.PropertyTester(class_name=c.name,
                                                      elements_module=elements_module,
                                                      property=p), test_dir / f"{c.name}_{p.getter}.ql")

        final_synth_types = []
        non_final_synth_types = []
        constructor_imports = []
        synth_constructor_imports = []
        stubs = {}
        for cls in sorted(data.classes.values(), key=lambda cls: (cls.group, cls.name)):
            synth_type = get_ql_synth_class(cls)
            if synth_type.is_final:
                final_synth_types.append(synth_type)
                if synth_type.has_params:
                    stub_file = stub_out / cls.group / f"{cls.name}Constructor.qll"
                    if not renderer.is_customized_stub(stub_file):
                        # stub rendering must be postponed as we might not have yet all subtracted synth types in `synth_type`
                        stubs[stub_file] = ql.Synth.ConstructorStub(synth_type, import_prefix=generated_import_prefix)
                    constructor_import = get_import(stub_file, opts.root_dir)
                    constructor_imports.append(constructor_import)
                    if synth_type.is_synth:
                        synth_constructor_imports.append(constructor_import)
            else:
                non_final_synth_types.append(synth_type)

        for stub_file, data in stubs.items():
            renderer.render(data, stub_file)
        renderer.render(ql.Synth.Types(root.name, generated_import_prefix,
                        final_synth_types, non_final_synth_types), out / "Synth.qll")
        renderer.render(ql.ImportList(constructor_imports), out / "SynthConstructors.qll")
        renderer.render(ql.ImportList(synth_constructor_imports), out / "PureSynthConstructors.qll")
        if opts.ql_format:
            format(opts.codeql_binary, renderer.written)
