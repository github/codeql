import hashlib
import hmac
import base64

from flask import Flask, request, make_response
app = Flask(__name__)

SECRET_KEY = b"SECRET_KEY"


@app.route("/hmac-example")
def hmac_example():
    data_raw = request.args.get("data").encode('utf-8')
    data = base64.decodebytes(data_raw)
    digest = hmac.digest(SECRET_KEY, data, hashlib.sha256)
    print(digest)
    return "ok"


@app.route("/unknown-lib-1")
def unknown_lib_1():
    from unknown.lib import func
    data = request.args.get("data")
    func(data) # TODO: currently not recognized


@app.route("/unknown-lib-2")
def unknown_lib_2():
    import unknown.lib
    data = request.args.get("data")
    unknown.lib.func(data) # TODO: currently not recognized


if __name__ == "__main__":
    app.run(debug=True)
