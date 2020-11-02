
import os
import subprocess

from flask import Flask, request
app = Flask(__name__)

@app.route("/command1")
def command_injection1():
    files = request.args.get('files', '')
    # Don't let files be `; rm -rf /`
    os.system("ls " + files)


@app.route("/command2")
def command_injection2():
    files = request.args.get('files', '')
    # Don't let files be `; rm -rf /`
    subprocess.Popen("ls " + files, shell=True)


@app.route("/command3")
def first_arg_injection():
    cmd = request.args.get('cmd', '')
    subprocess.Popen([cmd, "param1"])


@app.route("/other_cases")
def others():
    files = request.args.get('files', '')
    # Don't let files be `; rm -rf /`
    os.popen("ls " + files)
