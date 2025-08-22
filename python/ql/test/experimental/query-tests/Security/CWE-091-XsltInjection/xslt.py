from lxml import etree
from io import StringIO
from flask import Flask, request

app = Flask(__name__)


@app.route("/xslt")
def bad():
    xsltQuery = request.args.get('xml', '')
    xslt_root = etree.XML(xsltQuery)
    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result_tree = tree.xslt(xslt_root)  # Not OK
