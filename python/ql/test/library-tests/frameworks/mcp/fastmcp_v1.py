from mcp.server import FastMCP as ServerFastMCP
from mcp.server.fastmcp import Context, FastMCP
from mcp.server.fastmcp.server import FastMCP as ModuleFastMCP
from mcp.server.session import ServerSession

server = FastMCP("test")
other = ModuleFastMCP("test")
reexported = ServerFastMCP("test")


@reexported.tool()
def run_reexported(command): # $ threatModelSource[ai]=command
    return command


@server.tool()
def run(command): # $ threatModelSource[ai]=command
    return command


@other.resource("notes://{name}")
def note(name): # $ threatModelSource[ai]=name
    return name


@server.prompt()
def summarize(topic, style="short"): # $ threatModelSource[ai]=topic threatModelSource[ai]=style
    return topic + style


def fetch(url): # $ threatModelSource[ai]=url
    return url


other.add_tool(fn=fetch)


def register(app: FastMCP):
    @app.tool()
    def remove(path): # $ threatModelSource[ai]=path
        return path


class Service:
    def __init__(self):
        self.mcp = FastMCP("test")

    def register(self):
        @self.mcp.tool()
        def lookup(host): # $ threatModelSource[ai]=host
            return host


def not_registered(value):
    return value


# The SDK injects the `Context` parameter itself, so it is not chosen by the client.
@server.tool()
async def with_context(command, ctx: Context): # $ threatModelSource[ai]=command
    return command


@server.tool()
async def with_generic_context(command, ctx: Context[ServerSession, None]): # $ threatModelSource[ai]=command
    return command
