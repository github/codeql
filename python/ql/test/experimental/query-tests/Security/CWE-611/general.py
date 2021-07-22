from flask import request, Flask
from io import StringIO
import xml.etree
import xml.etree.ElementTree
import lxml.etree
import xml.dom.minidom
import xml.dom.pulldom
import xmltodict

'''
TO-DO

Extend tests
Model xmltodict and xml.dom
Write StringIO/BytesIO additional tain steps


XML Parsers:
  xml.etree.ElementTree.XMLParser() - no options, vuln by default
  lxml.etree.XMLParser() - no_network=True huge_tree=False resolve_entities=True
  lxml.etree.get_default_parser() - no options, default above options
  xml.sax.make_parser() - parser.setFeature(xml.sax.handler.feature_external_ges, True)

XML Parsing:
  string:
    xml.etree.ElementTree.fromstring(list)
    xml.etree.ElementTree.XML
    lxml.etree.fromstring(list)
    lxml.etree.XML
    xmltodict.parse

  file StringIO(), BytesIO(b):
    xml.etree.ElementTree.parse
    lxml.etree.parse
    xml.dom.(mini|pull)dom.parse(String)
'''


@app.route("/XMLParser-Empty&xml.etree.ElementTree.fromstring")
def test1():
    # <?xml version="1.0"?><!DOCTYPE dt [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><test>&xxe;</test>
    xml_content = request.args['xml_content']

    parser = lxml.etree.XMLParser()
    # 'root...'
    return xml.etree.ElementTree.fromstring(xml_content, parser=parser).text


@app.route("/XMLParser-Empty&xml.etree.ElementTree.parse")  # !
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


@app.route("/XMLParser-Empty&xml.etree.parse")  # !
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
