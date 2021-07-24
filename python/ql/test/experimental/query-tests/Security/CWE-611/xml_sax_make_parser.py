from flask import request, Flask
from io import StringIO
import xml.sax

# xml_content = '<?xml version="1.0"?><!DOCTYPE dt [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><test>&xxe;</test>'

app = Flask(__name__)


class MainHandler(xml.sax.ContentHandler):
    def __init__(self):
        self._result = []

    def characters(self, data):
        self._result.append(data)

    def parse(self, f):
        xml.sax.parse(f, self)
        return self._result

# GOOD


@app.route("/MainHandler")
def test1():
    xml_content = request.args['xml_content']

    return MainHandler().parse(StringIO(xml_content))


@app.route("/xml.sax.make_parser()+MainHandler")
def test1():
    xml_content = request.args['xml_content']

    BadHandler = MainHandler()
    parser = xml.sax.make_parser()
    parser.setContentHandler(BadHandler)
    parser.parse(StringIO(xml_content))
    return BadHandler._result


@app.route("/xml.sax.make_parser()+MainHandler-xml.sax.handler.feature_external_ges_False")
def test1():
    xml_content = request.args['xml_content']

    BadHandler = MainHandler()
    parser = xml.sax.make_parser()
    parser.setContentHandler(BadHandler)
    # https://docs.python.org/3/library/xml.sax.handler.html#xml.sax.handler.feature_external_ges
    parser.setFeature(xml.sax.handler.feature_external_ges, False)
    parser.parse(StringIO(xml_content))
    return BadHandler._result

# BAD


@app.route("/xml.sax.make_parser()+MainHandler-xml.sax.handler.feature_external_ges_True")
def test1():
    xml_content = request.args['xml_content']

    GoodHandler = MainHandler()
    parser = xml.sax.make_parser()
    parser.setContentHandler(GoodHandler)
    parser.setFeature(xml.sax.handler.feature_external_ges, True)
    parser.parse(StringIO(xml_content))
    return GoodHandler._result


@app.route("/xml.sax.make_parser()+xml.dom.minidom.parse-xml.sax.handler.feature_external_ges_True")
def test1():
    xml_content = request.args['xml_content']

    parser = xml.sax.make_parser()
    parser.setFeature(xml.sax.handler.feature_external_ges, True)
    return xml.dom.minidom.parse(StringIO(xml_content), parser=parser).documentElement.childNodes
