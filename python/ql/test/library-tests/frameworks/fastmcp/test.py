from typing import Annotated, Literal, Optional

from fastmcp import Context, FastMCP
from fastmcp.prompts import FunctionPrompt, Prompt, prompt
from fastmcp.prompts.base import Prompt as BasePrompt
from fastmcp.prompts.function_prompt import FunctionPrompt as ModuleFunctionPrompt
from fastmcp.prompts.function_prompt import prompt as module_prompt
from fastmcp.prompts.prompt import FunctionPrompt as PromptModuleFunctionPrompt
from fastmcp.prompts.prompt import Prompt as PromptModulePrompt
from fastmcp.server import Context as ServerContext
from fastmcp.server import FastMCP as ServerFastMCP
from fastmcp.server.auth import AuthProvider, TokenVerifier
from fastmcp.server.auth.auth import TokenVerifier as ModuleTokenVerifier
from fastmcp.server.context import Context as ModuleContext
from fastmcp.server.dependencies import get_access_token, get_http_headers, get_http_request
from fastmcp.server.server import FastMCP as ModuleFastMCP
from fastmcp.tools import FunctionTool, Tool, tool
from fastmcp.tools.base import Tool as BaseTool
from fastmcp.tools.function_tool import FunctionTool as ModuleFunctionTool
from fastmcp.tools.function_tool import tool as module_tool
from fastmcp.tools.tool import FunctionTool as ToolModuleFunctionTool
from fastmcp.tools.tool import Tool as ToolModuleTool

app = FastMCP("test")
server_app = ServerFastMCP("test")
module_app = ModuleFastMCP("test")


@app.tool
def bare(command): # $ threatModelSource[ai]=command
    return command


@server_app.tool(name="exec")
def called(command): # $ threatModelSource[ai]=command
    return command


@module_app.resource("files://{path}")
def resource(path): # $ threatModelSource[ai]=path
    return path


@app.prompt
def bare_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


@app.prompt()
def called_prompt(topic, style="short"): # $ threatModelSource[ai]=topic threatModelSource[ai]=style
    return topic + style


def added(command): # $ threatModelSource[ai]=command
    return command


app.add_tool(added)


def added_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


app.add_prompt(prompt=added_prompt)


# The SDK injects the `Context` parameter itself, so it is not chosen by the client.
@app.tool
def with_context(command, ctx: Context): # $ threatModelSource[ai]=command
    return command


@app.tool
async def with_optional_context(command, ctx: Context | None = None): # $ threatModelSource[ai]=command
    return command


@app.tool
async def with_typing_context(command, ctx: Optional[ModuleContext] = None): # $ threatModelSource[ai]=command
    return command


@app.tool
async def with_annotated_context(command, ctx: Annotated[Context, "injected"]): # $ threatModelSource[ai]=command
    return command


@app.tool
async def with_string_context(command, ctx: "Context"): # $ threatModelSource[ai]=command
    return command


@app.tool
async def with_string_module_context(command, ctx: "ModuleContext"): # $ threatModelSource[ai]=command
    return command


@app.tool
async def with_server_context(command, ctx: ServerContext): # $ threatModelSource[ai]=command
    return command


# Only type positions refer to the injected class; metadata and `Literal` values do not.
@app.tool
def with_context_metadata(command: Annotated[str, "Context"]): # $ threatModelSource[ai]=command
    return command


@app.tool
def with_context_literal(scope: Literal["Context", "Global"]): # $ threatModelSource[ai]=scope
    return scope


def via_tool(url): # $ threatModelSource[ai]=url
    return url


def via_function_tool(url): # $ threatModelSource[ai]=url
    return url


def via_base_tool(url): # $ threatModelSource[ai]=url
    return url


def via_module_function_tool(url): # $ threatModelSource[ai]=url
    return url


def via_tool_module_tool(url): # $ threatModelSource[ai]=url
    return url


def via_tool_module_function_tool(url): # $ threatModelSource[ai]=url
    return url


Tool.from_function(via_tool)
FunctionTool.from_function(via_function_tool)
BaseTool.from_function(fn=via_base_tool)
ModuleFunctionTool.from_function(via_module_function_tool)
ToolModuleTool.from_function(via_tool_module_tool)
ToolModuleFunctionTool.from_function(via_tool_module_function_tool)


def via_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


def via_function_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


def via_base_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


def via_module_function_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


def via_prompt_module_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


def via_prompt_module_function_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


app.add_prompt(Prompt.from_function(via_prompt))
FunctionPrompt.from_function(via_function_prompt)
BasePrompt.from_function(fn=via_base_prompt)
ModuleFunctionPrompt.from_function(via_module_function_prompt)
PromptModulePrompt.from_function(via_prompt_module_prompt)
PromptModuleFunctionPrompt.from_function(via_prompt_module_function_prompt)


@tool
def standalone(command): # $ threatModelSource[ai]=command
    return command


@tool()
def standalone_called(command): # $ threatModelSource[ai]=command
    return command


@module_tool
def standalone_module(command): # $ threatModelSource[ai]=command
    return command


@module_tool(name="exec")
def standalone_module_called(command): # $ threatModelSource[ai]=command
    return command


@prompt
def standalone_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


@module_prompt()
def standalone_module_prompt(topic): # $ threatModelSource[ai]=topic
    return topic


@app.tool
def forward_header():
    return get_http_headers()["x-target"] # $ mad-source__remote=get_http_headers()


@app.tool
def forward_request_header():
    return get_http_request().headers["x-target"] # $ mad-source__remote=get_http_request().headers


class Handlers:
    # A function decorated in a class body is registered unbound, so the client supplies every
    # parameter, `self` included.
    @app.tool
    def method(self, command): # $ threatModelSource[ai]=self threatModelSource[ai]=command
        return command

    @app.tool()
    def unbound(command): # $ threatModelSource[ai]=command
        return command

    @staticmethod
    @app.tool
    def static(command): # $ threatModelSource[ai]=command
        return command


def not_registered(value):
    return value


class Verifier(TokenVerifier):
    async def verify_token(self, token): # $ mad-source__remote=token
        return token


class ModuleVerifier(ModuleTokenVerifier):
    async def verify_token(self, token): # $ mad-source__remote=token
        return token


class Provider(AuthProvider):
    async def verify_token(self, token): # $ mad-source__remote=token
        return token


class NotAVerifier:
    async def verify_token(self, token):
        return token


def session():
    return get_access_token().token # $ mad-source__remote=get_access_token().token
