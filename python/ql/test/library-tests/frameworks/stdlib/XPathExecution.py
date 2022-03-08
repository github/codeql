match = "dc:title"
ns = {'dc': 'http://purl.org/dc/elements/1.1/'}

import xml.etree.ElementTree as ET
tree = ET.parse('country_data.xml')
root = tree.getroot()

root.find(match, namespaces=ns)  # $ getXPath=match
root.findall(match, namespaces=ns)  # $ getXPath=match
root.findtext(match, default=None, namespaces=ns)  # $ getXPath=match

tree = ET.ElementTree()
tree.parse("index.xhtml")

tree.find(match, namespaces=ns)  # $ getXPath=match
tree.findall(match, namespaces=ns)  # $ getXPath=match
tree.findtext(match, default=None, namespaces=ns)  # $ getXPath=match
