import websockets.sync.server

def ensure_tainted(*args):
    print("tainted", args)

def ensure_not_tainted(*args):
    print("not tainted", args)

def handler(websocket): # $ requestHandler routedParameter=websocket
    ensure_tainted(
        websocket, # $ tainted
        websocket.recv()  # $ tainted
    )

    for msg in websocket:
        ensure_tainted(msg)  # $ tainted
        websocket.send(msg) 

    for msg in websocket.recv_streaming():
        ensure_tainted(msg)  # $ tainted
        websocket.send(msg)


if __name__ == "__main__":
    server = websockets.sync.server.serve(handler, "localhost", 8000)
    server.serve_forever()
