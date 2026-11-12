from mcp.server import MCPServer
from mcp.server.mcpserver import MCPServer as PackageMCPServer
from mcp.server.mcpserver import Context
from mcp.server.mcpserver.context import Context as ModuleContext
from mcp.server.mcpserver.server import MCPServer as ModuleMCPServer

server = MCPServer("test")
package_server = PackageMCPServer("test")
module_server = ModuleMCPServer("test")


@server.tool()
def run(command): # $ threatModelSource[ai]=command
    return command


@package_server.resource("notes://{name}")
def note(name): # $ threatModelSource[ai]=name
    return name


@module_server.prompt()
def summarize(topic): # $ threatModelSource[ai]=topic
    return topic


def fetch(url): # $ threatModelSource[ai]=url
    return url


server.add_tool(fetch)


# The SDK injects the `Context` parameter itself, so it is not chosen by the client.
@server.tool()
async def with_context(command, ctx: Context): # $ threatModelSource[ai]=command
    return command


@server.tool()
async def with_module_context(command, ctx: ModuleContext | None = None): # $ threatModelSource[ai]=command
    return command
