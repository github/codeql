from flask import Flask, jsonify, request
import unicodedata

app = Flask(__name__)

STATIC_DIR = "/home/unknown/"


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


@app.route("/bad_2")
def bad_2():
    r = request.args.get("r", "")

    if len(r) >= 10:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404


@app.route("/bad_3")
def bad_3():
    r = request.args.get("r", "")
    length = len(r)
    if length >= 1_000:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404


@app.route("/bad_4")
def bad_4():
    r = request.args.get("r", "")
    length = len(r)
    if 1_000 <= length:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404


@app.route("/bad_5")
def bad_5():
    r = request.args.get("r", "")
    length = len(r)
    if not length < 1_000:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404


@app.route("/bad_6")
def bad_6():
    r = request.args.get("r", "")
    length = len(r)
    if not 1_000 > length:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404


@app.route("/good_1")
def good_1():
    r = request.args.get("r", "")

    if len(r) <= 1_000:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404


@app.route("/good_2")
def good_2():
    r = request.args.get("r", "")
    MAX_LENGTH = 1_000
    length = len(r)
    if length <= MAX_LENGTH:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404

@app.route("/good_3")
def good_3():
    r = request.args.get("r", "")
    MAX_LENGTH = 1_000
    length = len(r)
    if not length >= MAX_LENGTH:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404


@app.route("/good_4")
def good_4():
    r = request.args.get("r", "")
    MAX_LENGTH = 1_000
    length = len(r)
    if not MAX_LENGTH <= length:
        # Normalize the r using NFKD Unicode normalization
        r = unicodedata.normalize("NFKD", r)
        return r, 200, {"Content-Type": "application/octet-stream"}
    else:
        return jsonify({"error": "File not found"}), 404
