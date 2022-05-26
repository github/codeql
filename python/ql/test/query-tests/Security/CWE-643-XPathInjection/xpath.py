from lxml import etree
from io import StringIO


def a():
    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    r = tree.xpath('/foo/bar')


def b():
    root = etree.XML("<root><a>TEXT</a></root>")
    find_text = etree.XPath("//text()")
    text = find_text(root)[0]


def c():
    root = etree.XML("<root><a>TEXT</a></root>")
    find_text = etree.XPath("//text()", smart_strings=False)
    text = find_text(root)[0]


def d():
    root = etree.XML("<root><a>TEXT</a></root>")
    find_text = find = etree.ETXPath("//{ns}b")
    text = find_text(root)[0]


def e():
    import libxml2
    doc = libxml2.parseFile('xpath_injection/credential.xml')
    results = doc.xpathEval('sink')


if __name__ == "__main__":
    a()
    b()
    c()
    d()
    e()
