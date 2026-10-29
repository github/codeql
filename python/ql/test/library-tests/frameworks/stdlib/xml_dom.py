from io import StringIO
import xml.dom.minidom
import xml.dom.pulldom
import xml.sax

x = "some xml"

# minidom
xml.dom.minidom.parse(StringIO(x)) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' decodeOutput=xml.dom.minidom.parse(..) getAPathArgument=StringIO(..)
xml.dom.minidom.parse(file=StringIO(x)) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' decodeOutput=xml.dom.minidom.parse(..) getAPathArgument=StringIO(..)

xml.dom.minidom.parseString(x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.dom.minidom.parseString(..)
xml.dom.minidom.parseString(string=x) # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.dom.minidom.parseString(..)


# pulldom
xml.dom.pulldom.parse(StringIO(x))['START_DOCUMENT'][1] # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' decodeOutput=xml.dom.pulldom.parse(..) getAPathArgument=StringIO(..)
xml.dom.pulldom.parse(stream_or_string=StringIO(x))['START_DOCUMENT'][1] # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' decodeOutput=xml.dom.pulldom.parse(..) getAPathArgument=StringIO(..)

xml.dom.pulldom.parseString(x)['START_DOCUMENT'][1] # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.dom.pulldom.parseString(..)
xml.dom.pulldom.parseString(string=x)['START_DOCUMENT'][1] # $ decodeFormat=XML decodeInput=x xmlVuln='XML bomb' decodeOutput=xml.dom.pulldom.parseString(..)


# These are based on SAX parses, and you can specify your own, so you can expose yourself to XXE (yay/)
parser = xml.sax.make_parser()
parser.setFeature(xml.sax.handler.feature_external_ges, True)
xml.dom.minidom.parse(StringIO(x), parser) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' xmlVuln='DTD retrieval' xmlVuln='XXE' decodeOutput=xml.dom.minidom.parse(..) getAPathArgument=StringIO(..)
xml.dom.minidom.parse(StringIO(x), parser=parser) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' xmlVuln='DTD retrieval' xmlVuln='XXE' decodeOutput=xml.dom.minidom.parse(..) getAPathArgument=StringIO(..)

xml.dom.pulldom.parse(StringIO(x), parser) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' xmlVuln='DTD retrieval' xmlVuln='XXE' decodeOutput=xml.dom.pulldom.parse(..) getAPathArgument=StringIO(..)
xml.dom.pulldom.parse(StringIO(x), parser=parser) # $ decodeFormat=XML decodeInput=StringIO(..) xmlVuln='XML bomb' xmlVuln='DTD retrieval' xmlVuln='XXE' decodeOutput=xml.dom.pulldom.parse(..) getAPathArgument=StringIO(..)
