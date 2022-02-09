from flask import request, Flask
import lxml.etree
import xml.etree.ElementTree

app = Flask(__name__)

# BAD
@app.route("/bad")
def bad():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    parsed_xml = xml.etree.ElementTree.fromstring(xml_content, parser=parser)

    return parsed_xml.text

# GOOD
@app.route("/good")
def good():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser(resolve_entities=False)
    parsed_xml = xml.etree.ElementTree.fromstring(xml_content, parser=parser)

    return parsed_xml.text