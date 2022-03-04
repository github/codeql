from io import StringIO
import lxml.etree

x = "some xml"

# different parsing methods
lxml.etree.fromstring(x) # $ input=x vuln='XXE'
lxml.etree.fromstring(text=x) # $ input=x vuln='XXE'

lxml.etree.fromstringlist([x]) # $ input=List vuln='XXE'
lxml.etree.fromstringlist(strings=[x]) # $ input=List vuln='XXE'

lxml.etree.XML(x) # $ input=x vuln='XXE'
lxml.etree.XML(text=x) # $ input=x vuln='XXE'

lxml.etree.parse(StringIO(x)) # $ input=StringIO(..) vuln='XXE'
lxml.etree.parse(source=StringIO(x)) # $ input=StringIO(..) vuln='XXE'

lxml.etree.parseid(StringIO(x)) # $ input=StringIO(..) vuln='XXE'
lxml.etree.parseid(source=StringIO(x)) # $ input=StringIO(..) vuln='XXE'

# With default parsers (nothing changed)
parser = lxml.etree.XMLParser()
lxml.etree.fromstring(x, parser=parser) # $ input=x vuln='XXE'

parser = lxml.etree.get_default_parser()
lxml.etree.fromstring(x, parser=parser) # $ input=x vuln='XXE'

# manual use of feed method
parser = lxml.etree.XMLParser()
parser.feed(x) # $ input=x vuln='XXE'
parser.feed(data=x) # $ input=x vuln='XXE'
parser.close()

# XXE-safe
parser = lxml.etree.XMLParser(resolve_entities=False)
lxml.etree.fromstring(x, parser) # $ input=x
lxml.etree.fromstring(x, parser=parser) # $ input=x

# XXE-vuln
parser = lxml.etree.XMLParser(resolve_entities=True)
lxml.etree.fromstring(x, parser=parser) # $ input=x vuln='XXE'

# Billion laughs vuln (also XXE)
parser = lxml.etree.XMLParser(huge_tree=True)
lxml.etree.fromstring(x, parser=parser) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup' vuln='XXE'

# Safe for both Billion laughs and XXE
parser = lxml.etree.XMLParser(resolve_entities=False, huge_tree=True)
lxml.etree.fromstring(x, parser=parser) # $ input=x

# DTD retrival vuln (also XXE)
parser = lxml.etree.XMLParser(load_dtd=True, no_network=False)
lxml.etree.fromstring(x, parser=parser) # $ input=x vuln='DTD retrieval' vuln='XXE'
