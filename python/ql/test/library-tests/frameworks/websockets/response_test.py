import websockets.sync.server 
import websockets.sync.router
from werkzeug.routing import Map, Rule

def arg_handler(websocket): # $ requestHandler routedParameter=websocket
    websocket.send("arg" + websocket.recv())

s1 = websockets.sync.server.serve(arg_handler, "localhost", 8000)

def kw_handler(websocket): # $ requestHandler routedParameter=websocket
    websocket.send("kw" + websocket.recv())

s2 = websockets.sync.server.serve(handler=kw_handler, host="localhost", port=8001)

def route_handler(websocket, x):  # $ MISSING: requestHandler routedParameter=websocket routedParameter=x
    websocket.send(f"route {x} {websocket.recv()}")

s3 = websockets.sync.router.route(Map([
    Rule("/<string:x>", endpoint=route_handler)
]), "localhost", 8002)

def unix_handler(websocket): # $ requestHandler routedParameter=websocket
    websocket.send("unix" + websocket.recv())

s4 = websockets.sync.server.unix_serve(unix_handler, path="/tmp/ws.sock")

def unix_route_handler(websocket, x):  # $ MISSING: requestHandler routedParameter=websocket routedParameter=x
    websocket.send(f"unix route {x} {websocket.recv()}")

s5 = websockets.sync.router.unix_route(Map([
    Rule("/<string:x>", endpoint=unix_route_handler)
]), path="/tmp/ws2.sock")

if __name__ == "__main__":
    import sys
    server = s1 
    args = sys.argv # $ threatModelSource[commandargs]=sys.argv
    if len(args) > 1:
        if args[1] == "kw":
            server = s2
        elif args[1] == "route":
            server = s3
        elif args[1] == "unix":
            server = s4
        elif args[1] == "unix_route":
            server = s5
    server.serve_forever()