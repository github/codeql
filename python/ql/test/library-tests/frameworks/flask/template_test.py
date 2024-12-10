from flask import Flask, Response, stream_with_context, render_template_string, stream_template_string
app = Flask(__name__)

@app.route("/a")  # $routeSetup="/a"
def a():  # $ requestHandler
    r = render_template_string("abc") # $ templateConstruction="abc"
    return r # $ HttpResponse

@app.route("/b")  # $routeSetup="/b"
def b():  # $ requestHandler
    s = stream_template_string("abc") # $ templateConstruction="abc"
    r = Response(stream_with_context(s)) # $ HttpResponse
    return r # $ HttpResponse

if __name__ == "__main__":
    app.run(debug=True)