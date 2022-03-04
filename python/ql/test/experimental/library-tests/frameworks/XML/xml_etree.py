from io import StringIO
import xml.etree.ElementTree

x = "some xml"

# Parsing in different ways
xml.etree.ElementTree.fromstring(x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'
xml.etree.ElementTree.fromstring(text=x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'

xml.etree.ElementTree.fromstringlist([x]) # $ input=List vuln='Billion Laughs' vuln='Quadratic Blowup'
xml.etree.ElementTree.fromstringlist(sequence=[x]) # $ input=List vuln='Billion Laughs' vuln='Quadratic Blowup'

xml.etree.ElementTree.XML(x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'
xml.etree.ElementTree.XML(text=x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'

xml.etree.ElementTree.XMLID(x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'
xml.etree.ElementTree.XMLID(text=x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'

xml.etree.ElementTree.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'
xml.etree.ElementTree.parse(source=StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'

xml.etree.ElementTree.iterparse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'
xml.etree.ElementTree.iterparse(source=StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'


# With parsers (no options available to disable/enable security features)
parser = xml.etree.ElementTree.XMLParser()
xml.etree.ElementTree.fromstring(x, parser=parser) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'

# manual use of feed method
parser = xml.etree.ElementTree.XMLParser()
parser.feed(x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'
parser.feed(data=x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'
parser.close()

# manual use of feed method on XMLPullParser
parser = xml.etree.ElementTree.XMLPullParser()
parser.feed(x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'
parser.feed(data=x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'
parser.close()

# note: it's technically possible to use the thing wrapper func `fromstring` with an
# `lxml` parser, and thereby change what vulnerabilities you are exposed to.. but it
# seems very unlikely that anyone would do this, so we have intentionally not added any
# tests for this.
