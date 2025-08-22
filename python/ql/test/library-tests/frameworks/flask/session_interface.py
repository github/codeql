import flask 

class MySessionInterface(flask.sessions.SessionInterface):
    def open_session(self, app, request):
        ensure_tainted(request) # $tainted