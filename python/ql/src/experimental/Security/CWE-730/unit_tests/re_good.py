# move outside test folder

from flask import request, Flask
import re

app = Flask(__name__)


@app.route("/direct")
def direct():
    pattern = re.escape(request.args['pattern'])
    re.search(pattern, "")


@app.route("/compile")
def compile():
    pattern = re.compile(re.escape(request.args['pattern']))
    pattern.search("")


@app.route("/compile_direct")
def compile_direct():
    re.compile(re.escape(request.args['pattern'])).search("")


# if __name__ == "__main__":
#     app.run(debug=True)
