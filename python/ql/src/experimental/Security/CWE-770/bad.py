from flask import Flask, jsonify, request
import unicodedata

app = Flask(__name__)


@app.route("/bad_1")
def bad_1():
    # User controlled data
    file_path = request.args.get("file_path", "")

    # Normalize the file path using NFKC Unicode normalization
    return (
        unicodedata.normalize("NFKC", file_path),
        200,
        {"Content-Type": "application/octet-stream"},
    )
