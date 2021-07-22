from flask import request, Flask
from io import StringIO
import xml.etree
import xml.etree.ElementTree
import lxml.etree
import xml.dom.minidom
import xml.dom.pulldom
import xmltodict


app = Flask(__name__)


@app.route("/XMLParser-Empty&xml.etree.ElementTree.fromstring")
def test1():
    # <?xml version="1.0"?><!DOCTYPE dt [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><test>&xxe;</test>
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    # 'root...'
    return xml.etree.ElementTree.fromstring(xml_content, parser=parser).text


@app.route("/XMLParser-Empty&xml.etree.ElementTree.parse")
def test1():
    # <?xml version="1.0"?><!DOCTYPE dt [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><test>&xxe;</test>
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    # 'jorgectf'
    return xml.etree.ElementTree.parse(StringIO(xml_content), parser=parser).getroot().text


@app.route("/XMLParser-Empty&lxml.etree.fromstring")
def test1():
    # <?xml version="1.0"?><!DOCTYPE dt [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><test>&xxe;</test>
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    return lxml.etree.fromstring(xml_content, parser=parser).text  # 'jorgectf'


@app.route("/XMLParser-Empty&xml.etree.parse")
def test1():
    # <?xml version="1.0"?><!DOCTYPE dt [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><test>&xxe;</test>
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    # 'jorgectf'
    return lxml.etree.parse(StringIO(xml_content), parser=parser).getroot().text


@app.route("/xmltodict-disable_entities_False")
def test2():
    # <?xml version="1.0"?><!DOCTYPE dt [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><test>&xxe;</test>
    xml_content = request.args['xml_content']

    return xmltodict.parse(xml_content, disable_entities=False)
