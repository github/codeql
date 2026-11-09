import typing
from typing import Annotated, Annotated as A, Literal, Literal as L, Optional, Optional as O, Union as U

from fastmcp import Context as SDKContext, FastMCP
from pydantic import BaseModel

app = FastMCP("aliases")


# In this module `Context` is the project's own model, not the class that the SDK injects.
class Context(BaseModel):
    command: str


class ProjectContext(SDKContext):
    pass


@app.tool()
def run(data: "Context"): # $ threatModelSource[ai]=data
    return data.command


@app.tool()
def with_sdk_context(command, ctx: "SDKContext"): # $ threatModelSource[ai]=command
    return command


@app.tool()
def with_optional_sdk_context(command, ctx: "Optional[SDKContext]" = None): # $ threatModelSource[ai]=command
    return command


@app.tool()
def with_union_sdk_context(command, ctx: "SDKContext | None" = None): # $ threatModelSource[ai]=command
    return command


@app.tool()
def with_annotated_sdk_context(command, ctx: "Annotated[SDKContext, 'injected']"): # $ threatModelSource[ai]=command
    return command


@app.tool()
def with_aliased_annotated_sdk_context(command, ctx: A[SDKContext, "injected"]): # $ threatModelSource[ai]=command
    return command


# Quoted wrappers resolve through the imports of the module, like the class itself.
@app.tool()
def with_quoted_aliased_annotated(command, ctx: "A[SDKContext, 'injected']"): # $ threatModelSource[ai]=command
    return command


@app.tool()
def with_quoted_aliased_optional(command, ctx: "O[SDKContext]" = None): # $ threatModelSource[ai]=command
    return command


@app.tool()
def with_quoted_aliased_union(command, ctx: "U[SDKContext, None]" = None): # $ threatModelSource[ai]=command
    return command


@app.tool()
def with_quoted_qualified_optional(command, ctx: "typing.Optional[SDKContext]" = None): # $ threatModelSource[ai]=command
    return command


# The SDKs also inject subclasses of `Context`.
@app.tool()
def with_subclass(command, ctx: ProjectContext): # $ threatModelSource[ai]=command
    return command


@app.tool()
def with_quoted_subclass(command, ctx: "ProjectContext"): # $ threatModelSource[ai]=command
    return command


# Metadata and `Literal` values are client data, also under aliased typing imports and in strings.
@app.tool()
def aliased_metadata(command: A[str, "SDKContext"]): # $ threatModelSource[ai]=command
    return command


@app.tool()
def aliased_literal(scope: L["SDKContext", "Global"]): # $ threatModelSource[ai]=scope
    return scope


@app.tool()
def quoted_metadata(command: "Annotated[str, 'SDKContext']"): # $ threatModelSource[ai]=command
    return command


@app.tool()
def quoted_literal(scope: "Literal['SDKContext', 'Global']"): # $ threatModelSource[ai]=scope
    return scope


@app.tool()
def quoted_union_with_literal(scope: "str | Literal['SDKContext']"): # $ threatModelSource[ai]=scope
    return scope
