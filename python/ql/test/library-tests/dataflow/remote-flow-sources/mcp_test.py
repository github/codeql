from fastmcp import Context, FastMCP
from fastmcp import tool as standalone_tool
from mcp.server.fastmcp import FastMCP as McpFastMCP
from mcp.server import MCPServer

mcp_app = FastMCP("test")
mcp_sdk = McpFastMCP("test")
mcp_v2 = MCPServer("test")


def other_decorator(fn):
    return fn


@mcp_app.tool()
def sync_tool(command: str) -> str:
    return command


@mcp_app.tool
def bare_tool(command: str) -> str:
    return command


@mcp_sdk.prompt()
def sdk_prompt(topic: str, *, style: str = "short") -> str:
    return topic + style


@mcp_v2.resource("notes://{name}")
def v2_resource(name: str) -> str:
    return name


async def async_fetch(url: str) -> str:
    return url


mcp_app.add_tool(async_fetch)


def added_via_add(url: str) -> str:
    return url


mcp_sdk.add_tool(fn=added_via_add)


@standalone_tool
def module_tool(cmd: str) -> str:
    return cmd


@standalone_tool()
def module_tool_called(cmd: str) -> str:
    return cmd


@other_decorator
@mcp_app.tool()
def stacked_decorator(cmd: str) -> str:
    return cmd


def not_registered(value: str) -> str:
    return value


@mcp_app.tool()
def with_context(ctx: Context, data: str) -> str:
    return data


class Service:
    def __init__(self):
        self.mcp = FastMCP("svc")

    def register(self):
        @self.mcp.tool()
        def instance_lookup(host: str) -> str:
            return host
