from flask import Flask, request

app = Flask(__name__)


# Recursive merge function
def merge(src, dst):
    for k, v in src.items():
        if hasattr(dst, '__getitem__'):
            if dst.get(k) and type(v) == dict:
                merge(v, dst.get(k))
            else:
                dst[k] = v
        elif hasattr(dst, k) and type(v) == dict:
            merge(v, getattr(dst, k))
        else:
            setattr(dst, k, v)


class User:
    def __init__(self):
        pass


@app.route("/vuln")
def vuln_handler():
    not_accessible_variable = 'Hello'
    # '{"__class__":{"__init__":{"__globals__":{"not_accessible_variable":"Polluted value"}}}}'
    merge(request.json['arg'], User())
    return not_accessible_variable
