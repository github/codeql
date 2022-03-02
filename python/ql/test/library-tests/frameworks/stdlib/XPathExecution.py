match = "dc:title"
ns = {'dc': 'http://purl.org/dc/elements/1.1/'}

import xml.etree.ElementTree as ET
tree = ET.parse('country_data.xml')
root = tree.getroot()

root.find(match, namespaces=ns)  # $ MISSING: getXPath=match
root.findall(match, namespaces=ns)  # $ MISSING: getXPath=match
root.findtext(match, default=None, namespaces=ns)  # $ MISSING: getXPath=match

from xml.etree.ElementTree import ElementTree
tree = ElementTree()
tree.parse("index.xhtml")

tree.find(match, namespaces=ns)  # $ MISSING: getXPath=match
tree.findall(match, namespaces=ns)  # $ MISSING: getXPath=match
tree.findtext(match, default=None, namespaces=ns)  # $ MISSING: getXPath=match
