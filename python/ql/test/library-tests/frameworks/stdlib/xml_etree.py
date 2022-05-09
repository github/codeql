from io import StringIO
import xml.etree.ElementTree

x = "some xml"

# Parsing in different ways
xml.etree.ElementTree.fromstring(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.fromstring(..)
xml.etree.ElementTree.fromstring(text=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.fromstring(..)

xml.etree.ElementTree.fromstringlist([x]) # $ decodeFormat=XML decodeInput=List xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.fromstringlist(..)
xml.etree.ElementTree.fromstringlist(sequence=[x]) # $ decodeFormat=XML decodeInput=List xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.fromstringlist(..)

xml.etree.ElementTree.XML(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.XML(..)
xml.etree.ElementTree.XML(text=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.XML(..)

xml.etree.ElementTree.XMLID(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.XMLID(..)
xml.etree.ElementTree.XMLID(text=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.XMLID(..)

xml.etree.ElementTree.parse(StringIO(x)) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.parse(..) getAPathArgument=StringIO(..)
xml.etree.ElementTree.parse(source=StringIO(x)) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.parse(..) getAPathArgument=StringIO(..)

xml.etree.ElementTree.iterparse(StringIO(x)) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.iterparse(..) getAPathArgument=StringIO(..)
xml.etree.ElementTree.iterparse(source=StringIO(x)) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.iterparse(..) getAPathArgument=StringIO(..)

tree = xml.etree.ElementTree.ElementTree()
tree.parse("file.xml") # $ decodeFormat=XML decodeInput="file.xml" xmlVuln='XML bomb' decodeOutput=tree.parse(..) getAPathArgument="file.xml"
tree.parse(source="file.xml") # $ decodeFormat=XML decodeInput="file.xml" xmlVuln='XML bomb' decodeOutput=tree.parse(..) getAPathArgument="file.xml"


# With parsers (no options available to disable/enable security features)
parser = xml.etree.ElementTree.XMLParser()
xml.etree.ElementTree.fromstring(x, parser=parser) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.etree.ElementTree.fromstring(..)

# manual use of feed method
parser = xml.etree.ElementTree.XMLParser()
parser.feed(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb'
parser.feed(data=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb'
parser.close() # $ decodeOutput=parser.close()

# manual use of feed method on XMLPullParser
parser = xml.etree.ElementTree.XMLPullParser()
parser.feed(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb'
parser.feed(data=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb'
parser.close() # $ decodeOutput=parser.close()

# note: it's technically possible to use the thing wrapper func `fromstring` with an
# `lxml` parser, and thereby change what vulnerabilities you are exposed to.. but it
# seems very unlikely that anyone would do this, so we have intentionally not added any
# tests for this.
