from flask import request, Flask
import re

app = Flask(__name__)


@app.route("/direct")
def direct():
    """
    A RemoteFlowSource is escaped by re.escape and then used as
    re'search pattern
    """

    unsafe_pattern = request.args['pattern']
    safe_pattern = re.escape(unsafe_pattern)
    re.search(safe_pattern, "")


@app.route("/compile")
def compile():
    """
    A RemoteFlowSource is escaped by re.escape and used as re.compile's
    pattern which also executes .search()
    """

    unsafe_pattern = request.args['pattern']
    safe_pattern = re.escape(unsafe_pattern)
    compiled_pattern = re.compile(safe_pattern)
    compiled_pattern.search("")


@app.route("/compile_direct")
def compile_direct():
    """
    A RemoteFlowSource is escaped by re.escape and then used as re.compile's
    pattern which also executes .search() in the same line
    """

    unsafe_pattern = request.args['pattern']
    safe_pattern = re.escape(unsafe_pattern)
    re.compile(safe_pattern).search("")


# if __name__ == "__main__":
#     app.run(debug=True)
