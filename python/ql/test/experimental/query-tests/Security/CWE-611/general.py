from flask import request, Flask
from io import StringIO, BytesIO
import xml.etree
import xml.etree.ElementTree
import lxml.etree
import xml.dom.minidom
import xml.dom.pulldom
import xmltodict


app = Flask(__name__)

# xml_content = '<?xml version="1.0"?><!DOCTYPE dt [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><test>&xxe;</test>'


@app.route("/lxml.etree.fromstring")
def lxml_fromstring():
    xml_content = request.args['xml_content']

    return lxml.etree.fromstring(xml_content).text


@app.route("/lxml.etree.XML")
def lxml_XML():
    xml_content = request.args['xml_content']

    return lxml.etree.XML(xml_content).text


@app.route("/lxml.etree.parse")
def lxml_parse():
    xml_content = request.args['xml_content']

    return lxml.etree.parse(StringIO(xml_content)).text


@app.route("/xmltodict.parse")
def xmltodict_parse():
    xml_content = request.args['xml_content']

    return xmltodict.parse(xml_content, disable_entities=False)


@app.route("/lxml.etree.XMLParser+lxml.etree.fromstring")
def lxml_XMLParser_fromstring():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    return lxml.etree.fromstring(xml_content, parser=parser).text


@app.route("/lxml.etree.get_default_parser+lxml.etree.fromstring")
def lxml_defaultParser_fromstring():
    xml_content = request.args['xml_content']

    parser = lxml.etree.get_default_parser()
    return lxml.etree.fromstring(xml_content, parser=parser).text


@app.route("/lxml.etree.XMLParser+xml.etree.ElementTree.fromstring")
def lxml_XMLParser_xml_fromstring():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    return xml.etree.ElementTree.fromstring(xml_content, parser=parser).text


@app.route("/lxml.etree.XMLParser+xml.etree.ElementTree.parse")
def lxml_XMLParser_xml_parse():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    return xml.etree.ElementTree.parse(StringIO(xml_content), parser=parser).getroot().text
