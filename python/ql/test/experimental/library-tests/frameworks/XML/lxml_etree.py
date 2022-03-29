from io import StringIO
import lxml.etree

x = "some xml"

# different parsing methods
lxml.etree.fromstring(x) # $ xmlInput=x xmlVuln='XXE'
lxml.etree.fromstring(text=x) # $ xmlInput=x xmlVuln='XXE'

lxml.etree.fromstringlist([x]) # $ xmlInput=List xmlVuln='XXE'
lxml.etree.fromstringlist(strings=[x]) # $ xmlInput=List xmlVuln='XXE'

lxml.etree.XML(x) # $ xmlInput=x xmlVuln='XXE'
lxml.etree.XML(text=x) # $ xmlInput=x xmlVuln='XXE'

lxml.etree.parse(StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='XXE'
lxml.etree.parse(source=StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='XXE'

lxml.etree.parseid(StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='XXE'
lxml.etree.parseid(source=StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='XXE'

# With default parsers (nothing changed)
parser = lxml.etree.XMLParser()
lxml.etree.fromstring(x, parser=parser) # $ xmlInput=x xmlVuln='XXE'

parser = lxml.etree.get_default_parser()
lxml.etree.fromstring(x, parser=parser) # $ xmlInput=x xmlVuln='XXE'

# manual use of feed method
parser = lxml.etree.XMLParser()
parser.feed(x) # $ xmlInput=x xmlVuln='XXE'
parser.feed(data=x) # $ xmlInput=x xmlVuln='XXE'
parser.close()

# XXE-safe
parser = lxml.etree.XMLParser(resolve_entities=False)
lxml.etree.fromstring(x, parser) # $ xmlInput=x
lxml.etree.fromstring(x, parser=parser) # $ xmlInput=x

# XXE-vuln
parser = lxml.etree.XMLParser(resolve_entities=True)
lxml.etree.fromstring(x, parser=parser) # $ xmlInput=x xmlVuln='XXE'

# Billion laughs vuln (also XXE)
parser = lxml.etree.XMLParser(huge_tree=True)
lxml.etree.fromstring(x, parser=parser) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup' xmlVuln='XXE'

# Safe for both Billion laughs and XXE
parser = lxml.etree.XMLParser(resolve_entities=False, huge_tree=True)
lxml.etree.fromstring(x, parser=parser) # $ xmlInput=x

# DTD retrival vuln (also XXE)
parser = lxml.etree.XMLParser(load_dtd=True, no_network=False)
lxml.etree.fromstring(x, parser=parser) # $ xmlInput=x xmlVuln='DTD retrieval' xmlVuln='XXE'
