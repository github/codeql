import dataclasses
import typing

from misc.codegen.loaders import schemaloader
from . import qlgen


@dataclasses.dataclass
class Param:
    name: str
    type: str
    first: bool = False


@dataclasses.dataclass
class Function:
    name: str
    generic_params: list[Param]
    params: list[Param]
    return_type: str

    def __post_init__(self):
        if self.generic_params:
            self.generic_params[0].first = True
        if self.params:
            self.params[0].first = True


@dataclasses.dataclass
class TestCode:
    template: typing.ClassVar[str] = "rust_test_code"

    code: str
    function: Function | None = None


def generate(opts, renderer):
    assert opts.ql_test_output
    schema = schemaloader.load_file(opts.schema)
    with renderer.manage(generated=opts.ql_test_output.rglob("gen_*.rs"),
                         stubs=(),
                         registry=opts.generated_registry,
                         force=opts.force) as renderer:
        for cls in schema.classes.values():
            if (qlgen.should_skip_qltest(cls, schema.classes) or
                    "rust_skip_test_from_doc" in cls.pragmas or
                not cls.doc
                ):
                continue
            fn = cls.rust_doc_test_function
            if fn:
                generic_params = [Param(k, v) for k, v in fn.params.items() if k[0].isupper() or k[0] == "'"]
                params = [Param(k, v) for k, v in fn.params.items() if k[0].islower()]
                fn = Function(fn.name, generic_params, params, fn.return_type)
            code = []
            adding_code = False
            for line in cls.doc:
                match line, adding_code:
                    case "```", _:
                        adding_code = not adding_code
                    case _, False:
                        code.append(f"// {line}")
                    case _, True:
                        code.append(line)
            if fn:
                indent = 4 * " "
                code = [indent + l for l in code]
            test_with = schema.classes[cls.test_with] if cls.test_with else cls
            test = opts.ql_test_output / test_with.group / test_with.name / f"gen_{cls.name.lower()}.rs"
            renderer.render(TestCode(code="\n".join(code), function=fn), test)
