import shutil
from flask import Flask, request
app = Flask(__name__)

STATIC_DIR = "/server/static/"

@app.route("/shutil-path1")
def path_injection1():
    dir = request.args.get('dir', '')
    shutil.rmtree(dir) # NOT OK

@app.route("/shutil-path2")
def path_injection2():
    path1 = request.args.get('path1', '')
    path2 = request.args.get('path2', '')
    shutil.copyfile(path1, path2) # NOT OK

@app.route("/shutil-path3")
def path_injection3():
    path1 = request.args.get('path1', '')
    path2 = request.args.get('path2', '')
    shutil.copy(path1, path2) # NOT OK

@app.route("/shutil-path4")
def path_injection4():
    path1 = request.args.get('path1', '')
    path2 = request.args.get('path2', '')
    shutil.move(path1, path2) # NOT OK

@app.route("/shutil-path4")
def path_injection5():
    path1 = request.args.get('path1', '')
    path2 = request.args.get('path2', '')
    shutil.copymode(path1, path2) # NOT OK