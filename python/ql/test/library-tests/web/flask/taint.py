from flask import Flask, request
app = Flask(__name__)

@app.route('/test_taint/<name>/<int:number>')
def test_taint(name = "World!", number="0", foo="foo"):
    ensure_tainted(name, number)
    ensure_not_tainted(foo)

    ensure_tainted(
        request.path,
        request.full_path,
        request.base_url,
        request.url,

        request.args,
        request.form,
        request.values,
        request.files,
        request.headers,
        request.json,
        request.json['foo'],
        request.json['foo']['bar'],
    )
