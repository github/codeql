from lxml import etree
from io import StringIO
from flask import Flask, request

app = Flask(__name__)


@app.route("/xslt1")
def a():
    xsltQuery = request.args.get('xml', '')
    xslt_root = etree.XML(xsltQuery)
    transform = etree.XSLT(xslt_root) # Not OK


@app.route("/xslt2")
def b():
    xsltQuery = request.args.get('xml', '')
    xslt_root = etree.XML(xsltQuery)
    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result_tree = tree.xslt(xslt_root) # Not OK


@app.route("/xslt3")
def c():
    xsltQuery = request.args.get('xml', '')
    xslt_root = etree.XML(xsltQuery)

    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result = tree.xslt(xslt_root, a="'A'") # Not OK

@app.route("/xslt4")
def d():
    xsltQuery = request.args.get('xml', '')
    xslt_root = etree.fromstring(xsltQuery)

    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result = tree.xslt(xslt_root, a="'A'") # Not OK

@app.route("/xslt5")
def e():
    xsltQuery = request.args.get('xml', '')
    xsltStrings = [xsltQuery,"asd","random"]
    xslt_root = etree.fromstringlist(xsltStrings)

    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result = tree.xslt(xslt_root, a="'A'") # Not OK


@app.route("/xslt6")
def f():
    xsltQuery = '<non><remote><query></query></remote></non>'
    xslt_root = etree.XML(xsltQuery)

    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result = tree.xslt(xslt_root, a="'A'") # OK

@app.route("/xslt7")
def g():
    xsltQuery = '<non><remote><query></query></remote></non>'
    xslt_root = etree.fromstring(xsltQuery)

    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result = tree.xslt(xslt_root, a="'A'") # OK

@app.route("/xslt8")
def h():
    xsltQuery = '<non><remote><query></query></remote></non>'
    xsltStrings = [xsltQuery,"asd","random"]
    xslt_root = etree.fromstringlist(xsltStrings)

    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result = tree.xslt(xslt_root, a="'A'") # OK    