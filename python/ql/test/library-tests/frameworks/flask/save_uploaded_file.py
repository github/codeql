from flask import Flask, request, send_from_directory, send_file
app = Flask(__name__)

@app.route("/save-uploaded-file")  # $routeSetup="/save-uploaded-file"
def test_taint():  # $requestHandler
    request.files['key'].save("path") # $ getAPathArgument="path"


@app.route("/path-injection")  # $routeSetup="/path-injection"
def test_path():  # $requestHandler

    flask.send_from_directory("filepath","file")  # $ getAPathArgument="filepath" getAPathArgument="file"
    flask.send_file("file")  # $ getAPathArgument="file"
    
    flask.send_from_directory(directory="filepath","file") # $ getAPathArgument="filepath" getAPathArgument="file"
    flask.send_from_directory(filename="filepath","file") # $ getAPathArgument="filepath" getAPathArgument="file"
    flask.send_file(filename_or_fp="file")  # $ getAPathArgument="file"