from io import StringIO
import xml.etree.ElementTree

x = "some xml"

# Parsing in different ways
xml.etree.ElementTree.fromstring(x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.etree.ElementTree.fromstring(text=x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'

xml.etree.ElementTree.fromstringlist([x]) # $ xmlInput=List xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.etree.ElementTree.fromstringlist(sequence=[x]) # $ xmlInput=List xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'

xml.etree.ElementTree.XML(x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.etree.ElementTree.XML(text=x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'

xml.etree.ElementTree.XMLID(x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.etree.ElementTree.XMLID(text=x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'

xml.etree.ElementTree.parse(StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.etree.ElementTree.parse(source=StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'

xml.etree.ElementTree.iterparse(StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.etree.ElementTree.iterparse(source=StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'


# With parsers (no options available to disable/enable security features)
parser = xml.etree.ElementTree.XMLParser()
xml.etree.ElementTree.fromstring(x, parser=parser) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'

# manual use of feed method
parser = xml.etree.ElementTree.XMLParser()
parser.feed(x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
parser.feed(data=x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
parser.close()

# manual use of feed method on XMLPullParser
parser = xml.etree.ElementTree.XMLPullParser()
parser.feed(x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
parser.feed(data=x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
parser.close()

# note: it's technically possible to use the thing wrapper func `fromstring` with an
# `lxml` parser, and thereby change what vulnerabilities you are exposed to.. but it
# seems very unlikely that anyone would do this, so we have intentionally not added any
# tests for this.
