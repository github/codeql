from flask import request, Flask
from io import StringIO, BytesIO
import xml.etree
import xml.etree.ElementTree
import lxml.etree

app = Flask(__name__)

# Parsing

@app.route("/xml_etree_fromstring")
def xml_etree_fromstring():
    xml_content = request.args['xml_content']

    return xml.etree.ElementTree.fromstring(xml_content).text

@app.route("/xml_etree_fromstringlist")
def xml_etree_fromstringlist():
    xml_content = request.args['xml_content']

    return xml.etree.ElementTree.fromstringlist(xml_content).text

@app.route("/xml_etree_XML")
def xml_etree_XML():
    xml_content = request.args['xml_content']

    return xml.etree.ElementTree.XML(xml_content).text

@app.route("/xml_etree_parse")
def xml_etree_parse():
    xml_content = request.args['xml_content']

    return xml.etree.ElementTree.parse(StringIO(xml_content)).getroot().text

# With parsers

@app.route("/xml_etree_fromstring-xml_etree_XMLParser")
def xml_parser_1():
    xml_content = request.args['xml_content']

    parser = xml.etree.ElementTree.XMLParser()
    return xml.etree.ElementTree.fromstring(xml_content, parser=parser).text

@app.route("/xml_etree_fromstring-lxml_etree_XMLParser")
def xml_parser_2():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    return xml.etree.ElementTree.fromstring(xml_content, parser=parser).text

@app.route("/xml_etree_fromstring-lxml_get_default_parser")
def xml_parser_3():
    xml_content = request.args['xml_content']

    parser = lxml.etree.get_default_parser()
    return xml.etree.ElementTree.fromstring(xml_content, parser=parser).text

@app.route("/xml_etree_fromstring-lxml_get_default_parser")
def xml_parser_4():
    xml_content = request.args['xml_content']

    parser = xml.sax.make_parser()
    parser.setFeature(xml.sax.handler.feature_external_ges, True)
    return xml.etree.ElementTree.fromstring(xml_content, parser=parser).text