from io import StringIO
import lxml.etree

x = "some xml"

# different parsing methods
lxml.etree.fromstring(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.fromstring(..)
lxml.etree.fromstring(text=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.fromstring(..)

lxml.etree.fromstringlist([x]) # $ decodeFormat=XML decodeInput=List xmlVuln='XXE' decodeOutput=lxml.etree.fromstringlist(..)
lxml.etree.fromstringlist(strings=[x]) # $ decodeFormat=XML decodeInput=List xmlVuln='XXE' decodeOutput=lxml.etree.fromstringlist(..)

lxml.etree.XML(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.XML(..)
lxml.etree.XML(text=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.XML(..)

lxml.etree.XMLID(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.XMLID(..)
lxml.etree.XMLID(text=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.XMLID(..)

xml_file = 'xml_file'
lxml.etree.parse(xml_file) # $ decodeFormat=XML decodeInput=xml_file xmlVuln='XXE' decodeOutput=lxml.etree.parse(..) getAPathArgument=xml_file
lxml.etree.parse(source=xml_file) # $ decodeFormat=XML decodeInput=xml_file xmlVuln='XXE' decodeOutput=lxml.etree.parse(..) getAPathArgument=xml_file

lxml.etree.parseid(xml_file) # $ decodeFormat=XML decodeInput=xml_file xmlVuln='XXE' decodeOutput=lxml.etree.parseid(..) getAPathArgument=xml_file
lxml.etree.parseid(source=xml_file) # $ decodeFormat=XML decodeInput=xml_file xmlVuln='XXE' decodeOutput=lxml.etree.parseid(..) getAPathArgument=xml_file

lxml.etree.iterparse(xml_file) # $ decodeFormat=XML decodeInput=xml_file xmlVuln='XXE' decodeOutput=lxml.etree.iterparse(..) getAPathArgument=xml_file
lxml.etree.iterparse(source=xml_file) # $ decodeFormat=XML decodeInput=xml_file xmlVuln='XXE' decodeOutput=lxml.etree.iterparse(..) getAPathArgument=xml_file

# With default parsers (nothing changed)
parser = lxml.etree.XMLParser()
lxml.etree.fromstring(x, parser=parser) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.fromstring(..)

parser = lxml.etree.get_default_parser()
lxml.etree.fromstring(x, parser=parser) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.fromstring(..)

# manual use of feed method
parser = lxml.etree.XMLParser()
parser.feed(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE'
parser.feed(data=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE'
parser.close() # $ decodeOutput=parser.close()

# XXE-safe
parser = lxml.etree.XMLParser(resolve_entities=False)
lxml.etree.fromstring(x, parser) # $ decodeFormat=XML decodeInput=x decodeOutput=lxml.etree.fromstring(..)
lxml.etree.fromstring(x, parser=parser) # $ decodeFormat=XML decodeInput=x decodeOutput=lxml.etree.fromstring(..)

# XXE-vuln
parser = lxml.etree.XMLParser(resolve_entities=True)
lxml.etree.fromstring(x, parser=parser) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.fromstring(..)

# Billion laughs vuln (also XXE)
parser = lxml.etree.XMLParser(huge_tree=True)
lxml.etree.fromstring(x, parser=parser) # $ decodeFormat=XML decodeInput=x xmlVuln='XXE' decodeOutput=lxml.etree.fromstring(..)

# Safe for both Billion laughs and XXE
parser = lxml.etree.XMLParser(resolve_entities=False, huge_tree=True)
lxml.etree.fromstring(x, parser=parser) # $ decodeFormat=XML decodeInput=x decodeOutput=lxml.etree.fromstring(..)

# DTD retrival vuln (also XXE)
parser = lxml.etree.XMLParser(load_dtd=True, no_network=False)
lxml.etree.fromstring(x, parser=parser) # $ decodeFormat=XML decodeInput=x xmlVuln='DTD retrieval' xmlVuln='XXE' decodeOutput=lxml.etree.fromstring(..)

# iterparse configurations ... this doesn't use a parser argument but takes MOST (!) of
# the normal XMLParser arguments. Specifically, it doesn't allow disabling XXE :O

lxml.etree.iterparse(xml_file, huge_tree=True) # $ decodeFormat=XML decodeInput=xml_file xmlVuln='XXE' decodeOutput=lxml.etree.iterparse(..) getAPathArgument=xml_file
lxml.etree.iterparse(xml_file, load_dtd=True, no_network=False) # $ decodeFormat=XML decodeInput=xml_file xmlVuln='DTD retrieval' xmlVuln='XXE' decodeOutput=lxml.etree.iterparse(..) getAPathArgument=xml_file
