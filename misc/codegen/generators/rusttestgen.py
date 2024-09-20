import dataclasses
import typing
import inflection

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
    signature: str


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
                         registry=opts.ql_test_output / ".generated_tests.list",
                         force=opts.force) as renderer:
        for cls in schema.classes.values():
            if (qlgen.should_skip_qltest(cls, schema.classes) or
                    "rust_skip_test_from_doc" in cls.pragmas or
                    not cls.doc):
                continue
            code = []
            adding_code = False
            has_code = False
            for line in cls.doc:
                match line, adding_code:
                    case ("```", _) | ("```rust", _):
                        adding_code = not adding_code
                        has_code = True
                    case _, False:
                        code.append(f"// {line}")
                    case _, True:
                        code.append(line)
            if not has_code:
                continue
            assert not adding_code, "Unterminated code block in docstring: " + "\n".join(cls.doc)
            test_name = inflection.underscore(cls.name)
            signature = cls.pragmas.get("rust_doc_test_signature", "() -> ()")
            fn = signature and Function(f"test_{test_name}", signature)
            if fn:
                indent = 4 * " "
                code = [indent + l for l in code]
            test_with_name = typing.cast(str, cls.pragmas.get("qltest_test_with"))
            test_with = schema.classes[test_with_name] if test_with_name else cls
            test = opts.ql_test_output / test_with.group / test_with.name / f"gen_{test_name}.rs"
            renderer.render(TestCode(code="\n".join(code), function=fn), test)
