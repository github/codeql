from flask import request, Flask
import re

app = Flask(__name__)


@app.route("/direct")
def direct():
    pattern = request.args['pattern']

    re.search(pattern, "")


@app.route("/compile")
def compile():
    pattern = re.compile(request.args['pattern'])

    pattern.search("")


# if __name__ == "__main__":
#     app.run(debug=True)
