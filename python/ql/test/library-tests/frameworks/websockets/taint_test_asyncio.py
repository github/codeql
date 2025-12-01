import websockets.asyncio.server
import asyncio

def ensure_tainted(*args):
    print("tainted", args)

def ensure_not_tainted(*args):
    print("not tainted", args)

async def handler(websocket): # $ requestHandler routedParameter=websocket
    ensure_tainted(
        websocket, # $ tainted
        await websocket.recv()  # $ tainted
    )

    async for msg in websocket:
        ensure_tainted(msg)  # $ tainted
        await websocket.send(msg) 

    async for msg in websocket.recv_streaming():
        ensure_tainted(msg)  # $ tainted
        await websocket.send(msg)


async def main():
    server = await websockets.asyncio.server.serve(handler, "localhost", 8000)
    await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(main())