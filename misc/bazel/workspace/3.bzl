load("@python_toolchain//:defs.bzl", "interpreter")
load("@rules_python//python:pip.bzl", "pip_parse")

def codeql_workspace_3(repository_name = "codeql"):
    pip_parse(
        name = "codegen_deps",
        python_interpreter_target = interpreter,
        requirements_lock = "@%s//misc/codegen:requirements.txt" % repository_name,
    )
