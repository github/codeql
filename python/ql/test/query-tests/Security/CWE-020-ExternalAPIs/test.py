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
    my_hmac = hmac.new(SECRET_KEY, data, hashlib.sha256)
    digest = my_hmac.digest()
    print(digest)
    return "ok"


@app.route("/hmac-example2")
def hmac_example2():
    data_raw = request.args.get("data").encode('utf-8')
    data = base64.decodebytes(data_raw)
    my_hmac = hmac.new(key=SECRET_KEY, msg=data, digestmod=hashlib.sha256)
    digest = my_hmac.digest()
    print(digest)
    return "ok"


@app.route("/unknown-lib-1")
def unknown_lib_1():
    from unknown.lib import func
    data = request.args.get("data")
    func(data)
    func(kw=data)


@app.route("/unknown-lib-2")
def unknown_lib_2():
    import unknown.lib
    data = request.args.get("data")
    unknown.lib.func(data)
    unknown.lib.func(kw=data)


def handle_this(arg, application = None):
    if application:
        # since application could be None, we could end up reporting `None.json.dumps`
        application.json.dumps(arg)

@app.route("/optional-arg")
def optional_arg():
    data = request.args.get("data")
    handle_this(data)

if __name__ == "__main__":
    # http://127.0.0.1:5000/hmac-example?data=aGVsbG8gd29ybGQh
    app.run(debug=True)
