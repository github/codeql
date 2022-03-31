match = "dc:title"
ns = {'dc': 'http://purl.org/dc/elements/1.1/'}

import xml.etree.ElementTree as ET
tree = ET.parse('country_data.xml') # $ decodeFormat=XML decodeInput='country_data.xml' decodeOutput=ET.parse(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup' getAPathArgument='country_data.xml'
root = tree.getroot()

root.find(match, namespaces=ns)  # $ getXPath=match
root.findall(match, namespaces=ns)  # $ getXPath=match
root.findtext(match, default=None, namespaces=ns)  # $ getXPath=match

tree = ET.ElementTree()
tree.parse("index.xhtml") # $ decodeFormat=XML decodeInput="index.xhtml" decodeOutput=tree.parse(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup' getAPathArgument="index.xhtml"

tree.find(match, namespaces=ns)  # $ getXPath=match
tree.findall(match, namespaces=ns)  # $ getXPath=match
tree.findtext(match, default=None, namespaces=ns)  # $ getXPath=match

parser = ET.XMLParser()
parser.feed("<foo>bar</foo>") # $ decodeFormat=XML decodeInput="<foo>bar</foo>" xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
tree = parser.close() # $ decodeOutput=parser.close()
tree.find(match, namespaces=ns)  # $ getXPath=match
