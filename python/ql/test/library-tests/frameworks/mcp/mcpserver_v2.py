from mcp.server import MCPServer
from mcp.server.mcpserver import MCPServer as PackageMCPServer
from mcp.server.mcpserver.server import MCPServer as ModuleMCPServer

server = MCPServer("test")
package_server = PackageMCPServer("test")
module_server = ModuleMCPServer("test")


@server.tool()
def run(command): # $ mad-source__ai=command
    return command


@package_server.resource("notes://{name}")
def note(name): # $ mad-source__ai=name
    return name


@module_server.prompt()
def summarize(topic): # $ mad-source__ai=topic
    return topic


def fetch(url): # $ mad-source__ai=url
    return url


server.add_tool(fetch)
