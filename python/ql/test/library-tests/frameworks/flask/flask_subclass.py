from flask import Flask


class Sub(Flask):
    def __init__(self, *args, **kwargs):
        Flask.__init__(self, *args, **kwargs)


app = Sub(__name__) # $ instance


@app.route("/") # $ routeSetup="/"
def hello(): # $ requestHandler
    return "world" # $ HttpResponse