from flask import request, Flask
import re

app = Flask(__name__)


@app.route("/direct")
def direct():
    """
    A RemoteFlowSource is used directly as re.search's pattern
    """

    unsafe_pattern = request.args["pattern"]
    re.search(unsafe_pattern, "")


@app.route("/compile")
def compile():
    """
    A RemoteFlowSource is used directly as re.compile's pattern
    which also executes .search() 
    """

    unsafe_pattern = request.args["pattern"]
    compiled_pattern = re.compile(unsafe_pattern)
    compiled_pattern.search("")


@app.route("/compile_direct")
def compile_direct():
    """
    A RemoteFlowSource is used directly as re.compile's pattern
    which also executes .search() in the same line
    """

    unsafe_pattern = request.args["pattern"]
    re.compile(unsafe_pattern).search("")

# if __name__ == "__main__":
#     app.run(debug=True)
