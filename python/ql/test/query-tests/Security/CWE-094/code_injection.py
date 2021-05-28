from flask import Flask, request
app = Flask(__name__)

@app.route("/code-execution")
def code_execution():
    code = request.args.get("code")
    exec(code) # NOT OK
    eval(code) # NOT OK
    cmd = compile(code, "<filename>", "exec")
    exec(cmd) # NOT OK


@app.route("/safe-code-execution")
def code_execution():
    foo = 42
    bar = 43

    obj_name = request.args.get("obj")
    if obj_name == "foo" or obj_name == "bar":
        # TODO: Should not alert on this
        obj = eval(obj_name) # OK
        print(obj, obj*10)
