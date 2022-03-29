from io import StringIO
import xml.dom.minidom
import xml.dom.pulldom
import xml.sax

x = "some xml"

# minidom
xml.dom.minidom.parse(StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.dom.minidom.parse(file=StringIO(x)) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'

xml.dom.minidom.parseString(x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.dom.minidom.parseString(string=x) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'


# pulldom
xml.dom.pulldom.parse(StringIO(x))['START_DOCUMENT'][1] # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.dom.pulldom.parse(stream_or_string=StringIO(x))['START_DOCUMENT'][1] # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'

xml.dom.pulldom.parseString(x)['START_DOCUMENT'][1] # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
xml.dom.pulldom.parseString(string=x)['START_DOCUMENT'][1] # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'


# These are based on SAX parses, and you can specify your own, so you can expose yourself to XXE (yay/)
parser = xml.sax.make_parser()
parser.setFeature(xml.sax.handler.feature_external_ges, True)
xml.dom.minidom.parse(StringIO(x), parser) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='DTD retrieval' xmlVuln='Quadratic Blowup' xmlVuln='XXE'
xml.dom.minidom.parse(StringIO(x), parser=parser) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='DTD retrieval' xmlVuln='Quadratic Blowup' xmlVuln='XXE'

xml.dom.pulldom.parse(StringIO(x), parser) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='DTD retrieval' xmlVuln='Quadratic Blowup' xmlVuln='XXE'
xml.dom.pulldom.parse(StringIO(x), parser=parser) # $ xmlInput=StringIO(..) xmlVuln='Billion Laughs' xmlVuln='DTD retrieval' xmlVuln='Quadratic Blowup' xmlVuln='XXE'
