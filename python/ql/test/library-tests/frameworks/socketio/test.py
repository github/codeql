import socketio 

sio = socketio.Server()

@sio.on("connect")
def connect(sid, environ, auth): # $ requestHandler routedParameter=environ routedParameter=auth
    print("connect", sid, environ, auth)

@sio.on("event1")
def handle(sid, data): # $ requestHandler routedParameter=data
    print("e1", sid, data)

@sio.event
def event2(sid, data): # $ requestHandler routedParameter=data
    print("e2", sid, data)

def event3(sid, data): # $ requestHandler routedParameter=data
    print("e3", sid, data)

sio.on("event3", handler=event3)

sio.on("event4", lambda sid,data: print("e4", sid, data)) # $ requestHandler routedParameter=data



if __name__ == "__main__":
    app = socketio.WSGIApp(sio)
    import eventlet 
    eventlet.wsgi.server(eventlet.listen(('', 8000)), app)