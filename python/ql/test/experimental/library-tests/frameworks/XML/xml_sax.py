from io import StringIO
import xml.sax

x = "some xml"

class MainHandler(xml.sax.ContentHandler):
    def __init__(self):
        self._result = []

    def characters(self, data):
        self._result.append(data)

    def parse(self, f):
        xml.sax.parse(f, self) # $ MISSING: input=f vuln='Billion Laughs' vuln='Quadratic Blowup'
        self._result

MainHandler().parse(StringIO(x))

parser = xml.sax.make_parser()
parser.parse(StringIO(x)) # $ input=StringIO(..) vuln='Billion Laughs' vuln='Quadratic Blowup'

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
