from flask import request, Flask
from io import StringIO, BytesIO
import xml.dom.minidom
import xml.dom.pulldom
import xml.sax

app = Flask(__name__)

# Parsing

@app.route("/xml_minidom_parse")
def xml_minidom_parse():
    xml_content = request.args['xml_content']

    return xml.dom.minidom.parse(StringIO(xml_content)).documentElement.childNodes

@app.route("/xml_minidom_parseString")
def xml_minidom_parseString():
    xml_content = request.args['xml_content']

    return xml.dom.minidom.parseString(xml_content).documentElement.childNodes

@app.route("/xml_pulldom_parse")
def xml_pulldom_parse():
    xml_content = request.args['xml_content']

    return xml.dom.pulldom.parse(StringIO(xml_content))['START_DOCUMENT'][1].documentElement.childNodes

@app.route("/xml_pulldom_parseString")
def xml_pulldom_parseString():
    xml_content = request.args['xml_content']

    return xml.dom.pulldom.parseString(xml_content)['START_DOCUMENT'][1].documentElement.childNodes

# With parsers

@app.route("/xml_minidom_parse_xml_sax_make_parser")
def xml_minidom_parse_xml_sax_make_parser():
    xml_content = request.args['xml_content']

    parser = xml.sax.make_parser()
    parser.setFeature(xml.sax.handler.feature_external_ges, True)
    return xml.dom.minidom.parse(StringIO(xml_content), parser=parser).documentElement.childNodes

