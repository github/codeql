from flask import Flask, request
app = Flask(__name__)

@app.route("/save-uploaded-file")  # $routeSetup="/save-uploaded-file"
def test_taint():  # $requestHandler
    request.files['key'].save("path") # $ getAPathArgument="path"
