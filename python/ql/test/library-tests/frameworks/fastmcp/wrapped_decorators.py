import functools

from fastmcp import Context, FastMCP
from fastmcp import tool as standalone_tool

app = FastMCP("wrapped-test")


def custom_wrapper(fn):
    @functools.wraps(fn)
    def wrapper(*args, **kwargs):
        return fn(*args, **kwargs)

    return wrapper


@app.tool()
@custom_wrapper
def wrapped_with_context(command: str, ctx: Context) -> str:  # $ threatModelSource[ai]=command
    return command


@standalone_tool
@custom_wrapper
def standalone_wrapped(command: str) -> str:  # $ threatModelSource[ai]=command
    return command


class WrappedHandlers:
    @app.tool()
    @custom_wrapper
    def class_body_wrapped(command: str, ctx: Context) -> str:  # $ threatModelSource[ai]=command
        return command