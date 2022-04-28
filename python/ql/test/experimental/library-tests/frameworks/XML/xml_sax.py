from io import StringIO
import xml.sax

x = "some xml"

class MainHandler(xml.sax.ContentHandler):
    def __init__(self):
        self._result = []

    def characters(self, data):
        self._result.append(data)

xml.sax.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'
xml.sax.parse(source=StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'

xml.sax.parseString(x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'
xml.sax.parseString(string=x) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'

parser = xml.sax.make_parser()
parser.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'
parser.parse(source=StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'

# You can make it vuln to both XXE and DTD retrieval by setting this flag
# see https://docs.python.org/3/library/xml.sax.handler.html#xml.sax.handler.feature_external_ges
parser = xml.sax.make_parser()
parser.setFeature(xml.sax.handler.feature_external_ges, True)
parser.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='DTD retrieval' vuln='Quadratic Blowup' vuln='XXE'

parser = xml.sax.make_parser()
parser.setFeature(xml.sax.handler.feature_external_ges, False)
parser.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'

# Forward Type Tracking test
def func(cond):
    parser = xml.sax.make_parser()
    if cond:
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        parser.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='DTD retrieval' vuln='Quadratic Blowup' vuln='XXE'
    else:
        parser.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'

# make it vuln, then making it safe
# a bit of an edge-case, but is nice to be able to handle.
parser = xml.sax.make_parser()
parser.setFeature(xml.sax.handler.feature_external_ges, True)
parser.setFeature(xml.sax.handler.feature_external_ges, False)
parser.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'

def check_conditional_assignment(cond):
    parser = xml.sax.make_parser()
    if cond:
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
    else:
        parser.setFeature(xml.sax.handler.feature_external_ges, False)
    parser.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='DTD retrieval' vuln='Quadratic Blowup' vuln='XXE'

def check_conditional_assignment2(cond):
    parser = xml.sax.make_parser()
    if cond:
        flag_value = True
    else:
        flag_value = False
    parser.setFeature(xml.sax.handler.feature_external_ges, flag_value)
    parser.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='DTD retrieval' vuln='Quadratic Blowup' vuln='XXE'
