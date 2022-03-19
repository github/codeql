import os

from flask import Flask, request
app = Flask(__name__)


STATIC_DIR = "/server/static/"


@app.route("/path1")
def path_injection():
    filename = request.args.get('filename', '')
    f = open(os.path.join(STATIC_DIR, filename)) # NOT OK


@app.route("/path2")
def path_injection():
    # Normalized, but not checked
    filename = request.args.get('filename', '')
    npath = os.path.normpath(os.path.join(STATIC_DIR, filename))
    f = open(npath)  # NOT OK


@app.route("/path3")
def unsafe_path_normpath():
    # Normalized, but `open()` is not guarded by `startswith` check
    filename = request.args.get('filename', '')
    npath = os.path.normpath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        pass
    f = open(npath)  # NOT OK


@app.route("/path4")
def safe_path_normpath():
    # Normalized, and checked properly
    filename = request.args.get('filename', '')
    npath = os.path.normpath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        f = open(npath)  # OK


@app.route("/path5")
def unsafe_path_realpath():
    # Normalized (by `realpath` that also follows symlinks), but not checked properly
    filename = request.args.get('filename', '')
    npath = os.path.realpath(os.path.join(STATIC_DIR, filename))
    f = open(npath)  # NOT OK


@app.route("/path6")
def safe_path_realpath():
    # Normalized (by `realpath` that also follows symlinks), and checked properly
    filename = request.args.get('filename', '')
    npath = os.path.realpath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        f = open(npath)  # OK


@app.route("/path6")
def unsafe_path_abspath():
    # Normalized (by `abspath`), but not checked properly
    filename = request.args.get('filename', '')
    npath = os.path.abspath(os.path.join(STATIC_DIR, filename))
    f = open(npath)  # NOT OK


@app.route("/path7")
def safe_path_abspath():
    # Normalized (by `abspath`), and checked properly
    filename = request.args.get('filename', '')
    npath = os.path.abspath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        f = open(npath)  # OK


@app.route("/abspath_tricky")
def safe_path_abspath_tricky():
    # Normalized (by `abspath`), and checked properly. The tricky bit is that the
    # possibly unsafe path is the being used in the `open` call, but only if it is known
    # to be safe.
    #
    # FP for CVE-2021-41185
    filename = request.args.get('filename', '')
    possibly_unsafe_path = os.path.join(STATIC_DIR, filename)
    if os.path.abspath(possibly_unsafe_path).startswith(STATIC_DIR):
        f = open(possibly_unsafe_path)  # OK


@app.route("/int-only/<int:foo_id>")
def flask_int_only(foo_id):
    # This is OK, since the flask routing ensures that `foo_id` MUST be an integer.
    path = os.path.join(STATIC_DIR, foo_id)
    f = open(path)  # OK TODO: FP


@app.route("/not-path/<foo>")
def flask_not_path(foo):
    # On UNIX systems, this is OK, since without being marked as `<path:foo>`, flask
    # routing ensures that `foo` cannot contain forward slashes (not by using %2F either).
    path = os.path.join(STATIC_DIR, foo)
    f = open(path)  # OK if only running on UNIX systems, NOT OK if could be running on windows


@app.route("/no-dot-dot")
def no_dot_dot():
    filename = request.args.get('filename', '')
    path = os.path.join(STATIC_DIR, filename)
    # Note: even for UNIX-only programs, this check is not good enough, since it doesn't
    # handle if `filename` is an absolute path
    if '../' in path:
        return "not this time"
    f = open(path)  # NOT OK


@app.route("/no-dot-dot-with-prefix")
def no_dot_dot_with_prefix():
    filename = request.args.get('filename', '')
    path = os.path.join(STATIC_DIR, "img-"+filename)
    # Note: Since `filename` has a prefix, it's not possible to use an absolute path.
    # Therefore, for UNIX-only programs, the `../` check is enough to stop path injections.
    if '../' in path:
        return "not this time"
    f = open(path)  # OK if only running on UNIX systems, NOT OK if could be running on windows


@app.route("/replace-slash")
def replace_slash():
    filename = request.args.get('filename', '')
    path = os.path.join(STATIC_DIR, filename)
    sanitized = path.replace("/", "_")
    f = open(sanitized)  # OK if only running on UNIX systems, NOT OK if could be running on windows


@app.route("/stackoverflow-solution")
def stackoverflow_solution():
    # Solution provided in https://stackoverflow.com/a/45188896
    filename = request.args.get('filename', '')
    path = os.path.join(STATIC_DIR, filename)
    if os.path.commonprefix((os.path.realpath(path), STATIC_DIR)) != STATIC_DIR:
        return "not this time"
    f = open(path) # OK TODO: FP


SAFE_FILES = ['foo', 'bar', 'baz']

@app.route("/safe-set-of-files")
def safe_set_of_files():
    filename = request.args.get('filename', '')
    if filename in SAFE_FILES:
        path = os.path.join(STATIC_DIR, filename)
        f = open(path) # OK TODO: FP
