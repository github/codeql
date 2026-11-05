from fastmcp import Context, FastMCP
from pydantic import BaseModel

app = FastMCP("shadowed")


# The project's own model replaces the imported `Context`, and the SDKs resolve the string to it.
class Context(BaseModel):
    command: str


@app.tool()
def run(data: "Context"): # $ threatModelSource[ai]=data
    return data.command


@app.tool()
def run_unquoted(data: Context): # $ threatModelSource[ai]=data
    return data.command
