from flask import Flask


class Sub(Flask):
    def __init__(self, *args, **kwargs):
        Flask.__init__(self, *args, **kwargs)


app = Sub(__name__) # $ MISSING: instance


@app.route("/")
def hello():
    return "world"