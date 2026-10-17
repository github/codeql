from mcp.server import Server
from mcp.server.lowlevel import Server as LowLevelServer
from mcp.server.lowlevel.server import Server as ModuleServer

server = Server("test")
lowlevel_server = LowLevelServer("test")
module_server = ModuleServer("test")


@server.call_tool()
async def call_tool(name, arguments): # $ mad-source__ai=name mad-source__ai=arguments
    return arguments


@lowlevel_server.read_resource()
async def read_resource(uri): # $ mad-source__ai=uri
    return uri


@module_server.get_prompt()
async def get_prompt(name, arguments): # $ mad-source__ai=name mad-source__ai=arguments
    return arguments
