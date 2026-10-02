from fastmcp import FastMCP
from fastmcp.server import FastMCP as ServerFastMCP
from fastmcp.server.server import FastMCP as ModuleFastMCP
from fastmcp.server.auth import AuthProvider, TokenVerifier
from fastmcp.server.auth.auth import TokenVerifier as ModuleTokenVerifier
from fastmcp.server.dependencies import get_access_token, get_http_headers, get_http_request
from fastmcp.tools import FunctionTool, Tool, tool
from fastmcp.tools.base import Tool as BaseTool
from fastmcp.tools.function_tool import FunctionTool as ModuleFunctionTool

app = FastMCP("test")
server_app = ServerFastMCP("test")
module_app = ModuleFastMCP("test")


@app.tool
def bare(command): # $ mad-source__remote=command
    return command


@server_app.tool(name="exec")
def called(command): # $ mad-source__remote=command
    return command


@module_app.resource("files://{path}")
def resource(path): # $ mad-source__remote=path
    return path


@app.prompt
def bare_prompt(topic): # $ mad-source__remote=topic
    return topic


@app.prompt()
def called_prompt(topic, style="short"): # $ mad-source__remote=topic mad-source__remote=style
    return topic + style


def added(command): # $ mad-source__remote=command
    return command


app.add_tool(added)


def added_prompt(topic): # $ mad-source__remote=topic
    return topic


app.add_prompt(prompt=added_prompt)


def via_tool(url): # $ mad-source__remote=url
    return url


def via_function_tool(url): # $ mad-source__remote=url
    return url


def via_base_tool(url): # $ mad-source__remote=url
    return url


def via_module_function_tool(url): # $ mad-source__remote=url
    return url


Tool.from_function(via_tool)
FunctionTool.from_function(via_function_tool)
BaseTool.from_function(fn=via_base_tool)
ModuleFunctionTool.from_function(via_module_function_tool)


@tool
def standalone(command): # $ mad-source__remote=command
    return command


@tool()
def standalone_called(command): # $ mad-source__remote=command
    return command


@app.tool
def forward_header():
    return get_http_headers()["x-target"] # $ mad-source__remote=get_http_headers()


@app.tool
def forward_request_header():
    return get_http_request().headers["x-target"] # $ mad-source__remote=get_http_request().headers


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
