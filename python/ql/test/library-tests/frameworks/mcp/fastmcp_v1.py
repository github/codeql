from mcp.server.fastmcp import FastMCP
from mcp.server.fastmcp.server import FastMCP as ModuleFastMCP

server = FastMCP("test")
other = ModuleFastMCP("test")


@server.tool()
def run(command): # $ mad-source__remote=command
    return command


@other.resource("notes://{name}")
def note(name): # $ mad-source__remote=name
    return name


@server.prompt()
def summarize(topic, style="short"): # $ mad-source__remote=topic mad-source__remote=style
    return topic + style


def fetch(url): # $ mad-source__remote=url
    return url


other.add_tool(fn=fetch)


def register(app: FastMCP):
    @app.tool()
    def remove(path): # $ mad-source__remote=path
        return path


class Service:
    def __init__(self):
        self.mcp = FastMCP("test")

    def register(self):
        @self.mcp.tool()
        def lookup(host): # $ mad-source__remote=host
            return host


def not_registered(value):
    return value
