from flask import request, Flask
from io import StringIO, BytesIO
import lxml.etree

app = Flask(__name__)

# Parsing

@app.route("/lxml_etree_fromstring")
def lxml_etree_fromstring():
    xml_content = request.args['xml_content']

    return lxml.etree.fromstring(xml_content).text

@app.route("/lxml_etree_fromstringlist")
def lxml_etree_fromstringlist():
    xml_content = request.args['xml_content']

    return lxml.etree.fromstringlist([xml_content]).text

@app.route("/lxml_etree_XML")
def lxml_etree_XML():
    xml_content = request.args['xml_content']

    return lxml.etree.XML(xml_content).text

@app.route("/lxml_etree_parse")
def lxml_etree_parse():
    xml_content = request.args['xml_content']

    return lxml.etree.parse(StringIO(xml_content)).getroot().text

# With parsers - Default

@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    return lxml.etree.fromstring(xml_content, parser=parser).text

@app.route("/lxml_etree_fromstring-lxml.etree.get_default_parser")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.get_default_parser()
    return lxml.etree.fromstring(xml_content, parser=parser).text

# With parsers - With options

# XXE-safe
@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser+")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser(resolve_entities=False)
    return lxml.etree.fromstring(xml_content, parser=parser).text

# Billion laughs and quadratic blowup (huge_tree)

## Good (huge_tree=True but resolve_entities=False)

@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser+")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser(resolve_entities=False, huge_tree=True)
    return lxml.etree.fromstring(xml_content, parser=parser).text

## Bad
@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser+")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser(huge_tree=True)
    return lxml.etree.fromstring(xml_content, parser=parser).text
