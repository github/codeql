from lxml import etree
from io import StringIO

def test_parse():
    tree = etree.parse(StringIO('<foo><bar></bar></foo>')) # $ decodeFormat=XML decodeInput=StringIO(..) decodeOutput=etree.parse(..) xmlVuln='XXE' getAPathArgument=StringIO(..)
    r = tree.xpath('/foo/bar')  # $ getXPath='/foo/bar'

def test_XPath_class():
    root = etree.XML("<root><a>TEXT</a></root>") # $ decodeFormat=XML decodeInput="<root><a>TEXT</a></root>" decodeOutput=etree.XML(..) xmlVuln='XXE'
    find_text = etree.XPath("path")  # $ constructedXPath="path"
    text = find_text(root)[0]

def test_ETXpath_class():
    root = etree.XML("<root><a>TEXT</a></root>") # $ decodeFormat=XML decodeInput="<root><a>TEXT</a></root>" decodeOutput=etree.XML(..) xmlVuln='XXE'
    find_text = etree.ETXPath("path")  # $ constructedXPath="path"
    text = find_text(root)[0]

def test_XPathEvaluator_class():
    root = etree.XML("<root><a>TEXT</a></root>") # $ decodeFormat=XML decodeInput="<root><a>TEXT</a></root>" decodeOutput=etree.XML(..) xmlVuln='XXE'
    search_root = etree.XPathEvaluator(root)
    text = search_root("path")[0]  # $ getXPath="path"
