import sys
import socketio 

def ensure_tainted(*args):
    print("tainted", args)

def ensure_not_tainted(*args):
    print("not tainted", args)

sio = socketio.Server()

@sio.event
def connect(sid, environ, auth): # $ requestHandler routedParameter=environ routedParameter=auth
    ensure_not_tainted(sid)
    ensure_tainted(environ,  # $ tainted
                   auth)     # $ tainted

@sio.event
def event1(sid, data): # $ requestHandler routedParameter=data
    ensure_not_tainted(sid)
    ensure_tainted(data)  # $ tainted
    res = sio.call("e1", sid=sid)
    ensure_tainted(res)  # $ tainted
    sio.emit("e2", "hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted $ requestHandler routedParameter=x
    sio.send("hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted $ requestHandler routedParameter=x

class MyNamespace(socketio.Namespace):
    def on_event2(self, sid, data):  # $ requestHandler routedParameter=data
        ensure_not_tainted(self, sid)
        ensure_tainted(data)  # $ tainted
        res = self.call("e1", sid=sid) 
        ensure_tainted(res)  # $ tainted
        self.emit("e2", "hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted $ requestHandler routedParameter=x
        self.send("hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted $ requestHandler routedParameter=x

sio.register_namespace(MyNamespace("/ns"))

asio = socketio.AsyncServer(async_mode='asgi')

@asio.event
async def event3(sid, data): # $ requestHandler routedParameter=data
    ensure_not_tainted(sid)
    ensure_tainted(data)  # $ tainted
    res = await asio.call("e1", sid=sid)
    ensure_tainted(res)  # $ tainted
    await asio.emit("e2", "hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted $ requestHandler routedParameter=x
    await asio.send("hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted $ requestHandler routedParameter=x

class MyAsyncNamespace(socketio.AsyncNamespace):
    async def on_event4(self, sid, data):  # $ requestHandler routedParameter=data
        ensure_not_tainted(self, sid)
        ensure_tainted(data)  # $ tainted
        res = await self.call("e1", sid=sid) 
        ensure_tainted(res)  # $ tainted
        await self.emit("e2", "hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted $ requestHandler routedParameter=x
        await self.send("hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted $ requestHandler routedParameter=x

asio.register_namespace(MyAsyncNamespace("/ns"))

if __name__ == "__main__":
    
    if "--async" in sys.argv: # $ threatModelSource[commandargs]=sys.argv
        import uvicorn
        app = socketio.ASGIApp(asio)
        uvicorn.run(app, host='127.0.0.1', port=8000)
    else:
        import eventlet
        app = socketio.WSGIApp(sio)
        eventlet.wsgi.server(eventlet.listen(('', 8000)), app)