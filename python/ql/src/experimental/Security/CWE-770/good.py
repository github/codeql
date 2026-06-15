from flask import Flask, jsonify, request
import unicodedata

app = Flask(__name__)


@app.route("/good_1")
def good_1():
    r = request.args.get("file_path", "")

    if len(r) <= 1_000:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404
