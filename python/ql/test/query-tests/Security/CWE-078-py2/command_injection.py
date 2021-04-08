import os
import platform
import popen2

from flask import Flask, request

app = Flask(__name__)


@app.route("/python2-specific")
def python2_specific():
    """
    These tests are mostly included to check for extra paths that can be generated if
    we can track flow into the implementation of a stdlib function, and then to another sink.
    See comment in query for more details.
    """

    files = request.args.get("files", "")
    os.popen2("ls " + files)
    os.popen3("ls " + files)
    os.popen4("ls " + files)

    platform.popen("ls " + files)

    popen2.popen2("ls " + files)
    popen2.popen3("ls " + files)
    popen2.popen4("ls " + files)
    popen2.Popen3("ls " + files)
    popen2.Popen4("ls " + files)
