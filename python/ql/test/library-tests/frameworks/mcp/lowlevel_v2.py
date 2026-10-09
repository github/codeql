from mcp.server import Server


async def handle_call_tool(ctx, params):
    return params.arguments # $ mad-source__remote=params.arguments


async def handle_read_resource(ctx, params):
    return params.uri # $ mad-source__remote=params.uri


async def handle_get_prompt(ctx, params):
    return params.arguments # $ mad-source__remote=params.arguments


async def not_registered(ctx, params):
    return params.arguments


server = Server(
    "test",
    on_call_tool=handle_call_tool,
    on_read_resource=handle_read_resource,
    on_get_prompt=handle_get_prompt,
)
