from flask import request, Flask
import lxml.etree
import xml.etree.ElementTree


@app.route("/example")
def example():
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    parsed_xml = xml.etree.ElementTree.fromstring(xml_content, parser=parser)

    return parsed_xml.text
