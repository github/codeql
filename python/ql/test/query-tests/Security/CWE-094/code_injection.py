from flask import Flask, request
app = Flask(__name__)

@app.route("/code-execution")
def code_execution():
    code = request.args.get("code")
    exec(code)
    eval(code)
    cmd = compile(code, "<filename>", "exec")
    exec(cmd)
