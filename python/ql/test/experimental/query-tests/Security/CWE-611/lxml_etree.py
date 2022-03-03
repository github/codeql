from flask import request, Flask
from io import StringIO, BytesIO
import lxml.etree

app = Flask(__name__)

# Parsing

@app.route("/lxml_etree_fromstring")
def lxml_etree_fromstring():
    xml_content = request.args['xml_content']

    return lxml.etree.fromstring(xml_content).text # NOT OK for XXE

@app.route("/lxml_etree_fromstringlist")
def lxml_etree_fromstringlist():
    xml_content = request.args['xml_content']

    return lxml.etree.fromstringlist([xml_content]).text # NOT OK for XXE

@app.route("/lxml_etree_XML")
def lxml_etree_XML():
    xml_content = request.args['xml_content']

    return lxml.etree.XML(xml_content).text # NOT OK for XXE

@app.route("/lxml_etree_parse")
def lxml_etree_parse():
    xml_content = request.args['xml_content']

    return lxml.etree.parse(StringIO(xml_content)).getroot().text # NOT OK for XXE

# With parsers - Default

@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    return lxml.etree.fromstring(xml_content, parser=parser).text # NOT OK for XXE

@app.route("/lxml_etree_fromstring-lxml.etree.get_default_parser")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.get_default_parser()
    return lxml.etree.fromstring(xml_content, parser=parser).text # NOT OK for XXE

# With parsers - With options

# XXE-safe
@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser+")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser(resolve_entities=False)
    return lxml.etree.fromstring(xml_content, parser=parser).text # OK for XXE

# XXE-vuln
@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser+")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser(resolve_entities=True)
    return lxml.etree.fromstring(xml_content, parser=parser).text # NOT OK for XXE

# Billion laughs and quadratic blowup (huge_tree)

@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser+")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser(resolve_entities=False, huge_tree=True)
    return lxml.etree.fromstring(xml_content, parser=parser).text # OK for XXE, NOT OK for billion laughs/quadratic

@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser+")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser(huge_tree=True)
    return lxml.etree.fromstring(xml_content, parser=parser).text # NOT OK for XXE, NOT OK for billion laughs/quadratic

# DTD retrival

@app.route("/lxml_etree_fromstring-lxml.etree.XMLParser+")
def lxml_parser():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser(resolve_entities=False, load_dtd=True, no_network=False)
    return lxml.etree.fromstring(xml_content, parser=parser).text # NOT OK for DTD, OK for rest
