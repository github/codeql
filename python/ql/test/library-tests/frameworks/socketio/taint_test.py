import sys
import socketio 
import sys

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
    sio.emit("e2", "hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted
    sio.send("hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted

class MyNamespace(socketio.Namespace):
    def on_event2(self, sid, data):  # $ requestHandler routedParameter=data
        ensure_not_tainted(self, sid)
        ensure_tainted(data)
        res = self.call("e1", sid=sid) 
        ensure_tainted(res)  # $ tainted
        self.emit("e2", "hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted
        self.send("hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted

sio.register_namespace(MyNamespace("/ns"))

asio = socketio.AsyncServer(async_mode='asgi')

@asio.event
async def event3(sid, data): # $ requestHandler routedParameter=sid routedParameter=data
    ensure_not_tainted(sid)
    ensure_tainted(data)  # $ tainted
    res = await asio.call("e1", sid=sid)
    ensure_tainted(res)  # $ tainted
    await asio.emit("e2", "hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted
    await asio.send("hi", to=sid, callback=lambda x: ensure_tainted(x))   # $ tainted

if __name__ == "__main__":
    
    if "--async" in sys.argv:
        import uvicorn
        app = socketio.ASGIApp(asio)
        uvicorn.run(app, host='127.0.0.1', port=8000)
    else:
        import eventlet
        app = socketio.WSGIApp(sio)
        eventlet.wsgi.server(eventlet.listen(('', 8000)), app)